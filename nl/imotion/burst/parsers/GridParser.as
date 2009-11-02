package nl.imotion.burst.parsers 
{
	import flash.display.Sprite;
	import nl.imotion.burst.Burst;
	import flash.display.DisplayObject;
	import nl.imotion.burst.components.core.BurstSprite;
	import nl.imotion.utils.grid.GridCalculator;
	
	/**
	 * ...
	 * @author Pieter van de Sluis
	 */
	public class GridParser extends DisplayObjectParser
	{
		private const DEFAULT_TARGET_CLASS:Class = BurstSprite;
		
		
		public function GridParser() 
		{
			addAttributeMapping( "maxWidth", Number, "100" );
			addAttributeMapping( "cellWidth", Number, "100" );
			addAttributeMapping( "cellHeight", Number, "100" );
			addAttributeMapping( "margin", Number, "0" );
		}
		
		
		override public function create( xml:XML, burst:Burst = null, targetClass:Class = null ):DisplayObject 
		{
			targetClass = targetClass || DEFAULT_TARGET_CLASS;
			
			var grid:BurstSprite = new targetClass();
			
			var gridCalc:GridCalculator = new GridCalculator( getMappedValue( "maxWidth", xml ), getMappedValue( "cellWidth", xml ), getMappedValue( "cellHeight", xml ), getMappedValue( "margin", xml ) );
			
			parseChildren( grid, xml.children(), burst );
			applyMappings( grid, xml );
			
			for ( var i:int = 0; i < grid.numChildren; i++ ) 
			{
				grid.getChildAt( i ).x = gridCalc.getCellX( i );
				grid.getChildAt( i ).y = gridCalc.getCellY( i );
			}
			
			return grid;
		}
	}

}