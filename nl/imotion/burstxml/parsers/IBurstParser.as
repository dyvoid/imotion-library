package nl.imotion.burstxml.parsers 
{

	import nl.imotion.burstxml.components.IBurstComponent;

	
	public interface IBurstParser 
	{

		function parse( xml:XML, targetClass:Class ):IBurstComponent;

	}
}