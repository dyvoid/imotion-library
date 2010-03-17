package nl.imotion.forms.validators 
{
	
	/**
	 * @author Pieter van de Sluis
	 */
	public interface IValidator 
	{
		function get isValid():Boolean;
		function get errors():Array;
	}
	
}