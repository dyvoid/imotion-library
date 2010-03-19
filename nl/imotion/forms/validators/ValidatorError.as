package nl.imotion.forms.validators 
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class ValidatorError
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _validator		:IValidator;
		private var _errorMessage	:String;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function ValidatorError( validator:IValidator, errorMessage:String ):void 
		{ 
			_validator 		= validator;
			_errorMessage 	= errorMessage;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function isEqual( validatorError:ValidatorError ):Boolean
		{
			return ( validatorError.validator == _validator ) && ( validatorError.errorMessage == _errorMessage );
		}
		
		
		public function clone():ValidatorError
		{
			return new ValidatorError( _validator, _errorMessage );
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get validator():IValidator { return _validator; }
		
		public function get errorMessage():String { return _errorMessage; }
		
		
		
	}

}