package nl.usmedia.kinsence.interfaces
{
    /**
     * @author Pieter van de Sluis
     */
    public interface IKinectCore extends IServerMessageHandler
    {
        function registerModule( module:IKinectModule ):IKinectModule
        function removeModule( name:String ):IKinectModule
        function retrieveModule( name:String ):IKinectModule

        function sendMessage( target:String, type:String, data:* = null ):void
    }
}
