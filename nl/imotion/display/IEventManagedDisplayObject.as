package nl.imotion.display
{
	import flash.display.IDisplayObject;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public interface IEventManagedDisplayObject extends IDisplayObject
	{
		function destroy():void
	}
	
}