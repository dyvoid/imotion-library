package nl.imotion.mvc.core 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import nl.imotion.mvc.controller.IController;
	import nl.imotion.mvc.model.IModel;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class MVCCore 
	{
		private static var allowInstantiation:Boolean = false;
		private static var instance:MVCCore;
		
		private var _isStarted	:Boolean = false;
		
		private var bindMap		:Dictionary = new Dictionary();
		private var boundMap	:Dictionary = new Dictionary();
		
		private var modelMap	:Dictionary = new Dictionary();
		
		
		public function MVCCore()
		{
			if ( !allowInstantiation )
			{
				throw new Error( "Instantiation failed: Use MVCCore.getInstance() instead of constructor." );
			}
		}
		
		
		public static function getInstance():MVCCore
		{
			if ( instance == null )
			{
				allowInstantiation = true;
				instance = new MVCCore();
				allowInstantiation = false;
			}
			return instance as MVCCore;
		}
		
		
		public function startup( base:DisplayObject ):void
		{
			if ( _isStarted )
			{
				throw new Error( "MVCCore has already been started." );
			}
			
			base.addEventListener( Event.ADDED_TO_STAGE, 	 addedToStageHandler, true );
			base.addEventListener( Event.REMOVED_FROM_STAGE, removedFromStageHandler, true );
			
			_isStarted = true;
		}
		
		
		public function bind( viewClass:Class, controllerClass:Class ):void
		{
			if ( !_isStarted )
			{
				throw new Error( "MVCCore has not been initiated properly. Please use startup method." );
			}
			
			bindMap[ viewClass ] = controllerClass;
		}
		
		
		public function unbind( viewClass:Class, controllerClass:Class ):void
		{
			if ( bindMap[ viewClass ] == controllerClass )
			{
				delete bindMap[ viewClass ];
			}
		}
		
		
		public function registerModel( model:IModel ):void
		{
			modelMap[ model.name ] = model;
		}
		
		
		public function removeModel( model:IModel ):void
		{
			if ( modelMap[ model.name ] )
			{
				delete modelMap[ model.name ];
			}
		}
		
		
		public function retrieveModel( name:String ):IModel
		{
			if ( modelMap[ name ] )
			{
				return modelMap[ name ];
			}
			return null;
		}
		
		
		private function addedToStageHandler( e:Event ):void 
		{
			var view:DisplayObject = e.target as DisplayObject;
			
			if ( boundMap[ view ] == null )
			{
				var viewClass:Class = getDefinitionByName( getQualifiedClassName( view ) ) as Class;
				
				if ( bindMap[ viewClass ] )
				{
					var controllerClass:Class = bindMap[ viewClass ];
					var controller:IController = new controllerClass( view );
					
					boundMap[ view ] = controller;
				}
			}
		}
		
		
		private function removedFromStageHandler( e:Event ):void 
		{
			var view:DisplayObject = e.target as DisplayObject;
			
			if ( boundMap[ view ] )
			{
				var controller:IController = boundMap[ view ];
				controller.destroy();
				
				delete boundMap[ view ];
			}
		}
		
		
		public function get isStarted():Boolean { return _isStarted; }
		
	}
	
}