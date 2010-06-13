package nl.imotion.neuralnetwork 
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class Synapse
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _startNeuron			:Neuron
		private var _endNeuron				:Neuron
		
		private var _weight					:Number;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function Synapse( startNeuron:Neuron, endNeuron:Neuron ) 
		{
			_startNeuron 	= startNeuron;
			_endNeuron		= endNeuron
			
			_weight			= Math.random() * 2 - 1;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function getOutput():Number
		{
			return _startNeuron.value * _weight;
		}
		
		
		public function updateWeight( error:Number, learningRate:Number = 0.25 ):void
		{
			_weight += learningRate * error * startNeuron.value * endNeuron.value * ( 1 - endNeuron.value );
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get weight():Number { return _weight; }
		public function set weight(value:Number):void 
		{
			_weight = value;
		}
		
		public function get startNeuron():Neuron { return _startNeuron; }
		
		public function get endNeuron():Neuron { return _endNeuron; }
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}