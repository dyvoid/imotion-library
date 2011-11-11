package test 
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import nl.imotion.neuralnetwork.BackPropagationNet;
    import nl.imotion.neuralnetwork.events.NeuralNetworkEvent;
    import nl.imotion.neuralnetwork.training.Exercise;

    /**
     * Project:    iMotion Library
     * Package:    test
     * Class:      Main
     * 
     * 
     * 
     * @author     pieter.van.de.sluis@usmedia.nl
     * @version    0.1
     * @since      02-Jul-10 9:21 AM
    */
    public class Main extends Sprite
    {
        private var net:BackPropagationNet;
        private var input1:Array;
        private var input2:Array;
        private var input3:Array;
        private var input4:Array;
        private var expectedResult1:Array;
        private var expectedResult2:Array;
        private var expectedResult3:Array;
        private var expectedResult4:Array;
        private var tf:TextField;
        
        //_________________________________________________________________________________________________________________
        //																						      C O N S T R U C T O R
        
        public function Main() 
        {
            tf = new TextField();
            tf.width  =
            tf.height = 300;
            tf.x =
            tf.y = 15;
            this.addChild( tf );
            
            net = new BackPropagationNet( 0.8, 0.4 );
            net.addEventListener(NeuralNetworkEvent.TRAINING_EPOCH_COMPLETE, netEventHandler );
            net.addEventListener(NeuralNetworkEvent.TRAINING_COMPLETE, netEventHandler );
            net.create( 2, 1, 1, 10 );
            
            //SETUP XOR TRAINING
            input1 = [ 0, 0 ];
            input2 = [ 0, 1 ];
            input3 = [ 1, 0 ];
            input4 = [ 1, 1 ];
            expectedResult1 = [ 0 ];
            expectedResult2 = [ 1 ];
            expectedResult3 = [ 1 ];
            expectedResult4 = [ 0 ];
            
            var exercise:Exercise = new Exercise( 300 );
            exercise.addPatterns( input1, expectedResult1 );
            exercise.addPatterns( input2, expectedResult2 );
            exercise.addPatterns( input3, expectedResult3 );
            exercise.addPatterns( input4, expectedResult4 );
            
            trace( "START RESULT ---" );
            showResult();
            
            net.startTraining( exercise );
        }
        
        //_________________________________________________________________________________________________________________
        //                                                                                      P U B L I C   M E T H O D S
        
        
        
        //_________________________________________________________________________________________________________________
        //                                                                                  G E T T E R S  /  S E T T E R S
        
        
        
        //_________________________________________________________________________________________________________________
        //                                                                                      E V E N T   H A N D L E R S
        
        private function netEventHandler(e:NeuralNetworkEvent):void 
        {
            switch( e.type )
            {
                case NeuralNetworkEvent.TRAINING_EPOCH_COMPLETE:
                    tf.text = "Error: " + net.error + "\n";
                    tf.appendText( "nrOfEpochs: " + e.trainingResult.epochs );
                break;
                
                case NeuralNetworkEvent.TRAINING_COMPLETE:
                    trace( "RESULT AFTER TRAINING ---" );
                    showResult();
                break;
            }
        }
        
        //_________________________________________________________________________________________________________________
        //                                                                                P R O T E C T E D   M E T H O D S
        
        
        
        //_________________________________________________________________________________________________________________
        //                                                                                    P R I V A T E   M E T H O D S
        
        private function showResult():void
        {
            trace( "0 - 0 : " + net.run( input1 ) + " (should be " + expectedResult1 + ")" );
            trace( "0 - 1 : " + net.run( input2 ) + " (should be " + expectedResult2 + ")" );
            trace( "1 - 0 : " + net.run( input3 ) + " (should be " + expectedResult3 + ")" );
            trace( "1 - 1 : " + net.run( input4 ) + " (should be " + expectedResult4 + ")" );
            trace( "----------\n" );
        }
        
    }
}