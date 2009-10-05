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
		
		public function create( xml:XML, burst:Burst ):DisplayObject
		{
			var s:StackPanel = new StackPanel( xml.@orientation );
			
			var childNodes:XMLList = xml.children();
			
			for each ( var node:XML in childNodes )
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