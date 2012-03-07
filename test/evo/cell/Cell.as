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

        private var _brightness     :Number = 0;

        private var _shapeWidth     :Number = 0;
        private var _shapeHeight    :Number = 0;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Cell()
        {
            
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

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


        public function get brightness():Number
        {
            return _brightness;
        }


        public function set brightness( value:Number ):void
        {
            if ( _brightness == value ) return;

            _brightness = value;

            draw();
        }


        public function get surfaceSize():Number
        {
            return _shapeWidth * _shapeHeight;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function draw():void
        {
            var colorChannel:uint = 0xff * _brightness;
            var color:uint = ( colorChannel << 16 ) | ( colorChannel << 8 ) | colorChannel;

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


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}