package nl.imotion.burst.components.stackpanel 
{

	import flash.display.DisplayObject;
	import nl.imotion.burst.components.BurstSprite;
	import nl.imotion.burst.components.events.BurstComponentEvent;
	import nl.imotion.burst.components.IBurstComponent;

	public class StackPanel extends BurstSprite 
	{
		
		private var _orientation		:String;
		private var _autoDistribute		:Boolean;
		private var _margin				:uint;
		
		public function StackPanel( orientation:String = "vertical", autoDistribute:Boolean = false, margin:uint = 0 ) 
		{
			_orientation 	= ( orientation == StackPanelOrientation.HORIZONAL || orientation == StackPanelOrientation.VERTICAL ) ? orientation : StackPanelOrientation.VERTICAL;
			_autoDistribute	= autoDistribute;
			_margin			= margin;
		}
		
		
		public function get orientation():String { return _orientation; }
		
		public function get autoDistribute():Boolean { return _autoDistribute; }
		
		public function get margin():uint { return _margin; }
		
		
		override public function addChild( child:DisplayObject ):DisplayObject 
		{
			if ( _autoDistribute && child is BurstSprite )
			{
				child.addEventListener( BurstComponentEvent.SIZE_CHANGED,  	childSizeChangedHandler );
				
				switch ( _orientation )
				{
					case StackPanelOrientation.HORIZONAL:
						child.addEventListener( BurstComponentEvent.WIDTH_CHANGED,	childSizeChangedHandler );
					break;
					
					case StackPanelOrientation.VERTICAL:
						child.addEventListener( BurstComponentEvent.HEIGHT_CHANGED, childSizeChangedHandler );
					break;
				}
			}
			
			super.addChild( child );
			
			distributeChildren( child );
			
			dispatchEvent( new BurstComponentEvent( BurstComponentEvent.SIZE_CHANGED ) );
			
			return child;
		}
		
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			if ( child.hasEventListener( BurstComponentEvent.WIDTH_CHANGED ) )
			{
				child.removeEventListener( BurstComponentEvent.WIDTH_CHANGED, childSizeChangedHandler );
			}
			if ( child.hasEventListener( BurstComponentEvent.HEIGHT_CHANGED ) )
			{
				child.removeEventListener( BurstComponentEvent.HEIGHT_CHANGED, childSizeChangedHandler );
			}
			if ( child.hasEventListener( BurstComponentEvent.SIZE_CHANGED ) )
			{
				child.removeEventListener( BurstComponentEvent.SIZE_CHANGED, childSizeChangedHandler );
			}
			
			dispatchEvent( new BurstComponentEvent( BurstComponentEvent.SIZE_CHANGED ) );
			
			return super.removeChild(child);
		}
		
		
		private function distributeChildren( startChild:DisplayObject = null ):void
		{
			var startChildIndex:uint = ( startChild != null ) ? getChildIndex( startChild ) : 0;
			
			if ( numChildren > 1 )
			{
				if ( startChildIndex == 0 ) startChildIndex = 1;
				var i:int = startChildIndex;
				
				switch ( _orientation )
				{
					case StackPanelOrientation.HORIZONAL:
						var xPos:Number = getChildAt( startChildIndex - 1 ).getBounds( this ).right + margin;
						
						for ( i; i < numChildren; i++ ) 
						{
							var horzChild:DisplayObject = getChildAt( i );
							horzChild.x = xPos;
							
							xPos = horzChild.getBounds( this ).right + margin;
						}
						break;
						
					case StackPanelOrientation.VERTICAL:
						var yPos:Number = getChildAt( startChildIndex - 1 ).getBounds( this ).bottom + margin;
						
						for ( i; i < numChildren; i++ ) 
						{
							var vertChild:DisplayObject = getChildAt( i );
							vertChild.y = yPos;
							
							yPos = vertChild.getBounds( this ).bottom + margin;
						}
						break;
				}
				
				dispatchEvent( new BurstComponentEvent( BurstComponentEvent.SIZE_CHANGED ) );
			}
		}
		
		
		private function childSizeChangedHandler( e:BurstComponentEvent ):void 
		{
			try
			{
				if ( this.contains( e.target as DisplayObject ) )
				{
					distributeChildren( e.target as DisplayObject );
				}
			} 
			catch ( e:ArgumentError ) 
			{ 
				distributeChildren();
			}
			
		}
		
	}
	
}