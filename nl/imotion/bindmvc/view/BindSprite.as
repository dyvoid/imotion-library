package nl.imotion.bindmvc.view
{

	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import nl.imotion.events.EventManager;
	
	
	public class BindSprite extends Sprite implements IBindView
	{
		
		public function BindSprite() { }
		
		
		include "../../inc_eventmanagerclient.as"
		
		
		include "inc_destroy.as"
		
	}
	
}