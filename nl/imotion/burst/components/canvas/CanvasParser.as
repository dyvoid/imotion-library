package nl.imotion.burst.components.canvas 
{
	import flash.display.DisplayObject;
	import nl.imotion.burst.parsers.IBurstParser;
	
	/**
	 * ...
	 * @author Pieter van de Sluis
	 */
	public class CanvasParser implements IBurstParser
	{
		
		public function CanvasParser() 
		{
			
		}
		
		public function create( xml:XML, burst:Burst ):DisplayObject
		{
			return new Canvas();
		}
		
	}

}