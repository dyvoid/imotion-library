package nl.imotion.burst.components 
{

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import nl.imotion.burst.components.events.BurstComponentEvent;
	import nl.imotion.display.EventManagedSprite;

	[Event(name="widthChanged", type="nl.imotion.burst.components.events.BurstComponentEvent")]
	[Event(name="heightChanged", type="nl.imotion.burst.components.events.BurstComponentEvent")]
	[Event(name="sizeChanged", type="nl.imotion.burst.components.events.BurstComponentEvent")]
	
	public class BurstSprite extends EventManagedSprite implements IBurstComponent
	{
		
		public function BurstSprite() 
		{
			startEventInterest( this, Event.REMOVED_FROM_STAGE, removedFromStageHandler );
		}
		
		
		override public function set width( value:Number ):void 
		{
			if ( value != super.width )
			{
				super.width = value;
				dispatchEvent( new BurstComponentEvent( BurstComponentEvent.WIDTH_CHANGED ) );
			}
			
		}
		
		
		override public function set height( value:Number ):void 
		{
			if ( value != super.height )
			{
				super.height = value;
				dispatchEvent( new BurstComponentEvent( BurstComponentEvent.HEIGHT_CHANGED ) );
			}
			
		}

		override public function set scaleX( value:Number ):void 
		{
			if ( value != super.scaleX )
			{
				super.scaleX = value;
				dispatchEvent( new BurstComponentEvent( BurstComponentEvent.WIDTH_CHANGED ) );
			}
			
		}
		
		override public function set scaleY( value:Number ):void 
		{
			if ( value != super.scaleY )
			{
				super.scaleY = value;
				dispatchEvent( new BurstComponentEvent( BurstComponentEvent.HEIGHT_CHANGED ) );
			}
			
		}
		
		override public function addChild( child:DisplayObject ):DisplayObject 
		{
			var prevWidth	:Number = width;
			var prevHeight	:Number = height;
			
			super.addChild( child );
			
			broadcastSizeChange( prevWidth, prevHeight );

			return child;
		}
		
		
		override public function removeChild( child:DisplayObject ):DisplayObject 
		{
			var prevWidth	:Number = width;
			var prevHeight	:Number = height;
			
			super.removeChild( child );
			
			broadcastSizeChange( prevWidth, prevHeight );

			return child;
		}
		
		
		protected function broadcastSizeChange( prevWidth:Number, prevHeight:Number ):void
		{
			switch( true )
			{
				case ( prevWidth != width && prevHeight != height ):
					dispatchEvent( new BurstComponentEvent( BurstComponentEvent.SIZE_CHANGED ) );
				break;
				
				case ( prevWidth != width ):
					dispatchEvent( new BurstComponentEvent( BurstComponentEvent.WIDTH_CHANGED ) );
				break;
				
				case ( prevHeight != height ):
					dispatchEvent( new BurstComponentEvent( BurstComponentEvent.HEIGHT_CHANGED ) );
				break; 
			}
		}
		
		
		public function get explicitWidth():Number 
		{
			return this.width;
		}
		
		
		public function set explicitWidth( value:Number ):void 
		{
			this.width = value;
		}
		
		
		public function get explicitHeight():Number 
		{
			return this.height;
		}
		
		
		public function set explicitHeight( value:Number ):void 
		{
			this.height = value;
		}
		
		
		private function removedFromStageHandler():void
		{
			destroy();
		}
		
		
		override public function destroy():void 
		{
			eventManager.removeAllListeners();
		}

	}
	
	
}