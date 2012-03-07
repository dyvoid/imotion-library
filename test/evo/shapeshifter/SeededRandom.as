package test.evo.shapeshifter
{
    import flash.display.BitmapData;


    /**
     * @author Pieter van de Sluis
     */
    public class SeededRandom
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _seed:uint = 0;
        private var _pointer:uint = 0;
        private var _size:uint = 1;

        private var _bmd:BitmapData;

        private var _isInvalidated:Boolean = true;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function SeededRandom( seed:uint = 0, size:uint = 1 )
        {
            _seed = seed;
            _size = size;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function reset():void
        {
            _pointer = 0;
        }


        public function invalidate():void
        {
            _isInvalidated = true;
        }


        public function random():Number
        {
            var result:Number = ( bmd.getPixel32( _pointer, 1 ) * 0.999999999999998 + 0.000000000000001 ) / 0xFFFFFFFF;

            _pointer = ( _pointer + 1 ) % _size;

            return result;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED

        protected function get bmd():BitmapData
        {
            if ( _isInvalidated )
            {
                _bmd = new BitmapData( _size, 2 );
                _bmd.noise( _seed, 0, 255, 1 | 2 | 4 | 8 );
                _pointer = 0;
                _isInvalidated = false;
            }

            return _bmd;
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get seed():uint
        {
            return _seed;
        }


        public function set seed( value:uint ):void
        {
            if ( _seed == value ) return;

            _seed = value;

            _isInvalidated = true;
        }


        public function get size():uint
        {
            return _size;
        }


        public function set size( value:uint ):void
        {
            if ( _size == value ) return;

            _size = value;

            _isInvalidated = true;
        }


        public function get pointer():uint
        {
            return _pointer;
        }


        public function set pointer( value:uint ):void
        {
            if ( value > size - 1 ) throw new Error( "The pointer is out of range." );

            _pointer = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}