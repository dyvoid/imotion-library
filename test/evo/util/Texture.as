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
    import flash.display.BitmapData;


    /**
     * @author Pieter van de Sluis
     * Date: 12-okt-2010
     * Time: 20:40:00
     */
    public class Texture
    {
        private static var _abstract:BitmapData = new AbstractTexture();
        private static var _ink:BitmapData = new InkTexture();
        private static var _mona:BitmapData = new MonaTexture();
        private static var _gradient:BitmapData = new GradientTexture();
        private static var _rust:BitmapData = new RustyTexture();
        private static var _flower:BitmapData = new FlowerTexture();
        private static var _wall:BitmapData = new WallTexture();

        [Embed(source="../assets/noise.png")]
        private static var NoiseTexure:Class; 
        private static var _noise:BitmapData = new NoiseTexure().bitmapData;

        // ____________________________________________________________________________________________________
        // PUBLIC

        public static function get ABSTRACT():BitmapData
        {
            return _abstract;
        }


        public static function get INK():BitmapData
        {
            return _ink;
        }


        public static function get MONA():BitmapData
        {
            return _mona;
        }


        public static function get GRADIENT():BitmapData
        {
            return _gradient;
        }


        public static function get RUST():BitmapData
        {
            return _rust;
        }


        public static function get FLOWER():BitmapData
        {
            return _flower;
        }


        public static function get WALL():BitmapData
        {
            return _wall;
        }


        public static function get NOISE():BitmapData
        {
            return _noise;
        }

    }
}