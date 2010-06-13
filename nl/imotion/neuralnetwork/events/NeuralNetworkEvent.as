package nl.imotion.neuralnetwork.events
{
	import flash.events.Event;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class NeuralNetworkEvent extends Event 
	{
		public static const TRAINING_COMPLETE:String = "NeuralNetworkEvent::trainingComplete";
		
		
		public function NeuralNetworkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new NeuralNetworkEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("NeuralNetworkEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}