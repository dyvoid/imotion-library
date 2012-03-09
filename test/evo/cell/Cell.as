package test.evo.cell
{
    import flash.display.CapsStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;

    import org.osmf.layout.ScaleMode;


    /**
     * @author Pieter van de Sluis
     */
    public class Cell extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _colorR:uint = 0;
        private var _colorG:uint = 0;
        private var _colorB:uint = 0;

        private var _shapeWidth     :Number = 0;
        private var _shapeHeight    :Number = 0;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Cell()
        {
            
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function get surfaceSize():Number
        {
            return _shapeWidth * _shapeHeight;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function draw():void
        {
            var color:uint = ( _colorR << 16 ) | ( _colorG << 8 ) | _colorB;

            graphics.clear();
            graphics.beginFill( color );
            graphics.lineStyle( 1, color, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE );
            graphics.drawRect( 0, 0, _shapeWidth, _shapeHeight );
            graphics.endFill();
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        override public function set width( value:Number ):void
        {
            if ( _shapeWidth == value ) return;

            _shapeWidth = value;

            if ( _shapeHeight > 0 )
            {
                draw();
            }
        }


        override public function set height( value:Number ):void
        {
            if ( _shapeHeight == value ) return;

            _shapeHeight = value;

            if ( _shapeWidth > 0 )
            {
                draw();
            }
        }


        override public function get width():Number
        {
            return _shapeWidth;
        }


        override public function get height():Number
        {
            return _shapeHeight;
        }


        public function get colorR():uint
        {
            return _colorR;
        }


        public function set colorR( value:uint ):void
        {
            if ( _colorR == value ) return;

            _colorR = value;

            draw();
        }


        public function get colorG():uint
        {
            return _colorG;
        }


        public function set colorG( value:uint ):void
        {
            if ( _colorG == value ) return;

            _colorG = value;

            draw();
        }


        public function get colorB():uint
        {
            return _colorB;
        }


        public function set colorB( value:uint ):void
        {
            if ( _colorB == value ) return;

            _colorB = value;

            draw();
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}