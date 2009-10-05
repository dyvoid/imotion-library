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
		
		public function StackPanel( orientation:String = "vertical", autoDistribute:Boolean = true ) 
		{
			_orientation 	= orientation;
			_autoDistribute	= autoDistribute;
		}
		
		
		public function get orientation():String { return _orientation; }
		
		public function get autoDistribute():Boolean { return _autoDistribute; }
		
		
		override public function addChild( child:DisplayObject ):DisplayObject 
		{
			switch ( _orientation )
			{
				case StackPanelOrientation.HORIZONAL:
					child.x = this.width;
					
					if ( _autoDistribute && child is BurstSprite )
					{
						child.addEventListener( BurstComponentEvent.WIDTH_CHANGED,	childSizeChangedHandler );
						child.addEventListener( BurstComponentEvent.SIZE_CHANGED,  	childSizeChangedHandler );
					}
				break;
				
				case StackPanelOrientation.VERTICAL:
					child.y = this.height;
					
					if ( _autoDistribute && child is BurstSprite )
					{
						child.addEventListener( BurstComponentEvent.HEIGHT_CHANGED, childSizeChangedHandler );
						child.addEventListener( BurstComponentEvent.SIZE_CHANGED,  	childSizeChangedHandler );
					}
				break;
			}
			
			return super.addChild( child );
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
			
			return super.removeChild(child);
		}
		
		
		private function childSizeChangedHandler( e:BurstComponentEvent ):void 
		{
			var i:uint = 0;
			
			switch ( _orientation )
			{
				case StackPanelOrientation.HORIZONAL:
					var xPos:Number = 0;
					
					for ( i = 0; i < numChildren; i++ ) 
					{
						var horzChild:DisplayObject = getChildAt( i );
						horzChild.x = xPos;
						
						xPos += horzChild.width;
					}
				break;
				
				case StackPanelOrientation.VERTICAL:
					var yPos:Number = 0;
					
					for ( i = 0; i < numChildren; i++ ) 
					{
						var vertChild:DisplayObject = getChildAt( i );
						vertChild.y = yPos;
						
						yPos += vertChild.height;
					}
				break;
			}
			
			dispatchEvent( new BurstComponentEvent( BurstComponentEvent.SIZE_CHANGED ) );
		}
		
	}
	
}