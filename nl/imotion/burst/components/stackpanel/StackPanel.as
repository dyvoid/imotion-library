package nl.imotion.burst.components.stackpanel 
{

	import flash.display.DisplayObject;
	import flash.events.Event;
	import nl.imotion.burst.components.core.BurstSprite;
	import nl.imotion.burst.components.events.BurstComponentEvent;
	import nl.imotion.burst.components.core.IBurstComponent;
	
	
	public class StackPanel extends BurstSprite implements IBurstComponent
	{
		private var _orientation		:String;
		private var _autoUpdate			:Boolean;
		private var _margin				:uint;
		
		
		public function StackPanel( orientation:String = StackPanelOrientation.VERTICAL, autoUpdate:Boolean = false, margin:uint = 0 ) 
		{
			_orientation 	= ( orientation == StackPanelOrientation.HORIZONAL || orientation == StackPanelOrientation.VERTICAL ) ? orientation : StackPanelOrientation.VERTICAL;
			_autoUpdate		= autoUpdate;
			_margin			= margin;
		}
		
		
		public function get orientation():String { return _orientation; }
		
		public function get autoUpdate():Boolean { return _autoUpdate; }
		
		public function get margin():uint { return _margin; }
		
		
		override protected function onAddedToStage():void 
		{
			if ( numChildren > 0 )
				hasChangedSize = true;
		}
		
		
		override public function addChild( child:DisplayObject ):DisplayObject 
		{
			try 
			{
				var child:DisplayObject = addChildAt( child, numChildren );
			}
			catch ( e:Error )
			{
				//Catch any error, and then throw it ourselves.
				//In this way the error will seem to come from addChild rather than addChildAt
				throw new Error( e );
			}
			
			return child;
		}
		
	
		
		override public function addChildAt( child:DisplayObject, index:int ):DisplayObject 
		{
			super.addChildAt( child, index );
			registerChildListeners( child );
			
			hasChangedSize = true;
			
			return child;
		}
		
		
		override public function removeChild( child:DisplayObject ):DisplayObject 
		{
			super.removeChild( child );
			removeChildListeners( child );
			
			hasChangedSize = true;
			
			return child;
		}
		
		
		override public function removeChildAt( index:int ):DisplayObject 
		{
			try 
			{
				var child:DisplayObject = getChildAt( index );
				removeChild( child );
			} 
			catch ( e:Error )
			{
				//Catch any error, and then throw it ourselves.
				//In this way the error will seem to come from removeChildAt rather than removeChild or getChildAt
				throw new Error( e );
			}			
			
			return child;
		}
		
		
		private function registerChildListeners( child:DisplayObject ):void
		{
			if ( _autoUpdate && child is IBurstComponent )
			{
				startEventInterest( child, BurstComponentEvent.SIZE_CHANGED, childSizeChangedHandler );
			}
		}
		
		
		private function removeChildListeners( child:DisplayObject ):void
		{
			if ( child is IBurstComponent )
			{
				stopEventInterest( child, BurstComponentEvent.SIZE_CHANGED, 	childSizeChangedHandler );
			}
		}
		
		
		private function distributeChildren( startChild:DisplayObject = null ):void
		{
			if ( numChildren > 0 )
			{				
				var startChildIndex:uint = ( startChild != null ) ? getChildIndex( startChild ) : 0;
				
				var i:int = startChildIndex;
				
				switch ( _orientation )
				{
					case StackPanelOrientation.HORIZONAL:
						var xPos:Number = ( startChildIndex == 0 ) ? 0 : getChildAt( startChildIndex - 1 ).getBounds( this ).right + margin;
						
						for ( i; i < numChildren; i++ ) 
						{
							const horzChild:DisplayObject = getChildAt( i );
							const childWidth:Number = ( ( horzChild is IBurstComponent ) ? IBurstComponent( horzChild ).explicitWidth : horzChild.width ) || 0;
							
							horzChild.x = xPos;
							
							xPos = horzChild.x + childWidth + margin;
						}
						break;
						
					case StackPanelOrientation.VERTICAL:
						var yPos:Number = ( startChildIndex == 0 ) ? 0 : getChildAt( startChildIndex - 1 ).getBounds( this ).bottom + margin;
						
						for ( i; i < numChildren; i++ ) 
						{
							const vertChild:DisplayObject = getChildAt( i );
							const childHeight:Number = ( ( vertChild is IBurstComponent ) ? IBurstComponent( vertChild ).explicitHeight : vertChild.height ) || 0;
							vertChild.y = yPos;
							
							yPos = vertChild.y + childHeight + margin;
						}
						break;
				}
			}
		}
		
		
		override protected function onSizeChange():void 
		{
			distributeChildren();
			
			super.onSizeChange();
		}
		
		
		private function childSizeChangedHandler( event:BurstComponentEvent ):void 
		{
			event.stopPropagation();
			
			hasChangedSize = true;
		}
		
	}
	
}