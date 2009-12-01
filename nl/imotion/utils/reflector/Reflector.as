package nl.imotion.utils.reflector
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	/**
	 * @author Pieter van de Sluis
	 */
	public class Reflector
	{
		
		public static function reflectProperties( target:*, accessType:String = null ):Array
		{
			var xml:XML = describeType( target );
			
			var result:Array = [];
			
			switch( accessType )
			{
				case AccessType.READ: case AccessType.READ_ONLY:
					result = result.concat( getPropDefs( xml.accessor.( @access == AccessType.READ_ONLY ) ) );
				break;
				
				case AccessType.WRITE: case AccessType.WRITE_ONLY:
					result = result.concat( getPropDefs( xml.accessor.( @access == AccessType.WRITE_ONLY ) ) );
				break;
			}
			
			switch( accessType )
			{
				case AccessType.READ: case AccessType.WRITE: case AccessType.READ_WRITE:
					result = result.concat( getPropDefs( xml.accessor.( @access == AccessType.READ_WRITE ) ) );
				break;
				
				case null:
					result = result.concat( getPropDefs( xml.accessor ) );
				break;
			}
			
			if ( accessType != AccessType.READ_ONLY && accessType != AccessType.WRITE_ONLY )
			{
				result = result.concat( getPropDefs( xml.variable ) );
			}
			
			return result;
		}
		
		
		private static function getPropDefs( xmlList:XMLList ):Array
		{
			var result:Array = [];
			
			for each ( var node:XML in xmlList ) 
			{
				result[ result.length ] = new PropertyDefinition( node.@name, Class( getDefinitionByName( node.@type ) ), node.@access || AccessType.READ_WRITE );
			}
			
			return result;
		}
		
		
	}

}