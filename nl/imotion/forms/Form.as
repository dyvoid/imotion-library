package nl.imotion.forms 
{
    import flash.display.InteractiveObject;
    import flash.utils.Dictionary;
	import nl.imotion.forms.validators.IValidator;
    import nl.imotion.utils.reflector.AccessType;
    import nl.imotion.utils.reflector.PropertyDefinition;
    import nl.imotion.utils.reflector.Reflector;

    
    public class Form implements IFormElement
    {
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
        private var _elements           :Dictionary = new Dictionary();
		private var _validators			:Array = [];
        
        private var _numElements        :uint = 0;
        private var _autoTabIndex       :Boolean = true;
        
        private var _valueObjectClass   :Class;
		
        // ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
        public function Form( valueObjectClass:Class = null, autoTabIndex:Boolean = true ) 
        {
            _valueObjectClass   = ( valueObjectClass ) ? valueObjectClass : Object;
            _autoTabIndex       = autoTabIndex;
        }
        
		// ____________________________________________________________________________________________________
		// PUBLIC

        public function registerElement( element:IFormElement, elementName:String ):IFormElement
		{
			_elements[ elementName ] = element;
            
            if ( _autoTabIndex && element is InteractiveObject )
                InteractiveObject( element ).tabIndex = _numElements;
                
			_numElements++;
            
            return element;
		}
        
        
        public function removeElement( elementName:String ):IFormElement
        {
            var element:IFormElement = retrieveElement( elementName );
			
			if ( element )
			{
				delete _elements[ elementName ];
                _numElements--;
				return element;
			}
			return null;
        }
        
        
        public function retrieveElement( elementName:String ):IFormElement
        {
            return _elements[ elementName ];
        }
        
		
		public function addValidator( validator:IValidator ):IValidator
		{
			_validators.push( validator );
			
			return validator;
		}
		
		
		public function removeValidator( validator:IValidator ):IValidator
		{
			for ( var i:int = _validators.length - 1; i >= 0; i-- ) 
			{
				if ( _validators[ i ] == validator )
				{
					return _validators.splice( i, 1 )[ 0 ];
				}
			}
			
			return;
		}
		
		
		public function validate():Boolean
        {
            var formIsValid:Boolean = true;
            
            for each ( var validator:IValidator in _validators ) 
            {
                if ( !validator.validate() && formIsValid )
                    formIsValid = false;
            }
            
            return formIsValid;
        }
		
        
        public function getValidElements():Array
        {
            return getElementsByValidState( true );
        }
        
        
        public function getInvalidElements():Array
        {
            return getElementsByValidState( false );
        }
        
        
        public function populate( object:Object ):Object
        {
            for ( var elementName:String in _elements ) 
            {
                try 
                {
                    object[ elementName ] = IFormElement( _elements[ elementName ] ).value;
                }
                catch ( e:Error )
                {
                    throw new Error( "Object property is incompatible with IFormElement value" ); 
                }
            }
            
            return object;
        }     
        
        
        public function destroy():void
        {
            _elements       = new Dictionary();
            _numElements    = 0;
        }
        
        
        // ____________________________________________________________________________________________________
		// GETTERS/SETTERS
		
        public function get value():*
        {
            var o:Object = populateObject( new _valueObjectClass() );
            
            return o;
        }
        
        public function set value( value:* ):void
        {
            var props:/*PropertyDefinition*/Array = Reflector.getProperties( value, AccessType.READ );
            
            for ( var i:int = 0; i < props.length; i++ ) 
            {
                var prop:PropertyDefinition = props[ i ] as PropertyDefinition;
                var element:IFormElement = IFormElement( _elements[ prop.name ] );
                
                if ( element )
                {
					try 
					{
						element.value = value[ prop.name ];
					}
					catch ( e:Error )
					{
						throw new Error( "IFormElement value is incompatible with Object property value" ); 
					}
                }
            }
        }
        
        
        public function get isValid():Boolean
        {
            for each ( var validator:IValidator in _validators ) 
            {
                if ( ! validator.isValid )
                    return false;
            }
            
            return true;
        }
        
        
        public function get numElements():uint { return _numElements; }
        
        public function get autoTabIndex():Boolean { return _autoTabIndex; }
        
        public function set autoTabIndex(value:Boolean):void 
        {
            _autoTabIndex = value;
        }
        
        public function get valueObjectClass():Class { return _valueObjectClass; }
        
        public function set valueObjectClass(value:Class):void 
        {
            _valueObjectClass = value;
        }
		
        // ____________________________________________________________________________________________________
		// PROTECTED
		
        protected function getElementsByValidState( validState:Boolean ):Array
        {
            var result:Array = [];
            
            for each ( var element:IFormElement in _elements ) 
            {
                if ( element.isValid == validState )
                    result[ result.length ] = element
            }
            
            return result;
        }
        
    }
	
}