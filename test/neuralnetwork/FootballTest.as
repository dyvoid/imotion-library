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
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import nl.imotion.neuralnetwork.BackPropagationNet;
    import nl.imotion.neuralnetwork.events.NeuralNetworkEvent;
    import nl.imotion.neuralnetwork.training.Exercise;
    import nl.imotion.neuralnetwork.training.TrainingState;

    import test.burst.components.Box;


    /**
     * @author Pieter van de Sluis
     * Date: 4-sep-2010
     * Time: 10:57:41
     */

    [SWF(backgroundColor="#ffffff",width="624",height="500",frameRate="31")]
    public class FootballTest extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private const RODAJC:String = "0000";
        private const WILLEMII:String = "0001";
        private const PSV:String = "0010";
        private const TWENTE:String = "0011";
        private const AJAX:String = "0100";
        private const FEYENOORD:String = "0101";
        private const SPARTA:String = "0110";
        private const VOLENDAM:String = "0111";
        private const DEGRAAFSCHAP:String = "1000";
        private const HEERENVEEN:String = "1001";

        private var tf:TextField;

        private var net:BackPropagationNet;
        private var exercise:Exercise;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function FootballTest()
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

            test();
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function test():void
        {
            net = new BackPropagationNet( 0.5, 0.25, 1000 );
            net.fps = stage.frameRate;
            net.create( 12, 2, 2, 12 );
            net.addEventListener( NeuralNetworkEvent.TRAINING_EPOCH_COMPLETE, trainingEpochCompleteHandler );
            net.addEventListener( NeuralNetworkEvent.TRAINING_COMPLETE, trainingCompleteHandler );

            var trainingPatterns:Array =
                    [
                        [
                            [ WILLEMII, AJAX ],
                            [ 0, 1 ]
                        ],
                        [
                            [ AJAX, WILLEMII  ],
                            [ 1, 0 ]
                        ],

                        [
                            [ AJAX, HEERENVEEN  ],
                            [ 0, 1 ]
                        ],
                        [
                            [ HEERENVEEN, AJAX  ],
                            [ 1, 0 ]
                        ],

                        [
                            [ WILLEMII, HEERENVEEN  ],
                            [ 0, 1 ]
                        ],
                        [
                            [ HEERENVEEN, WILLEMII  ],
                            [ 1, 0 ]
                        ],


                        [
                            [ AJAX, RODAJC  ],
                            [ 1, 0 ]
                        ],
                        [
                            [ RODAJC, AJAX  ],
                            [ 0, 1 ]
                        ],

                        [
                            [ FEYENOORD, AJAX  ],
                            [ 0.5, 0.5 ]
                        ],
                        [
                            [ AJAX, FEYENOORD  ],
                            [ 1, 0 ]
                        ],

                        [
                            [ AJAX, SPARTA  ],
                            [ 1, 0 ]
                        ],
                        [
                            [ SPARTA, AJAX  ],
                            [ 0, 1 ]
                        ],

                        [
                            [ AJAX, PSV  ],
                            [ 1, 0 ]
                        ],
                        [
                            [ PSV, AJAX  ],
                            [ 1, 0 ]
                        ],

                        [
                            [ TWENTE, AJAX  ],
                            [ 0, 1 ]
                        ],
                        [
                            [ AJAX, TWENTE  ],
                            [ 1, 0 ]
                        ],

                        [
                            [ VOLENDAM, AJAX  ],
                            [ 0, 1 ]
                        ],
                        [
                            [ AJAX, VOLENDAM  ],
                            [ 1, 0 ]
                        ],

//                        [ [ AJAX, DEGRAAFSCHAP  ], [ 1, 0 ] ],
                [
                    [ DEGRAAFSCHAP, AJAX  ],
                    [ 0, 1 ]
                ],


                [
                    [ WILLEMII, FEYENOORD  ],
                    [ 1, 0 ]
                ],
                [
                    [ FEYENOORD, WILLEMII  ],
                    [ 0.5, 0.5 ]
                ],

                [
                    [ WILLEMII, RODAJC  ],
                    [ 1, 0 ]
                ],
                [
                    [ RODAJC, WILLEMII  ],
                    [ 0, 1 ]
                ],

                [
                    [ WILLEMII, VOLENDAM  ],
                    [ 0, 1 ]
                ],
                [
                    [ VOLENDAM, WILLEMII  ],
                    [ 0.5, 0.5 ]
                ],

                [
                    [ WILLEMII, TWENTE  ],
                    [ 0, 1 ]
                ],
//                        [ [ TWENTE, WILLEMII  ], [ 1, 0 ] ],

                [
                    [ WILLEMII, PSV  ],
                    [ 0, 1 ]
                ],
                [
                    [ PSV, WILLEMII  ],
                    [ 1, 0 ]
                ],

                [
                    [ SPARTA, WILLEMII  ],
                    [ 0, 1 ]
                ],
                [
                    [ WILLEMII, SPARTA  ],
                    [ 1, 0 ]
                ],

                [
                    [ WILLEMII, DEGRAAFSCHAP  ],
                    [ 0.5, 0.5 ]
                ],
                [
                    [ DEGRAAFSCHAP, WILLEMII  ],
                    [ 1, 0 ]
                ],


                [
                    [ HEERENVEEN, RODAJC  ],
                    [ 1, 0 ]
                ],
                [
                    [ RODAJC, HEERENVEEN  ],
                    [ 0.5, 0.5 ]
                ],

                [
                    [ HEERENVEEN, TWENTE  ],
                    [ 0.5, 0.5 ]
                ],
                [
                    [ TWENTE, HEERENVEEN  ],
                    [ 1, 0 ]
                ],

                [
                    [ HEERENVEEN, SPARTA  ],
                    [ 1, 0 ]
                ],
//                        [ [ SPARTA, HEERENVEEN  ], [ 1, 0 ] ],

                [
                    [ HEERENVEEN, FEYENOORD  ],
                    [ 1, 0 ]
                ],
                [
                    [ FEYENOORD, HEERENVEEN  ],
                    [ 0.5, 0.5 ]
                ],

                [
                    [ HEERENVEEN, PSV  ],
                    [ 0.5, 0.5 ]
                ],
                [
                    [ PSV, HEERENVEEN  ],
                    [ 0, 1 ]
                ],

                [
                    [ HEERENVEEN, VOLENDAM  ],
                    [ 1, 0 ]
                ],
                [
                    [ VOLENDAM, HEERENVEEN  ],
                    [ 0, 1 ]
                ],

                [
                    [ HEERENVEEN, DEGRAAFSCHAP  ],
                    [ 1, 0 ]
                ],
                [
                    [ DEGRAAFSCHAP, HEERENVEEN  ],
                    [ 1, 0 ]
                ]


            ];

            exercise = new Exercise( 0, 0.0001 );

            for each ( var game:Array in trainingPatterns )
            {
                exercise.addPatterns( binStringToArray( game[0][0] + "0000" + game[0][1] ), game[1] );
            }


        }


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function boxClickHandler( e:MouseEvent ):void
        {
            switch ( net.trainingState )
            {
                case TrainingState.STOPPED:
                    net.startTraining( exercise );
                    break;

                case TrainingState.STARTED:
                    net.pauseTraining();
                    trainingCompleteHandler();
                    break;

                case TrainingState.PAUSED:
                    net.resumeTraining();
                    break;
            }

        }


        private function trainingEpochCompleteHandler( e:NeuralNetworkEvent ):void
        {
            tf.text = "currerror:" + e.trainingResult.endError + "\nlearningRate:" + net.learningRate + "\nnrOfTrainingEpochs:" + e.trainingResult.epochs;
        }


        private function trainingCompleteHandler( e:NeuralNetworkEvent = null ):void
        {
            trace( "---------------" );
            trace( "FEYENOORD-AJAX::" + netResult( [ FEYENOORD, AJAX  ] ) );
            trace( "AJAX-FEYENOORD::" + netResult( [ AJAX, FEYENOORD  ] ) );
            trace( "AJAX-WILLEMII::" + netResult( [ AJAX, WILLEMII ] ) );
            trace( "WILLEMII-AJAX::" + netResult( [ WILLEMII, AJAX ] ) );
            trace( "PSV-RODAJC::" + netResult( [ PSV, RODAJC ] ) );
            trace( "RODAJC-PSV::" + netResult( [ RODAJC, PSV ] ) );
            trace( "FEYENOORD-RODAJC::" + netResult( [ FEYENOORD, RODAJC  ] ) );
            trace( "RODAJC-FEYENOORD::" + netResult( [ RODAJC, FEYENOORD  ] ) );
            trace( "RODAJC-SPARTA::" + netResult( [ RODAJC, SPARTA ] ) );
            trace( "FEYENOORD-DEGRAAFSCHAP::" + netResult( [ FEYENOORD, DEGRAAFSCHAP ] ) );
            trace( "DEGRAAFSCHAP-FEYENOORD::" + netResult( [ DEGRAAFSCHAP, FEYENOORD ] ) );
            trace( "PSV-FEYENOORD::" + netResult( [ PSV, FEYENOORD ] ) );
            trace( "FEYENOORD-PSV::" + netResult( [ FEYENOORD, PSV ] ) );
            trace( "VOLENDAM-AJAX::" + netResult( [ VOLENDAM, AJAX ] ) );
            trace( "WILLEMII-TWENTE::" + netResult( [ WILLEMII, TWENTE ] ) );
            trace( "RODAJC-HEERENVEEN::" + netResult( [ RODAJC, HEERENVEEN ] ) );
            trace( "AJAX-FEYENOORD::" + netResult( [ AJAX, FEYENOORD ] ) );
            trace( "WILLEMII-PSV::" + netResult( [ WILLEMII, PSV ] ) );
            trace( "HEERENVEEN-FEYENOORD::" + netResult( [ HEERENVEEN, FEYENOORD ] ) );
            trace( "AJAX-DEGRAAFSCHAP::" + netResult( [ AJAX, DEGRAAFSCHAP ] ) );
            trace( "TWENTE-WILLEMII::" + netResult( [ TWENTE, WILLEMII ] ) );
            trace( "SPARTA-HEERENVEEN::" + netResult( [ SPARTA, HEERENVEEN ] ) );
            trace( "---------------" );
            /*
             trace( "AJAX-TWENTE::"+net.run( [ AJAX, TWENTE ] ) );
             trace( "PSV-AJAX::"+net.run( [ PSV, AJAX ] ) );
             trace( "RODAJC-AJAX::"+net.run( [ RODAJC, AJAX ] ) );
             trace( "AJAX-RODAJC::"+net.run( [ AJAX, RODAJC ] ) );*/

//            trace(net.toXML());
        }


        private function netResult( matchup:Array ):Array
        {
            var result:Array = net.run( binStringToArray( matchup[0] + "0000" + matchup[1] ) );

            return result;
        }


        private function binStringToArray( str:String ):Array
        {
            return str.split( "" );
        }

    }
}