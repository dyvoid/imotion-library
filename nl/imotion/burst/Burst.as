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
				var binding:BurstBinding = bindMap[ xml.name() ];
				var instance:* = new binding.classRef();
				
				switch( binding.type )
				{
					case BurstBindingType.PARSER:
						return IBurstParser( instance ).create( xml, this );
					break;
					
					case BurstBindingType.DISPLAY_OBJECT:
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