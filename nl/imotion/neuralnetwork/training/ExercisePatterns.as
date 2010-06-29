package nl.imotion.neuralnetwork.training
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class ExercisePatterns
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _inputPattern		:Array;
		private var _targetPattern		:Array;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function ExercisePatterns( inputPattern:Array, targetPattern:Array ) 
		{
			_inputPattern  = inputPattern;
			_targetPattern = targetPattern;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get inputPattern():Array { return _inputPattern; }
		
		public function get targetPattern():Array { return _targetPattern; }
		

	}

}