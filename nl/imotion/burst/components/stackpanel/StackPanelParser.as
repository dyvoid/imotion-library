package nl.imotion.burst.components.stackpanel 
{
	import flash.display.DisplayObject;
	import nl.imotion.burst.Burst;
	import nl.imotion.burst.parsers.BurstParser;
	import nl.imotion.burst.parsers.IBurstParser;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class StackPanelParser extends BurstParser implements IBurstParser
	{
		public function StackPanelParser()
		{
			addAttributeFilter( "x", Number );
			addAttributeFilter( "y", Number );
		}
		
		
		override public function create( xml:XML, burst:Burst ):DisplayObject
		{
			const orientation:String 		= xml.@orientation || StackPanelOrientation.VERTICAL;
			const autoDistribute:Boolean 	= ( xml.@autoDistribute == "true" );
			const margin:uint 				= ( xml.@margin != undefined ) ? parseInt( xml.@margin ) : 0;
			
			const s:StackPanel = new StackPanel( orientation, autoDistribute, margin );
			
			parseChildren( s, xml.children(), burst );
			processFilters( s, xml );
			
			return s;
		}
		
	}

}