package test.flag
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.BlendMode;
    import flash.display.GradientType;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.BlurFilter;
    import flash.filters.DisplacementMapFilter;
    import flash.filters.DisplacementMapFilterMode;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;


    /**
     * @author Pieter van de Sluis
     */
    public class Flag extends MovieClip
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        [Embed(source="../../../lib/dutchflag.png")]
        private var SourceImage:Class;

        public var sourceImage      :Bitmap;
        public var sourceImageBMD      :BitmapData;
        public var copyImageBMD      :BitmapData;

        private var _dampenMap      :BitmapData;
        private var _displacement   :BitmapData;
        private var _merged   :BitmapData;

        private var _waveSize:Number = 50;

        private var _matrix:Matrix;

        private var _offset:uint = 8;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Flag()
        {
            sourceImage = new SourceImage() as Bitmap;
//            sourceImage.x = 300;
//            sourceImage.y = 300;
//            this.addChild( sourceImage);

            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
//            sourceImageBMD = sourceImage.bitmapData;
            sourceImageBMD = new BitmapData( sourceImage.width + _waveSize * 0.5, sourceImage.height + _waveSize, true, 0x00000000 );
            sourceImageBMD.copyPixels( sourceImage.bitmapData, sourceImage.bitmapData.rect, new Point( 0,_waveSize*0.5 ) );
            copyImageBMD = sourceImageBMD.clone();

            var flag:Bitmap = new Bitmap( sourceImageBMD );
            flag.y = -_waveSize * 0.5;
            this.addChild( flag );

            var dampen:Sprite = new Sprite();
            var matrix:Matrix = new Matrix();
            matrix.createGradientBox(sourceImageBMD.width, 1, 0,0);
//            dampen.graphics.beginGradientFill(GradientType.LINEAR,[0x808080,0x808080,0x808080],[1,0,1],[0,128,255],matrix);
            dampen.graphics.beginGradientFill(GradientType.LINEAR,[0x808080,0x808080], [1,0],[0,200],matrix);
            dampen.graphics.drawRect( 0, 0, sourceImageBMD.width, sourceImageBMD.height );
//            this.addChild(dampen);
            _dampenMap = new BitmapData( sourceImageBMD.width, sourceImageBMD.height, true, 0x00808080 );
            _dampenMap.draw(dampen);

            _displacement = new BitmapData( sourceImageBMD.width, sourceImageBMD.height, false, 0x808080 );
            _displacement.perlinNoise( sourceImageBMD.width/2, sourceImageBMD.height/2, 2, Math.random() * 0xFFFFFFFF, true, true, 1, true );

            _merged = new BitmapData( sourceImageBMD.width, sourceImageBMD.height );

//            this.addChild( new Bitmap( _displacement));

            var mergedBitmap:Bitmap = new Bitmap( _merged );
            mergedBitmap.x = 500;
//            this.addChild( mergedBitmap );

            this.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
        }


        private function draw():void
        {
            sourceImageBMD.copyPixels( copyImageBMD, copyImageBMD.rect,new Point( 0,0 ) );

            var copyLeft:BitmapData = new BitmapData( _offset, sourceImageBMD.height );
            copyLeft.copyPixels( _displacement, new Rectangle( sourceImageBMD.width - _offset,0,_offset,sourceImageBMD.height), new Point(0,0),null,null)
            
            _displacement.scroll( _offset, 0 );
            _displacement.copyPixels( copyLeft,copyLeft.rect, new Point(0,0));

            _merged.copyPixels( _displacement, _displacement.rect, new Point(0,0));
            _merged.draw(_dampenMap);

            sourceImageBMD.copyPixels(copyImageBMD, copyImageBMD.rect, new Point(0,0));
            sourceImageBMD.draw( _displacement, null, new ColorTransform(1,1,1,0.1), BlendMode.HARDLIGHT );
            sourceImageBMD.copyChannel(copyImageBMD,copyImageBMD.rect,new Point(0,0),BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

            var filter:DisplacementMapFilter = new DisplacementMapFilter( _merged, null, 1, 2, _waveSize, _waveSize, DisplacementMapFilterMode.CLAMP );

            sourceImageBMD.applyFilter( sourceImageBMD, sourceImageBMD.rect, new Point(0,0), filter );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function enterFrameHandler( e:Event ):void
        {
            draw();
        }

    }

}