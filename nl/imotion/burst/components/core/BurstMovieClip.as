package nl.imotion.burst.components.core 
{
	import flash.display.DisplayObject;
	import nl.imotion.burst.components.events.BurstComponentEvent;
	import nl.imotion.display.EventManagedMovieClip;
	
	[Event(name="widthChanged", type="nl.imotion.burst.components.events.BurstComponentEvent")]
	[Event(name="heightChanged", type="nl.imotion.burst.components.events.BurstComponentEvent")]
	[Event(name = "sizeChanged", type = "nl.imotion.burst.components.events.BurstComponentEvent")]
	
	public class BurstMovieClip extends EventManagedMovieClip implements IBurstComponent
	{
		private var _explicitWidth	:Number;
		private var _explicitHeight	:Number;
		
		
		public function BurstMovieClip() 
		{
			
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
			if ( this.stage )
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