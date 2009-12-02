package nl.imotion.utils.reflector 
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class PropertyDefinition
	{
		private var _name:String;
		private var _classRef:Class;
		private var _isReadable:Boolean;
		private var _isWriteable:Boolean;
		
		public function PropertyDefinition( name:String, classRef:Class, isReadable:Boolean, isWriteable:Boolean ) 
		{
			_name = name;
			_classRef = classRef;
			_isReadable = isReadable;
			_isWriteable = isWriteable;
		}
		
		public function get name():String { return _name; }
		
		public function get classRef():Class { return _classRef; }
		
		public function get isReadable():Boolean { return _isReadable; }
		
		public function get isWriteable():Boolean { return _isWriteable; }
		
	}

}