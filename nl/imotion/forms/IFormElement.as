package nl.imotion.forms 
{
	
	/**
	 * @author Pieter van de Sluis
	 */
	public interface IFormElement extends IValidatable
	{
		function get value():*
		function set value( value:* )
	}
	
}