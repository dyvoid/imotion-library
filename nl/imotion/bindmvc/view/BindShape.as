package nl.imotion.bindmvc.view
{

	import flash.display.Shape;
	import flash.events.IEventDispatcher;
	import nl.imotion.events.EventManager;
	
	
	public class BindShape extends Shape implements IBindView
	{
		
		public function BindShape() { }
		
		
		include "../../inc_eventmanagerclient.as"
		
		
		include "inc_destroy.as"
		
	}
	
}