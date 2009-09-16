package nl.imotion.events 
{
	import flash.events.Event;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class DataEvent extends Event 
	{
		private var _data:Object
		
		
		public function DataEvent( type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false ) 
		{ 
			super( type, bubbles, cancelable );
			
			_data = data;			
		} 
		
		
		public override function clone():Event 
		{ 
			return new DataEvent( type, data, bubbles, cancelable );
		} 
		
		
		public override function toString():String 
		{ 
			return formatToString( "DataEvent", "type", "data", "bubbles", "cancelable", "eventPhase" ); 
		}
		
		
		public function get data():Object { return _data; }
		
	}
	
}