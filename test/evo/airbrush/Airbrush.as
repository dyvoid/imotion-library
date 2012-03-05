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

        private var _size:uint;

        private var _colorR:uint;
        private var _colorG:uint;
        private var _colorB:uint;

        private var _matrix:Matrix;


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
            var color:uint = ( _colorR << 16 ) | ( _colorG << 8 ) | _colorB;

            _matrix.createGradientBox( _size, _size );

            var g:Graphics = this.graphics;
            g.clear();
            g.beginGradientFill( GradientType.RADIAL, [ color, color ], [ 1, 0 ], [ 0x00, 0xff ], _matrix );
            g.drawCircle( 0, 0, _size * 2 );
            g.endFill();
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get size():uint
        {
            return _size;
        }


        public function set size( value:uint ):void
        {
            _size = value;
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


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}