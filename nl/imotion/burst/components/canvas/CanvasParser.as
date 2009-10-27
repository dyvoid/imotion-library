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
		public function CanvasParser()
		{
			addAttributeMapping( "padding", uint, "0" );
			addAttributeMapping( "backgroundColor", uint );
		}
		
		override public function create( xml:XML, burst:Burst = null ):DisplayObject
		{
			const padding:Number = getMappedValue( "padding", xml );
			const backgroundColor:Number = getMappedValue( "backgroundColor", xml ) || NaN;
			const canvas:Canvas = new Canvas( padding, backgroundColor );
			
			parseChildren( canvas, xml.children(), burst );
			applyMappings( canvas, xml, [ "padding", "backgroundColor" ] );
			
			return canvas;
		}
		
	}

}