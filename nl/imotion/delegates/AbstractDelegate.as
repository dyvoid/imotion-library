package nl.imotion.delegates 
{
	import nl.imotion.commands.ICommand;
	
	/**
	 * @author Pieter van de Sluis
	 * Based on code by Thomas Reppa (www.reppa.net)
	 */
	public class AbstractDelegate implements IDelegate, ICommand
	{
		protected static var defaultResponder	:IDelegateResponder;
		
		private var _operationName	:String;
		private var _data			:Object
		private var _responder		:IDelegateResponder
		
		
		public function AbstractDelegate( operationName:String = null, data:Object = null, responder:IDelegateResponder = null ) 
		{
			_operationName 	= operationName;
			_data 			= data;
			_responder 		= responder;
		}
		
		
		public static function setDefaultResponder( responder:IDelegateResponder ):void
		{
			defaultResponder = responder;
		}
		
		
		public function execute():void
		{
			// override in subclass
		}
		
		
		public function get operationName():String { return _operationName; }
		public function set operationName( value:String ):void 
		{
			_operationName = value;
		}
		
		
		public function get data():Object { return _data; }
		public function set data( value:Object ):void 
		{
			_data = value;
		}
		
		
		public function get responder():IDelegateResponder 
		{ 
			return ( _responder == null ) ? defaultResponder : _responder;
		}
		public function set responder( value:IDelegateResponder ):void
		{
			_responder = value;
		}
		
	}
	
}