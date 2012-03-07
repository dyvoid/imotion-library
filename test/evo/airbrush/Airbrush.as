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

package test.evo.airbrush
{
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;

    import nl.imotion.evo.evolvers.IUpdateableDisplayObject;


    /**
     * @author Pieter van de Sluis
     * Date: 16-okt-2010
     * Time: 13:27:19
     */
    public class Airbrush extends Sprite implements IUpdateableDisplayObject
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _graphics:Graphics;

        private var _radius:uint = 50;

        private var _colorR:uint;
        private var _colorG:uint;
        private var _colorB:uint;

        private var _matrix:Matrix;

        private var _alpha1:Number = 1;
        private var _alpha2:Number = 0;

        private var _ratio1:uint = 0x00;
        private var _ratio2:uint = 0xff;

        private var _brightness1:uint = 0x00;
        private var _brightness2:uint = 0x00;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Airbrush()
        {
            _matrix = new Matrix();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function update():void
        {
            var color1:uint = ( _brightness1 << 16 ) | ( _brightness1 << 8 ) | _brightness1;
            var color2:uint = ( _brightness2 << 16 ) | ( _brightness2 << 8 ) | _brightness2;

            _matrix = new Matrix();
            _matrix.createGradientBox( 2 * _radius, 2 * _radius, 0, -_radius, -_radius );

            graphics.clear();
            graphics.beginGradientFill( GradientType.RADIAL, [ color1, color2 ], [ _alpha1, _alpha2 ], [ _ratio1, _ratio2 ], _matrix );
            graphics.drawCircle( 0, 0, _radius );
            graphics.endFill();
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get radius():uint
        {
            return _radius;
        }


        public function set radius( value:uint ):void
        {
            _radius = value;
        }


        public function get colorR():uint
        {
            return _colorR;
        }


        public function set colorR( value:uint ):void
        {
            _colorR = value;
        }


        public function get colorG():uint
        {
            return _colorG;
        }


        public function set colorG( value:uint ):void
        {
            _colorG = value;
        }


        public function get colorB():uint
        {
            return _colorB;
        }


        public function set colorB( value:uint ):void
        {
            _colorB = value;
        }


        public function get matrix():Matrix
        {
            return _matrix;
        }


        public function set matrix( value:Matrix ):void
        {
            _matrix = value;
        }


        public function get alpha1():Number
        {
            return _alpha1;
        }


        public function set alpha1( value:Number ):void
        {
            _alpha1 = value;
        }


        public function get alpha2():Number
        {
            return _alpha2;
        }


        public function set alpha2( value:Number ):void
        {
            _alpha2 = value;
        }


        public function get ratio1():uint
        {
            return _ratio1;
        }


        public function set ratio1( value:uint ):void
        {
            _ratio1 = value;
        }


        public function get ratio2():uint
        {
            return _ratio2;
        }


        public function set ratio2( value:uint ):void
        {
            _ratio2 = value;
        }


        public function get brightness1():uint
        {
            return _brightness1;
        }


        public function set brightness1( value:uint ):void
        {
            _brightness1 = value;
        }


        public function get brightness2():uint
        {
            return _brightness2;
        }


        public function set brightness2( value:uint ):void
        {
            _brightness2 = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}