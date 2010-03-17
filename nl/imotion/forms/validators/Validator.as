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
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function Validator() 
		{
			
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC		
		
		
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS		
		
		public function get isValid():Boolean
		{
			return true;
		}
		
		
		public function get errors():/*String*/Array
		{
			return ( _defaultErrorMessage && !isValid ) ? [ _defaultErrorMessage ] : [];
		}
		
		
		public function get formElement():IFormElement { return _formElement; }
		
		public function set formElement( value:IFormElement ):void 
		{
			_formElement = value;
		}
		
		public function get defaultErrorMessage():String { return _defaultErrorMessage; }
		
		public function set defaultErrorMessage(value:String):void 
		{
			_defaultErrorMessage = value;
		}
		
		
		protected function get value():*
		{
			if ( _formElement )
			{
				return _formElement.value;
			}
			else
			{
				throw new Error( "formElement has not been set");
			}
		}
	}

}