package nl.imotion.utils.reflector 
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class PropertyDefinition
	{
		private var _name:String;
		private var _classRef:Class;
		private var _accessType:String
		
		public function PropertyDefinition( name:String, classRef:Class, accessType:String ) 
		{
			_name = name;
			_classRef = classRef;
			_accessType = accessType;
		}
		
		public function get name():String { return _name; }
		
		public function get classRef():Class { return _classRef; }
		
		public function get accessType():String { return _accessType; }
		
	}

}