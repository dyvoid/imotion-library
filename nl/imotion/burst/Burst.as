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
		
		
		public function bindParser( name:String, parserClass:Class ):void 
		{
			bindMap[ name ] = parserClass;
		}
		
		
		public function bindDisplayObject( name:String, displayObjectClass:Class ):void
		{
			bindMap[ name ] = displayObjectClass;
		}
		
		
		public function hasBinding( name:String ):Boolean
		{
			return ( bindMap[ name ] != null );
		}
		
		
		public function removeBinding( name:String ):Boolean 
		{
			if ( hasBinding( name ) )
			{
				delete bindMap[ name ];
				return true;
			}
			return false;
		}
		
	}
}