package nl.imotion.burst 
{

	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;
	import nl.imotion.burst.parsers.IBurstParser;
	

	public class Burst 
	{
		
		private var bindMap:Dictionary = new Dictionary();
		
		
		public function Burst() 
		{
			
		}
		
		
		public function parse( xml:XML ):DisplayObject 
		{			
			var binding:BurstBinding = bindMap[ xml.name() ];
			
			if ( binding )
			{
				var instance:* = new binding.classRef();
				
				switch( true )
				{
					case ( instance is IBurstParser ):
						return IBurstParser( instance ).parse( xml, this );
					break;
					
					case ( instance is DisplayObject ):
						return instance as DisplayObject;
					break;
				}
			}
			
			return null;
		}
		
		
		public function bindParser( name:String, parserClass:Class ):void 
		{
			bindMap[ name ] = new BurstBinding( parserClass, BurstBindingType.PARSER );
		}
		
		
		public function bindDisplayObject( name:String, displayObjectClass:Class ):void
		{
			bindMap[ name ] = new BurstBinding( displayObjectClass, BurstBindingType.DISPLAY_OBJECT );
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