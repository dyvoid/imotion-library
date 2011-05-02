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

package test.evo.benchmark
{
    import com.gskinner.performance.MethodTest;
    import com.gskinner.performance.TestSuite;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.BlendMode;
    import flash.display.Stage;
    import flash.geom.Matrix;
    import flash.geom.Point;


    /**
     * @author Pieter van de Sluis
     * Date: 30-okt-2010
     * Time: 10:04:19
     */
    public class EvoTest extends TestSuite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var numLoops:uint = 20;

        private var _stage:Stage;

        private var sourceImg:BitmapData = new Mona();

        private var bm:Bitmap;

        private var seed1:uint = 1;
        private var seed2:uint = 2;


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function EvoTest( stage:Stage )
        {
            _stage = stage;

            name = "EvoTest";
            initFunction = init;
            tareTest = new MethodTest( tare );
            tests = [
                new MethodTest( compare, null, "Compare", 15, numLoops ),
                new MethodTest( diffMap, null, "DiffMap", 15, numLoops ),
                new MethodTest( diffMap2, null, "DiffMap2", 15, numLoops ),


            ];
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        public function init():void
        {
            var evo:BenchmarkEvo = new BenchmarkEvo();
            evo.init();
            bm = evo.draw();
        }


        private function tare():void
        {
            var bmWidth:uint, bmHeight:uint, sourceSegment:BitmapData;
            var difference:uint, numPixels:uint, numUsedPixels:uint, bmPix:uint, sourcePix:uint;
            var rDiff:Number, gDiff:Number, bDiff:Number;
            var sourceVector:Vector.<uint>, bmVector:Vector.<uint>;
            var fitness:Number;
            var matrix:Matrix = new Matrix();

            bmWidth = bm.width;
            bmHeight = bm.height;
        }


        public function compare():void
        {
            var bmWidth:uint, bmHeight:uint, sourceSegment:BitmapData;
            var difference:uint, numPixels:uint, numUsedPixels:uint, bmPix:uint, sourcePix:uint;
            var rDiff:Number, gDiff:Number, bDiff:Number;
            var sourceVector:Vector.<uint>, bmVector:Vector.<uint>;
            var fitness:Number;
            var matrix:Matrix = new Matrix();

            bmWidth = bm.width;
            bmHeight = bm.height;


            sourceSegment = new BitmapData( bmWidth, bmHeight, false );
            matrix.tx = -bm.x;
            matrix.ty = -bm.y;

            sourceSegment.draw( sourceImg, matrix );

            difference = 0;
            numUsedPixels = 0;

            sourceVector = sourceSegment.getVector( sourceSegment.rect );
            bmVector = bm.bitmapData.getVector( bm.bitmapData.rect );

            numPixels = sourceVector.length;

            for ( var j:int = 0; j < numPixels; j++ )
            {
                bmPix = bmVector[ j ];

                if ( ( bmPix >> 24 & 0xFF ) != 0x00 )
                {
                    sourcePix = sourceVector[ j ];

                    rDiff = ( bmPix >> 16 & 0xFF ) - ( sourcePix >> 16 & 0xFF );
                    gDiff = ( bmPix >> 8 & 0xFF ) - ( sourcePix >> 8 & 0xFF );
                    bDiff = ( bmPix & 0xFF ) - ( sourcePix & 0xFF );

                    difference += ( rDiff >= 0 ) ? rDiff : -rDiff;
                    difference += ( gDiff >= 0 ) ? gDiff : -gDiff;
                    difference += ( bDiff >= 0 ) ? bDiff : -bDiff;

                    numUsedPixels++;
                }
            }

            difference = difference / numUsedPixels;
//            trace(difference)
        }


        public function diffMap():void
        {
            var bmWidth:uint, bmHeight:uint, sourceSegment:BitmapData;
            var difference:uint, numPixels:uint, numUsedPixels:uint, bmPix:uint, sourcePix:uint;
            var rDiff:Number, gDiff:Number, bDiff:Number;
            var sourceVector:Vector.<uint>, bmVector:Vector.<uint>;
            var fitness:Number;
            var matrix:Matrix = new Matrix();

            bmWidth = bm.width;
            bmHeight = bm.height;


            sourceSegment = new BitmapData( bmWidth, bmHeight, true );
            matrix.tx = -bm.x;
            matrix.ty = -bm.y;

            sourceSegment.draw( sourceImg, matrix );
            sourceSegment.draw( bm.bitmapData, null, null, BlendMode.DIFFERENCE );
            sourceSegment.copyChannel( bm.bitmapData, bm.bitmapData.rect, new Point( 0, 0 ), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA );

            difference = 0;
            numUsedPixels = 0;

            bmVector = sourceSegment.getVector( bm.bitmapData.rect );

            numPixels = bmVector.length;

            for ( var j:int = 0; j < numPixels; j++ )
            {
                bmPix = bmVector[ j ];

                if ( ( bmPix >> 24 & 0xFF ) != 0x00 )
                {
                    difference += ( bmPix >> 16 & 0xFF );
                    difference += ( bmPix >> 8 & 0xFF );
                    difference += ( bmPix & 0xFF );

                    numUsedPixels++;
                }
            }

            difference = difference / numUsedPixels;
//            trace(difference)
        }


        public function diffMap2():void
        {
            var bmWidth:uint, bmHeight:uint, sourceSegment:BitmapData;
            var difference:uint, numPixels:uint, numUsedPixels:uint, bmPix:uint, sourcePix:uint;
            var rDiff:Number, gDiff:Number, bDiff:Number;
            var sourceVector:Vector.<uint>, bmVector:Vector.<uint>;
            var fitness:Number;
            var matrix:Matrix = new Matrix();

            bmWidth = bm.width;
            bmHeight = bm.height;


            sourceSegment = new BitmapData( bmWidth, bmHeight, true );
            matrix.tx = -bm.x;
            matrix.ty = -bm.y;

            sourceSegment.draw( sourceImg, matrix );
            sourceSegment.draw( bm.bitmapData, null, null, BlendMode.DIFFERENCE );
//            sourceSegment.copyChannel( bm.bitmapData, bm.bitmapData.rect, new Point(0,0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA );

            difference = 0;
            numUsedPixels = 0;

            bmVector = bm.bitmapData.getVector( bm.bitmapData.rect );
            sourceVector = sourceSegment.getVector( sourceSegment.rect );

            numPixels = bmVector.length;

            for ( var j:int = 0; j < numPixels; j++ )
            {
                if ( ( bmVector[ j ] >> 24 & 0xFF ) != 0x00 )
                {
                    sourcePix = bmVector[ j ];

                    difference += ( sourcePix >> 16 & 0xFF );
                    difference += ( sourcePix >> 8 & 0xFF );
                    difference += ( sourcePix & 0xFF );

                    numUsedPixels++;
                }
            }

            difference = difference / numUsedPixels;
//            trace(difference)
        }


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}