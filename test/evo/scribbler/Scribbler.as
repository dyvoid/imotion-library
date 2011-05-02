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

package test.evo.scribbler
{
    import flash.display.BitmapData;
    import flash.display.CapsStyle;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.geom.Point;


    /**
     * @author Pieter van de Sluis
     * Date: 15-okt-2010
     * Time: 20:07:46
     */
    public class Scribbler extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _life:uint = 10;
        private var _stepLength:uint = 10;

        private var _seed:uint = 0;
        private var _mutateSeed:uint = 0;
        private var _mutateDampening:Number = 0.35;
        private var _straightening:Number = 0.9;

        private var _rndMap:BitmapData;
        private var _mutateMap:BitmapData;

        private var _strokeWidth:Number = 1;

        private var _colorR:uint = 0;
        private var _colorG:uint = 0;
        private var _colorB:uint = 0;


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Scribbler()
        {
            super();
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function update():void
        {
            _rndMap = new BitmapData( _life, 1, true );
            _rndMap.noise( _seed, 0, 255, 1 | 2 | 4 | 8, true );

            _mutateMap = new BitmapData( _life, 1, true );
            _mutateMap.noise( _mutateSeed, 0, 255, 1 | 2 | 4 | 8, true );

            var g:Graphics = this.graphics;
            g.clear();
            var color:uint = ( _colorR << 16 ) | ( _colorR << 8 ) | _colorR;

            var rndList:Vector.<uint> = _rndMap.getVector( _rndMap.rect );
            var mutateList:Vector.<uint> = _mutateMap.getVector( _rndMap.rect );

            var points:Vector.<Point> = new Vector.<Point>();
            var prevAngle:Number;

            for ( var i:int = 0; i < _life; i++ )
            {
                var rndVal:Number = rndList[ i ] / 0xFFFFFFFF;
                var mutateVal:Number = ( mutateList[ i ] / 0xFFFFFFFF ) * 2 - 1;
                var mutateEffect:Number = i / _life;

                var angle:Number = ( Math.PI * 2 ) * ( rndVal + ( mutateVal * mutateEffect * _mutateDampening ) );

                if ( prevAngle && _straightening != 0 )
                {
                    angle = prevAngle + getAnglesDiff( prevAngle, angle ) * ( 1 - _straightening );
                }

                var point:Point = new Point( Math.cos( angle ) * _stepLength, Math.sin( angle ) * _stepLength );

                if ( i > 0 )
                {
                    point.x += points[ i - 1 ].x;
                    point.y += points[ i - 1 ].y;
                }

                points.push( point );
                prevAngle = angle;
            }

            var prevMidPt:Point, midPt:Point, pt1:Point, pt2:Point;

            for ( i = 1; i < _life; i++ )
            {
                g.lineStyle( _strokeWidth, color, i / ( _life - 1 ), false, "normal", CapsStyle.NONE );

                pt1 = points[ i - 1 ];
                pt2 = points[ i ];

                midPt = new Point( pt1.x + ( pt2.x - pt1.x ) / 2, pt1.y + ( pt2.y - pt1.y ) / 2 );

                if ( prevMidPt )
                {
                    g.moveTo( prevMidPt.x, prevMidPt.y );
                    g.curveTo( pt1.x, pt1.y, midPt.x, midPt.y );
                }
                else
                {
                    g.lineTo( midPt.x, midPt.y );
                }

                prevMidPt = midPt;
            }
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


        private function getAnglesDiff( alfa:Number, gamma:Number ):Number
        {
            var dif:Number = (alfa - gamma) % ( Math.PI * 2 );

            if ( dif != dif % Math.PI )
            {
                dif = (dif < 0) ? dif + ( Math.PI * 2 ) : dif - ( Math.PI * 2 );
            }
            return dif;
        }


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get life():uint
        {
            return _life;
        }


        public function set life( value:uint ):void
        {
            _life = value;
        }


        public function get stepLength():uint
        {
            return _stepLength;
        }


        public function set stepLength( value:uint ):void
        {
            _stepLength = value;
        }


        public function get straightening():Number
        {
            return _straightening;
        }


        public function set straightening( value:Number ):void
        {
            _straightening = value;
        }


        public function get seed():uint
        {
            return _seed;
        }


        public function set seed( value:uint ):void
        {
            _seed = value;
        }


        public function get mutateSeed():uint
        {
            return _mutateSeed;
        }


        public function set mutateSeed( value:uint ):void
        {
            _mutateSeed = value;
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


        public function get strokeWidth():Number
        {
            return _strokeWidth;
        }


        public function set strokeWidth( value:Number ):void
        {
            _strokeWidth = value;
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}