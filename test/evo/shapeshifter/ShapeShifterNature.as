package test.evo.shapeshifter
{
    import test.evo.scribbler.*;
    import flash.display.BitmapData;

    import nl.imotion.evo.evolvers.IBitmapEvolver;
    import nl.imotion.utils.range.Range;

    import test.evo.nature.BitmapNature;


    /**
     * @author Pieter van de Sluis
     */
    public class ShapeShifterNature extends BitmapNature
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _currMinSize    :Number;
        private var _currMaxSize    :Number;

        private var _minSizeRange   :Range = new Range( 30, 5 );
        private var _maxSizeRange   :Range = new Range( 100, 60 );

        private var _numEvosRange   :Range = new Range( 100, 500 );

        [Embed(source="../assets/charlize_complexity_map.png")]
        private var ComplexityMap:Class;

        private var _complexityMap:BitmapData;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function ShapeShifterNature( sourceBitmapData:BitmapData )
        {
            _complexityMap = new ComplexityMap().bitmapData;

            super( sourceBitmapData );

            minEvoFitness = 0.8;
            maxNumPopulations = 20;
            useMating = false;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override protected function createEvo():IBitmapEvolver
        {
            var evo:ShapeShifterEvolver = new ShapeShifterEvolver( sourceBitmapData.width, sourceBitmapData.height, _complexityMap );
            evo.minSize = _currMinSize;
            evo.maxSize = _currMaxSize;

            return evo;
        }


        override protected function resetEvo( evo:IBitmapEvolver ):void
        {
            var s:ShapeShifterEvolver = evo as ShapeShifterEvolver;
            s.minSize = _currMinSize;
            s.maxSize = _currMaxSize;

            super.resetEvo( evo );
        }


        override protected function initializePopulation( useMating:Boolean = true ):void
        {
            var relPop:Number;
            if ( maxNumPopulations > 1 )
            {
                relPop = ( status.populationNr - 1 ) / ( maxNumPopulations - 1 );
            }
            else
            {
                relPop = 1;
            }

            numEvosPerPopulation = _numEvosRange.getValueFromRelativePos( relPop );

            _currMinSize = _minSizeRange.getValueFromRelativePos( relPop );
            _currMaxSize = _maxSizeRange.getValueFromRelativePos( relPop );

            super.initializePopulation( useMating );
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}