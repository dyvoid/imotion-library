package nl.imotion.delegates 
{
	
	/**
	 * @author Pieter van de Sluis
	 * Based on code by Thomas Reppa (www.reppa.net)
	 */
	public interface IDelegate 
	{
		function execute():void
		
		function get operationName():String
		function set operationName( value:String ):void 
		
		function get data():Object
		function set data( value:Object ):void 
		
		function get responder():IDelegateResponder 
		function set responder( value:IDelegateResponder ):void
	}
	
}