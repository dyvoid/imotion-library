package nl.imotion.mvc.model 
{
	import nl.imotion.mvc.core.IDestroyable;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public interface IModel extends IDestroyable
	{
		function get name():String
	}
	
}