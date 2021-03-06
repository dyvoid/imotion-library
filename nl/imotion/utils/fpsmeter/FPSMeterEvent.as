/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2009-2013 Pieter van de Sluis
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

package nl.imotion.utils.fpsmeter
{
    import flash.events.Event;


    /**
     * @author Pieter van de Sluis
     */
    public class FPSMeterEvent extends Event
    {
        public static const MEASURE_COMPLETE		:String = "FPSMeterEvent::MEASURE_COMPLETE";

        private var _fps    :uint;
        

        public function FPSMeterEvent( type:String, fps:uint, bubbles:Boolean=false, cancelable:Boolean=false )
        {
            super( type, bubbles, cancelable );

            _fps = fps;
        }


        public override function clone():Event
        {
            return new FPSMeterEvent( type, fps, bubbles, cancelable );
        }


        public override function toString():String
        {
            return formatToString("FPSMeterEvent", "type", "fps", "bubbles", "cancelable", "eventPhase");
        }


        public function get fps():uint
        {
            return _fps;
        }

    }

}