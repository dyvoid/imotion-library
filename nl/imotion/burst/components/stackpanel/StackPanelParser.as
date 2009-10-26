package nl.imotion.burst.components.stackpanel 
{
	import flash.display.DisplayObject;
	import nl.imotion.burst.Burst;
	import nl.imotion.burst.parsers.BurstDisplayObjectParser;
	import nl.imotion.burst.parsers.BurstParser;
	import nl.imotion.burst.parsers.IBurstParser;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class StackPanelParser extends BurstDisplayObjectParser implements IBurstParser
	{
		
		public function StackPanelParser()
		{
			addAttributeMapping( "orientation", String, StackPanelOrientation.VERTICAL, [ StackPanelOrientation.HORIZONAL, StackPanelOrientation.VERTICAL ] );
			addAttributeMapping( "autoUpdate", Boolean, "true" );
			addAttributeMapping( "margin", Number, "0" );
		}
		
		
		override public function create( xml:XML, burst:Burst = null ):DisplayObject
		{
			const orientation:String 		= getMappedValue( "orientation", xml );
			const autoUpdate:Boolean 	= getMappedValue( "autoUpdate", xml );
			const margin:uint 				= getMappedValue( "margin", xml );
			
			const s:StackPanel = new StackPanel( orientation, autoUpdate, margin );
			
			parseChildren( s, xml.children(), burst );
			applyMappings( s, xml );
			
			return s;
		}
		
	}

}