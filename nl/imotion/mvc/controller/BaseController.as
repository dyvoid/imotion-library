package nl.imotion.mvc.controller
{
	
	import nl.imotion.mvc.core.MCComponent;
	import nl.imotion.mvc.model.IModel;
	import nl.imotion.mvc.view.IView;

	public class BaseController extends MCComponent implements IController
	{
		
		protected var defaultView:IView;
		protected var defaultModel:IModel;
		
		
		public function BaseController( defaultView:IView = null, defaultModel:IModel = null )
		{
			this.defaultView 	= defaultView;
			this.defaultModel 	= defaultModel;
		}
		
		
		override public function destroy():void
		{
			defaultView 	= null;
			defaultModel 	= null;
			
			super.destroy();
		}
		
	}
	
}