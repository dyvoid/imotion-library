package nl.imotion.burst.parsers 
{

	import flash.display.DisplayObject;
	import nl.imotion.burst.Burst;

	public interface IBurstParser 
	{
		
		function create( xml:XML, burst:Burst = null, targetClass:Class = null ):DisplayObject;
		
	}
	
}