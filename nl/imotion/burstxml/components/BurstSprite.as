package nl.imotion.burstxml.components {

	import flash.display.Sprite;
	import nl.imotion.burstxml.Burst;

	public class BurstSprite extends Sprite implements IBurstComponent 
	{

		public var burst:Burst;
		
		private var _explicitWidth	:Number	= 0;
		private var _explicitHeight	:Number	= 0;
		
		
		public function BurstSprite() 
		{
		}
		
		
		public function get explicitWidth():Number 
		{
			return _explicitWidth;
		}
		public function set explicitWidth( value:Number ):void 
		{
			_explicitWidth = value;
		}
		
		
		public function get explicitHeight():Number 
		{
			return _explicitHeight;
		}
		public function set explicitHeight( value:Number ):void 
		{
			_explicitHeight = value;
		}

	}
}