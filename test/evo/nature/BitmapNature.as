package test.evo.nature
{
    import nl.imotion.evo.evolvers.ILinkedEvolver;

    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.utils.getTimer;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.evaluators.BitmapEvaluator;
    import nl.imotion.evo.evaluators.IFitnessEvaluator;
    import nl.imotion.evo.evolvers.IBitmapEvolver;
    import nl.imotion.utils.momentum.MomentumCalculator;


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
        private var _numEvosPerPopulation    :uint = 50;

        private var _evaluator       :IFitnessEvaluator;

        private var _minEvoFitness   :Number = 0.5;

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

            var newPopulationFitness:Number = mutateAndEvaluateEvos( _firstEvo );
            _momentumCalc.addSample( newPopulationFitness );

            _fitnessList.sortOn( "fitness", Array.DESCENDING | Array.NUMERIC );

            _status.fitness = newPopulationFitness;
            _status.momentum = _momentumCalc.momentum;

            if ( newPopulationFitness >= _targetPopulationFitness || ( _momentumCalc.isReady && ( Math.abs( _momentumCalc.momentum ) < _minGenerationMomentum ) ) )
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


        public function draw():BitmapData
        {
            var result:Sprite = new Sprite();

            for each ( var evo:IBitmapEvolver in _fitnessList )
            {
                result.addChildAt( evo.getBitmap(), 0 );
            }

            var resultBmd:BitmapData = new BitmapData( _sourceBitmapData.width, _sourceBitmapData.height, true, 0x00000000 )
            resultBmd.draw( result );

            return resultBmd;
        }


        public function getGenomeXML():XML
        {
            var xml:XML = <root />;
            var evo:ILinkedEvolver = firstEvo;

            do
            {
                xml.appendChild( evo.genome.toXML() );

                evo = evo.next;
            }
            while ( evo );

            return xml;
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
                _fitnessList[ 0 ] = _firstEvo;
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
            evo.reset();
        }


        protected function mutateEvo( evo:IBitmapEvolver ):void
        {
            evo.mutate();
        }


        protected function evaluateEvo( evo:IBitmapEvolver ):Number
        {
            return _evaluator.evaluate( evo )
        }


        protected function mutateAndEvaluateEvos( firstEvo:IBitmapEvolver ):Number
        {
            var evo:IBitmapEvolver = firstEvo;
            var newPopulationFitness:Number = 0;

            do
            {
                if ( evo.momentum != 0 || !IBitmapEvolver( evo ).momentumIsReady )
                {
                    mutateEvo( evo );
                    var fitness:Number = evaluateEvo( evo );

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

            return newPopulationFitness;
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
                var genome1:Genome = _fitnessList[ 0 ].genome;
                var genome2:Genome = _fitnessList[ 1 ].genome;

                return genome1.mate( genome2 );
            }
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get numEvosPerPopulation():uint
        {
            return _numEvosPerPopulation;
        }


        public function set numEvosPerPopulation( value:uint ):void
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


        public function get minEvoFitness():Number
        {
            return _minEvoFitness;
        }


        public function set minEvoFitness( value:Number ):void
        {
            _minEvoFitness = value;
        }


        public function get firstEvo():IBitmapEvolver
        {
            return _firstEvo;
        }


        public function set firstEvo( value:IBitmapEvolver ):void
        {
            _firstEvo = value;
        }


        public function get fitnessList():Array
        {
            return _fitnessList;
        }

        public function set fitnessList( value:Array ):void
        {
            _fitnessList = value;
        }


        public function get targetPopulationFitness():Number
        {
            return _targetPopulationFitness;
        }


        public function set targetPopulationFitness( value:Number ):void
        {
            _targetPopulationFitness = value;
        }


        public function get minGenerationMomentum():Number
        {
            return _minGenerationMomentum;
        }


        public function set minGenerationMomentum( value:Number ):void
        {
            _minGenerationMomentum = value;
        }


        public function get momentumCalc():MomentumCalculator
        {
            return _momentumCalc;
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}