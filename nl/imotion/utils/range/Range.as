package nl.imotion.utils.range
{
	
	/**
	 * The <code>Range</code> class allows calculations on values within a range and translation to other ranges
	 * @author Pieter van de Sluis
	 */
	public class Range
	{
		private var _boundary1		:Number;
		private var _boundary2		:Number;
		
		
		/**
		 * Constructs a new <code>Range</code>
		 * @param	boundary1 the first boundary value of the range
		 * @param	boundary2 the second boundary value of the range
		 */
		public function Range( boundary1:Number, boundary2:Number ):void
		{
			_boundary1 = boundary1;
			_boundary2 = boundary2;
		}
		
		
		/**
		 * Translates a value in the range to a relative position (0-1).
		 * The input value is automatically constrained to the boundaries of the range.
		 * @param	value a value within the range
		 * @return	the relative position within the range
		 */
		public function getRelativePosFromValue( value:Number ):Number
		{
			value = constrain( value );
			
			return Math.abs( value - _boundary1 ) / rangeSize;
		}
		
		
		/**
		 * Translates a relative position (0-1) to a value within the range.
		 * The input value is automatically constrained to 0-1.
		 * @param	relativePos the relative position
		 * @return	the value within the range
		 */
		public function getValueFromRelativePos( relativePos:Number ):Number
		{
			relativePos = constrainTo( relativePos, 0, 1 );
			
			var result	:Number;
			
			if ( _boundary2 > _boundary1 )
			{
				result	= _boundary1 + ( relativePos * rangeSize );
			}
			else
			{
				result	= _boundary1 - ( relativePos * rangeSize );
			}
			
			return result;
		}
		
		
		/**
		 * Translates a value within this range to a value in a target range
		 * @param	value a value within the boundaries of this range
		 * @param	targetRange the target range that the value should be translated to
		 * @return	the translated value
		 */
		public function translate( value:Number, targetRange:Range ):Number
		{
			return targetRange.getValueFromRelativePos( getRelativePosFromValue( value ) );
		}
		
		
		/**
		 * Constrains a value to the boundaries of the range
		 * @param	value the value that should be constrained
		 * @return	the constrained value
		 */
		public function constrain( value:Number ):Number
		{			
			if ( _boundary2 > _boundary1 )
			{
				return constrainTo( value, _boundary1, _boundary2 );
			}
			else
			{
				return constrainTo( value, _boundary2, _boundary1 );
			}
		}
		
		
		private function constrainTo( value:Number, lower:Number, upper:Number ):Number
		{
			return Math.max( lower, Math.min( value, upper ) );
		}
		
		
		private function get rangeSize():Number
		{
			return Math.abs( _boundary2 - _boundary1 );
		}
		
		
		/**
		 * The first boundary of the range
		 */
		public function get boundary1():Number { return _boundary1; }
		public function set boundary1( value:Number ):void
		{
			_boundary1 = value;
		}
		
		
		/**
		 * The second boundary of the range
		 */
		public function get boundary2():Number { return _boundary2; }
		public function set boundary2( value:Number ):void
		{
			_boundary2 = value;
		}

	}
}