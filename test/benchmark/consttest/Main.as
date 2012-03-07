/**
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 * Copyright (c) 2010 Pieter van de Sluis
 * http://code.google.com/p/imotionproductions/
 */
package test.benchmark.consttest
{
    import com.gskinner.performance.PerformanceTest;

    import flash.display.Sprite;
    import flash.events.Event;


    /**
     * @author Pieter van de Sluis
     */
    public class Main extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var pt:PerformanceTest;
        private var test:ConstSuite;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Main()
        {
            test = new ConstSuite();

            pt = new PerformanceTest();
            pt.addEventListener( Event.COMPLETE, completeHandler );
            pt.delay = 1000;
            pt.runTestSuite( test );
        }


        private function completeHandler( e:Event ):void
        {
            trace( test.toString() );
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }

}