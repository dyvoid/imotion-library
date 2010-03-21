package nl.imotion.forms.validators 
{
	import flash.text.TextField;
	import nl.imotion.forms.IFormElement;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class Validator implements IValidator
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _target					:*;
		private var _defaultErrorMessage	:String;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function Validator() 
		{
			
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC		
		
		
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS		
		
		public function get isValid():Boolean
		{
			return true;
		}
		
		
		public function get errors():/*ValidatorError*/Array
		{
			if ( _defaultErrorMessage && !isValid )
			{
				return [ new ValidatorError( this, _defaultErrorMessage ) ];
			}
			else
			{
				return [ ];
			}
		}
		
		
		public function get target():* { return _target; }
		
		public function set target( value:* ):void 
		{
			_target = value;
		}
		
		
		public function get defaultErrorMessage():String { return _defaultErrorMessage; }
		
		public function set defaultErrorMessage(value:String):void 
		{
			_defaultErrorMessage = value;
		}
		
		
		protected function get value():*
		{
			if ( _target )
			{
				switch ( true )
				{
					case _target is IFormElement:
						return IFormElement( _target ).value;
					
					case _target is TextField:
						return TextField( _target ).text;
						
					default:
						return _target;
				}
			}
			else
			{
				throw new Error( "target has not been set");
			}
		}
		
	}

}