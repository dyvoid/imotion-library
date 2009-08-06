package nl.imotion.mvc.model
{

	import nl.imotion.mvc.core.MVCComponent;
	import nl.imotion.mvc.core.MVCCore;

	public class AbstractModel extends MVCComponent implements IModel
	{
		private var _name:String;
		
		
		public function AbstractModel( name:String ):void
		{
			_name = name;
			
			MVCCore.getInstance().registerModel( this );
		}
		
		
		override public function destroy():void
		{
			MVCCore.getInstance().removeModel( this );
			
			super.destroy();
		}
		
		
		public function get name():String { return _name; }
		
	}
	
}