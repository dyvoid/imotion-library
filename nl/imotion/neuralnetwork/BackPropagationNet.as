package nl.imotion.neuralnetwork 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	import nl.imotion.neuralnetwork.components.*;
	import nl.imotion.neuralnetwork.events.NeuralNetworkEvent;
	import nl.imotion.neuralnetwork.training.*;
	import nl.imotion.utils.fpsmeter.FPSMeter;
	
	/**
	 * @author Pieter van de Sluis
	 */
	 
	[Event(name="NeuralNetworkEvent::trainingEpochComplete", type="nl.imotion.neuralnetwork.events.NeuralNetworkEvent")]
	[Event(name="NeuralNetworkEvent::trainingComplete", type="nl.imotion.neuralnetwork.events.NeuralNetworkEvent")]
	
	public class BackPropagationNet extends EventDispatcher implements IEventDispatcher
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _layerMap			:/*Layer*/Array;
		
		private var _currExercise		:Exercise;
		private var _currTrainingResult	:TrainingResult;
		
		private var _error  			:Number = 1;
		
		private var _learningRate		:Number;
		private var _momentum			:Number;
		
		private var _trainingPriority	:Number;
		
		private var _fpsMeter			:FPSMeter;
		private var _enterFrameClip		:Sprite;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function BackPropagationNet( trainingPriority:Number = 1, learningRate:Number = 0.25, momentum:Number = 0.5 ) 
		{
			this.trainingPriority	= trainingPriority;
			this.learningRate		= learningRate;
			this.momentum			= momentum;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function create( nrOfInputNeurons:uint, nrOfOutputNeurons:uint, nrOfHiddenLayers:uint = 0, nrOfNeuronsPerHiddenLayer:uint = 0 ):void
		{
			_layerMap = [];
			
			//Build input layer
			_layerMap[ 0 ] = new Layer( nrOfInputNeurons );
			
			//Build hidden layers
			var layerNr:uint = 1;
			for ( var i:int = 0; i < nrOfHiddenLayers; i++ ) 
			{
				_layerMap[ layerNr++ ] = new Layer( nrOfNeuronsPerHiddenLayer, _layerMap[ i ] );
			}
			
			//Build output layer
			_layerMap[ layerNr ] = new Layer( nrOfOutputNeurons, _layerMap[ layerNr - 1 ] );
		}
		
		
		public function createFromXML( xml:XML ):void
		{
			try
			{
				var netXML:XML = xml.net[ 0 ];
				
				//Gather the base properties from the XML
				var nrOfInputNeurons:uint = netXML.layer[0].neuron.length();
				var nrOfOutputNeurons:uint = netXML.layer[ netXML.layer.length() - 1 ].neuron.length();
				var nrOfHiddenLayers:uint = netXML.layer.length() - 2;
				var nrOfNeuronsPerHiddenLayer:uint = ( nrOfHiddenLayers > 0 ) ? netXML.layer[1].neuron.length() : 0;
				
				//Create a Net based on these properties
				create( nrOfInputNeurons, nrOfOutputNeurons, nrOfHiddenLayers, nrOfNeuronsPerHiddenLayer );
				_error = Number( netXML.@error );
				this.learningRate = Number( netXML.@learningRate );
				this.trainingPriority = Number( netXML.@trainingPriority );
				this.momentum = Number( netXML.@momentum );
				
				//Loop through the XML and set the weights of the synapses
				for ( var i:int = 1; i < _layerMap.length; i++ ) 
				{
					var layer:Layer = _layerMap[ i ];
					var layerXML:XML = netXML.layer[ i ];
					
					for ( var j:int = 0; j < layer.neuronMap.length ; j++ ) 
					{
						var neuron:Neuron = layer.neuronMap[ j ];
						var neuronXML:XML = layerXML.neuron[ j ];
						
						for ( var k:int = 0; k < neuron.synapseMap.length; k++ ) 
						{
							var synapse:Synapse = neuron.synapseMap[ k ];
							var synapseXML:XML = neuronXML.synapse[ k ];
							
							synapse.weight = Number( synapseXML.@weight );
						}
					}
				}
			}
			catch ( e:Error )
			{
				throw new Error( "XML definition is invalid" );
			}
		}
		
		
		
		public function run( pattern:Array ):Array 
		{
			for ( var i:int = 0; i < _layerMap.length; i++ ) 
			{
				var layer:Layer = _layerMap[ i ] as Layer;
				
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
			_currTrainingResult = new TrainingResult( _error );
			
			if ( !_fpsMeter )
				_fpsMeter = new FPSMeter( false );
			_fpsMeter.startMeasure();
			
			if ( !_enterFrameClip )
				_enterFrameClip = new Sprite();
			_enterFrameClip.addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
		}
		
		
		public function stopTraining():TrainingResult 
		{
			_fpsMeter.stopMeasure();
			
			_enterFrameClip.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			
			var finalTrainingResult:TrainingResult = _currTrainingResult;
			_currTrainingResult = null;			
			
			return finalTrainingResult;
		}
		
		
		public function toXML():XML
		{
			var xml:XML = 
				<root>
					<net error={_error} learningRate={_learningRate} momentum={_momentum} trainingPriority={trainingPriority} />
				</root>;
			
			for ( var i:int = 0; i < _layerMap.length; i++ ) 
			{
				xml.net.appendChild( _layerMap[ i ].toXML() );
			}
			
			return xml;
		}
		
		
		public function getLayer( layerIndex:uint ):Layer
		{
			return _layerMap[ layerIndex ];
		}
		
		
		public function getLayerValues( layerIndex:uint ):Array
		{
			return _layerMap[ layerIndex ].getValues();
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get layerMap():/*Layer*/Array { return _layerMap; }
		
		public function get nrOfLayers():uint { return _layerMap.length; }
		
		public function get error():Number { return _error; }
		
		public function get learningRate():Number { return _learningRate; }
		public function set learningRate(value:Number):void 
		{
			_learningRate = Math.max( 0, Math.min( 1, value ) );
		}
		
		public function get momentum():Number { return _momentum; }
		public function set momentum(value:Number):void 
		{
			_momentum = Math.max( 0, Math.min( 1, value ) );
		}
		
		public function get trainingPriority():Number { return _trainingPriority; }
		public function set trainingPriority(value:Number):void 
		{
			_trainingPriority = Math.max( 0, Math.min( 1, value ) );
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		protected function doExercise( exercise:Exercise ):void
		{
			var startTime:uint = getTimer();			
			var trainingCycleTime:uint = int( _fpsMeter.timePerFrame * _trainingPriority );
			
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
					i = _layerMap.length - 1;
					for ( ; i > 0; i-- )
					{
						layer = _layerMap[ i ];
						
						if ( i == _layerMap.length - 1 )
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
							
							var nextLayer:Layer = _layerMap[ i + 1 ];
							
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
					for ( ; i < _layerMap.length; i++ ) 
					{
						layer = _layerMap[ i ];
						
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
				
				if ( ( exercise.maxEpochs > 0 && _currTrainingResult.epochs >= exercise.maxEpochs ) || _error <= exercise.maxError )
				{
					var trainingResult:TrainingResult = stopTraining();
					this.dispatchEvent( new NeuralNetworkEvent( NeuralNetworkEvent.TRAINING_COMPLETE, trainingResult ) );
					return;
				}
				else
				{
					this.dispatchEvent( new NeuralNetworkEvent( NeuralNetworkEvent.TRAINING_EPOCH_COMPLETE, _currTrainingResult ) );
				}
			} while ( ( getTimer() - startTime ) < trainingCycleTime );
		}
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		private function enterFrameHandler(e:Event):void 
		{
			doExercise( _currExercise );
		}
		
	}

}