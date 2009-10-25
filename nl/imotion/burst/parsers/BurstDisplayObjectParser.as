package nl.imotion.burst.parsers 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import nl.imotion.burst.Burst;
	import nl.imotion.burst.parsers.IBurstParser;
	import nl.imotion.burst.parsers.BurstParser;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class BurstDisplayObjectParser extends BurstParser implements IBurstParser
	{
		
		public function BurstDisplayObjectParser() 
		{
			initMappings();
		}
		
		
		private function initMappings():void
		{
			addAttributeMapping( "x", Number );
			addAttributeMapping( "y", Number );
			addAttributeMapping( "width", Number );
			addAttributeMapping( "height", Number );
			addAttributeMapping( "scaleX", Number );
			addAttributeMapping( "scaleY", Number );
			addAttributeMapping( "alpha", Number );
			addAttributeMapping( "blendMode", String, null, [ BlendMode.ADD, BlendMode.ALPHA, BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT, BlendMode.LAYER, BlendMode.LIGHTEN, BlendMode.MULTIPLY, BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.SUBTRACT ] );
			addAttributeMapping( "cacheAsBitmap", Boolean );
			addAttributeMapping( "rotation", Number );
			addAttributeMapping( "visible", Boolean );
		}
		
		
		override public function create( xml:XML, burst:Burst = null ):DisplayObject
		{
			throw new Error( "create method should be overridden in subclass." );
		}
		
	}

}