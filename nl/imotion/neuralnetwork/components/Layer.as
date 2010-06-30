package nl.imotion.neuralnetwork.components
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class Layer
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _neurons			:/*Neuron*/Array = [];
		
		private var _nrOfNeurons		:uint;
		private var _inputLayer			:Layer;
		
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
			
			for ( var i:int = 0; i < _neurons.length; i++ ) 
			{
				result.push( _neurons[ i ].calcValue() );
			}
			
			return result;
		}
		
		
		public function setValues( values:Array ):void
		{
			if ( values.length != _neurons.length )
				throw new Error( "Number of input values do not match the amount of neurons in the layer" );
			
			for ( var i:int = 0; i < _neurons.length; i++ ) 
			{
				_neurons[ i ].value = values[ i ];
			}
		}
		
		
		public function toXML():XML
		{
			var xml:XML = <layer />;
			
			for ( var i:int = 0; i < _neurons.length; i++ ) 
			{
				xml.appendChild( _neurons[ i ].toXML() );
			}
			
			return xml;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get neurons():/*Neuron*/Array { return _neurons; }
		
		public function get nrOfNeurons():uint { return _nrOfNeurons; }
		
		public function get inputLayer():Layer { return _inputLayer; }
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		private function init( nrOfNeurons:uint, inputLayer:Layer = null ):void
		{
			_nrOfNeurons = nrOfNeurons;
			_inputLayer	 = inputLayer;
			
			for ( var i:uint = 0; i < _nrOfNeurons; i++ ) 
			{
				var neuron:Neuron = new Neuron();
				
				if ( _inputLayer )
				{
					for ( var j:uint = 0; j < _inputLayer.neurons.length; j++ ) 
					{
						neuron.synapses[ neuron.synapses.length ] = new Synapse( _inputLayer.neurons[ j ], neuron );
					}
				}
				
				_neurons [ _neurons.length ] = neuron;
			}
		}
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}
	

}