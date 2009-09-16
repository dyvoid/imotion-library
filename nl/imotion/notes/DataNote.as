package nl.imotion.notes 
{
	import nl.imotion.notes.Note;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class DataNote extends Note
	{
		private var _data:Object;
		
		public function DataNote( type:String, data:Object = null ) 
		{
			super( type );
			
			_data = data;			
		}
		
		
		public function get data():Object { return _data; }
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
		
	}
	
}