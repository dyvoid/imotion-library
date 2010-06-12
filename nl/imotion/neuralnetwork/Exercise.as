package nl.imotion.neuralnetwork 
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class Exercise
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _inputPattern		:Array;
		private var _outputPattern		:Array;
		
		private var _maxCycles			:uint;
		private var _fitnessGoal		:uint;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function Exercise( inputPattern:Array, outputPattern:Array, maxCycles:uint = 0, fitnessGoal:uint = 0 ) 
		{
			_inputPattern	= inputPattern;
			_outputPattern	= outputPattern;
			_maxCycles		= maxCycles;
			_fitnessGoal	= fitnessGoal;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get inputPattern():Array { return _inputPattern; }
		
		public function get outputPattern():Array { return _outputPattern; }
		
		public function get maxCycles():uint { return _maxCycles; }
		
		public function set maxCycles(value:uint):void 
		{
			_maxCycles = value;
		}
		
		public function get fitnessGoal():uint { return _fitnessGoal; }
		
		public function set fitnessGoal(value:uint):void 
		{
			_fitnessGoal = value;
		}
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}