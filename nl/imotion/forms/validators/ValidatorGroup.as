package nl.imotion.forms.validators 
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class ValidatorGroup implements IValidator
	{		
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _validators		:/*IValidator*/Array = [];
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function ValidatorGroup() 
		{
			
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function addValidator( validator:Validator ):Validator
		{
			_validators.push( validator );
			
			return validator;
		}
		
		
		public function removeValidator( validator:Validator ):Validator
		{
			for ( var i:int = _validators.length - 1; i >= 0; i-- ) 
			{
				if ( _validators[ i ] == validator )
				{
					return _validators.splice( i, 1 )[ 0 ];
				}
			}
			
			return null;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get isValid():Boolean
		{
			for ( var i:int = 0; i < _validators.length; i++ ) 
			{
				if ( !_validators[ i ].isValid )
					return false;
			}
			
			return true;
		}
		
		
		public function get errors():/*String*/Array
		{
			var errors:/*String*/Array = [];
			
			for ( var i:int = 0; i < _validators.length; i++ ) 
			{
				if ( !_validators[ i ].isValid )
					errors = errors.concat( _validators[ i ].errors );
			}
			
			return errors;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
	}

}