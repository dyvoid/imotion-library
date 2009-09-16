package nl.imotion.bindmvc.controller
{
	
	import flash.display.DisplayObject;
	import nl.imotion.bindmvc.core.BindComponent;
	import nl.imotion.bindmvc.model.IBindModel;
	import nl.imotion.notes.NoteManager;

	public class BindController extends BindComponent implements IBindController
	{
		
		protected var defaultView:DisplayObject;
		protected var defaultModel:IBindModel;
		
		
		public function BindController( defaultView:DisplayObject, defaultModel:IBindModel = null )
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