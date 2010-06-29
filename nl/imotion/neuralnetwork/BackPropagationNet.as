package nl.imotion.neuralnetwork 
{
	import flash.events.Event;
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
		private var _currTrainingResult	:TrainingResult;
		
		private var _error  			:Number = 1;
		
		private var _learningRate		:Number = 0.25;
		private var _momentum			:Number = 0.5;
		
		private var _trainingPriority	:Number;
		private var _trainingCycleTime	:uint;
		private var _trainingCycleDelay	:uint;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function BackPropagationNet( nrOfInputNeurons:uint, nrOfOutputNeurons:uint, nrOfHiddenLayers:uint = 0, nrOfNeuronsPerHiddenLayer:uint = 0 ) 
		{
			init( nrOfInputNeurons, nrOfOutputNeurons, nrOfHiddenLayers, nrOfNeuronsPerHiddenLayer );
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
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
			_currTrainingResult = new TrainingResult();
			
			doExercise( _currExercise );
		}
		
		
		public function stopTraining():TrainingResult 
		{
			timer.reset();
			
			var finalTrainingResult:TrainingResult = _currTrainingResult;
			_currTrainingResult = null;
			
			return finalTrainingResult;
		}
		
		
		public function toXML():XML
		{
			var xml:XML = new XML();
			
			for ( var i:int = 0; i < layerMap.length; i++ ) 
			{
				var currXML:XML = xml.appendChild( <layer /> );
				
				for ( var j:int = 0; j <  layerMap[ i ].neuronMap.length ; j++ ) 
				{
					currXML.appendChild( <neuron /> );
				}
			}
			
			return xml;
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
				_timer = new Timer( 1, 1 );
				_timer.addEventListener( TimerEvent.TIMER, timerTickHandler, false, 0, true );
				
			return _timer;
		}
		
		public function get nrOfLayers():uint { return layerMap.length; }
		
		public function get error():Number { return _error; }
		
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
		
		public function get trainingPriority():Number { return _trainingPriority; }
		public function set trainingPriority(value:Number):void 
		{
			_trainingPriority   = Math.max( 0, Math.min( 1, value ) );
			_trainingCycleTime  = Math.round( 1000 * _trainingPriority );
			_trainingCycleDelay = 1000 - _trainingCycleTime + 1;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		protected function doExercise( exercise:Exercise ):void
		{
			var startTime:uint = getTimer();
			var timeSpend:uint;
			
			do
			{
				while ( exercise.hasNext() )
				{
					var i:int = 0;
					var j:int = 0;
					var k:int = 0;
					
					var e:ExercisePatterns = exercise.next();
					
					var result:Array = run( e.inputPattern );
					_error = 0;
					
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
								_error += delta * delta;
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
				
				exercise.reset();
				
				_currTrainingResult.epochs++;
				_currTrainingResult.endError = _error;
				
				if ( _currTrainingResult.epochs == 1 )
				{
					_currTrainingResult.startError = _error;
				}
				
				if ( ( exercise.maxEpochs > 0 && _currTrainingResult.epochs >= exercise.maxEpochs ) || _error <= exercise.maxError )
				{
					this.dispatchEvent( new NeuralNetworkEvent( NeuralNetworkEvent.TRAINING_COMPLETE, _currTrainingResult ) );
					stopTraining();
					return;
				}
				else
				{
					this.dispatchEvent( new NeuralNetworkEvent( NeuralNetworkEvent.TRAINING_EPOCH_COMPLETE, _currTrainingResult ) );
				}
			
			} while ( ( getTimer() - startTime ) < _trainingCycleTime );
			
			timer.delay = _trainingCycleDelay;
			timer.reset();
			timer.start();
		}
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		public function init( nrOfInputNeurons:uint, nrOfOutputNeurons:uint, nrOfHiddenLayers:uint, nrOfNeuronsPerHiddenLayer:uint ):void
		{
			//Build input layer
			layerMap[ 0 ] = new Layer( nrOfInputNeurons );
			
			//Build hidden layers
			var layerNr:uint = 1;
			for ( var i:int = 0; i < nrOfHiddenLayers; i++ ) 
			{
				layerMap[ layerNr++ ] = new Layer( nrOfNeuronsPerHiddenLayer, layerMap[ i ] );
			}
			
			//Build output layer
			layerMap[ layerNr ] = new Layer( nrOfOutputNeurons, layerMap[ layerNr - 1 ] );
			
			trainingPriority = 0.8;
		}
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		private function timerTickHandler( e:TimerEvent ):void 
		{
			doExercise( _currExercise );
		}
		
	}

}