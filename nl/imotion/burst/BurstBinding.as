package nl.imotion.burst 
{

	internal class BurstBinding 
	{

		private var _classRef	:Class;
		private var _type		:String;


		public function BurstBinding( classRef:Class, type:String ) 
		{
			_classRef = classRef;
			_type = type;
		}
		
		
		public function get classRef():Class { return _classRef; }		
		public function get type():String { return _type; }

	}
}