package nl.imotion.bindmvc.model 
{
	import nl.imotion.bindmvc.core.IDestroyable;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public interface IBindModel extends IDestroyable
	{
		function get name():String
	}
	
}