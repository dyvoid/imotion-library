package nl.imotion.burstxml 
{

	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import nl.imotion.burstxml.parsers.IBurstParser;
	

	public class Burst 
	{
		
		private var componentMap:Dictionary;
		
		
		public function Burst() 
		{
		}
		
		
		public function parse( xml:XMLList, target:DisplayObject ):void 
		{
			
		}
		
		
		public function registerComponent( component:Class, parser:Class ):void 
		{
			componentMap[ component ] = parser;
		}
		
		
		public function removeComponent( component:Class, parser:Class ):void 
		{
			if ( componentMap[ component] && ( componentMap[ component] == parser ) )
			{
				delete componentMap[ component ];
			}
		}
		
	}
	
}