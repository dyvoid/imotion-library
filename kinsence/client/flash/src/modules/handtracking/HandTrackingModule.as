package modules.handtracking
{
    import modules.handtracking.HandTrackingEvent;

    import modules.AbstractKinectModule;
    import modules.handtracking.hands.Hands;
    import modules.skeletontracking.skeleton.KinectVector;


    /**
     * @author Pieter van de Sluis
     */

    [Event(name="HandControlEvent::HAND_TRACKING_UPDATE", type="modules.handtracking.HandTrackingEvent")]

    public class HandTrackingModule extends AbstractKinectModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const NAME:String = "HandTracking";

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function HandTrackingModule()
        {
            super( NAME );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function onServerMessage( type:String, data:* ):void
        {
            switch( type )
            {
                case "HandTrackingUpdate":
                    var handSets:Array = data;

                    var arr:Array = [];

                    for each ( var handsObject:Object in handSets )
                    {
                        var hands:Hands = new Hands();
                        hands.fromObject( handsObject );
                        arr.push( hands );
                    }

                    dispatchEvent( new HandTrackingEvent( HandTrackingEvent.HAND_TRACKING_UPDATE, arr ) );
                break;
            }
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