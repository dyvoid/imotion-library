package test
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.GradientType;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.utils.Timer;


    /**
     * @author Pieter van de Sluis
     */
    public class Sky extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        

        private var _animate        :Boolean = true;
        private var _animateOffsetX  :Number = 0;
        private var _animateOffsetY  :Number = 0;
        private var _animateOffsetDeltaX  :Number = -0.3;
        private var _animateOffsetDeltaY  :Number = -0.1;
        private var _scaleFactor:Number = 4;

        private var _upperColor:uint = 0xccf0fc;
        private var _lowerColor:uint = 0x6fbedb;
        private var _cirrusCloudVisibility:Number = 1;

        private var _skyColorBMD:BitmapData;
        private var _cloudsBMD:BitmapData;
        private var _cloudsCompressorBMD:BitmapData;
        private var _skyBMD:BitmapData;
        private var _sky:Bitmap;

        private var _cloudsScaleMatrix:Matrix;
        private var _cloudsCompressorTransform:ColorTransform;

        private var _copyPoint:Point = new Point();

        private var _numOctaves:uint = 6;
        private var _offsets:Array;

        private var _seed:uint = Math.random() * uint.MAX_VALUE;

        private var _timer      :Timer;
        private var _timerDelay :uint = 1000;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Sky( width:Number, height:Number )
        {
            init( width, height );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init( width:Number, height:Number ):void
        {
            _skyBMD = new BitmapData( width, height, false );

            _animateOffsetX = -width;
            _animateOffsetY = -height;

            _skyColorBMD = new BitmapData( width, height, false );
            var gradient:Shape = new Shape();
            var matrix:Matrix = new Matrix();
            matrix.createGradientBox( 1, height, Math.PI * 0.5 );
            gradient.graphics.beginGradientFill(GradientType.LINEAR, [_upperColor, _lowerColor],[1,1],[0,255],matrix);
            gradient.graphics.drawRect( 0, 0, width, height );
            _skyColorBMD.draw( gradient );

            _cloudsBMD = new BitmapData( width / _scaleFactor, height /_scaleFactor, false );
            _cloudsCompressorBMD = new BitmapData( width / _scaleFactor, height / _scaleFactor, false );

            _cloudsScaleMatrix = new Matrix();
            _cloudsScaleMatrix.scale( _scaleFactor, _scaleFactor );

            _cloudsCompressorTransform = new ColorTransform( 1.25, 1.25, 1.25, _cirrusCloudVisibility );

            _sky = new Bitmap( _skyBMD );
            this.addChild( _sky );

            _offsets = [];
            for ( var i:int = 0; i < _numOctaves; i++ )
            {
                _offsets.push( new Point() )
            }


            draw();

            if ( _animate )
            {
                _timer = new Timer( _timerDelay );
                _timer.addEventListener( TimerEvent.TIMER, timerTickHandler );
                _timer.start();
            }

        }


        private function draw():void
        {
            _skyBMD.lock();

            _skyBMD.copyPixels( _skyColorBMD, _skyColorBMD.rect, _copyPoint );

            for ( var i:int = 0; i < _numOctaves; i++ )
            {
                _offsets[i].x = _animateOffsetX;
            }
            _offsets[0].y =  _animateOffsetY;
            _offsets[1].y = -_animateOffsetY;

            _cloudsBMD.perlinNoise( 150, 75, _numOctaves, _seed, true, false, 7, true, _offsets );

            _cloudsCompressorBMD.fillRect( _cloudsCompressorBMD.rect, 0x000000 );
            _cloudsCompressorBMD.draw( _cloudsBMD, null, _cloudsCompressorTransform, BlendMode.HARDLIGHT );

            _skyBMD.draw( _cloudsCompressorBMD, _cloudsScaleMatrix, null, BlendMode.SCREEN );

            _skyBMD.unlock();
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function timerTickHandler( e:TimerEvent ):void
        {
            _animateOffsetX += _animateOffsetDeltaX;
            _animateOffsetY += _animateOffsetDeltaY;
            draw();
        }
    }
}