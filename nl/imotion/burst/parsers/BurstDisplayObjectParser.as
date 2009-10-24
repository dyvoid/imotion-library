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
			initxmlMappings();
		}
		
		
		private function initxmlMappings():void
		{
			addAttributeMapping( "x", Number, "0" );
			addAttributeMapping( "y", Number, "0" );
			addAttributeMapping( "width", Number );
			addAttributeMapping( "height", Number );
			addAttributeMapping( "scaleX", Number, "1" );
			addAttributeMapping( "scaleY", Number, "1" );
			addAttributeMapping( "alpha", Number, "1" );
			addAttributeMapping( "blendMode", String, BlendMode.NORMAL, [ BlendMode.ADD, BlendMode.ALPHA, BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT, BlendMode.LAYER, BlendMode.LIGHTEN, BlendMode.MULTIPLY, BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.SUBTRACT ] );
			addAttributeMapping( "cacheAsBitmap", Boolean, "true" );
			addAttributeMapping( "rotation", Number, "0");
			addAttributeMapping( "visible", Boolean, "true" );
		}
		
		
		override public function create( xml:XML, burst:Burst = null ):DisplayObject
		{
			throw new Error( "create method should be overridden in subclass." );
		}
		
	}

}