package nl.imotion.mvc.model
{

	import nl.imotion.mvc.core.MCComponent;

	public class BaseModel extends MCComponent implements IModel
	{
		private var _name:String;
		
		
		public function BaseModel( name:String ):void
		{
			_name = name;
			
			modelLocator.register( this );
		}
		
		
		override public function destroy():void
		{
			modelLocator.remove( this );
			
			super.destroy();
		}
		
		
		public function get name():String { return _name; }
		
		private function get modelLocator():ModelLocator
		{
			return ModelLocator.getInstance();
		}
		
	}
	
}