package nl.imotion.forms 
{
	import nl.imotion.display.EventManagedSprite;
	import nl.imotion.forms.validators.IValidator;
	import nl.imotion.forms.validators.RequiredValidator;
	import nl.imotion.forms.validators.Validator;
	import nl.imotion.forms.validators.ValidatorGroup;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class FormElementSprite extends EventManagedSprite implements IFormElement
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _validatorGroup		:ValidatorGroup		= new ValidatorGroup();
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function FormElementSprite() 
		{
			
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
			validator.formElement = this;
			return _validatorGroup.addValidator( validator );
		}
		
		
		public function removeValidator( validator:Validator ):IValidator
		{
			validator = _validatorGroup.removeValidator( validator );
			
			if ( validator )
				validator.formElement = null;
			
			return validator;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		// public
		
		public function get value():* { return null; }
		
		public function set value( value:* ):void
		{
			
		}
		
		
		public function get isValid():Boolean
        {
            return _validatorGroup.isValid;
        }
		
		
		public function get errors():/*String*/Array
		{
			return _validatorGroup.errors;
		}
		
		
		// protected
		
		protected function get validatorGroup():ValidatorGroup { return _validatorGroup; }
		
		protected function set validatorGroup( value:ValidatorGroup ):void 
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