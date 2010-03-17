package nl.imotion.forms.validators 
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class ValidatorGroup implements IValidator
	{		
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _validators		:/*IValidator*/Array;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function ValidatorGroup() 
		{
			
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function addValidator( validator:IValidator ):IValidator
		{
			_validators.push( validator );
			
			return validator;
		}
		
		
		public function removeValidator( validator:IValidator ):IValidator
		{
			for ( var i:int = _validators.length - 1; i >= 0; i-- ) 
			{
				if ( _validators[ i ] == validator )
				{
					return _validators.splice( i, 1 )[ 0 ];
				}
			}
			
			return;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get isValid():Boolean
		{
			for ( var i:int = 0; i < _subValidators.length; i++ ) 
			{
				if ( !_subValidators[ i ].isValid )
					return false;
			}
			
			return true;
		}
		
		
		public function get errors():Array
		{
			var errors:/*String*/Array = [];
			
			for ( var i:int = 0; i < _subValidators.length; i++ ) 
			{
				if ( !_subValidators[ i ].isValid )
					errors.concat( _subValidators[ i ].errors );
			}
			
			return errors;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
	}

}