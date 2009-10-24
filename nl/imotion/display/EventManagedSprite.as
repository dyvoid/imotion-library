package nl.imotion.display
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import nl.imotion.events.EventManager;
	
	
	public class EventManagedSprite extends Sprite implements IEventManagedDisplayObject
	{	
		
		public function EventManagedSprite( autoDestroy:Boolean = true ) 
		{
			if ( autoDestroy )
			{
				startEventInterest( this, Event.REMOVED_FROM_STAGE, removedFromStageHandler );
			}
		}
		
		
		private function removedFromStageHandler( e:Event ):void
		{
			//Wait for the next frame before destroying, so that functionality like 
			//switching to a different parent DisplayObjectContainer does not break
			startEventInterest( this, Event.ENTER_FRAME, enterFrameHandler );
		}
		
		
		private function enterFrameHandler( e:Event ):void
		{
			if ( !this.stage )
			{
				destroy();
			}
		}
		
		
		private var _eventManager:EventManager;
		protected function get eventManager():EventManager
		{
			if ( !_eventManager ) _eventManager = new EventManager();
			return _eventManager;
		}
		
		
		protected function startEventInterest( target:*, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			switch( true )
			{
				case ( target is IEventDispatcher ):
					registerEventListener( target, type, listener, useCapture, priority, useWeakReference );
				break;
					
				case ( target is Array ):
					for each( var currTarget:* in target )
					{
						if ( currTarget is IEventDispatcher )
						{
							registerEventListener( IEventDispatcher( currTarget ), type, listener, useCapture, priority, useWeakReference );
						}
					}
				break;
				
			}
		}		
		
		
		private function registerEventListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			target.addEventListener( type, listener, useCapture, priority, useWeakReference );
			
			eventManager.registerListener( target, type, listener, useCapture );
		}
		
		
		protected function stopEventInterest( target:*, type:String, listener:Function, useCapture:Boolean = false ):void
		{
			switch( true )
			{
				case ( target is IEventDispatcher ):
					unregisterEventListener( target, type, listener, useCapture );
				break;
					
				case ( target is Array ):
					for each( var currTarget:* in target )
					{
						if ( currTarget is IEventDispatcher )
						{
							unregisterEventListener( IEventDispatcher( currTarget ), type, listener, useCapture );
						}
					}
				break;
			}
		}
		
		
		private function unregisterEventListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false ):void
		{
			eventManager.removeListener( target, type, listener, useCapture );
		}
		
		
		public function destroy():void
		{
			if ( _eventManager != null )
			{
				_eventManager.removeAllListeners();
				_eventManager = null;
			}
			
			if ( this.parent != null )
			{
				this.parent.removeChild( this );
			}
		}
		
	}
	
}