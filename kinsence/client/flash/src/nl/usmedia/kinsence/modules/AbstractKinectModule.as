package nl.usmedia.kinsence.modules
{
    import flash.events.EventDispatcher;

    import nl.usmedia.kinsence.interfaces.IKinectCore;

    import nl.usmedia.kinsence.interfaces.IKinectModule;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="KinectModuleEvent::REGISTERED", type="nl.usmedia.kinsence.modules.events.KinectModuleEvent")]
    [Event(name="KinectModuleEvent::REMOVED", type="nl.usmedia.kinsence.modules.events.KinectModuleEvent")]

    public class AbstractKinectModule extends EventDispatcher implements IKinectModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _name       :String;
        private var _core       :IKinectCore;
        
        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function AbstractKinectModule( name:String )
        {
            _name = name;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function onRegister():void { }

        public function onRemove():void { }

        public function onServerMessage( type:String, data:* ):void { }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED

        protected function sendMessage( type:String, data:* = null ):void
        {
            _core.sendMessage( _name, type, data );
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get core():IKinectCore
        {
            return _core;
        }

        public function set core( value:IKinectCore ):void
        {
            _core = value;
        }
        

        public function get name():String
        {
            return _name;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

    }
}