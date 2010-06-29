package nl.imotion.neuralnetwork 
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class Exercise
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _patterns			:Array = [];
		
		private var _maxEpochs			:uint;
		private var _maxError   		:Number;
		
		private var _index				:uint = 0;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function Exercise( maxEpochs:uint = 0, maxError:Number = 0 ) 
		{
			_maxEpochs		= maxEpochs;
			_maxError		= maxError;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function addPatterns( inputPattern:Array, targetPattern:Array ):void
		{
			_patterns.push( new ExercisePatterns( inputPattern, targetPattern ) );
		}
		
		
		public function next():ExercisePatterns
		{
			return _patterns[ _index++ ];
		}
		
		
		public function reset():void
		{
			_index = 0;
		}
		
		
		public function hasNext():Boolean
		{
			return ( _index < _patterns.length );
		}
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get maxEpochs():uint { return _maxEpochs; }
		public function set maxEpochs(value:uint):void 
		{
			_maxEpochs = value;
		}
		
		public function get maxError():Number { return _maxError; }
		public function set maxError(value:Number):void 
		{
			_maxError = value;
		}
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}