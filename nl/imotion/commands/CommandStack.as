package nl.imotion.commands
{
	
	/**
	* @author	Pieter van de Sluis
	*/

	public class CommandStack
	{
		private var stack		:Array  = [];
		private var _index		:int	= -1;
		private var _maxLength	:uint;
		
		
		/*
		 * Constructs a new CommandStack
		 * @param	maxLength	The maximum length of the stack. 0 is unlimited (default).
		 */
		public function CommandStack( maxLength:uint = 0 )
		{
			_maxLength = maxLength;
		}
		
		
		/**
		 * Removes commands from the stack, if the max length of the stack has been reached
		 */
		private function enforceMaxLength():void
		{
			if ( maxLength != 0 && stack.length > maxLength )
			{
				stack.splice( stack.length - maxLength );
				
				_index = stack.length - 1;
			}
		}
		
		
		/**
		 * Clears the stack
		 */
		public function clear():void
		{
			stack  = [];
			_index = -1;
		}
		
		
		/**
		 * Adds a command to the stack
		 * @param	command		the command
		 */
		public function addCommand( command:ICommand ):void
		{
			stack[ _index++ ] = command;
			stack.splice( _index );
			
			enforceMaxLength();
		}
		
		
		private function doSingleUndo():void
		{
			IUndoableCommand( stack[ --_index ] ).undo();
		}
		
		
		/**
		 * Undos a number of steps in stack
		 * @param	nrOfSteps	the number of steps to undo
		 */
		public function undo( nrOfSteps:uint = 1 ):void
		{
			if ( stack.length > 0 )
			{
				nrOfSteps = Math.min( nrOfSteps, index + 1 );
				
				for ( var i:int = 0; i < nrOfSteps; i++ ) 
				{
					doSingleUndo();
				}
			}
		}
		
		
		private function doSingleRedo():void
		{
			if ( index < stack.length )
			{
				IRedoableCommand( stack[ ++_index ] ).redo();
			}
		}
		
		
		/**
		 * Redos a number of steps in stack
		 * @param	nrOfSteps	the number of steps to redo
		 */
		public function redo( nrOfSteps:uint = 1 ):void
		{
			if ( stack.length > 0 )
			{
				nrOfSteps = Math.min( nrOfSteps, stack.length - index );
				
				for ( var i:int = 0; i < nrOfSteps; i++ ) 
				{
					doSingleRedo();
				}
			}
		}
		
		
		/**
		 * The current index of the stack
		 */
		public function get index():int { return _index; }
		
		
		/**
		 * The length of the stack
		 */
		public function get length():uint { return stack.length; }
		
	}
}
