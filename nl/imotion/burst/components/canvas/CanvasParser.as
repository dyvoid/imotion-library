package nl.imotion.burst.components.canvas 
{
	import flash.display.DisplayObject;
	import nl.imotion.burst.Burst;
	import nl.imotion.burst.parsers.BurstDisplayObjectParser;
	import nl.imotion.burst.parsers.BurstParser;
	import nl.imotion.burst.parsers.IBurstParser;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class CanvasParser extends BurstDisplayObjectParser implements IBurstParser
	{
		
		override public function create( xml:XML, burst:Burst = null ):DisplayObject
		{
			const canvas:Canvas = new Canvas();
			
			parseChildren( canvas, xml.children(), burst );
			applyMappings( canvas, xml );
			
			return canvas;
		}
		
	}

}