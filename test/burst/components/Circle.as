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

package test.burst.components
{
    import flash.events.Event;
    import flash.events.MouseEvent;

    import nl.imotion.burst.components.core.BurstSprite;


    /**
     * @author Pieter van de Sluis
     */
    public class Circle extends BurstSprite
    {
        private var radius:Number;
        private var interval:Number = 0;


        public function Circle( radius:Number = 60, color:Number = 0x330099 )
        {
            this.buttonMode = true;

            this.radius = radius;

            this.graphics.beginFill( color );
            this.graphics.drawCircle( radius, radius, radius );

            //startEventInterest( this, Event.ENTER_FRAME, enterFrameHandler );
            startEventInterest( this, MouseEvent.CLICK, mouseClickEvent );
        }


        private function mouseClickEvent( e:MouseEvent ):void
        {
            if ( hasEventListener( Event.ENTER_FRAME ) )
            {
                stopEventInterest( this, Event.ENTER_FRAME, enterFrameHandler );
            }
            else
            {
                startEventInterest( this, Event.ENTER_FRAME, enterFrameHandler );
            }
        }


        private function enterFrameHandler( e:Event ):void
        {
            interval = ( interval + 0.03 ) % 1;

            this.width =
                    this.height = Math.sin( Math.PI * interval ) * radius;
        }

    }

}