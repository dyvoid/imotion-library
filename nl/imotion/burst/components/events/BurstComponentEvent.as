package nl.imotion.burst.components.events 
{

	import flash.events.Event;

	public class BurstComponentEvent extends Event 
	{

		public static const WIDTH_CHANGED:String 	= "BurstComponentEvent::WIDTH_CHANGED";
		public static const HEIGHT_CHANGED:String 	= "BurstComponentEvent::HEIGHT_CHANGED";
		public static const SIZE_CHANGED:String 	= "BurstComponentEvent::SIZE_CHANGED";
		
		
		public function BurstComponentEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) 
		{
			super( type, bubbles, cancelable );
		}
		
		
		public override function clone():Event 
		{
			return new BurstComponentEvent( type, bubbles, cancelable );
		}
		
		
		public override function toString():String 
		{
			return formatToString( "BurstComponentEvent", "type", "bubbles", "cancelable", "eventPhase", "WIDTH_CHANGED", "HEIGHT_CHANGED", "SIZE_CHANGED" );
		}

	}
}