package nl.imotion.forms 
{
	
	/**
	 * @author Pieter van de Sluis
	 */
	public interface IValidatable 
	{
		function validate():Boolean;
		
		function get isValid():Boolean;
		
        function changeValidState( isValid:Boolean ):Boolean
        
		function get errors():Array;
	}
	
}