package test.evo.nature
{
    import test.evo.*;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.utils.getTimer;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.evaluators.BitmapEvaluator;
    import nl.imotion.evo.evaluators.IFitnessEvaluator;
    import nl.imotion.evo.evolvers.IBitmapEvolver;
    import nl.imotion.evo.evolvers.IBitmapEvolver;
    import nl.imotion.utils.momentum.MomentumCalculator;
    import nl.imotion.utils.range.Range;


    /**
     * @author Pieter van de Sluis
     */
    public class BitmapNature
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _firstEvo:IBitmapEvolver;

        private var _targetPopulationFitness:Number = 0.99;
        private var _minGenerationMomentum:Number = 0.0000001;

        private var _sourceBitmapData        :BitmapData;

        private var _maxNumPopulations       :uint = 1;
        private var _numEvosPerPopulation    :uint = 2;

        private var _evaluator       :IFitnessEvaluator;

        private var _minEvoFitness   :Number = 0.7;

        private var _fitnessList     :/*IBitmapEvolver*/Array = [];

        private var _momentumCalc    :MomentumCalculator;

        private var _status          :EvolveStatus;

        private var _useMating       :Boolean = true;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function BitmapNature( sourceBitmapData:BitmapData = null, evaluator:IFitnessEvaluator = null )
        {
            _sourceBitmapData = sourceBitmapData;
            _evaluator = ( evaluator == null ) ? new BitmapEvaluator( sourceBitmapData ) : evaluator;
            _status = new EvolveStatus();
            _momentumCalc = new MomentumCalculator( 30 );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function evolve():EvolveStatus
        {
            var startTime:uint = getTimer();

            if ( !_firstEvo )
                initializePopulation( false );

            if ( _status.type == EvolveStatus.FINISHED_POPULATION )
            {
                _status.populationNr++;
                _status.populationTime = 0;
                _status.generationNr = 0;
                _status.fitness = 0;

                initializePopulation( _useMating );

                _momentumCalc.reset();
            }

            _status.type = EvolveStatus.FINISHED_GENERATION;

            var evo:IBitmapEvolver = _firstEvo;
            var newPopulationFitness:Number = 0;

            var i:int = 0;

            do
            {
                if ( IBitmapEvolver( evo ).momentum != 0 || !IBitmapEvolver( evo ).momentumIsReady )
                {
                    evo.mutate();
                    var fitness:Number = _evaluator.evaluate( evo );

                    if ( evo.fitness < fitness )
                    {
                        evo.reward( fitness );
                    }
                    else
                    {
                        evo.punish();
                    }
                }
                else if ( evo.fitness < _minEvoFitness )
                {
                    evo.genome = createMatedGenome();
                    resetEvo( evo );
                }

                newPopulationFitness += evo.fitness;

                evo = IBitmapEvolver( evo.next );
            }
            while ( evo );

            newPopulationFitness = newPopulationFitness / _fitnessList.length;
            _momentumCalc.addSample( newPopulationFitness );

            _fitnessList.sortOn( "fitness", Array.DESCENDING | Array.NUMERIC );

            _status.fitness = newPopulationFitness;
            _status.momentum = _momentumCalc.momentum;

            if ( newPopulationFitness > _targetPopulationFitness || ( _momentumCalc.isReady && ( Math.abs( _momentumCalc.momentum ) < _minGenerationMomentum ) ) )
            {
                if ( _status.populationNr == _maxNumPopulations )
                {
                    _status.type = EvolveStatus.FINISHED_All;
                }
                else
                {
                    _status.type = EvolveStatus.FINISHED_POPULATION;
                }
            }

            _status.generationNr++;

            _status.generationTime = getTimer() - startTime;
            _status.populationTime += _status.generationTime;

            if ( _status.type == EvolveStatus.FINISHED_All )
                _status.totalTime += _status.populationTime;

            return _status.clone();
        }


        public function getAllEvoTargets():Sprite
        {
            var result:Sprite = new Sprite();

            for each ( var evo:IBitmapEvolver in _fitnessList )
            {
                if ( evo.fitness > _minEvoFitness )
                    result.addChildAt( DisplayObject( evo.evoTarget ), 0 );
            }

            return result;
        }


        public function getQuickPreview():Sprite
        {
            var result:Sprite = new Sprite();

            var evo:IBitmapEvolver = _firstEvo;

            do
            {
                result.addChild( evo.getBitmap() );

                evo = IBitmapEvolver( evo.next );
            }
            while ( evo );

            return result;
        }


        public function getBitmapData():BitmapData
        {
            var result:Sprite = new Sprite();

            for each ( var evo:IBitmapEvolver in _fitnessList )
            {
                if ( evo.fitness > _minEvoFitness )
                    result.addChildAt( evo.getBitmap(), 0 );
            }

            var resultBmd:BitmapData = new BitmapData( _sourceBitmapData.width, _sourceBitmapData.height, true, 0x00000000 )
            resultBmd.draw( result );

            return resultBmd;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED

        protected function initializePopulation( useMating:Boolean = true ):void
        {
            var evoCount:Number = 1;

            if ( !_firstEvo )
            {
                _firstEvo = createEvo();
                _fitnessList[ _fitnessList.length ] = _firstEvo;
            }

            var evo:IBitmapEvolver = _firstEvo;

            do
            {
                if ( !evo.next && evoCount < _numEvosPerPopulation )
                {
                    evo.next = createEvo();
                    evo.next.previous = evo;
                    _fitnessList[ _fitnessList.length ] = IBitmapEvolver( evo.next );
                }

                if ( useMating && _fitnessList.length > 1 && _status.populationNr > 1 )
                {
                    evo.genome = createMatedGenome();
                }

                resetEvo( evo );

                evoCount++;

                evo = IBitmapEvolver( evo.next );

            }
            while ( evo );
        }


        protected function createEvo():IBitmapEvolver
        {
            // Implement in subclass
            return null;
        }
        
        
        protected function resetEvo( evo:IBitmapEvolver ):void
        {
            // Implement in subclass
            evo.reset();
        }


        // This method assumes the list has been sorted, fittest first
        protected function createMatedGenome():Genome
        {
            if ( _fitnessList.length == 1 )
            {
                return _fitnessList[ 0 ].genome.clone();
            }
            else
            {
                var genome1:Genome = _fitnessList[ 0 ].genome.clone();
                var genome2:Genome = _fitnessList[ 1 ].genome.clone();

                return genome1.mate( genome2 );
            }
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        protected function get numEvosPerPopulation():Number
        {
            return _numEvosPerPopulation;
        }


        protected function set numEvosPerPopulation( value:Number ):void
        {
            _numEvosPerPopulation = value;
        }


        public function get status():EvolveStatus
        {
            return _status.clone();
        }

        public function get sourceBitmapData():BitmapData
        {
            return _sourceBitmapData;
        }


        public function set sourceBitmapData( value:BitmapData ):void
        {
            _sourceBitmapData = value;
        }


        public function get maxNumPopulations():uint
        {
            return _maxNumPopulations;
        }


        public function set maxNumPopulations( value:uint ):void
        {
            _maxNumPopulations = value;
        }


        public function get useMating():Boolean
        {
            return _useMating;
        }

        public function set useMating( value:Boolean ):void
        {
            _useMating = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}