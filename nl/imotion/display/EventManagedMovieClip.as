package nl.imotion.display
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import nl.imotion.events.EventManager;
	
	
	public class EventManagedMovieClip extends MovieClip implements IEventManagedDisplayObject
	{	
		
		public function EventManagedMovieClip( autoDestroy:Boolean = true ) 
		{
			if ( autoDestroy )
			{
				startEventInterest( this, Event.REMOVED_FROM_STAGE, removedFromStageHandler );
			}
		}
		
		
		private function removedFromStageHandler( e:Event ):void
		{
			destroy();
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
					registerListener( target, type, listener, useCapture, priority, useWeakReference );
				break;
					
				case ( target is Array ):
					for each( var currTarget:* in target )
					{
						if ( currTarget is IEventDispatcher )
						{
							registerListener( IEventDispatcher( currTarget ), type, listener, useCapture, priority, useWeakReference );
						}
					}
				break;
			}
		}		
		
		
		private function registerListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			eventManager.registerListener( target, type, listener, useCapture, priority, useWeakReference );
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
		}
		
	}
	
}