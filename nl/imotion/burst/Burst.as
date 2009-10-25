package nl.imotion.burst 
{

	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;
	import nl.imotion.burst.parsers.IBurstParser;
	

	public class Burst 
	{
		
		protected var bindMap:Dictionary = new Dictionary();
		
		
		public function Burst() 
		{
			
		}
		
		
		public function parse( xml:XML ):DisplayObject 
		{
			if ( hasBinding( xml.name() ) )
			{
				var instance:* = new bindMap[ xml.name() ]();
				
				switch( true )
				{
					case ( instance is IBurstParser ):
						return IBurstParser( instance ).create( xml, this );
					
					case ( instance is DisplayObject ):
						return instance as DisplayObject;
						
					default:
						return null;
				}
			}
			
			return null;
		}
		
		
		public function bindParser( nodeName:String, parserClass:Class ):void 
		{
			bindMap[ nodeName ] = parserClass;
		}
		
		
		public function bindDisplayObject( nodeName:String, displayObjectClass:Class ):void
		{
			bindMap[ nodeName ] = displayObjectClass;
		}
		
		
		public function hasBinding( nodeName:String ):Boolean
		{
			return ( bindMap[ nodeName ] != null );
		}
		
		
		public function removeBinding( nodeName:String ):Boolean 
		{
			if ( hasBinding( nodeName ) )
			{
				delete bindMap[ nodeName ];
				return true;
			}
			return false;
		}
		
	}
}