package nl.imotion.neuralnetwork 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * @author Pieter van de Sluis
	 */
	public class BackPropagationNet
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		public var layerMap				:/*Layer*/Array = [];
		
		private var _currExercise		:Exercise;
		private var _fitness			:Number;
		private var _nrOfTrainingCycles	:uint;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function BackPropagationNet( nrOfInputNeurons:uint, nrOfOutputNeurons:uint, nrOfHiddenLayers:uint = 0, nrOfNeuronsPerHiddenLayer:uint = 0 ) 
		{
			//Build input layer
			layerMap[ 0 ] = new Layer( nrOfInputNeurons );
			
			//Build hidden layers
			var layerNr:uint = 1;
			for ( var i:int = 0; i < nrOfHiddenLayers; i++ ) 
			{
				layerMap[ layerNr ] = new Layer( nrOfNeuronsPerHiddenLayer, layerMap[ i ] );
				layerNr++;
			}
			
			//Build output layer
			layerMap[ layerNr ] = new Layer( nrOfOutputNeurons, layerMap[ layerNr - 1 ] );
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		/*public function addHiddenLayer( nrOfNeurons:uint ):Layer 
		{
			var layer = new Layer( nrOfOutputNeurons, layer );
			layerMap.push( layer );
			
			return null;
		}*/
		
		
		public function run( pattern:Array ):Array 
		{
			for ( var i:int = 0; i < layerMap.length; i++ ) 
			{
				var layer:Layer = layerMap[ i ] as Layer;
				
				if ( i == 0 )
				{
					layer.setValues( pattern );
				}
				else
				{
					var result:Array = layer.calcValues();
				}
			}
			
			return result;
		}
		
		
		public function startTraining( exercise:Exercise ):void 
		{
			_currExercise = exercise;
			_nrOfTrainingCycles = 0;
			_fitness = 0;
			
			resumeTraining();
		}
		
		
		public function stopTraining():void 
		{
			timer.removeEventListener( TimerEvent.TIMER, timerTickHandler );
			timer.reset();
		}
		
		
		public function resumeTraining():void
		{
			if ( _currExercise )
			{
				stopTraining();
				
				timer.addEventListener( TimerEvent.TIMER, timerTickHandler );
				//timer.start();
				
				doTrainingCycle( _currExercise );
			}
			else
			{
				throw new Error( "No exercise has been defined yet." );
			}
		}
		
		
		public function toXML():XML
		{
			return null;
		}
		
		
		public function parseXML( xml:XML ):void
		{
			
		}
		
		
		public function getLayer( layerIndex:uint ):Layer
		{
			return layerMap[ layerIndex ];
		}
		
		
		public function getLayerValues( layerIndex:uint ):Array
		{
			return layerMap[ layerIndex ].getValues();
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		private var _timer:Timer;
		private function get timer():Timer
		{
			if ( !_timer )
				_timer = new Timer( 100 );
				
			return _timer;
		}
		
		public function get nrOfLayers():uint { return layerMap.length; }
		
		public function get fitness():Number { return _fitness; }
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		protected function doTrainingCycle( exercise:Exercise ):void
		{
			_nrOfTrainingCycles++;
			
			var result:Array = run( exercise.inputPattern );
			var error:Number = exercise.outputPattern[ 0 ] - result[ 0 ];
			
			for ( var i:int = layerMap.length - 1; i > 0; i-- ) 
			{
				for ( var j:int = 0; j < layerMap[ i ].neuronMap.length; j++ ) 
				{
					layerMap[ i ].neuronMap[ j ].updateWeights( error );
				}
			}
		}
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		private function timerTickHandler(e:TimerEvent):void 
		{
			doTrainingCycle( _currExercise );
		}
		
	}

}