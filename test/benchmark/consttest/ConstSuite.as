/**
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 * Copyright (c) 2010 Pieter van de Sluis
 * http://code.google.com/p/imotionproductions/
 */
package test.benchmark.consttest
{
    import com.gskinner.performance.MethodTest;
    import com.gskinner.performance.TestSuite;


    /**
     * @author Pieter van de Sluis
     */
    public class ConstSuite extends TestSuite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var numLoops:uint = 100;
        private var numInstances:uint = 5000;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function ConstSuite()
        {
            name = "ConstTest";
            tareTest = new MethodTest( tare );
            tests = [
                new MethodTest( varTest, null, "varTest", 15, numLoops ),
                new MethodTest( constTest, null, "constTest", 15, numLoops ),
                new MethodTest( staticConstTest, null, "staticConstTest", 15, numLoops ),
            ];
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function tare():void
        {
            var testArr:Array = [];

            for ( var i:int = 0; i < numInstances; i++ )
            {
                testArr[i] = new TareTest();
            }
        }


        private function varTest():void
        {
            var testArr:Array = [];

            for ( var i:int = 0; i < numInstances; i++ )
            {
                testArr[i] = new VarTest();
            }
        }


        private function constTest():void
        {
            var testArr:Array = [];

            for ( var i:int = 0; i < numInstances; i++ )
            {
                testArr[i] = new ConstTest();
            }
        }


        private function staticConstTest():void
        {
            var testArr:Array = [];

            for ( var i:int = 0; i < numInstances; i++ )
            {
                testArr[i] = new StaticConstTest();
            }
        }


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }

}