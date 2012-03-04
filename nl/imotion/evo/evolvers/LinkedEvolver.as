package nl.imotion.evo.evolvers
{
    import nl.imotion.evo.evolvers.IEvolver;


    /**
     * @author Pieter van de Sluis
     */
    public class LinkedEvolver extends Evolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _previous:IEvolver;
        private var _next:IEvolver;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function LinkedEvolver()
        {
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get previous():IEvolver
        {
            return _previous;
        }


        public function set previous( value:IEvolver ):void
        {
            _previous = value;
        }


        public function get next():IEvolver
        {
            return _next;
        }


        public function set next( value:IEvolver ):void
        {
            _next = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}