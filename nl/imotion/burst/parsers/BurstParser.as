﻿package nl.imotion.burst.parsers 
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
		
		
		public function create( xml:XML, burst:Burst = null, targetClass:Class = null ):DisplayObject
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
				if ( burst.hasBinding( node.name() ) )
				{
					var parsedChild:DisplayObject = burst.parse( node );
					
					if ( parsedChild )
					{
						target.addChild( parsedChild );
					}
				}
			}
		}
		
		
		protected function addAttributeMapping( attributeName:String, targetClass:Class, defaultValue:String = null, allowedValues:/*String*/Array = null ):void
		{
			var mapping:BurstXMLMapping = xmlMappings [ attributeName ];
			
			if ( defaultValue && allowedValues )
			{
				if ( allowedValues.indexOf( defaultValue ) == -1 )
				{
					throw new Error( "Default value does not match with allowed values.");
				}
			}
			
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
			var mapping:BurstXMLMapping = xmlMappings [ nodeName ];
			
			if ( defaultValue && allowedValues )
			{
				if ( allowedValues.indexOf( defaultValue ) == -1 )
				{
					throw new Error( "Default value does not match with allowed values.");
				}
			}
			
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
		
		
		protected function applyMappings( target:DisplayObject, xml:XML, ignoreList:/*String*/Array = null ):void
		{
			for each ( var mapping:BurstXMLMapping in xmlMappings ) 
			{
				if ( ignoreList == null || ignoreList.indexOf( mapping.itemName ) == -1 )
				{
					applyMapping( target, xml, mapping );
				}
			}
		}
		
		
		private function applyMapping( target:DisplayObject, xml:XML, mapping:BurstXMLMapping ):void
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
			if ( !value || !checkAllowedValue( value, mapping ) )
			{ 
				if ( mapping.defaultValue && checkAllowedValue( mapping.defaultValue, mapping ) )
				{
					return mapping.defaultValue;
				}
				else
				{
					return null;
				}
			}
			
			return value;
		}
		
		
		private function checkAllowedValue( value:String, mapping:BurstXMLMapping ):Boolean
		{
			if ( mapping.allowedValues )
			{
				return ( mapping.allowedValues.indexOf( value ) != -1 )
			}
			
			return true;			
		}
		
		
		private function applyValue( target:DisplayObject, propertyName:String, value:* ):void
		{
			try { target[ propertyName ] = value; }
			catch ( e:Error ) { return; }
		}
		
	}

}