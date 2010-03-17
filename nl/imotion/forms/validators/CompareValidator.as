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
		
		private var _compare	:*;
		private var _compareTo	:*;
		private var _operator	:String;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function CompareValidator( compare:*, compareTo:*, operator:String = "==" ) 
		{
			_compare	= compare;
			_compareTo	= compareTo;
			_operator 	= operator;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		override public function get isValid():Boolean 
		{
			var compareValue:*   = ( _compare   is IFormElement ) ? IFormElement( _compare   ).value : _compare;
			var compareToValue:* = ( _compareTo is IFormElement ) ? IFormElement( _compareTo ).value : _compareTo;
			
			switch( _operator )
			{
				case "==":
					return compareValue == compareToValue;
					
				case "!=":
					return compareValue != compareToValue;
					
				case "<":
					return compareValue <  compareToValue;
					
				case ">":
					return compareValue >  compareToValue;
					
				case "<=":
					return compareValue <= compareToValue;
					
				case ">=":
					return compareValue >= compareToValue;
			}
			
			return false;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get compare():* { return _compare; }
		
		public function set compare(value:*):void 
		{
			_compare = value;
		}
		
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