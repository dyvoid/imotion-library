package nl.imotion.notes 
{
	import flash.utils.Dictionary;
	import nl.imotion.notes.NoteDispatcher;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class NoteManager 
	{
		private var listeners:Dictionary = new Dictionary();
		
		
		public function NoteManager() { }
		
		
		public function registerListener( type:String, listener:Function ):void
		{
			noteDispatcher.addNoteListener( type, listener );
			
			listeners[ type ] = listener;
		}
		
		
		public function removeListener( type:String, listener:Function ):void
		{
			var f:Function = listeners[ type ];
			
			if ( f != null && f == listener )
			{
				noteDispatcher.removeNoteListener( type, listener );
				
				delete listeners[ type ];
			}
		}
		
		
		public function removeAllListeners():void
		{
			for ( var type:String in listeners ) 
			{
				removeListener( type, listeners[ type ] );
			}
		}
		
		
		private function get noteDispatcher():NoteDispatcher
		{
			return NoteDispatcher.getInstance();
		}
	}
	
}