package nl.imotion.mvc.model
{

	import nl.imotion.mvc.core.MCComponent;
	import nl.imotion.mvc.core.MVCCore;

	public class BaseModel extends MCComponent implements IModel
	{
		private var _name:String;
		
		
		public function BaseModel( name:String ):void
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