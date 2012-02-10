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

package test.evo.brush
{
    import flash.display.Sprite;
    import flash.geom.ColorTransform;

    import test.evo.*;


    /**
     * @author Pieter van de Sluis
     * Date: 17-sep-2010
     * Time: 10:20:23
     */
    public class Brush extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _color:Color = new Color();

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Brush()
        {
//            this.graphics.beginFill( 0x000000 )
//            this.graphics.drawRect( -25, -25, 50, 50 );
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function applyColor():void
        {
            var c:ColorTransform = new ColorTransform();
            c.color = _color.value;

            this.transform.colorTransform = c;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get colorR():uint
        {
            return _color.red;
        }


        public function set colorR( value:uint ):void
        {
            _color.red = value;
            applyColor();

        }


        public function get colorG():uint
        {
            return _color.green;
        }


        public function set colorG( value:uint ):void
        {
            _color.green = value;
            applyColor();
        }


        public function get colorB():uint
        {
            return _color.blue;
        }


        public function set colorB( value:uint ):void
        {
            _color.blue = value;
            applyColor();
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}