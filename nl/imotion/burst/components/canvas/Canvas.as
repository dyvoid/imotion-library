package nl.imotion.burst.components.canvas 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import nl.imotion.burst.components.core.IBurstComponent;
	import nl.imotion.burst.components.core.BurstSprite;
	import nl.imotion.burst.components.events.BurstComponentEvent;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class Canvas extends BurstSprite implements IBurstComponent
	{
		private var _padding: uint = 0;
		
		protected var backgroundContainer	:Sprite;
		protected var childContainer		:BurstSprite = new BurstSprite();
		
		
		public function Canvas( padding:uint = 0, backgroundColor:Number = NaN ) 
		{
			init( padding, backgroundColor );
		}
		
		
		private function init( padding:uint = 0, backgroundColor:Number = NaN ):void
		{
			super.addChild( childContainer  );
			
			this.padding = padding;
			if ( !isNaN( backgroundColor ) )
				this.backgroundColor = backgroundColor;
			
			startEventInterest( childContainer, BurstComponentEvent.WIDTH_CHANGED, sizeChangedHandler );
			startEventInterest( childContainer, BurstComponentEvent.HEIGHT_CHANGED, sizeChangedHandler );
			startEventInterest( childContainer, BurstComponentEvent.SIZE_CHANGED, sizeChangedHandler );
		}
		
		
		private function sizeChangedHandler( e:BurstComponentEvent ):void
		{
			updateBackgroundSize();
		}
		
		
		
		protected function updateBackgroundSize():void
		{
			if ( backgroundContainer )
			{
				backgroundContainer.x		= childContainer.getBounds( this ).x - padding;
				backgroundContainer.y		= childContainer.getBounds( this ).y - padding;
				backgroundContainer.width 	= childContainer.width  + ( _padding * 2 );
				backgroundContainer.height 	= childContainer.height + ( _padding * 2 );
			}
		}
		
		public function set backgroundColor( value:Number ):void
		{
			if ( !backgroundContainer )
			{
				backgroundContainer = super.addChildAt( new Sprite(), 0 ) as Sprite;
			}
			
			var g:Graphics = backgroundContainer.graphics;
			g.beginFill( value );
			g.drawRect( 0, 0, 1, 1 );
			
			updateBackgroundSize();
		}
		
		
		public function get padding():uint { return _padding; }
		
		public function set padding( value:uint ):void 
		{
			if ( _padding != value )
			{
				_padding			=			
				childContainer.x	= 
				childContainer.y 	= value;
			}
		}
		
		
		override public function addChild( child:DisplayObject ):DisplayObject 
		{
			childContainer.addChild(child);
			updateBackgroundSize();
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			childContainer.addChildAt(child, index);
			updateBackgroundSize();
			return child;
		}
		
		override public function removeChild( child:DisplayObject ):DisplayObject 
		{
			childContainer.removeChild(child);
			updateBackgroundSize();
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject 
		{
			var child:DisplayObject = childContainer.removeChildAt(index);
			updateBackgroundSize();
			return child;
		}
		
		override public function getChildAt(index:int):DisplayObject 
		{
			return childContainer.getChildAt(index);
		}
		
		override public function contains(child:DisplayObject):Boolean 
		{
			return childContainer.contains(child);
		}
		
		
		override public function get width():Number
		{
			return childContainer.width + ( _padding * 2 );
		}
		
		
		override public function get height():Number
		{
			return childContainer.height + ( _padding * 2 );
		}
		
	}
		
}