package nl.imotion.events
{
	import flash.events.IEventDispatcher;
	
	
	
	final internal class EventListener
	{
		private var _target				:IEventDispatcher
		private var _type				:String
		private var _listener			:Function
		private var _useCapture			:Boolean;
		
		
        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                        C O N S T R U C T O R     |
        //__________________________________________________________________________________________________________________|
		
		public function EventListener( target:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false )
		{
            _target 			= target;
			_type 				= type;
			_listener			= listener;
			_useCapture			= useCapture;
		}
		
        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                G E T T E R S / S E T T E R S     |
        //__________________________________________________________________________________________________________________|
		
		public function get target():IEventDispatcher { return _target; }
		
		public function get type():String { return _type; }
		
		public function get listener():Function { return _listener; }
		
		public function get useCapture():Boolean { return _useCapture; }
		
		public function equals( eventListener:EventListener ):Boolean
		{
			return ( eventListener.target == _target && eventListener.type == _type && eventListener.listener == _listener && eventListener.useCapture == _useCapture );
		}
	}
}