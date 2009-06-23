package nl.imotion.notes 
{
	import nl.imotion.notes.Note;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class DataNote extends Note
	{
		public var _data:Object;
		
		public function DataNote( type:String, data:Object ) 
		{
			super( type );
			
			_data = data;			
		}
		
		
		public function get data():Object { return _data; }
		
	}
	
}