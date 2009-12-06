package nl.imotion.burst.components.core 
{

	import flash.display.DisplayObject;
	import flash.events.Event;
	import nl.imotion.burst.components.events.BurstComponentEvent;
	import nl.imotion.display.EventManagedSprite;

	[Event(name="sizeChanged", type="nl.imotion.burst.components.events.BurstComponentEvent")]
	
	public class BurstSprite extends EventManagedSprite implements IBurstComponent
	{
		private var _explicitWidth	:Number;
		private var _explicitHeight	:Number;
		
		private var _prevWidth		:Number;
		private var _prevHeight		:Number;
		
		protected var hasChangedSize		:Boolean = false;
		
		
		public function BurstSprite() 
		{
			if ( stage ) init();
			else startEventInterest( this, Event.ADDED_TO_STAGE, init );
		}
		
		
		private function init( e:Event = null ):void
		{
			stopEventInterest( this, Event.ADDED_TO_STAGE, init );
			
			onInit();
		}
		
		
		protected function onInit():void
		{
			startEventInterest( stage, Event.RENDER, stageRenderHandler );
			
			_prevWidth 	= this.width;
			_prevHeight = this.height;
		}
		
		
		private function stageRenderHandler( e:Event ):void
		{
			if ( hasChangedSize )
			{
				hasChangedSize = false;
				onSizeChange();
			}
		}
		
		
		override public function set width( value:Number ):void 
		{
			if ( value != super.width )
			{
				super.width = value;
				checkSizeChange();
			}
			
		}
		
		
		override public function set height( value:Number ):void 
		{
			if ( value != super.height )
			{
				super.height = value;
				checkSizeChange();
			}
			
		}

		override public function set scaleX( value:Number ):void 
		{
			if ( value != super.scaleX )
			{
				super.scaleX 	= value;
				checkSizeChange();
			}
			
		}
		
		override public function set scaleY( value:Number ):void 
		{
			if ( value != super.scaleY )
			{
				super.scaleY 	= value;
				checkSizeChange();
			}
			
		}
		
		override public function addChild( child:DisplayObject ):DisplayObject 
		{
			super.addChild( child );
			
			checkSizeChange();
			
			return child;
		}
		
		
		override public function addChildAt( child:DisplayObject, index:int ):DisplayObject 
		{
			super.addChildAt(child, index);
			
			checkSizeChange();
			
			return child;
		}
		
		
		override public function removeChild( child:DisplayObject ):DisplayObject 
		{
			super.removeChild( child );
			
			checkSizeChange();
			
			return child;
		}
		
		
		override public function removeChildAt( index:int ):DisplayObject 
		{
			var child:DisplayObject = super.removeChildAt(index);
			
			checkSizeChange();
			
			return child;
		}
		
		
		protected function checkSizeChange():void
		{
			if ( this.stage && ( _prevWidth != width || _prevHeight != height )  )
			{
				forceRedraw();
				
				_prevWidth 	= width;
				_prevHeight = height;
			}
		}
		
		
		protected function forceRedraw():void
		{
			if ( stage )
			{
				hasChangedSize = true;
				stage.invalidate();
			}
			else
			{
				onSizeChange();
			}
		}
		
		
		
		protected function onSizeChange():void
		{
			dispatchEvent( new BurstComponentEvent( BurstComponentEvent.SIZE_CHANGED ) );
		}
		
		
		public function get explicitWidth():Number { return isNaN( _explicitWidth) ? this.width : _explicitWidth; }		
		public function set explicitWidth( value:Number ):void 
		{
			_explicitWidth = value;
		}
		
		
		public function get explicitHeight():Number { return isNaN( _explicitHeight) ? this.height : _explicitHeight; }		
		public function set explicitHeight( value:Number ):void 
		{
			_explicitHeight = value;
		}

	}
	
	
}