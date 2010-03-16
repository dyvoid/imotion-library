package nl.imotion.forms 
{
	
	/**
	 * @author Pieter van de Sluis
	 */
	public interface IValidatable 
	{
		function validate():Boolean;
		
		function get isValid():Boolean;
		function set isValid( value:Boolean ):void;
		
		function get errors():/*String*/Array;
	}
	
}