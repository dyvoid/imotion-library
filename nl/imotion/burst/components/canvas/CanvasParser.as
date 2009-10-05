package nl.imotion.burst.components.canvas 
{
	import flash.display.DisplayObject;
	import nl.imotion.burst.parsers.IBurstParser;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class CanvasParser implements IBurstParser
	{
		
		public function create( xml:XML, burst:Burst ):DisplayObject
		{
			var c:Canvas = new Canvas();
			
			var childNodes:XMLList = xml.children();
			
			for each ( var node:XML in childNodes )
			{
				var d:DisplayObject = burst.parse( node );
				
				if ( d )
				{
					c.addChild( d );
				}
			}
			
			return c;
		}
		
	}

}