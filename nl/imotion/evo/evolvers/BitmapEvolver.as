package nl.imotion.evo.evolvers
{
    import flash.display.DisplayObject;

    import test.evo.scribbler.*;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    import nl.imotion.evo.Genome;
    import nl.imotion.utils.momentum.MomentumCalculator;


    /**
     * @author Pieter van de Sluis
     */
    public class BitmapEvolver extends Evolver implements IBitmapEvolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _container:Sprite;

        private var _areaWidth:Number;
        private var _areaHeight:Number;

        private var _previous:ILinkedEvolver;
        private var _next:ILinkedEvolver;

        private var _evoTarget:IUpdateableDisplayObject;

        private var _previousBitmap:Bitmap;
        private var _bitmap:Bitmap;

        private var _momentumCalc:MomentumCalculator;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function BitmapEvolver( evoTarget:IUpdateableDisplayObject, areaWidth:Number, areaHeight:Number )
        {
            _evoTarget = evoTarget;
            _areaWidth = areaWidth;
            _areaHeight = areaHeight;

            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function mutate( mutationDampening:Number = 0, updateMomentum:Boolean = true ):Genome
        {
            super.mutate( mutationDampening, updateMomentum );

            if ( _bitmap )
                _previousBitmap = _bitmap;

            _bitmap = null;

            return genome;
        }


        override public function reward( fitness:Number ):Genome
        {
            _previousBitmap = null;

            _momentumCalc.addSample( fitness );

            return super.reward( fitness );
        }


        override public function punish():Genome
        {
            _bitmap = _previousBitmap;
            _previousBitmap = null;

            _momentumCalc.addSample( fitness );

            return super.punish();
        }


        public function reset():IEvolver
        {
            previousGenome = null;
            
            fitness = 0;

            _previousBitmap =
            _bitmap = null;

            _momentumCalc.reset();

            return this;
        }


        public function getBitmap():Bitmap
        {
            if ( !_bitmap )
            {
                genome.apply( _evoTarget );
                _evoTarget.update();

                var bounds:Rectangle = _evoTarget.getBounds( _container );

                if ( bounds.left < 0 ) bounds.left = 0;
                if ( bounds.top  < 0 ) bounds.top  = 0;
                if ( bounds.right  > _areaWidth  ) bounds.right  = _areaWidth;
                if ( bounds.bottom > _areaHeight ) bounds.bottom = _areaHeight;

                if ( bounds.width  < 1 ) bounds.width  = 1;
                if ( bounds.height < 1 ) bounds.height = 1;

                var bmd:BitmapData = new BitmapData( bounds.width, bounds.height, true, 0x00000000 );
                bmd.draw( _container, new Matrix( 1, 0, 0, 1, -bounds.left, -bounds.top ) );

                _bitmap = new Bitmap( bmd );
                _bitmap.x = bounds.x;
                _bitmap.y = bounds.y;
            }

            return getBitmapClone();
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            _container = new Sprite();
            _container.addChild( DisplayObject( _evoTarget ) );

            _momentumCalc = new MomentumCalculator( 20 );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED

        protected function getBitmapClone():Bitmap
        {
            if ( !_bitmap ) return null;

            var bm:Bitmap = new Bitmap( _bitmap.bitmapData );
            bm.transform.matrix = _bitmap.transform.matrix;

            return bm;
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        protected function get container():Sprite
        {
            return _container;
        }

        protected function set container( value:Sprite ):void
        {
            _container = value;
        }


        protected function get areaWidth():Number
        {
            return _areaWidth;
        }

        protected function set areaWidth( value:Number ):void
        {
            _areaWidth = value;
        }


        protected function get areaHeight():Number
        {
            return _areaHeight;
        }

        protected function set areaHeight( value:Number ):void
        {
            _areaHeight = value;
        }


        public function get evoTarget():IUpdateableDisplayObject
        {
            return _evoTarget;
        }


        protected function get previousBitmap():Bitmap
        {
            return _previousBitmap;
        }

        protected function set previousBitmap( value:Bitmap ):void
        {
            _previousBitmap = value;
        }


        protected function get bitmap():Bitmap
        {
            return _bitmap;
        }

        protected function set bitmap( value:Bitmap ):void
        {
            _bitmap = value;
        }


        protected function get momentumCalc():MomentumCalculator
        {
            return _momentumCalc;
        }

        protected function set momentumCalc( value:MomentumCalculator ):void
        {
            _momentumCalc = value;
        }


        public function get previous():ILinkedEvolver
        {
            return _previous;
        }

        public function set previous( value:ILinkedEvolver ):void
        {
            _previous = value;
        }


        public function get next():ILinkedEvolver
        {
            return _next;
        }
        
        public function set next( value:ILinkedEvolver ):void
        {
            _next = value;
        }


        public function get momentum():Number
        {
            return _momentumCalc.isReady ? _momentumCalc.momentum : 1;
        }


        public function get momentumIsReady():Boolean
        {
            return _momentumCalc.isReady;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}