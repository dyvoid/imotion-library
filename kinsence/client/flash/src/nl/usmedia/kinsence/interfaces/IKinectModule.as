package nl.usmedia.kinsence.interfaces
{
    import flash.events.IEventDispatcher;


    /**
     * @author Pieter van de Sluis
     */
    public interface IKinectModule extends IServerMessageHandler, IEventDispatcher
    {
        function onRegister():void
        function onRemove():void

        function get core():IKinectCore
        function set core( value:IKinectCore ):void

        function get name():String
    }
}
