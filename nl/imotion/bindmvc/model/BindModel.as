package nl.imotion.bindmvc.model
{

	import nl.imotion.bindmvc.core.BindComponent;
	import nl.imotion.bindmvc.core.BindMVCCore;

	public class BindModel extends BindComponent implements IBindModel
	{
		private var _name:String;
		
		
		public function BindModel( name:String )
		{
			_name = name;
			
			BindMVCCore.getInstance().registerModel( this );
		}
		
		
		override public function destroy():void
		{
			BindMVCCore.getInstance().removeModel( _name );
			
			super.destroy();
		}
		
		
		public function get name():String { return _name; }
		
	}
	
}