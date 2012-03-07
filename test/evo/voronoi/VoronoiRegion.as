package test.evo.voronoi
{
    import com.nodename.Delaunay.Voronoi;

    import flash.display.BitmapData;

    import flash.display.Shape;

    import flash.display.Sprite;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;

    import nl.imotion.evo.evolvers.IUpdateableDisplayObject;

    import test.evo.util.Texture;


    /**
     * @author Pieter van de Sluis
     */
    public class VoronoiRegion extends Sprite implements IUpdateableDisplayObject
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _point:Point;

        private var _colorR:uint;
        private var _colorG:uint;
        private var _colorB:uint;

        private var _redMultiplier:Number;
        private var _greenMultiplier:Number;
        private var _blueMultiplier:Number;

        private var _textureOffsetX:Number;
        private var _textureOffsetY:Number;
        private var _textureOffsetRotation:Number;

        private var _voronoi:Voronoi;

        private var _texture:BitmapData;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function VoronoiRegion()
        {
            _point = new Point( 0, 0 );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function update():void
        {
            var region:Vector.<Point> = _voronoi.region( _point );
            var color:uint = ( colorR << 16 ) | ( colorB << 8 ) | colorG;

            _texture = Texture.NOISE;

            drawRegion( region, color );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function drawRegion( region:Vector.<Point>, color:uint ):void
        {
            this.x = region[ 0 ].x;
            this.y = region[ 0 ].y;

            graphics.clear();
            graphics.lineStyle( 1, color );
            graphics.beginFill( color );

            /*var m:Matrix = new Matrix();
//            m.rotate( _textureOffsetRotation * ( Math.PI * 2 ) );
            m.tx = _textureOffsetX * _texture.width;
            m.ty = _textureOffsetY * _texture.height;
            graphics.beginBitmapFill( _texture, m );
//            graphics.beginBitmapFill( _texture );

            var colorTransformer:ColorTransform = this.transform.colorTransform;
            colorTransformer.redMultiplier = _redMultiplier;
            colorTransformer.greenMultiplier = _greenMultiplier;
            colorTransformer.blueMultiplier = _blueMultiplier;
            this.transform.colorTransform = colorTransformer;*/

            for ( var j:int = 1; j < region.length; j++ )
            {
                var p:Point = region[ j ];
                graphics.lineTo( p.x - this.x, p.y - this.y );
            }

            graphics.endFill();
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get centerX():Number
        {
            return _point.x;
        }

        public function set centerX( value:Number ):void
        {
            _point.x = value;
        }


        public function get centerY():Number
        {
            return _point.y;
        }

        public function set centerY( value:Number ):void
        {
            _point.y = value;
        }


        public function get redMultiplier():Number
        {
            return _redMultiplier;
        }


        public function set redMultiplier( value:Number ):void
        {
            _redMultiplier = value;
        }


        public function get greenMultiplier():Number
        {
            return _greenMultiplier;
        }


        public function set greenMultiplier( value:Number ):void
        {
            _greenMultiplier = value;
        }


        public function get blueMultiplier():Number
        {
            return _blueMultiplier;
        }


        public function set blueMultiplier( value:Number ):void
        {
            _blueMultiplier = value;
        }


        public function get textureOffsetX():Number
        {
            return _textureOffsetX;
        }


        public function set textureOffsetX( value:Number ):void
        {
            _textureOffsetX = value;
        }


        public function get textureOffsetY():Number
        {
            return _textureOffsetY;
        }


        public function set textureOffsetY( value:Number ):void
        {
            _textureOffsetY = value;
        }


        public function get textureOffsetRotation():Number
        {
            return _textureOffsetRotation;
        }


        public function set textureOffsetRotation( value:Number ):void
        {
            _textureOffsetRotation = value;
        }


        public function get colorR():uint
        {
            return _colorR;
        }


        public function set colorR( value:uint ):void
        {
            _colorR = value;
        }


        public function get colorG():uint
        {
            return _colorG;
        }


        public function set colorG( value:uint ):void
        {
            _colorG = value;
        }


        public function get colorB():uint
        {
            return _colorB;
        }


        public function set colorB( value:uint ):void
        {
            _colorB = value;
        }


        public function get point():Point
        {
            return _point;
        }


        public function get voronoi():Voronoi
        {
            return _voronoi;
        }


        public function set voronoi( value:Voronoi ):void
        {
            _voronoi = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS




    }
    
}