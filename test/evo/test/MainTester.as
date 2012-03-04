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

package test.evo.test
{
    import flash.display.Sprite;
    import flash.events.Event;

    import test.evo.scribbler.FlowText;


    /**
     * @author Pieter van de Sluis
     * Date: 16-okt-2010
     * Time: 13:31:37
     */
    [SWF(backgroundColor="#000000",width="1024",height="700",frameRate="31")]
    public class MainTester extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _scribbler:FlowText;


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR


        public function MainTester()
        {
            _scribbler = new FlowText();
            _scribbler.x = stage.stageWidth / 2;
            _scribbler.y = stage.stageHeight / 2;

            this.addChild( _scribbler );

            _scribbler.colorR = 0xff;
            _scribbler.seed = 200;
            _scribbler.stepLength = 35;

            addEventListener( Event.ENTER_FRAME, ef );
        }


        private function ef( e:Event ):void
        {
            var s:FlowText = new FlowText();
            s.x = stage.stageWidth / 2;
            s.y = stage.stageHeight / 2;

            this.addChild( s );

            s.colorR = 0xff;
            s.seed = _scribbler.seed;
            s.mutateSeed = _scribbler.mutateSeed;
            s.stepLength = 35;
            s.update();

            _scribbler.mutateSeed++;
            _scribbler.seed = Math.round( Math.random() * 0xffffffff );
            _scribbler.update();

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