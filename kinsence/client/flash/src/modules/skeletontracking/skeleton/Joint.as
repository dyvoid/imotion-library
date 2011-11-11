package modules.skeletontracking.skeleton
{
    /**
     * @author Pieter van de Sluis
     */
    public final class Joint
	{
		public var id:uint;
        public var position:KinectVector;
        public var trackingState:uint;

		public function Joint( ):void
		{

		}


        public function fromObject( object:Object ):void
        {
            id = object.ID;

            position = new KinectVector();
            position.fromObject( object.Position );

            trackingState = object.TrackingState;
        }

	}
}