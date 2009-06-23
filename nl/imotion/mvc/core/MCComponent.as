package nl.imotion.mvc.core
{

	import flash.events.IEventDispatcher;
	import nl.imotion.events.EventManager;
	import nl.imotion.mvc.model.IModel;
	import nl.imotion.mvc.model.ModelLocator;
	import nl.imotion.notes.Note;
	import nl.imotion.notes.NoteDispatcher;
	import nl.imotion.notes.NoteManager;
	
	
	public class MCComponent implements IDestroyable
	{
		
		protected function retrieveModel( name:String ):IModel
		{
			return ModelLocator.getInstance().retrieve( name );
		}
		
		
		protected function startEventInterest( target:*, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			if ( target is IEventDispatcher )
			{
				registerEventListener( target, type, listener, useCapture, priority, useWeakReference );
			}
			if ( target is Array )
			{
				for each( var currTarget:IEventDispatcher in target )
				{
					registerEventListener( currTarget, type, listener, useCapture, priority, useWeakReference );
				}
			}
		}
		
		
		private function registerEventListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			target.addEventListener( type, listener, useCapture, priority, useWeakReference );
			
			eventManager.registerListener( target, type, listener, useCapture );
		}
		
		
		protected function stopEventInterest( target:*, type:String, listener:Function, useCapture:Boolean = false ):void
		{
			if ( target is IEventDispatcher )
			{
				unregisterEventListener( target, type, listener, useCapture );
			}
			if ( target is Array )
			{
				for each( var currTarget:IEventDispatcher in target )
				{
					unregisterEventListener( currTarget, type, listener, useCapture );
				}
			}
		}
		
		
		private function unregisterEventListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false ):void
		{
			eventManager.removeListener( target, type, listener, useCapture );
		}
		
		
		protected function startNoteInterest( type:String, listener:Function ):void
		{
			noteManager.registerListener( type, listener );
		}
		
		
		protected function stopNoteInterest( type:String, listener:Function ):void
		{
			noteManager.removeListener( type, listener );
		}
		
		
		protected function dispatchNote( note:Note ):void
		{
			noteDispatcher.dispatchNote( note );
		}
		
		
		public function destroy():void
		{
			if ( _eventManager != null )
			{
				_eventManager.removeAllListeners();
				_eventManager = null;
			}
			if ( _noteManager != null )
			{
				_noteManager.removeAllListeners();
				_noteManager = null;
			}
		}
		
		
		private var _eventManager:EventManager;
		private function get eventManager():EventManager
		{
			if ( !_eventManager ) _eventManager = new EventManager();
			return _eventManager;
		}
		
		private var _noteManager:NoteManager;
		private function get noteManager():NoteManager
		{
			if ( !_noteManager ) _noteManager = new NoteManager();
			return _noteManager;
		}
		
		private function get noteDispatcher():NoteDispatcher
		{
			return NoteDispatcher.getInstance();
		}
	}
}