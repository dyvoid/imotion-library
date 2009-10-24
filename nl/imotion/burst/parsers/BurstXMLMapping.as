package nl.imotion.burst.parsers
{
	internal class BurstXMLMapping
	{
		private var _type:String;
		private var _itemName:String;
		private var _targetClass:Class;
		private var _defaultValue:*;
		private var _allowedValues:Array;
		
		public function BurstXMLMapping( type:String, itemName:String, targetClass:Class, defaultValue:* = null, allowedValues:Array = null ):void 
		{ 
			if ( type != BurstXMLMappingType.ATTRIBUTE && type != BurstXMLMappingType.NODE )
				throw new Error( "Invalid BurstXMLMapping type.");
			
			_type = type;
			_itemName = itemName;
			_targetClass = targetClass;
			_defaultValue = defaultValue;
			_allowedValues = allowedValues;
		}
		
		public function get type():String { return _type; }		
		
		public function get itemName():String { return _itemName; }
		
		public function get targetClass():Class { return _targetClass; }
		
		public function get defaultValue():* { return _defaultValue; }
		
		public function get allowedValues():Array { return _allowedValues; }
		
	}
	
}