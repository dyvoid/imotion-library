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
	public class DisplayObjectParser extends BurstParser implements IBurstParser
	{
		private const DEFAULT_TARGET_CLASS:Class = DisplayObject; 
		
		public function DisplayObjectParser() 
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
		
		
		override public function create( xml:XML, burst:Burst = null, targetClass:Class = null ):DisplayObject
		{
			targetClass = targetClass || DEFAULT_TARGET_CLASS;
			
			const d:DisplayObject = new targetClass();
			
			applyMappings( d, xml );
			
			return d;
		}
		
	}

}