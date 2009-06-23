package nl.imotion.notes
{
	import flash.utils.Dictionary;
	
	public class NoteDispatcher
	{
		private static var allowInstantiation:Boolean = false;
		private static var instance:NoteDispatcher;
		
		private var listeners:Dictionary = new Dictionary();
		
		
		public function NoteDispatcher()
		{
			if ( !allowInstantiation )
			{
				throw new Error("Error: Instantiation failed: Use NoteDispatcher.getInstance() instead of new.");
			}
		}
		
		
		public static function getInstance():NoteDispatcher
		{
			if ( instance == null )
			{
				allowInstantiation = true;
				instance = new NoteDispatcher();
				allowInstantiation = false;
			}
			return instance as NoteDispatcher;
		}
		
		
		public function addNoteListener( type:String, listener:Function ):void
		{
			var typeListeners:Array = listeners[ type ];
			
			if ( typeListeners ) 
			{
				for each( var f:Function in typeListeners )
				{
					if ( listener == f )
					{
						return;
					}
				}
				typeListeners.push( listener );
			} 
			else 
			{
				listeners[ type ] = [ listener ];	
			}
		}
		
		
		public function removeNoteListener( type:String, listener:Function ):void
		{
			var typeListeners:Array = listeners[ type ];
			
			if ( typeListeners )
			{
				for ( var i:int = 0; i < typeListeners.length; i++ ) 
				{
					if ( typeListeners[ i ] == listener )
					{
						typeListeners.splice( i, 1 );
						break;
					}
				}
				
				if ( typeListeners.length == 0)
				{
					delete listeners[ type ];
				}
			}
		}
		
		
		public function hasNoteListener( type:String ):Boolean
		{
			return ( listeners[ type ] != null );
		}
		
		
		public function dispatchNote( note:Note ):void
		{
			var typeListeners:Array = listeners[ note.type ];
			
			for each( var f:Function in typeListeners )
			{
				f( note );
			}
		}
		
	}
	
}