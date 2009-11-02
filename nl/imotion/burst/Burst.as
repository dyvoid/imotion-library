package nl.imotion.burst 
{

	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;
	import nl.imotion.burst.parsers.IBurstParser;
	import nl.imotion.burst.parsers.ParserPool;
	

	public class Burst 
	{
		
		protected var bindMap:Dictionary 	= new Dictionary();
		
		protected var parserPool:ParserPool	= new ParserPool();
		
		
		public function Burst() 
		{
			
		}
		
		
		public function parse( xml:XML ):DisplayObject 
		{
			var binding:BurstBinding = bindMap[ xml.name() ];
			
			if ( binding )
			{
				var parser:IBurstParser = parserPool.getParser( binding.parserClass );
				
				return parser.create( xml, this, binding.targetClass );
			}
			
			return null;
		}
		
		
		public function bindParser( nodeName:String, parserClass:Class, targetClass:Class = null ):void 
		{
			bindMap[ nodeName ] = new BurstBinding( parserClass, targetClass );
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
		
		
		public function purge():void
		{
			bindMap = new Dictionary();
			parserPool.purge();
		}
		
	}
}