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
		
		public function CanvasParser() { }
		
		
		override protected function initMappings():void
		{
			addAttributeMapping( "padding", uint, "0" );
			addAttributeMapping( "backgroundColor", uint );
			
			super.initMappings();
		}
		
		
		override public function create( xml:XML, burst:Burst = null, targetClass:Class = null ):DisplayObject
		{
			targetClass = targetClass || DEFAULT_TARGET_CLASS;
			
			var padding:Number = getMappedValue( "padding", xml );
			var backgroundColor:Number = getMappedValue( "backgroundColor", xml ) || NaN;
			
			var canvas:Canvas = new targetClass( padding, backgroundColor );
			
			parseChildren( canvas, xml.children(), burst );
			applyMappings( canvas, xml, [ "padding", "backgroundColor" ] );
			
			return canvas;
		}
		
	}

}