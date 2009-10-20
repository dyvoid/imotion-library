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
		
		
		public function StackPanel( orientation:String = StackPanelOrientation.VERTICAL, autoDistribute:Boolean = false, margin:uint = 0 ) 
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
			if ( _autoDistribute && child is IBurstComponent )
			{
				startEventInterest( child, BurstComponentEvent.SIZE_CHANGED, childSizeChangedHandler );
				
				switch ( _orientation )
				{
					case StackPanelOrientation.HORIZONAL:
						startEventInterest( child, BurstComponentEvent.WIDTH_CHANGED,	childSizeChangedHandler );
					break;
					
					case StackPanelOrientation.VERTICAL:
						startEventInterest( child, BurstComponentEvent.HEIGHT_CHANGED, childSizeChangedHandler );
					break;
				}
			}
			
			super.addChild( child );
			
			var prevWidth	:Number = width;
			var prevHeight	:Number = height;
			
			distributeChildren( child );
			
			broadcastSizeChange( prevWidth, prevHeight );
			
			return child;
		}
		
		
		override public function removeChild( child:DisplayObject ):DisplayObject 
		{
			stopEventInterest( child, BurstComponentEvent.WIDTH_CHANGED, 	childSizeChangedHandler );
			stopEventInterest( child, BurstComponentEvent.HEIGHT_CHANGED, 	childSizeChangedHandler );
			stopEventInterest( child, BurstComponentEvent.SIZE_CHANGED, 	childSizeChangedHandler );
			
			super.removeChild( child );
			
			var prevWidth	:Number = width;
			var prevHeight	:Number = height;
			
			distributeChildren();
			
			return child;
		}
		
		
		private function distributeChildren( startChild:DisplayObject = null ):void
		{
			if ( numChildren > 1 )
			{
				var prevWidth	:Number = width;
				var prevHeight	:Number = height;
				
				var startChildIndex:uint = ( startChild != null ) ? getChildIndex( startChild ) : 1;
				
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
				
				broadcastSizeChange( prevWidth, prevHeight );
			}
		}
		
		
		private function childSizeChangedHandler( event:BurstComponentEvent ):void 
		{
			event.stopPropagation();
			
			try
			{
				if ( this.contains( event.target as DisplayObject ) )
				{
					distributeChildren( event.target as DisplayObject );
				}
			} 
			catch ( e:ArgumentError ) 
			{ 
				distributeChildren();
			}
			
		}
		
	}
	
}