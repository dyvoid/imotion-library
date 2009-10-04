package nl.imotion.burst.parsers 
{

	import flash.display.DisplayObject;
	import nl.imotion.burst.Burst;

	public interface IBurstParser 
	{

		function parse( xml:XML, burst:Burst ):DisplayObject;

	}
}