package nl.imotion.forms.validators 
{
	import nl.imotion.forms.IFormElement;
	import nl.imotion.forms.validators.Validator;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class RequiredValidator extends Validator
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function RequiredValidator( formElement:IFormElement = null, defaultErrorMessage:String = null ) 
		{
			super( formElement, defaultErrorMessage );
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		override public function get isValid():Boolean 
		{
			return super.isValid && ( super.formElement.value != null && super.formElement.value != "" ); 
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}