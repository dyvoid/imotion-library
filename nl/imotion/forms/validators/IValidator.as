package nl.imotion.forms.validators 
{
	import nl.imotion.forms.IFormElement;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public interface IValidator 
	{
		function get isValid():Boolean;
		
		function get errors():Array;
	}
	
}