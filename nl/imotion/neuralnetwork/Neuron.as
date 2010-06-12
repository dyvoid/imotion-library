package nl.imotion.neuralnetwork 
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class Neuron
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _value			:Number;
		
		private var _synapseMap		:/*Synapse*/Array = [];
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function Neuron() 
		{
			
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function calcValue():Number 
		{
			if ( _synapseMap.length == 0 )
				throw new Error( "Unable to calculate a value. Neuron has no synapses connected to it" );
			
			_value = 0;
			
			for ( var i:int = 0; i < _synapseMap.length; i++ ) 
			{
				_value += _synapseMap[ i ].getOutput();
			}
			
			_value = applySigmoid( _value );
			
			return _value;
		}
		
		
		public function updateValue():Number
		{
			return NaN;
		}
		
		
		public function updateWeights( error:Number ):void
		{
			for ( var i:int = 0; i < _synapseMap.length; i++ ) 
			{
				_synapseMap[ i ].updateWeight( error );
			}
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get value():Number { return _value; }
		
		public function set value(value:Number):void 
		{
			_value = value;
		}
		
		public function get synapseMap():/*Synapse*/Array { return _synapseMap; }		
		
		/*public function set synapses(value:Array):void 
		{
			_synapses = value;
		}*/
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		private function applySigmoid( value:Number ):Number
		{
			return 1 / ( 1 + Math.exp( -value ) );
		}
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}