 /*
 * Licensed under the MIT license
 *
 * Copyright (c) 2010 Pieter van de Sluis
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * http://code.google.com/p/imotionproductions/
 */

package nl.imotion.neuralnetwork
{
    import flash.display.Sprite;
    import flash.events.*;
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

        private var _layers				:/*Layer*/Array = [];

        private var _currExercise		:Exercise;
        private var _currTrainingResult	:TrainingResult;

        private var _error  			:Number = 1;

        private var _learningRate		:Number;
        private var _momentumRate		:Number;
        private var _jitterEpoch		:uint;

        private var _trainingPriority	:Number;
        private var _trainingState		:String;

        private var _fpsMeter			:FPSMeter;
        private var _enterFrameClip		:Sprite;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function BackPropagationNet( trainingPriority:Number = 1, learningRate:Number = 0.25, momentumRate:Number = 0.5, jitterEpoch:uint = 1000 )
        {
            this.trainingPriority	= trainingPriority;
            this.learningRate		= learningRate;
            this.momentumRate	    = momentumRate;
            this.jitterEpoch        = jitterEpoch;

            _trainingState			= TrainingState.STOPPED;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function create( nrOfInputNeurons:uint, nrOfOutputNeurons:uint, nrOfHiddenLayers:uint = 0, nrOfNeuronsPerHiddenLayer:uint = 0 ):void
        {
            if ( nrOfInputNeurons == 0 )
                throw new Error( "Cannot create a BackPropagationNet with less than 1 input neuron" );

            if ( nrOfOutputNeurons == 0 )
                throw new Error( "Cannot create a BackPropagationNet with less than 1 output neuron" );

            _layers = [];

            //Build input layer
            _layers[ 0 ] = new Layer( nrOfInputNeurons );

            //Build hidden layers
            var layerNr:uint = 1;
            for ( var i:int = 0; i < nrOfHiddenLayers; i++ )
            {
                _layers[ layerNr++ ] = new Layer( nrOfNeuronsPerHiddenLayer, _layers[ i ] );
            }

            //Build output layer
            _layers[ layerNr ] = new Layer( nrOfOutputNeurons, _layers[ layerNr - 1 ] );
        }


        public function createFromXML( xml:XML ):void
        {
            try
            {
                var netXML:XML = xml.net[ 0 ];
                var layers:XMLList = netXML.layer;

                //Gather the base properties from the XML
                var nrOfInputNeurons:uint = layers[0].neuron.length();
                var nrOfOutputNeurons:uint = layers[ layers.length() - 1 ].neuron.length();
                var nrOfHiddenLayers:uint = layers.length() - 2;
                var nrOfNeuronsPerHiddenLayer:uint = ( nrOfHiddenLayers > 0 ) ? layers[1].neuron.length() : 0;

                //Create a Net with random weights based on these properties
                create( nrOfInputNeurons, nrOfOutputNeurons, nrOfHiddenLayers, nrOfNeuronsPerHiddenLayer );
                _error = Number( netXML.@error );
                this.learningRate = Number( netXML.@learningRate );
                this.trainingPriority = Number( netXML.@trainingPriority );
                this.momentumRate = Number( netXML.@momentumRate );
                this.jitterEpoch = Number( netXML.@jitterEpoch );

                //Loop through the XML and set the weights of the synapses
                for ( var i:int = 1; i < _layers.length; i++ )
                {
                    var layer:Layer = _layers[ i ];
                    var layerXML:XML = layers[ i ];

                    for ( var j:int = 0; j < layer.neurons.length ; j++ )
                    {
                        var neuron:Neuron = layer.neurons[ j ];
                        var neuronXML:XML = layerXML.neuron[ j ];

                        for ( var k:int = 0; k < neuron.synapses.length; k++ )
                        {
                            var synapse:Synapse = neuron.synapses[ k ];
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
            for ( var i:int = 0; i < _layers.length; i++ )
            {
                var layer:Layer = _layers[ i ] as Layer;

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
            if ( !_layers || _layers.length == 0 )
                throw new Error( "Valid neural network for training has not yet been created" );

            if ( _trainingState == TrainingState.STARTED || _trainingState == TrainingState.PAUSED )
            {
                stopTraining();
            }

            _trainingState = TrainingState.STARTED;

            _currExercise = exercise;
            _currTrainingResult = new TrainingResult( _error );

            toggleTraining( true );
        }


        public function pauseTraining():void
        {
            if ( _trainingState == TrainingState.STARTED )
            {
                toggleTraining( false );
                _trainingState = TrainingState.PAUSED;
            }
        }


        public function resumeTraining():void
        {
            if ( _trainingState == TrainingState.PAUSED )
            {
                toggleTraining( true );
                _trainingState = TrainingState.STARTED;
            }
        }


        public function stopTraining():TrainingResult
        {
            if ( _trainingState == TrainingState.STARTED || _trainingState == TrainingState.PAUSED )
            {
                if ( _trainingState == TrainingState.STARTED )
                {
                    toggleTraining( false );
                }

                var finalTrainingResult:TrainingResult = _currTrainingResult;
                _currTrainingResult = null;
                _currExercise = null;

                _trainingState = TrainingState.STOPPED;

                return finalTrainingResult;
            }
            return null;
        }


        public function toXML():XML
        {
            var xml:XML =
                <root>
                    <net error={_error} learningRate={_learningRate} momentumRate={_momentumRate} trainingPriority={trainingPriority} jitterEpoch={jitterEpoch} />
                </root>;

            for ( var i:int = 0; i < _layers.length; i++ )
            {
                xml.net.appendChild( _layers[ i ].toXML() );
            }

            return xml;
        }


        public function reset():void
        {
            stopTraining();

            _layers = [];

            _error				= 1;
            _trainingPriority 	= 1;
            _learningRate		= 0.25;
            _momentumRate 	    = 0.5;
            _jitterEpoch        = 1000;

            _fpsMeter 		= null;
            _enterFrameClip = null;
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get layers():/*Layer*/Array { return _layers; }

        public function get nrOfNeuronsPerHiddenLayer():uint
        {
            if ( _layers.length > 2 )
            {
                return _layers[ 1 ].neurons.length;
            }
            return 0;
        }

        public function get nrOfHiddenLayers():uint
        {
            if ( _layers.length > 2 )
            {
                return _layers.length - 2;
            }
            return 0;
        }

        public function get nrOfOutputNeurons():uint
        {
            if ( _layers.length > 0 )
            {
                return _layers[ _layers.length - 1 ].neurons.length;
            }
            return 0;
        }

        public function get nrOfInputNeurons():uint
        {
            if ( _layers.length > 0 )
            {
                return _layers[ 0 ].neurons.length;
            }
            return 0;
        }

        public function get nrOfLayers():uint { return _layers.length; }

        public function get error():Number { return _error; }

        public function get trainingState():String { return _trainingState; }

        public function get learningRate():Number { return _learningRate; }
        public function set learningRate(value:Number):void
        {
            _learningRate = Math.max( 0, Math.min( 1, value ) );
        }

        public function get momentumRate():Number { return _momentumRate; }
        public function set momentumRate(value:Number):void
        {
            _momentumRate = Math.max( 0, Math.min( 1, value ) );
        }

        public function get trainingPriority():Number { return _trainingPriority; }
        public function set trainingPriority(value:Number):void
        {
            _trainingPriority = Math.max( 0, Math.min( 1, value ) );
        }

        public function get jitterEpoch():uint { return _jitterEpoch; }
        public function set jitterEpoch( value:uint ):void
        {
            _jitterEpoch = value;
        }

        private function get fpsMeter():FPSMeter
        {
            if ( !_fpsMeter )
                _fpsMeter = new FPSMeter();

            return _fpsMeter;
        }

        private function get enterFrameClip():Sprite
        {
            if ( !_enterFrameClip )
                _enterFrameClip = new Sprite();

            return _enterFrameClip;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED

        protected function doExercise( exercise:Exercise ):void
        {
            var trainingCycleTime:uint = int( fpsMeter.timePerFrame * _trainingPriority );
            var startTime:uint = getTimer();

            do
            {
                //Apply jitter if the jitterEpoch is reached
                var jitter:Number = 0;
                if ( jitterEpoch != 0 && _currTrainingResult.epochs != 0 && _currTrainingResult.epochs % _jitterEpoch == 0 )
                {
                    jitter = Math.random() * 0.02 - 0.01;
                }

                while ( exercise.hasNext() )
                {
                    //Init vars that will be used for fast, optimized iterators
                    var i:int = 0;
                    var iIterTarget:int = 0;
                    var j:int = 0;
                    var jIterTarget:int = 0;
                    var k:int = 0;
                    var kIterTarget:int = 0;

                    //Grab next exercise patterns
                    var patterns:ExercisePatterns = exercise.next();

                    //Run the neural network, using the exercise patterns
                    var result:Array = run( patterns.inputPattern );
                    _error = 0;

                    var layer:Layer;

                    //Calculate errors
                    i = _layers.length - 1;
                    for ( ; i > 0; i-- )
                    {
                        layer = _layers[ i ];

                        if ( i == _layers.length - 1 )
                        {
                            //First calculate errors for output layers

                            j = 0;
                            jIterTarget = layer.neurons.length;
                            for ( ; j < jIterTarget; j++ )
                            {
                                var resultVal:Number = result[ j ];
                                var targetVal:Number = patterns.targetPattern[ j ];
                                var delta:Number = ( targetVal - resultVal );

                                layer.neurons[ j ].error = delta * resultVal * ( 1 - resultVal );
                                _error += delta * delta;
                            }
                        }
                        else
                        {
                            //Calculate errors for hidden layers

                            var nextLayer:Layer = _layers[ i + 1 ];

                            j = 0;
                            jIterTarget = layer.neurons.length;
                            for ( ; j < jIterTarget; j++ )
                            {
                                var sum:Number = 0;

                                k = 0;
                                kIterTarget = nextLayer.neurons.length;
                                for ( ; k < kIterTarget; k++ )
                                {
                                    sum += nextLayer.neurons[ k ].error * nextLayer.neurons[ k ].synapses[ j ].weight;
                                }
                                var neuronValue:Number = layer.neurons[ j ].value;
                                layer.neurons[ j ].error = neuronValue * ( 1 - neuronValue ) * sum;
                            }
                        }
                    }

                    //Update all weights

                    i = 1;
                    iIterTarget = _layers.length;
                    for ( ; i < iIterTarget; i++ )
                    {
                        layer = _layers[ i ];

                        j = 0;
                        jIterTarget = layer.neurons.length;
                        for ( ; j < jIterTarget; j++ )
                        {
                            k = 0;
                            kIterTarget = layer.neurons[ j ].synapses.length;
                            for ( ; k < kIterTarget; k++ )
                            {
                                var synapse:Synapse = layer.neurons[ j ].synapses[ k ];

                                var weightChange:Number = ( _learningRate * synapse.endNeuron.error * synapse.startNeuron.value ) + synapse.momentum;
                                synapse.momentum = weightChange * _momentumRate;
                                synapse.weight += weightChange + jitter;
                            }
                        }
                    }

                    //Reset jitter. If it was set it only needed to be applied once this epoch
                    jitter = 0;
                }

                var trainingTime:uint = getTimer() - startTime;

                exercise.reset();

                _currTrainingResult.epochs++;
                _currTrainingResult.endError = _error;

                this.dispatchEvent( new NeuralNetworkEvent( NeuralNetworkEvent.TRAINING_EPOCH_COMPLETE, _currTrainingResult ) );

                if ( ( exercise.maxEpochs > 0 && _currTrainingResult.epochs >= exercise.maxEpochs ) || _error <= exercise.maxError )
                {
                    var trainingResult:TrainingResult = stopTraining();
                    trainingResult.trainingTime += trainingTime;
                    this.dispatchEvent( new NeuralNetworkEvent( NeuralNetworkEvent.TRAINING_COMPLETE, trainingResult ) );
                    return;
                }
            } while ( !exercise.useAsync || trainingTime < trainingCycleTime );

            _currTrainingResult.trainingTime += trainingTime;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function toggleTraining( isTraining:Boolean ):void
        {
            var hasListener:Boolean = enterFrameClip.hasEventListener( Event.ENTER_FRAME );

            if ( isTraining )
            {
                fpsMeter.startMeasure( false );
                if ( !hasListener )
                    enterFrameClip.addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
            }
            else
            {
                fpsMeter.stopMeasure();
                if ( hasListener )
                    enterFrameClip.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
            }
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function enterFrameHandler( e:Event ):void
        {
            if ( _trainingState == TrainingState.STARTED )
            {
                doExercise( _currExercise );
            }
            else
            {
                enterFrameClip.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
            }

        }
        
    }

}