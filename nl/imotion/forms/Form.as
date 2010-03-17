package nl.imotion.forms 
{
    import flash.display.InteractiveObject;
    import flash.utils.Dictionary;
	import nl.imotion.forms.validators.IValidator;
	import nl.imotion.forms.validators.ValidatorGroup;
    import nl.imotion.utils.reflector.AccessType;
    import nl.imotion.utils.reflector.PropertyDefinition;
    import nl.imotion.utils.reflector.Reflector;

    
    public class Form implements IFormElement
    {
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
        private var _elements           :Dictionary 		= new Dictionary();
		private var _validators			:ValidatorGroup		= new ValidatorGroup();
        
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
			return _validators.addValidator( validator );
		}
		
		
		public function removeValidator( validator:IValidator ):IValidator
		{
			return _validators.removeValidator( validator );
		}
		
		
		public function validate():Boolean
        {
            var formIsValid:Boolean = true;
            
            for each ( var element:IFormElement in _elements )
            {				
                if ( !element.validate() && formIsValid )
                    formIsValid = false;
            }
            
			if ( formIsValid )
				formIsValid = _validators.isValid;
			
            return formIsValid;
        }
		
        
        public function getValidElements():/*IFormElement*/Array
        {
            return getElementsByValidState( true );
        }
        
        
        public function getInvalidElements():/*IFormElement*/Array
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
			_validators		= new ValidatorGroup();
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
            for each ( var element:IFormElement in _elements )
            {				
                if ( !element.isValid )
                    return false;
            }
			
            return _validators.isValid;
        }
        
		
		public function get errors():/*String*/Array
		{
			var errors:/*String*/Array = [];
			
			for each ( var element:IFormElement in _elements )
			{
				if ( !element.isValid )
					errors.concat( element.errors );
			}
			
			errors.concat( _validators.errors );
			
			return errors;
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
		
        protected function getElementsByValidState( validState:Boolean ):/*IFormElement*/Array
        {
            var result:/*IFormElement*/Array = [];
            
            for each ( var element:IFormElement in _elements ) 
            {
                if ( element.isValid == validState )
                    result[ result.length ] = element
            }
            
            return result;
        }
        
    }
	
}