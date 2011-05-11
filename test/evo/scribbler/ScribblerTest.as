/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2009-2011 Pieter van de Sluis
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
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(backgroundColor="#ffffff",width="1100",height="900",frameRate="30")]

    public class ScribblerTest extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var bm:BitmapData;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function ScribblerTest()
        {
            bm = new BitmapData( stage.stageWidth, stage.stageHeight, false, 0xffffff )
            this.addChild( new Bitmap( bm ) );

            addEventListener( Event.ENTER_FRAME, enterFrameHandler );
        }


        private function enterFrameHandler( e:Event ):void
        {
            var scribblers:Array = [];
            var numDraw:uint = 100;
            var i:uint;
            var scribbler:FlowText;

            for ( i = 0; i < numDraw; i++ )
            {
                scribbler = new FlowText();
                scribbler.x = stage.stageWidth/2;
                scribbler.y = stage.stageHeight/2;
                scribbler.startAngle = Math.random() * ( Math.PI * 2 );
                scribbler.life = 2 + Math.random() * 70;
//                scribbler.straightening = 0;
                scribbler.straightening = 0 + Math.random() * 1;
                scribbler.alpha = Math.random();
                scribbler.seed = Math.random();
                scribbler.mutateSeed = Math.random();
                scribbler.update();
                scribbler.z = Math.random() * 300;
                scribbler.rotationX = Math.random() * 90 - 180;
                scribbler.rotationY = Math.random() * 90 - 180;

                this.addChild( scribbler );
                scribblers[ scribblers.length ] = scribbler;
            }

            bm.draw( stage, null, null, null, null, true );

            for (  i = 0; i < numDraw; i++ )
            {
                removeChild( scribblers[ i ] );
            }

            scribblers.length = 0;
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