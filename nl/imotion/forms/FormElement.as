package nl.imotion.forms 
{
	import nl.imotion.forms.validators.IValidator;
	import nl.imotion.forms.validators.RequiredValidator;
	import nl.imotion.forms.validators.Validator;
	import nl.imotion.forms.validators.ValidatorGroup;
	import nl.imotion.forms.validators.ValidatorGroupOperator;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class FormElement implements IFormElement
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _validatorGroup		:ValidatorGroup		= new ValidatorGroup();
		
		private var _value:String = "";
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function FormElement() 
		{
			_validatorGroup.operatorMethod = ValidatorGroupOperator.AND;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function validate():Boolean
        {
            return changeValidState( isValid );
        }
		
		
		public function changeValidState( isValid:Boolean ):Boolean
		{
			// override in subclass
			
			return isValid;
		}
		
		
		public function addValidator( validator:Validator ):IValidator
		{
			validator.target = this;
			
			return _validatorGroup.addValidator( validator );
		}
		
		
		public function removeValidator( validator:Validator ):IValidator
		{
			validator = _validatorGroup.removeValidator( validator );
			
			if ( validator )
				validator.target = null;
			
			return validator;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		// public
		
		public function get value():* { return _value; }
		
		public function set value( value:* ):void
		{
			_value = value;
		}
		
		
		public function get isValid():Boolean
        {
            return _validatorGroup.isValid;
        }
		
		
		public function get errors():/*String*/Array
		{
			return _validatorGroup.errors;
		}
		
		public function get validatorGroup():ValidatorGroup { return _validatorGroup; }
		
		public function set validatorGroup( value:ValidatorGroup ):void 
		{
			_validatorGroup = value;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}