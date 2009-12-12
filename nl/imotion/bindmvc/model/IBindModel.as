package nl.imotion.bindmvc.model 
{
	import nl.imotion.bindmvc.core.IBindComponent;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public interface IBindModel extends IBindComponent
	{
		function get name():String
	}
	
}