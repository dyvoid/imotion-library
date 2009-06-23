package nl.imotion.mvc.view 
{
	import flash.display.IDisplayObject;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public interface IView extends IDisplayObject
	{
		function destroy():void
	}
	
}