package nl.imotion.neuralnetwork.components
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class Neuron
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _synapseMap		:/*Synapse*/Array = [];
		
		private var _value			:Number;
		private var _error			:Number;
		
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
		
		
		public function toXML():XML
		{
			var xml:XML = <neuron />;
			
			for ( var i:int = 0; i < _synapseMap.length; i++ ) 
			{
				xml.appendChild( _synapseMap[ i ].toXML() );
			}
			
			return xml;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get synapseMap():/*Synapse*/Array { return _synapseMap; }	
		
		public function get value():Number { return _value; }
		public function set value(value:Number):void 
		{
			_value = value;
		}
		
		public function get error():Number { return _error; }
		public function set error(value:Number):void 
		{
			_error = value;
		}
		
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