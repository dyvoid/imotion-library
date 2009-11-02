package nl.imotion.burst.parsers 
{
	import flash.display.DisplayObject;
	import nl.imotion.burst.Burst;
	import nl.imotion.burst.components.canvas.Canvas;
	import nl.imotion.burst.parsers.BurstParser;
	import nl.imotion.burst.parsers.IBurstParser;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class CanvasParser extends DisplayObjectParser implements IBurstParser
	{
		private const DEFAULT_TARGET_CLASS:Class = Canvas;
		
		public function CanvasParser()
		{
			addAttributeMapping( "padding", uint, "0" );
			addAttributeMapping( "backgroundColor", uint );
		}
		
		
		override public function create( xml:XML, burst:Burst = null, targetClass:Class = null ):DisplayObject
		{
			targetClass = targetClass || DEFAULT_TARGET_CLASS;
			
			const padding:Number = getMappedValue( "padding", xml );
			const backgroundColor:Number = getMappedValue( "backgroundColor", xml ) || NaN;
			const canvas:Canvas = new targetClass( padding, backgroundColor );
			
			parseChildren( canvas, xml.children(), burst );
			applyMappings( canvas, xml, [ "padding", "backgroundColor" ] );
			
			return canvas;
		}
		
	}

}