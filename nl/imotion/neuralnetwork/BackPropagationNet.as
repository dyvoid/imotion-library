package nl.imotion.neuralnetwork 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import nl.imotion.neuralnetwork.events.NeuralNetworkEvent;
	/**
	 * @author Pieter van de Sluis
	 */	 
	public class BackPropagationNet extends EventDispatcher implements IEventDispatcher
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		public var layerMap				:/*Layer*/Array = [];
		
		private var _currExercise		:Exercise;
		private var _error  			:Number = 1;
		private var _nrOfTrainingCycles	:uint;
		
		private var _trainingFinished	:Boolean = false;
		
		private var _learningRate		:Number = 0.25;
		private var _momentum			:Number = 0.5; 
		
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
				_trainingFinished = false;
				
				stopTraining();
				
				timer.addEventListener( TimerEvent.TIMER, timerTickHandler );
				timer.start();
				
				/*var time:Number = getTimer();
				
				while ( getTimer() - time < 900 || _trainingFinished )
				{
					doTrainingCycle( _currExercise );
					trace( _nrOfTrainingCycles);
				}*/
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
				_timer = new Timer( 0 );
				
			return _timer;
		}
		
		public function get nrOfLayers():uint { return layerMap.length; }
		
		public function get error():Number { return _error; }
		
		public function get nrOfTrainingCycles():uint { return _nrOfTrainingCycles; }
		
		public function get learningRate():Number { return _learningRate; }
		public function set learningRate(value:Number):void 
		{
			_learningRate = value;
		}
		
		public function get momentum():Number { return _momentum; }
		public function set momentum(value:Number):void 
		{
			_momentum = value;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		protected function doTrainingCycle( exercise:Exercise ):void
		{
			_nrOfTrainingCycles++;
			
			while ( exercise.hasNext() )
			{
				var i:int = 0;
				var j:int = 0;
				var k:int = 0;
				
				var e:ExercisePatterns = exercise.next();
				
				var result:Array = run( e.inputPattern );
				var netError:Number = 0;
				
				var layer:Layer;
				
				//Calculate errors
				i = layerMap.length - 1;
				for ( ; i > 0; i-- )
				{
					layer = layerMap[ i ];
					
					if ( i == layerMap.length - 1 )
					{
						//First calculate errors for output layers
						j = 0;
						for ( ; j < layer.neuronMap.length; j++ ) 
						{
							var resultVal:Number = result[ j ];
							var targetVal:Number = e.targetPattern[ j ];
							var delta:Number = ( targetVal - resultVal );
							
							layer.neuronMap[ j ].error = delta * resultVal * ( 1 - resultVal );
							netError += delta * delta;
						}
					}
					else
					{
						//Calculate errors for hidden layers
						
						var nextLayer:Layer = layerMap[ i + 1 ];
						
						j = 0;
						for ( ; j < layer.neuronMap.length; j++ ) 
						{
							var sum:Number = 0;
							
							k = 0;
							for ( ; k < nextLayer.neuronMap.length; k++ ) 
							{
								sum += nextLayer.neuronMap[ k ].error * nextLayer.neuronMap[ k ].synapseMap[ j ].weight;
							}
							var neuronValue:Number = layer.neuronMap[ j ].value;
							layer.neuronMap[ j ].error = neuronValue * ( 1 - neuronValue ) * sum;
						}
					}
				}
				
				
				//Update all weights
				i = 1;
				for ( ; i < layerMap.length; i++ ) 
				{
					layer = layerMap[ i ];
					
					j = 0;
					for ( ; j < layer.neuronMap.length; j++ )
					{
						k = 0;
						for ( ; k < layer.neuronMap[ j ].synapseMap.length; k++ )
						{
							var synapse:Synapse = layer.neuronMap[ j ].synapseMap[ k ];
							
							var weightChange:Number = ( _learningRate * synapse.endNeuron.error * synapse.startNeuron.value ) + ( synapse.momentum * _momentum );
							synapse.momentum = weightChange;
							synapse.weight += weightChange;
						}
					}
				}				
			}
			
			_error = netError;
			exercise.reset();
			
			if ( ( exercise.maxCycles > 0 && _nrOfTrainingCycles >= exercise.maxCycles ) || _error <= exercise.maxError )
			{
				_trainingFinished = true
				stopTraining();
				this.dispatchEvent( new NeuralNetworkEvent( NeuralNetworkEvent.TRAINING_COMPLETE ) );
			}
		}
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		private function timerTickHandler(e:TimerEvent):void 
		{
			//trace( "timerTickHandler : " + nrOfTrainingCycles );
			doTrainingCycle( _currExercise );
		}
		
	}

}