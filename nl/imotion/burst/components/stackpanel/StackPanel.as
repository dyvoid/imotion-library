package nl.imotion.burst.components.stackpanel 
{

	import flash.display.DisplayObject;
	import nl.imotion.burst.components.BurstSprite;

	public class StackPanel extends BurstSprite 
	{
		
		private var _orientation:String;
		
		
		public function StackPanel( orientation:String = "vertical" ) 
		{
			_orientation = orientation;
		}
		
		
		public function get orientation():String 
		{
			return _orientation;
		}
		
		
		override public function addChild( child:DisplayObject ):DisplayObject 
		{
			switch ( _orientation )
			{
				case StackPanelOrientation.HORIZONAL:
					child.x = this.width;
				break;
				
				case StackPanelOrientation.VERTICAL:
					child.y = this.height;
				break;
			}
			
			return super.addChild(child);
		}
		
	}
}