package nl.imotion.neuralnetwork 
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class Layer
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _neuronMap			:/*Neuron*/Array = [];
		
		/*private var _inputSynapseMap	:Array = [];
		private var _outputSynapseMap	:Array = [];*/
		
		private var _inputLayer			:Layer;
		//private var _outputLayer		:Layer;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function Layer( nrOfNeurons:uint, inputLayer:Layer = null ) 
		{
			init ( nrOfNeurons, inputLayer );
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function calcValues():Array 
		{
			var result:Array = [];
			
			for ( var i:int = 0; i < _neuronMap.length; i++ ) 
			{
				result.push( _neuronMap[ i ].calcValue() );
			}
			
			return result;
		}
		
		
		public function setValues( values:Array ):void
		{
			if ( values.length != _neuronMap.length )
				throw new Error( "Number of input values do not match the amount of neurons in the layer" );
			
			for ( var i:int = 0; i < _neuronMap.length; i++ ) 
			{
				_neuronMap[ i ].value = values[ i ];
			}
		}
		
		
		public function getValues():Array
		{
			var result:Array = [];
			
			for ( var i:int = 0; i < _neuronMap.length; i++ ) 
			{
				result.push( _neuronMap[ i ].value );
			}
			
			return result;
		}
		
		
		public function updateWeights( delta:Number, learningRate:Number ):void 
		{
			
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get neuronMap():/*Neuron*/Array { return _neuronMap; }
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		private function init( nrOfNeurons:uint, inputLayer:Layer = null ):void
		{
			_inputLayer = inputLayer;
			
			for ( var i:uint = 0; i < nrOfNeurons; i++ ) 
			{
				var neuron:Neuron = new Neuron();
				
				if ( _inputLayer )
				{
					for ( var j:uint = 0; j < _inputLayer.neuronMap.length; j++ ) 
					{
						neuron.synapseMap[ neuron.synapseMap.length ] = new Synapse( _inputLayer.neuronMap[ j ], neuron );
					}
				}
				
				_neuronMap [ _neuronMap.length ] = neuron;
			}
		}
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}
	

}