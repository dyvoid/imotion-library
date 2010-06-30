package nl.imotion.neuralnetwork.components
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class Neuron
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _synapses		:/*Synapse*/Array = [];
		
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
			if ( _synapses.length == 0 )
				throw new Error( "Unable to calculate a value. Neuron has no synapses connected to it" );
			
			_value = 0;
			
			for ( var i:int = 0; i < _synapses.length; i++ ) 
			{
				_value += _synapses[ i ].getOutput();
			}
			
			_value = applySigmoid( _value );
			
			return _value;
		}
		
		
		public function toXML():XML
		{
			var xml:XML = <neuron />;
			
			for ( var i:int = 0; i < _synapses.length; i++ ) 
			{
				xml.appendChild( _synapses[ i ].toXML() );
			}
			
			return xml;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get synapses():/*Synapse*/Array { return _synapses; }	
		
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