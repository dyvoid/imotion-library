package nl.imotion.bindmvc.view
{

	import flash.display.Bitmap;
	import flash.events.IEventDispatcher;
	import nl.imotion.events.EventManager;
	
	
	public class BindBitmap extends Bitmap implements IBindView
	{
		
		public function BindBitmap() { }
		
		
		include "../../inc_eventmanagerclient.as"
		
		
		include "inc_destroy.as"
	}
	
}