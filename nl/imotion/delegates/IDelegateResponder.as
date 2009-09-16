package nl.imotion.delegates 
{
	
	/**
	 * @author Pieter van de Sluis
	 * Based on code by Thomas Reppa (www.reppa.net)
	 */
	public interface IDelegateResponder 
	{
		function onDelegateResult	( operationName:String, data:Object ):void;
		function onDelegateFault	( operationName:String, data:Object ):void;
	}
	
}