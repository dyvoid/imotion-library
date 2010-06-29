package nl.imotion.neuralnetwork.events
{
	import flash.events.Event;
	import nl.imotion.neuralnetwork.training.TrainingResult;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class NeuralNetworkEvent extends Event 
	{
		public static const TRAINING_EPOCH_COMPLETE		:String = "NeuralNetworkEvent::trainingEpochComplete";
		public static const TRAINING_COMPLETE			:String = "NeuralNetworkEvent::trainingComplete";
		
		private var _trainingResult		:TrainingResult;
		
		
		public function NeuralNetworkEvent( type:String, trainingResult:TrainingResult, bubbles:Boolean=false, cancelable:Boolean=false ) 
		{ 
			super(type, bubbles, cancelable);
			
			_trainingResult = trainingResult;			
		} 
		
		
		public override function clone():Event 
		{ 
			return new NeuralNetworkEvent( type, trainingResult, bubbles, cancelable );
		} 
		
		
		public override function toString():String 
		{ 
			return formatToString("NeuralNetworkEvent", "type", "trainingResult", "bubbles", "cancelable", "eventPhase"); 
		}
		
		
		public function get trainingResult():TrainingResult { return _trainingResult; }
		
	}
	
}