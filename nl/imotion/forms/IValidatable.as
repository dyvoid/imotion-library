package nl.imotion.forms 
{
	
	/**
	 * @author Pieter van de Sluis
	 */
	public interface IValidatable 
	{
		function validate():Boolean;
		
		function get isValid():Boolean;
		
		function get errors():Array;
	}
	
}