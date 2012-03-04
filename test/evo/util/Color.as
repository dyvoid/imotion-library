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

package test.evo.util
{
    /**
     * Util for working with Color
     *
     * @author Stroep.nl | Mark Knol
     */
    public final class Color
    {
        private var _value:int = 0;

        protected var _red:int = 0;
        protected var _green:int = 0;
        protected var _blue:int = 0;

        protected var grayList:Array = [];


        public function Color( value:int = 0xFFFFFF ):void
        {
            this.value = value;
        }


        /// get the real color value
        public function get value():int
        {
            return (_red << 16) | (_green << 8) | _blue;
        }


        /// set the real color value
        public function set value( value:int ):void
        {
            _red = value >> 16 & 0xFF; // red
            _green = value >> 8 & 0xFF; // green
            _blue = value & 0xFF; // blue

            _value = value;
        }


        /**
         * Get the red value of a color
         *
         * @param color Enter full color from range 0x000000 to 0xFFFFFF
         * @return Red colorvalue
         * @tiptext
         */
        public function get red():int
        {
            return _red;
        }


        /**
         * Get the green value of a color
         *
         * @param color Enter full color from range 0x000000 to 0xFFFFFF
         * @return Green colorvalue
         * @tiptext
         */
        public function get green():int
        {
            return _green;
        }


        /**
         * Get the blue value of a color
         *
         * @param color Enter full color from range 0x000000 to 0xFFFFFF
         * @return Blue colorvalue
         * @tiptext
         */
        public function get blue():int
        {
            return _blue;
        }


        /**
         * Set new red value to a color
         * @param    tint    range between 0-255
         * @tiptext
         */
        public function set red( val:int ):void
        {
            _red = val;
            _red = limit( _red, 0, 255 );
        }


        /**
         * Set new green value to a color
         * @param    tint    range between 0-255
         * @tiptext
         */
        public function set green( val:int ):void
        {
            _green = val;
            _green = limit( _green, 0, 255 );
        }


        /**
         * Set new blue value to a color
         * @param    tint    range between 0-255
         * @tiptext
         */
        public function set blue( val:int ):void
        {
            _blue = val;
            _blue = limit( _blue, 0, 255 );
        }


        /**
         * Get a grayscale color from a tint
         *
         * @param tint Enter tint from range 0 to 255
         * @return Gray colorvalue
         * @tiptext
         */
        public static function grayscale( val:int = 0 ):int
        {
            if ( val < 0 )
            {
                val = 0
            }
            if ( val > 255 )
            {
                val = 255
            }

            return (val << 16) | (val << 8) | val;
        }


        /**
         * Darken or lighten color with count(-255 to 255)<br/>
         * Darken = count &lt; 0<br/>
         * Lighten = count &gt; 0
         * @param    count    amount sliding color (-255 to 255)
         * @return darker color
         * @tiptext
         */
        public function slideColor( count:int = 0 ):int
        {
            var retval:int = value;

            var r:int = limit( (retval >> 16) + count, 0, 255 )
            var g:int = limit( (retval >> 8 & 0xFF) + count, 0, 255 )
            var b:int = limit( (retval & 0xFF) + count, 0, 255 )

            return (r << 16) | (g << 8) | ( b );
        }


        /**
         * Darken color with amount (0 to 255)
         * @param    count    amount to darken color (0 to 255)
         * @return darker color
         * @tiptext
         */
        public function darker( count:int = 0 ):int
        {
            return slideColor( -count );
        }


        /**
         * Lighten color with amount (0 to 255)
         * @param    count    amount to lighten color (0 to 255)
         * @return lighter color
         * @tiptext
         */
        public function lighter( count:int = 0 ):int
        {
            return slideColor( count );
        }


        protected function limit( val:Number, lowerLimit:Number, upperLimit:Number ):Number
        {
            if ( val < lowerLimit )
            {
                return lowerLimit
            }
            if ( val > upperLimit )
            {
                return upperLimit
            }
            return val;
        }
    }
}