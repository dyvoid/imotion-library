package nl.imotion.commandstack
{

	/**
	* @author	Pieter van de Sluis
	*/
	public interface IRedoableCommand extends ICommand
	{
		function redo():void 
	}
	
}