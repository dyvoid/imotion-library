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

package test.evo.shapeshifter
{
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;

    import nl.imotion.evo.evolvers.IUpdateableDisplayObject;


    /**
     * @author Pieter van de Sluis
     * Date: 19-sep-2010
     * Time: 19:44:57
     */
    public class ShapeShifter extends Sprite implements IUpdateableDisplayObject
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _numPoints:Number = 20;
        private var _seed:Number = 0.5;

        private var _texture:BitmapData;
        private var _textureOffsetX:Number;
        private var _textureOffsetY:Number;
        private var _textureOffsetRotation:Number;

        private var _size:Number = 50;
        private var _distortionRatio:Number = 0;
        private var _distortion:Number;

        private var _shape:Shape;

        private var _redMultiplier:Number;
        private var _greenMultiplier:Number;
        private var _blueMultiplier:Number;

        private var _graphics:Graphics;

        private var _randomizer:SeededRandom;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function ShapeShifter()
        {
            _randomizer = new SeededRandom();
            this.addChild( _shape = new Shape() );
            _graphics = _shape.graphics;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function update():void
        {
            _randomizer.seed = _seed;
            _randomizer.size = _numPoints;
            _randomizer.reset();

            _graphics.clear();

            var m:Matrix = new Matrix();
            m.rotate( _textureOffsetRotation * ( Math.PI * 2 ) );
            m.tx = _textureOffsetX * _texture.width;
            m.ty = _textureOffsetY * _texture.height;
            _graphics.beginBitmapFill( _texture, m );

            var colorTransformer:ColorTransform = _shape.transform.colorTransform;

            colorTransformer.redMultiplier = _redMultiplier;
            colorTransformer.greenMultiplier = _greenMultiplier;
            colorTransformer.blueMultiplier = _blueMultiplier;

            _shape.transform.colorTransform = colorTransformer;

            var interval:Number = 2 / _numPoints;

            _distortion = ( size * _distortionRatio ) * 2;

            var pos:Point = getPosByInterval( interval / 2 );
            _graphics.moveTo( pos.x, pos.y );

            for ( var i:int = 1; i < _numPoints; i++ )
            {
                pos = getPosByInterval( interval * i + interval / 2 );

                _graphics.lineTo( pos.x, pos.y );
            }

            _graphics.endFill();
        }


        private function getPosByInterval( interval:Number ):Point
        {
            var radius:Number = _size + _randomizer.random() * _distortion - ( _distortion / 2 );

            var pi:Number = Math.PI * interval;

            return new Point( Math.cos( pi ) * radius, Math.sin( pi ) * radius );
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get redMultiplier():Number
        {
            return _redMultiplier;
        }


        public function set redMultiplier( value:Number ):void
        {
            _redMultiplier = value;
        }


        public function get greenMultiplier():Number
        {
            return _greenMultiplier;
        }


        public function set greenMultiplier( value:Number ):void
        {
            _greenMultiplier = value;
        }


        public function get blueMultiplier():Number
        {
            return _blueMultiplier;
        }


        public function set blueMultiplier( value:Number ):void
        {
            _blueMultiplier = value;
        }


        public function get numPoints():Number
        {
            return _numPoints;
        }


        public function set numPoints( value:Number ):void
        {
            _numPoints = value;
        }


        public function get seed():Number
        {
            return _seed;
        }


        public function set seed( value:Number ):void
        {
            _seed = value;
        }


        public function get size():Number
        {
            return _size;
        }


        public function set size( value:Number ):void
        {
            _size = value;
        }


        public function get distortionRatio():Number
        {
            return _distortionRatio;
        }


        public function set distortionRatio( value:Number ):void
        {
            _distortionRatio = value;
        }


        public function get texture():BitmapData
        {
            return _texture;
        }


        public function set texture( value:BitmapData ):void
        {
            _texture = value;
        }


        public function get textureOffsetX():Number
        {
            return _textureOffsetX;
        }


        public function set textureOffsetX( value:Number ):void
        {
            _textureOffsetX = value;
        }


        public function get textureOffsetY():Number
        {
            return _textureOffsetY;
        }


        public function set textureOffsetY( value:Number ):void
        {
            _textureOffsetY = value;
        }


        public function get textureOffsetRotation():Number
        {
            return _textureOffsetRotation;
        }


        public function set textureOffsetRotation( value:Number ):void
        {
            _textureOffsetRotation = value;
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}