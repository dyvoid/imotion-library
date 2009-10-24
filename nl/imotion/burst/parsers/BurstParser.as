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
		protected var attributeFilterMap:Dictionary = new Dictionary();
		protected var nodeFilterMap:Dictionary 		= new Dictionary();
		
		
		public function BurstParser() 
		{
			
		}
		
		
		public function create( xml:XML, burst:Burst ):DisplayObject
		{
			//override in subclass
			return null;
		}
		
		
		protected function parseChildren( target:DisplayObjectContainer, children:XMLList, burst:Burst ):void
		{
			for each ( var node:XML in children )
			{
				const d:DisplayObject = burst.parse( node );
				
				if ( d )
				{
					target.addChild( d );
				}
			}
		}
		
		
		protected function addAttributeFilter( attributeName:String, targetClass:Class ):void
		{
			attributeFilterMap[ attributeName ] = targetClass;
		}
		
		
		protected function addNodeFilter( nodeName:String, targetClass:Class ):void
		{
			nodeFilterMap[ nodeName ] = targetClass;
		}
		
		
		protected function processFilters( target:DisplayObject, xml:XML ):void
		{
			for ( var attributeName:String in attributeFilterMap ) 
			{
				processAttributeFilter( xml, target, attributeName, attributeFilterMap[ attributeName ] );
			}
			for ( var nodeName:String in nodeFilterMap ) 
			{
				processNodeFilter( xml, target, nodeName, nodeFilterMap[ nodeName ] );
			}
		}
		
		
		protected function processAttributeFilter( xml:XML, target:DisplayObject, attributeName:String, targetClass:Class ):void
		{
			const value:* = xml.attribute( attributeName );
			
			if ( value && value != undefined )
			{
				processValue( target, attributeName, value, targetClass );
			}
		}
		
		
		protected function processNodeFilter( xml:XML, target:DisplayObject, nodeName:String, targetClass:Class ):void
		{
			const value:* = xml.child( nodeName ).toString();
			
			if ( value && value != undefined )
			{
				processValue( target, nodeName, value, targetClass );
			}
		}
		
		
		private function processValue( target:DisplayObject, propertyName:String, value:String, targetClass:Class ):void
		{
			try { target[ propertyName ]; }
			catch ( e:Error ) { return; }

			switch ( targetClass )
			{
				case uint: case int:
					target[ propertyName ] = parseInt( value );
				return;
				
				case Number:
					target[ propertyName ] = parseFloat( value );
				return;
				
				case String:
					target[ propertyName ] = value;
				return;
				
				case Boolean:
					target[ propertyName ] = ( value == "true" )
				return;
			}
		}
	}

}