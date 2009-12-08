package nl.imotion.burst.components.events 
{

	import flash.events.Event;

	public class BurstComponentEvent extends Event 
	{
		
		public static const SIZE_CHANGED:String 	= "sizeChanged";
		
		
		public function BurstComponentEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = true ) 
		{
			super( type, bubbles, cancelable );
		}
		
		
		public override function clone():Event 
		{
			return new BurstComponentEvent( type, bubbles, cancelable );
		}
		
		
		public override function toString():String 
		{
			return formatToString( "BurstComponentEvent", "type", "bubbles", "cancelable", "eventPhase" );
		}

	}
}