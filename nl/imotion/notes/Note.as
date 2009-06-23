package nl.imotion.notes
{

	public class Note
	{
		private var _type:String;
		
		
		public function Note( type:String )
		{
			_type = type;
		}
		
		
		public function get type():String { return _type; }
		
	}
	
}