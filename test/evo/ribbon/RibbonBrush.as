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

package test.evo.ribbon
{
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.ColorTransform;

    import test.evo.*;


    /**
     * @author Pieter van de Sluis
     * Date: 18-sep-2010
     * Time: 22:46:55
     */
    public class RibbonBrush extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _lifeLength:Number = 40;
        private var _noiseSeed:Number = 0.5;
        private var _speed:Number = 0;

        private var _startSpeed:Number = 5;
        private var _startRotation:Number = 0;
        private var _dSpeed:Number = 0;
        private var _dRotation:Number = -6;

        private var _holder:Sprite;

        private var _brushClass:Class = Brush1VC;

        private var _color:Color = new Color();

        private var _minScale:Number = 0.1;
        private var _maxScale:Number = .01;


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function RibbonBrush()
        {

        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function update():void
        {
            if ( _holder && this.contains( _holder ) )
                removeChild( _holder );

            this.addChild( _holder = new Sprite() );

            var noiseMap:BitmapData = new BitmapData( 1, _lifeLength );
            noiseMap.perlinNoise( 1, _lifeLength, 3, _noiseSeed, false, false, 7 );

            _dSpeed = _startSpeed;

            var prevX:Number = 0;
            var prevY:Number = 0;
            var prevRotation:Number = _startRotation;

            for ( var i:int = 0; i < _lifeLength; i++ )
            {
                var brush:Sprite = new _brushClass() as Sprite;
                _holder.addChild( brush );

                var scaleFactor:Number = noiseMap.getPixel( 0, i ) & 0xFF;

                brush.scaleX = brush.scaleY = minScale + ( scaleFactor / 50 ) * ( maxScale - minScale );

                brush.rotation = prevRotation + Math.sin( Math.PI * ( i / _lifeLength ) * 2 ) * _dRotation;

                _dSpeed = ( _startSpeed * ( ( _lifeLength - i ) / _lifeLength ) );

                var angle:Number = Trig.degToRad( brush.rotation );

                brush.x = prevX + Math.cos( angle ) * _dSpeed;
                brush.y = prevY + Math.sin( angle ) * _dSpeed;

                prevX = brush.x;
                prevY = brush.y;
                prevRotation = brush.rotation;
            }
        }


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


        public function get minScale():Number
        {
            return _minScale;
        }


        public function set minScale( value:Number ):void
        {
            _minScale = value;
        }


        public function get maxScale():Number
        {
            return _maxScale;
        }


        public function set maxScale( value:Number ):void
        {
            _maxScale = value;
        }


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


        public function get lifeLength():Number
        {
            return _lifeLength;
        }


        public function set lifeLength( value:Number ):void
        {
            _lifeLength = value;
        }


        public function get noiseSeed():Number
        {
            return _noiseSeed;
        }


        public function set noiseSeed( value:Number ):void
        {
            _noiseSeed = value;
        }


        public function get speed():Number
        {
            return _speed;
        }


        public function set speed( value:Number ):void
        {
            _speed = value;
        }


        public function get startSpeed():Number
        {
            return _startSpeed;
        }


        public function set startSpeed( value:Number ):void
        {
            _startSpeed = value;
        }


        public function get dSpeed():Number
        {
            return _dSpeed;
        }


        public function set dSpeed( value:Number ):void
        {
            _dSpeed = value;
        }


        public function get dRotation():Number
        {
            return _dRotation;
        }


        public function set dRotation( value:Number ):void
        {
            _dRotation = value;
        }


        public function get startRotation():Number
        {
            return _startRotation;
        }


        public function set startRotation( value:Number ):void
        {
            _startRotation = value;
        }


        public function get brushClass():Class
        {
            return _brushClass;
        }


        public function set brushClass( value:Class ):void
        {
            _brushClass = value;
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}