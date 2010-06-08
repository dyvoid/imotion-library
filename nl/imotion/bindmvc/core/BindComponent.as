package nl.imotion.bindmvc.core
{

	import flash.events.IEventDispatcher;
	import nl.imotion.events.EventManager;
	import nl.imotion.bindmvc.model.IBindModel;
	import nl.imotion.notes.Note;
	import nl.imotion.notes.NoteDispatcher;
	
	
	public class BindComponent implements IBindComponent
	{
		
		protected function retrieveModel( name:String ):IBindModel
		{
			return BindMVCCore.getInstance().retrieveModel( name );
		}
		
		
		private var _eventManager:EventManager;
		private function get eventManager():EventManager
		{
			if ( !_eventManager ) _eventManager = new EventManager();
			return _eventManager;
		}
		
		
		protected function startEventInterest( target:*, type:*, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			var targets	:Array = new Array().concat( target );
			var types	:Array = new Array().concat( type );
			
			for each ( var currTarget:IEventDispatcher in targets ) 
			{
				for each ( var currType:String in types ) 
				{
					registerListener( currTarget, currType, listener, useCapture, priority, useWeakReference );
				}
			}
		}		
		
		
		private function registerListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			eventManager.registerListener( target, type, listener, useCapture, priority, useWeakReference );
		}
		
		
		protected function stopEventInterest( target:*, type:*, listener:Function, useCapture:Boolean = false ):void
		{
			var targets	:Array = new Array().concat( target );
			var types	:Array = new Array().concat( type );
			
			for each ( var currTarget:IEventDispatcher in targets ) 
			{
				for each ( var currType:String in types ) 
				{
					unregisterListener( currTarget, currType, listener, useCapture );
				}
			}
		}
		
		
		private function unregisterListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false ):void
		{
			eventManager.removeListener( target, type, listener, useCapture );
		}
		
		
		protected function dispatchNote( note:Note ):void
		{
			NoteDispatcher.getInstance().dispatchNote( note );
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