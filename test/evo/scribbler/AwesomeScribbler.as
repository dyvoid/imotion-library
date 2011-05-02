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
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.geom.Point;


    /**
     * @author Pieter van de Sluis
     * Date: 15-okt-2010
     * Time: 20:07:46
     */
    public class AwesomeScribbler extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _life:uint = 1;
        private var _stepLength:Number = 1;

        private var _seed:uint = 0;
        private var _mutateSeed:uint = 0;

        private var _rndMap:BitmapData;
        private var _mutateMap:BitmapData;

        private var _color:uint;


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function AwesomeScribbler()
        {
            super();

            _seed = Math.round( Math.random() * 0xffffffff );
            _mutateSeed = Math.round( Math.random() * 0xffffffff );

//            this.blendMode = BlendMode.ADD;
//            this.filters = [ new BlurFilter( 15, 15 ) ];

            _color = Math.round( Math.random() * 0xFFFFFF );


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

            var rndList:Vector.<uint> = _rndMap.getVector( _rndMap.rect );
            var mutateList:Vector.<uint> = _mutateMap.getVector( _rndMap.rect );

            var points:Vector.<Point> = new Vector.<Point>();

            for ( var i:int = 0; i < _life; i++ )
            {
                var rndVal:Number = rndList[ i ] / 0xFFFFFFFF;
                var mutateVal:Number = mutateList[ i ] / 0xFFFFFFFF * 2 - 1;
                var mutateEffect:Number = i / _life;

                var val:Number = rndVal + ( mutateVal * mutateEffect );

                var angle:Number = ( Math.PI * 2 ) * val;

                var point:Point = new Point( Math.cos( angle ) * _stepLength, Math.sin( angle ) * _stepLength );

                if ( i > 0 )
                {
                    point.x += points[ i - 1 ].x;
                    point.y += points[ i - 1 ].y;
                }

                points.push( point );
            }

            var prevMidPt:Point, midPt:Point, pt1:Point, pt2:Point;

            for ( i = 1; i < _life; i++ )
            {
                pt1 = points[ i - 1 ];
                pt2 = points[ i ];

                midPt = new Point( pt1.x + ( pt2.x - pt1.x ) / 2, pt1.y + ( pt2.y - pt1.y ) / 2 );

                g.lineStyle( 1, 0xff, ( i / _life ) * 0.8, true, "normal" );

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

            _life++
            _stepLength += 0.2;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


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


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}