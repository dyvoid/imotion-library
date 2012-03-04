package test.evo.nature
{
    /**
     * @author Pieter van de Sluis
     */
    public class EvolveStatus
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const FINISHED_GENERATION :String = "finishedGeneration";
        public static const FINISHED_POPULATION :String = "finishedPopulation";
        public static const FINISHED_All        :String = "finishedAll";

        private var _type           :String;

        private var _generationTime :uint = 0;
        private var _populationTime :uint = 0;
        private var _totalTime      :uint = 0;

        private var _generationNr   :uint = 0;
        private var _populationNr   :uint = 1;

        private var _fitness        :Number = 0;
        private var _momentum       :Number = 0;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function EvolveStatus()
        {

        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function clone():EvolveStatus
        {
            var clone:EvolveStatus = new EvolveStatus();

            clone.type = _type;

            clone.generationTime = _generationTime;
            clone.populationTime = _populationTime;
            clone.totalTime = _totalTime;

            clone.generationNr = _generationNr;
            clone.populationNr = _populationNr;

            clone.fitness      = _fitness;
            clone.momentum     = _momentum;

            return clone;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get type():String
        {
            return _type;
        }

        public function set type( value:String ):void
        {
            _type = value;
        }


        public function get generationTime():uint
        {
            return _generationTime;
        }

        public function set generationTime( value:uint ):void
        {
            _generationTime = value;
        }


        public function get populationTime():uint
        {
            return _populationTime;
        }

        public function set populationTime( value:uint ):void
        {
            _populationTime = value;
        }


        public function get totalTime():uint
        {
            return _totalTime;
        }

        public function set totalTime( value:uint ):void
        {
            _totalTime = value;
        }


        public function get generationNr():uint
        {
            return _generationNr;
        }

        public function set generationNr( value:uint ):void
        {
            _generationNr = value;
        }


        public function get populationNr():uint
        {
            return _populationNr;
        }

        public function set populationNr( value:uint ):void
        {
            _populationNr = value;
        }


        public function get fitness():Number
        {
            return _fitness;
        }

        public function set fitness( value:Number ):void
        {
            _fitness = value;
        }


        public function get momentum():Number
        {
            return _momentum;
        }

        public function set momentum( value:Number ):void
        {
            _momentum = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}