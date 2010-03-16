package nl.imotion.forms.validators 
{
	import nl.imotion.forms.IFormElement;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class Validator implements IValidator
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _formElement			:IFormElement;
		private var _defaultErrorMessage	:String;
		
		private var _subValidators			:/*IValidator*/Array;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function Validator( formElement:IFormElement = null, defaultErrorMessage:String = null ) 
		{
			_formElement 			= formElement;
			_defaultErrorMessage	= defaultErrorMessage;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC		
		
		public function validate():Boolean
		{
			var __isValid:Boolean = isValid;
			
			_formElement.validate( __isValid );
			
			return __isValid;
		}
		
		
		public function addSubValidator( validator:IValidator ):IValidator
		{
			_subValidators.push( validator );
		}
		
		
		public function removeSubValidator( validator:IValidator ):IValidator
		{
			for ( var i:int = _subValidators.length - 1; i >= 0; i-- ) 
			{
				if ( _subValidators[ i ] == validator )
				{
					return _subValidators.splice( i, 1 )[ 0 ];
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
		
		
		public function get errors():/*String*/Array
		{
			var errors:/*String*/Array = [];
			
			for ( var i:int = 0; i < _subValidators.length; i++ ) 
			{
				if ( !_subValidators[ i ].isValid )
					errors.concat( _subValidators[ i ].errors );
			}
			
			if ( _defaultErrorMessage && !isValid )
				errors.push( _defaultErrorMessage );
			
			return errors;
		}
		
		public function get formElement():IFormElement { return _formElement; }
	}

}