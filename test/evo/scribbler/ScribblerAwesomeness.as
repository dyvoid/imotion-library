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

package test.evo.scribbler
{
    import flash.display.Sprite;
    import flash.events.Event;


    /**
     * @author Pieter van de Sluis
     * Date: 15-okt-2010
     * Time: 20:10:15
     */

    [SWF(backgroundColor="#000000",width="1024",height="700",frameRate="31")]
    public class ScribblerAwesomeness extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _nrOfScribblers:uint = 10;

        private var _scribblers:Vector.<AwesomeScribbler> = new Vector.<AwesomeScribbler>();

        private var scribbler:Scribbler;
        private var scribbler2:Scribbler;
        private var scribbler3:Scribbler;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function ScribblerAwesomeness()
        {
            for ( var i:int = 0; i < _nrOfScribblers; i++ )
            {
                var s:AwesomeScribbler = new AwesomeScribbler();
                s.x = stage.stageWidth / 2;
                s.y = stage.stageHeight / 2;
                this.addChild( s )
                _scribblers.push( s );
            }

            this.addEventListener( Event.ENTER_FRAME, enterFrameHandler )
        }


        private function enterFrameHandler( e:Event ):void
        {
            for ( var i:int = 0; i < _nrOfScribblers; i++ )
            {
                _scribblers[ i ].update();
            }
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