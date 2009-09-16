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
		private static var allowInstantiation:Boolean = false;
		private static var instance:BindMVCCore;
		
		private var _isStarted	:Boolean = false;
		
		private var bindMap		:Dictionary = new Dictionary();
		private var boundMap	:Dictionary = new Dictionary();
		
		private var modelMap	:Dictionary = new Dictionary();
		
		
		public function BindMVCCore()
		{
			if ( !allowInstantiation )
			{
				throw new Error( "Instantiation failed: Use BindMVCCore.getInstance() instead of constructor." );
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
			if ( !_isStarted )
			{
				throw new Error( "BindMVCCore has not been initiated properly. Please use startup method." );
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
		
		
		public function registerModel( model:IBindModel ):void
		{
			modelMap[ model.name ] = model;
		}
		
		
		public function retrieveModel( modelName:String ):IBindModel
		{
			if ( modelMap[ modelName ] )
			{
				return modelMap[ modelName ];
			}
			return null;
		}
		
		
		public function removeModel( modelName:String ):IBindModel
		{
			var model:IBindModel = modelMap[ modelName ];
			
			if ( model )
			{
				delete modelMap[ modelName ];
			}
			
			return model;
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
					var controller:IBindController = new controllerClass( view );
					
					boundMap[ view ] = controller;
				}
			}
		}
		
		
		private function removedFromStageHandler( e:Event ):void
		{
			var view:DisplayObject = e.target as DisplayObject;
			
			if ( boundMap[ view ] )
			{
				var controller:IBindController = boundMap[ view ];
				controller.destroy();
				
				delete boundMap[ view ];
			}
		}
		
		
		public function get isStarted():Boolean { return _isStarted; }
		
	}
	
}