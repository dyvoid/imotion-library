package nl.imotion.bindmvc.core
{

	import flash.events.IEventDispatcher;
	import nl.imotion.events.EventManager;
	import nl.imotion.bindmvc.model.IBindModel;
	import nl.imotion.notes.Note;
	import nl.imotion.notes.NoteDispatcher;
	
	
	public class BindComponent implements IDestroyable
	{
		
		protected function retrieveModel( name:String ):IBindModel
		{
			return BindMVCCore.getInstance().retrieveModel( name );
		}
		
		
		include "../../inc_eventmanagerclient.as"
		
		
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