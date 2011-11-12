package nl.usmedia.kinsence.modules.events
{

    import flash.events.Event;


    /**
     * Package:    modules.events
     * Class:      KinectModuleEvent
     *
     * @author     pieter.van.de.sluis
     * @since      10/28/11
     */
    public class KinectModuleEvent extends Event
    {

        // EVENT TYPES
        public static const REGISTERED:String = "KinectModuleEvent::REGISTERED";
        public static const REMOVED:String = "KinectModuleEvent::REMOVED";

        // EVENT DATA


        //_________________________________________________________________________________________________________
        //                                                                                    C O N S T R U C T O R

        public function KinectModuleEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
        {
            super( type, bubbles, cancelable );
        }


        //_________________________________________________________________________________________________________
        //                                                                              P U B L I C   M E T H O D S

        public override function clone():Event
        {
            return new KinectModuleEvent( type, bubbles, cancelable );
        }


        public override function toString():String
        {
            return formatToString( "KinectModuleEvent", "type", "bubbles", "cancelable", "eventPhase" );
        }


        //_________________________________________________________________________________________________________
        //                                                                          G E T T E R S  /  S E T T E R S



    }
}