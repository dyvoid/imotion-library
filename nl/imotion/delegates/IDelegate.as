package nl.imotion.delegates 
{
	import nl.imotion.commands.ICommand;
	
	/**
	 * @author Pieter van de Sluis
	 * Based on code by Thomas Reppa (www.reppa.net)
	 */
	public interface IDelegate extends ICommand
	{
		function get operationName():String
		function set operationName( value:String ):void 
		
		function get data():Object
		function set data( value:Object ):void 
		
		function get responder():IDelegateResponder 
		function set responder( value:IDelegateResponder ):void
	}
	
}