package nl.imotion.burst.components.core
{

	import nl.imotion.display.IEventManagedDisplayObject;

	public interface IBurstComponent extends IEventManagedDisplayObject
	{
		
		function get explicitWidth():Number;
		function set explicitWidth( value:Number ):void;
		function get explicitHeight():Number;
		function set explicitHeight( value:Number ):void;
		
	}
}