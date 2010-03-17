package nl.imotion.forms.validators 
{
	import nl.imotion.forms.IFormElement;
	import nl.imotion.forms.validators.Validator;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class CompareValidator extends Validator
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _compareTo	:*;
		private var _operator	:String;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function CompareValidator( compareTo:*, operator:String = "==" ) 
		{
			_compareTo	= compareTo;
			_operator 	= operator;
		}

		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		override public function get isValid():Boolean 
		{
			var compareValue:* = ( _compareTo is IFormElement ) ? IFormElement( _compareTo ).value : _compareTo;
			
			switch( _operator )
			{
				case "==":
					return formElement.value == compareValue;
					
				case "!=":
					return formElement.value != compareValue;
					
				case "<":
					return formElement.value <  compareValue;
					
				case ">":
					return formElement.value >  compareValue;
					
				case "<=":
					return formElement.value <= compareValue;
					
				case ">=":
					return formElement.value >= compareValue;
			}
			
			return false;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get compareTo():* { return _compareTo; }
		
		public function set compareTo(value:*):void 
		{
			_compareTo = value;
		}
		
		public function get operator():String { return _operator; }
		
		public function set operator(value:String):void 
		{
			_operator = value;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}