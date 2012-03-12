package test.evo.capsule
{
    import flash.display.Sprite;

    import nl.imotion.evo.evolvers.IUpdateableDisplayObject;


    /**
     * @author Pieter van de Sluis
     */
    public class Capsule extends Sprite implements IUpdateableDisplayObject
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _thickness      :uint;
        private var _length         :uint;
        private var _brightness     :uint;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Capsule()
        {

        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function update():void
        {
            var color:uint = ( _brightness << 16 ) | ( _brightness << 8 ) | _brightness;

            graphics.clear();
            graphics.lineStyle( _thickness, color );
            graphics.moveTo( 0, -length * 0.5 );
            graphics.lineTo( 0, length * 0.5 );
            graphics.endFill();
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get thickness():Number
        {
            return _thickness;
        }

        public function set thickness( value:Number ):void
        {
            _thickness = value;
        }


        public function get length():Number
        {
            return _length;
        }

        public function set length( value:Number ):void
        {
            _length = value;
        }


        public function get brightness():Number
        {
            return _brightness;
        }

        public function set brightness( value:Number ):void
        {
            _brightness = value;
        }


// ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}