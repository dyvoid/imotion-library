package nl.imotion.bindmvc.view
{

	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	import nl.imotion.events.EventManager;
	
	
	public class BindMovieClip extends MovieClip implements IBindView
	{
		
		public function BindMovieClip() { }
		
		
		include "../../inc_eventmanagerclient.as"
		
		
		include "inc_destroy.as"
		
	}
	
}