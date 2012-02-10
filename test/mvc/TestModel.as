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

package test.mvc
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import nl.imotion.bindmvc.model.BindModel;
    import nl.imotion.notes.DataNote;


    /**
     * @author Pieter van de Sluis
     */
    public class TestModel extends BindModel
    {
        public static const NAME:String = "TestModel";

        public static const NOTE_TEST_RESULT:String = "noteTestResult";


        public function TestModel()
        {
            super( NAME );
        }


        public function getTestData():void
        {
            var t:Timer = new Timer( 500 );
            startEventInterest( t, TimerEvent.TIMER, onTimer );
            t.start();
        }


        private function onTimer( e:TimerEvent ):void
        {
            dispatchNote( new DataNote( NOTE_TEST_RESULT, "Test" ) );
        }
    }

}