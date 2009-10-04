package nl.imotion.burst.components.stackpanel 
{
	import flash.display.DisplayObject;
	import nl.imotion.burst.Burst;
	import nl.imotion.burst.parsers.IBurstParser;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class StackPanelParser implements IBurstParser
	{
		
		public function StackPanelParser() 
		{
			
		}
		
		
		public function parse( xml:XML, burst:Burst ):DisplayObject
		{
			var s:StackPanel = new StackPanel( xml.@orientation );
			
			var list:XMLList = xml.*;
			
			for each ( var node:XML in list )
			{
				var d:DisplayObject = burst.parse( node );
				
				if ( d )
				{
					s.addChild( d );
				}
			}
			
			return s;
		}
		
	}

}