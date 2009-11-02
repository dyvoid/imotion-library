package nl.imotion.burst.parsers 
{
	/**
	 * ...
	 * @author Pieter van de Sluis
	 */
	public class ParserPool
	{
		
		protected var pool	:Array = [];
		
        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                        C O N S T R U C T O R     |
        //__________________________________________________________________________________________________________________|
        
		public function ParserPool() { }
		
        //__________________________________________________________________________________________________________________
        //                                                                                                                  |
        //                                                                                                  P U B L I C     |
        //__________________________________________________________________________________________________________________|
        
		public function getParser( parserClass:Class ):IBurstParser
        {
			var parser:IBurstParser = pool[ parserClass ];
			
			if ( !parser )
			{
				parser = new parserClass();
				
				if ( parser is IBurstParser )
				{
					pool[ parserClass ] = parser;
				}
				else
				{
					throw new Error( "parserClass is not an IBurstParser");
				}
			}
			
			return parser;
        }
		
		
		public function purge():void
		{
			pool = [];
		}
		
		
		public function showInfo():void
		{
			trace( "Burst Parser Pool" );
			trace( "=================" );
			
			for ( var c:String in pool )
 			{
				trace( c + "::" + pool[ c ] );
			}
			
			trace( "=================" );
		}
		
	}

}