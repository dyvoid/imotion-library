package nl.imotion.burst.parsers 
{
	import flash.display.DisplayObject;
	import nl.imotion.burst.Burst;
	import nl.imotion.burst.components.stackpanel.StackPanel;
	import nl.imotion.burst.components.stackpanel.StackPanelOrientation;
	import nl.imotion.burst.parsers.BurstParser;
	import nl.imotion.burst.parsers.IBurstParser;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class StackPanelParser extends CanvasParser implements IBurstParser
	{
		private const DEFAULT_TARGET_CLASS:Class = StackPanel;
		
		
		public function StackPanelParser() { }
		
		
		override protected function initMappings():void
		{
			addAttributeMapping( "orientation", String, StackPanelOrientation.VERTICAL, [ StackPanelOrientation.HORIZONAL, StackPanelOrientation.VERTICAL ] );
			addAttributeMapping( "autoUpdate", Boolean, "true" );
			addAttributeMapping( "margin", Number, "0" );
			
			super.initMappings();
		}
		
		
		override public function create( xml:XML, burst:Burst = null, targetClass:Class = null ):DisplayObject
		{
			targetClass = targetClass || DEFAULT_TARGET_CLASS;
			
			const orientation:String 		= getMappedValue( "orientation", xml );
			const autoUpdate:Boolean 		= getMappedValue( "autoUpdate", xml );
			const margin:Number				= getMappedValue( "margin", xml );
			
			const s:StackPanel = new targetClass( orientation, autoUpdate, margin );
			
			parseChildren( s, xml.children(), burst );
			applyMappings( s, xml, [ "orientation", "autoUpdate", "margin" ] );
			
			return s;
		}
		
	}

}