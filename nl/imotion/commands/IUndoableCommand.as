package nl.imotion.commandstack
{

	/**
	* @author	Pieter van de Sluis
	*/
	public interface IUndoableCommand extends ICommand
	{
		function undo():Void 
	}
	
}