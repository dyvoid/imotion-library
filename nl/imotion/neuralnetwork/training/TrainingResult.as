package nl.imotion.neuralnetwork.training
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class TrainingResult
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _startError		:Number;
		private var _endError		:Number;
		private var _epochs			:uint;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function TrainingResult( startError:Number = NaN, endError:Number = NaN, epochs:uint = 0 ):void 
		{ 
			_startError = startError;
			_endError = endError;
			_epochs = epochs;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get startError():Number { return _startError; }
		public function set startError( value:Number ):void
		{
			_startError = value;
		}
		
		public function get endError():Number { return _endError; }
		public function set endError( value:Number ):void
		{
			_endError = value;
		}
		
		public function get errorChange():Number 
		{
			if ( !isNaN( _startError ) && !isNaN( _endError ) )
			{
				return _endError - _startError; 
			}
			return 0;
		}
		
		public function get epochs():uint { return _epochs; }
		public function set epochs( value:uint ):void
		{
			_epochs = value;
		}

	}

}