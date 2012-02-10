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

package test.neuralnetwork
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import nl.imotion.display.EventManagedSprite;
    import nl.imotion.neuralnetwork.BackPropagationNet;
    import nl.imotion.neuralnetwork.events.NeuralNetworkEvent;
    import nl.imotion.neuralnetwork.training.Exercise;
    import nl.imotion.neuralnetwork.training.TrainingState;
    import nl.imotion.utils.fpsmeter.FPSMeter;

    import test.burst.components.Box;


    /**
     * @author Pieter van de Sluis
     */
    public class Main extends EventManagedSprite
    {
        private var net:BackPropagationNet;
        private var pattern1:Array;
        private var output1:Array;
        private var pattern2:Array;
        private var pattern3:Array;
        private var pattern4:Array;
        private var output2:Array;
        private var output3:Array;
        private var output4:Array;

        private var tf:TextField;
        private var exercise:Exercise;


        public function Main():void
        {
            if ( stage ) init();
            else addEventListener( Event.ADDED_TO_STAGE, init );
        }


        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, init );

            testXOR()
        }


        private function testXOR():void
        {
            createInterface();

            pattern1 = [ 1, 1 ];
            output1 = [ 0 ];

            pattern2 = [ 0, 1 ];
            output2 = [ 1 ];

            pattern3 = [ 1, 0 ];
            output3 = [ 1 ];

            pattern4 = [ 1, 1 ];
            output4 = [ 0 ];

            net = new BackPropagationNet( 0.6, 0.9 );
            net.fps = stage.frameRate;
            net.create( 2, 1, 1, 10 );
            net.addEventListener( NeuralNetworkEvent.TRAINING_EPOCH_COMPLETE, trainingEpochCompleteHandler );
            net.addEventListener( NeuralNetworkEvent.TRAINING_COMPLETE, trainingCompleteHandler );

            exercise = new Exercise( 0, 0.000001 );
            exercise.addPatterns( pattern1, output1 );
            exercise.addPatterns( pattern2, output2 );
            exercise.addPatterns( pattern3, output3 );
            exercise.addPatterns( pattern4, output4 );

            net.startTraining( exercise );
        }


        private function createInterface():void
        {
            var c:Box = this.addChild( new Box() ) as Box;
            c.addEventListener( MouseEvent.CLICK, boxClickHandler );
            c.x = 350;
            c.y = 10;
            this.addChild( c );

            this.addChild( tf = new TextField() );
            tf.x = 20;
            tf.y = 20;
            tf.width = 300;
            tf.height = 300;
        }


        private function boxClickHandler( e:MouseEvent ):void
        {
            trace( "net.trainingState : " + net.trainingState );
            if ( net.trainingState == TrainingState.STARTED )
            {
                net.pauseTraining();
            } else if ( net.trainingState == TrainingState.PAUSED )
            {
                net.resumeTraining();
            }
        }


        private function enterFrameHandler( e:Event ):void
        {
            //trace( fps.fps );
        }


        private function trainingEpochCompleteHandler( e:NeuralNetworkEvent ):void
        {
            tf.text = "currerror:" + e.trainingResult.endError + "\nlearningRate:" + net.learningRate + "\nnrOfTrainingEpochs:" + e.trainingResult.epochs;
        }


        private function trainingCompleteHandler( e:NeuralNetworkEvent ):void
        {
            trace( "RESULT ORG NET::::" + net.error + "::" + e.trainingResult.errorChange );
            trace( "Pattern1:" + net.run( pattern1 ) );
            trace( "Pattern2:" + net.run( pattern2 ) );
            trace( "Pattern3:" + net.run( pattern3 ) );
            trace( "Pattern4:" + net.run( pattern4 ) );
            trace( "Training Time:" + e.trainingResult.trainingTime )
            trace( "---" );

            var xml:XML = net.toXML();
            net.createFromXML( xml );

            trace( "RESULT NEW NET::::" + net.error );
            trace( "Pattern1:" + net.run( pattern1 ) );
            trace( "Pattern2:" + net.run( pattern2 ) );
            trace( "Pattern3:" + net.run( pattern3 ) );
            trace( "Pattern4:" + net.run( pattern4 ) );
            trace( "---" );

            exercise.maxError = exercise.maxError * 0.1;
            exercise.reset();
            //net.startTraining( exercise );
        }

    }

}