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
		
		public function RequiredValidator() 
		{
			
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		override public function get isValid():Boolean 
		{
			if ( value is String )
			{
				return ( value != "" );
			}
			else
			{
				return ( value != null  ) && ( value != undefined );
			}
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}