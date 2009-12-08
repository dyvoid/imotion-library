package nl.imotion.burst.parsers 
{
	import flash.display.Sprite;
	import nl.imotion.burst.Burst;
	import flash.display.DisplayObject;
	import nl.imotion.burst.components.grid.SimpleGrid;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class SimpleGridParser extends CanvasParser
	{
		private const DEFAULT_TARGET_CLASS:Class = SimpleGrid;
		
		
		public function SimpleGridParser() { }
		
		
		override protected function initMappings():void 
		{
			addAttributeMapping( "nrOfCols", uint );
			addAttributeMapping( "cellWidth", Number );
			addAttributeMapping( "cellHeight", Number );
			addAttributeMapping( "margin", Number, "0" );
			
			super.initMappings();
		}
		
		
		override public function create( xml:XML, burst:Burst = null, targetClass:Class = null ):DisplayObject 
		{
			targetClass = targetClass || DEFAULT_TARGET_CLASS;
			
			var nrOfCols:uint	 		= getMappedValue( "nrOfCols", xml );
			var cellWidth:Number 		= getMappedValue( "cellWidth", xml );
			var cellHeight:Number 		= getMappedValue( "cellHeight", xml );
			var margin:Number 			= getMappedValue( "margin", xml );
			
			var grid:SimpleGrid = new targetClass( nrOfCols, cellWidth, cellHeight, margin );
			
			parseChildren( grid, xml.children(), burst );
			applyMappings( grid, xml, [ "nrOfCols", "cellWidth", "cellHeight", "margin" ] );
			
			return grid;
		}
	}

}