package nl.imotion.neuralnetwork.components
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
		
		private var _momentum				:Number = 0;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function Synapse( startNeuron:Neuron, endNeuron:Neuron, weight:Number = NaN ) 
		{
			_startNeuron 	= startNeuron;
			_endNeuron		= endNeuron
			
			_weight			= ( isNaN( weight) ) ? Math.random() * 2 - 1 : weight;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function getOutput():Number
		{
			return _startNeuron.value * _weight;
		}
		
		
		public function toXML():XML
		{
			var xml:XML = <synapse weight={_weight} />;
			
			return xml;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get startNeuron():Neuron { return _startNeuron; }
		
		public function get endNeuron():Neuron { return _endNeuron; }
		
		public function get weight():Number { return _weight; }
		public function set weight(value:Number):void 
		{
			_weight = value;
		}
		
		public function get momentum():Number { return _momentum; }
		public function set momentum(value:Number):void 
		{
			_momentum = value;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}