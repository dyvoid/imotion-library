package nl.imotion.mvc.controller
{
	
	import flash.display.DisplayObject;
	import nl.imotion.mvc.core.MCComponent;
	import nl.imotion.mvc.model.IModel;
	import nl.imotion.notes.NoteManager;

	public class BaseController extends MCComponent implements IController
	{
		
		protected var defaultView:DisplayObject;
		protected var defaultModel:IModel;
		
		
		public function BaseController( defaultView:DisplayObject, defaultModel:IModel = null )
		{
			this.defaultView 	= defaultView;
			this.defaultModel 	= defaultModel;
		}
		
		
		protected function startNoteInterest( type:String, listener:Function ):void
		{
			noteManager.registerListener( type, listener );
		}
		
		
		protected function stopNoteInterest( type:String, listener:Function ):void
		{
			noteManager.removeListener( type, listener );
		}
		
		
		override public function destroy():void
		{
			defaultView 	= null;
			defaultModel 	= null;
			
			if ( _noteManager != null )
			{
				_noteManager.removeAllListeners();
				_noteManager = null;
			}
			
			super.destroy();
		}
		
		
		private var _noteManager:NoteManager;
		private function get noteManager():NoteManager
		{
			if ( !_noteManager ) _noteManager = new NoteManager();
			return _noteManager;
		}
		
	}
	
}