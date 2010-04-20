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
		private var _operatorMethod :String = ValidatorGroupOperator.AND;
        
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
			var __isValid:Boolean = ( _operatorMethod != ValidatorGroupOperator.OR );
			
			for ( var i:int = 0; i < _validators.length; i++ ) 
			{
				var validatorIsValid:Boolean = _validators[ i ].isValid;
				
				switch( _operatorMethod )
				{
					case ValidatorGroupOperator.AND:
						if ( !validatorIsValid )
							return false;
					break;
					
					case ValidatorGroupOperator.OR:
						__isValid = __isValid || validatorIsValid;
					break;
				}
			}
			
			return __isValid;
		}
		
		
		public function get errors():/*ValidatorError*/Array
		{
			var errors:/*ValidatorError*/Array = [];
			
			if ( !isValid )
			{
				for ( var i:int = 0; i < _validators.length; i++ ) 
				{
					errors = errors.concat( _validators[ i ].errors );
				}
			}
			
			return errors;
		}
		
		
		public function get operatorMethod():String { return _operatorMethod; }
		
		public function set operatorMethod( value:String ):void 
		{
			_operatorMethod = value;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
	}

}