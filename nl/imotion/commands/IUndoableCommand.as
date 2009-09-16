package nl.imotion.commands
{

	/**
	* @author	Pieter van de Sluis
	*/
	public interface IUndoableCommand extends ICommand
	{
		function undo():void 
	}
	
}