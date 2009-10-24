package nl.imotion.burst.components.canvas 
{
	import flash.display.DisplayObject;
	import nl.imotion.burst.Burst;
	import nl.imotion.burst.parsers.BurstParser;
	import nl.imotion.burst.parsers.IBurstParser;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class CanvasParser extends BurstParser implements IBurstParser
	{
		public function CanvasParser()
		{
			addAttributeFilter( "x", Number );
			addAttributeFilter( "y", Number );
		}
		
		
		override public function create( xml:XML, burst:Burst ):DisplayObject
		{
			const canvas:Canvas = new Canvas();
			
			parseChildren( canvas, xml.children(), burst );
			processFilters( canvas, xml );
			
			return canvas;
		}
		
	}

}