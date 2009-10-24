package nl.imotion.bindmvc.core
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import nl.imotion.bindmvc.controller.IBindController;
	import nl.imotion.bindmvc.model.IBindModel;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class BindMVCCore
	{
		protected static var allowInstantiation:Boolean = false;
		protected static var instance:BindMVCCore;
		
		private var _isStarted	:Boolean = false;
		
		protected var bindMap		:Dictionary = new Dictionary();
		protected var boundMap	:Dictionary = new Dictionary();
		
		protected var modelMap	:Dictionary = new Dictionary();
		
		
		public function BindMVCCore()
		{
			if ( !allowInstantiation )
			{
				throw new Error( "Instantiation failed: Use BindMVCCore.getInstance() Singleton factory method instead of constructor." );
			}
		}
		
		
		public static function getInstance():BindMVCCore
		{
			if ( instance == null )
			{
				allowInstantiation = true;
				instance = new BindMVCCore();
				allowInstantiation = false;
			}
			return instance as BindMVCCore;
		}
		
		
		public function startup( base:DisplayObject ):void
		{
			if ( _isStarted )
			{
				throw new Error( "BindMVCCore has already been started." );
			}
			
			base.addEventListener( Event.ADDED_TO_STAGE, 	 addedToStageHandler, true );
			base.addEventListener( Event.REMOVED_FROM_STAGE, removedFromStageHandler, true );
			
			_isStarted = true;
		}
		
		
		public function bind( viewClass:Class, controllerClass:Class ):void
		{
			checkStartup();
			
			bindMap[ viewClass ] = controllerClass;
		}
		
		
		public function unbind( viewClass:Class, controllerClass:Class ):void
		{
			checkStartup();
			
			if ( bindMap[ viewClass ] == controllerClass )
			{
				delete bindMap[ viewClass ];
			}
		}
		
		
		public function registerModel( model:IBindModel ):void
		{
			modelMap[ model.name ] = model;
		}
		
		
		public function retrieveModel( modelName:String ):IBindModel
		{
			return modelMap[ modelName ];
		}
		
		
		public function removeModel( modelName:String ):IBindModel
		{
			const model:IBindModel = modelMap[ modelName ];
			
			if ( model )
			{
				delete modelMap[ modelName ];
			}
			
			return model;
		}
		
		
		protected function addedToStageHandler( e:Event ):void
		{
			const view:DisplayObject = e.target as DisplayObject;
			
			if ( boundMap[ view ] == null )
			{
				const viewClass:Class = getDefinitionByName( getQualifiedClassName( view ) ) as Class;
				
				if ( bindMap[ viewClass ] )
				{
					const controllerClass:Class = bindMap[ viewClass ];
					const controller:IBindController = new controllerClass( view );
					
					boundMap[ view ] = controller;
				}
			}
		}
		
		
		protected function removedFromStageHandler( e:Event ):void
		{
			const view:DisplayObject = e.target as DisplayObject;
			const controller:IBindController = boundMap[ view ];
			
			if ( controller )
			{
				controller.destroy();
				
				delete boundMap[ view ];
			}
		}
		
		
		private function checkStartup():void
		{
			if ( !_isStarted )
			{
				throw new Error( "BindMVCCore has not been initiated properly to support binding. Please use startup method." );
			}
		}
		
		
		public function get isStarted():Boolean { return _isStarted; }
		
	}
	
}