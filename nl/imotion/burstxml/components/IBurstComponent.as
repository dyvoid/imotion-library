package nl.imotion.burstxml.components 
{

	import flash.display.IDisplayObject;

	public interface IBurstComponent extends IDisplayObject 
	{

		function get explicitWidth():Number;
		function set explicitWidth( value:Number ):void;
		
		function get explicitHeight():Number;
		function set explicitHeight( value:Number ):void;

	}
}