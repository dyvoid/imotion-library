package nl.imotion.forms.validators 
{
	import nl.imotion.forms.validators.Validator;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class RegExpValidator extends Validator
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _regExp		:RegExp;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function RegExpValidator( regExp:RegExp ) 
		{
			_regExp = regExp;			
		}		
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		override public function get isValid():Boolean 
		{
			return regExp.test( String( value ) );
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get regExp():RegExp { return _regExp; }
		
		public function set regExp(value:RegExp):void 
		{
			_regExp = value;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}