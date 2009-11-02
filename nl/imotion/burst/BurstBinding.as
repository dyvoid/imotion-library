package nl.imotion.burst
{
	public class BurstBinding
	{
		private var _parserClass:Class;
		private var _targetClass:Class;
		
		
		public function BurstBinding( parserClass:Class, targetClass:Class = null ):void 
		{ 
			_parserClass = parserClass;
			_targetClass = targetClass;
		}

		public function get parserClass():Class { return _parserClass; }

		public function get targetClass():Class { return _targetClass; }

	}
}