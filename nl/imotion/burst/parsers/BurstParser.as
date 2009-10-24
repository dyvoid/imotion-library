package nl.imotion.burst.parsers 
{
	import adobe.utils.CustomActions;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import nl.imotion.burst.Burst;
	
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class BurstParser implements IBurstParser
	{
		private var xmlMappings:Dictionary 	= new Dictionary();
		
		
		public function create( xml:XML, burst:Burst = null ):DisplayObject
		{
			throw new Error( "create method should be overridden in subclass." );
		}
		
		
		protected function parseChildren( target:DisplayObjectContainer, children:XMLList, burst:Burst ):void
		{
			if ( !burst )
			{
				throw new Error( "Cannot parse children without a valid Burst instance" );
			}
			
			for each ( var node:XML in children )
			{
				const d:DisplayObject = burst.parse( node );
				
				if ( d )
				{
					target.addChild( d );
				}
			}
		}
		
		
		protected function addAttributeMapping( attributeName:String, targetClass:Class, defaultValue:String = null, allowedValues:/*String*/Array = null ):void
		{
			const mapping:BurstXMLMapping = xmlMappings [ attributeName ];
			
			if ( mapping && mapping.type == BurstXMLMappingType.NODE )
			{
				throw new Error( "Mapping already exists for node type." );
			}
			
			xmlMappings[ attributeName ] = new BurstXMLMapping( BurstXMLMappingType.ATTRIBUTE, attributeName, targetClass, defaultValue, allowedValues );
		}
		
		
		protected function removeAttributeMapping( attributeName:String ):Boolean
		{
			if ( xmlMappings[ attributeName ] )
			{
				delete xmlMappings[ attributeName ];
				return true;
			}
			return false;
		}
		
		
		protected function addNodeMapping( nodeName:String, targetClass:Class, defaultValue:String = null, allowedValues:/*String*/Array = null ):void
		{
			const mapping:BurstXMLMapping = xmlMappings [ nodeName ];
			
			if ( mapping && mapping.type == BurstXMLMappingType.ATTRIBUTE )
			{
				throw new Error( "Mapping already exists for attribute type." );
			}
			
			xmlMappings[ nodeName ] = new BurstXMLMapping( BurstXMLMappingType.NODE, nodeName, targetClass, defaultValue, allowedValues );
		}
		
		
		protected function removeNodeMapping( nodeName:String ):Boolean
		{
			if ( xmlMappings[ nodeName ] )
			{
				delete xmlMappings[ nodeName ];
				return true;
			}
			return false;
		}
		
		
		protected function applyMappings( target:DisplayObject, xml:XML ):void
		{
			for ( var name:String in xmlMappings ) 
			{
				applyMapping( xml, target, xmlMappings[ name ] as BurstXMLMapping );
			}
		}
		
		
		private function applyMapping( xml:XML, target:DisplayObject, mapping:BurstXMLMapping ):void
		{
			var value:* = getMappedValue( mapping.itemName, xml );
			
			if ( value != null )
			{
				applyValue( target, mapping.itemName, value );
			}
		}
		
		
		protected function getMappedValue( name:String, xml:XML ):*
		{
			var mapping:BurstXMLMapping = xmlMappings[ name ];
			
			if ( mapping )
			{
				var value:*;
				
				switch ( mapping.type )
				{
					case BurstXMLMappingType.ATTRIBUTE:
						value = getValue( xml.attribute( mapping.itemName ), mapping );
					break;
					
					case BurstXMLMappingType.NODE:
						value = getValue( xml.child( mapping.itemName ).toString(), mapping );
					break;
				}
				
				if ( value )
				{
					var resultValue:*
					
					switch ( mapping.targetClass )
					{
						case uint: case int:
							resultValue = parseInt( value );
							if ( !isNaN ( resultValue ) )
								return resultValue;
						break;
						
						case Number:
							resultValue = parseFloat( value );
							if ( !isNaN ( resultValue ) )
								return resultValue;
						break;
						
						case String:
							return value;
						return;
						
						case Boolean:
							 return ( value == "true" )
						return;
						
						default:
							return null;
					}
					
					return null;
				}
				else
				{
					return null;
				}
			}
			else
			{
				return null;
			}
		}
		
		
		private function getValue( value:String, mapping:BurstXMLMapping ):String
		{
			if ( !value )
			{ 
				if ( mapping.defaultValue )
				{
					return mapping.defaultValue;
				}
				else
				{
					return null;
				}
			}
			
			if ( mapping.allowedValues && mapping.allowedValues.indexOf( value ) == -1 )
			{
				return mapping.defaultValue;
			}
			
			return value;
		}

		
		
		private function applyValue( target:DisplayObject, propertyName:String, value:* ):void
		{
			try { target[ propertyName ] = value; }
			catch ( e:Error ) { return; }
		}
		
	}

}