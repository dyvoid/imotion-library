package nl.imotion.mvc.model
{
	import flash.utils.Dictionary;

	public class ModelLocator
	{
		private static var allowInstantiation:Boolean = false;
		private static var instance:ModelLocator;
		
		private var models:Dictionary = new Dictionary();
		
		
		public function ModelLocator()
		{
			if ( !allowInstantiation )
			{
				throw new Error( "Error: Instantiation failed: Use ModelLocator.getInstance() instead of constructor." );
			}
		}
		
		
		public static function getInstance():ModelLocator
		{
			if ( instance == null )
			{
				allowInstantiation = true;
				instance = new ModelLocator();
				allowInstantiation = false;
			}
			return instance as ModelLocator;
		}
		

		public function register( model:IModel ):void
		{
			models[ model.name ] = model;
		}
		
		
		public function remove( model:IModel ):void
		{
			if ( models[ model.name ] )
			{
				delete models[ model.name ];
			}
		}
		
		
		public function retrieve( name:String ):IModel
		{
			if ( models[ name ] )
			{
				return models[ name ];
			}
			return null;
		}

	}
}