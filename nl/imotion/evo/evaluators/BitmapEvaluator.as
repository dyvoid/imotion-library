/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2009-2013 Pieter van de Sluis
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

package nl.imotion.evo.evaluators
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.geom.Matrix;
    import flash.utils.getTimer;

    import nl.imotion.evo.evolvers.IBitmapEvolver;


    /**
     * @author Pieter van de Sluis
     */
    public class BitmapEvaluator implements IFitnessEvaluator
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _sourceBitmapData:BitmapData;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function BitmapEvaluator( sourceBitmapData:BitmapData = null )
        {
            _sourceBitmapData = sourceBitmapData;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function evaluate( data:* ):Number
        {
            if ( !data is IBitmapEvolver ) throw new Error( "data should be of type Bitmap" );

            var bm:Bitmap = IBitmapEvolver( data ).getBitmap();

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

            sourceSegment.draw( _sourceBitmapData, matrix );

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




            /*var diffMap:BitmapData = new BitmapData( bm.width, bm.height, false );
            diffMap.draw( _sourceBitmapData, new Matrix( 1, 0, 0, 1, -bm.x, -bm.y ) );
            diffMap.draw( bm.bitmapData, null, null, BlendMode.DIFFERENCE );

            var difference:int = 0;
            var numUsedPixels:int = 0;

            var sourceVector:Vector.<uint> = diffMap.getVector( diffMap.rect );
            var bmVector:Vector.<uint> = bm.bitmapData.getVector( bm.bitmapData.rect );

            var i:int = 0;
            var numSourcePixels:int = sourceVector.length;
            var sourcePix:uint;

            do
            {
                if ( ( bmVector[ i ] >> 24 & 0xFF ) != 0x00 )
                {
                    sourcePix = sourceVector[ i ];

                    difference += ( sourcePix >> 16 & 0xFF );
                    difference += ( sourcePix >> 8 & 0xFF );
                    difference += ( sourcePix & 0xFF );

                    numUsedPixels++;
                }
            } while ( ++i < numSourcePixels );

            difference = difference / numUsedPixels;*/

            //765 is the worst fitness, where every color channel difference is 255
            return 1 - ( difference / 765 );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get sourceBitmapData():BitmapData
        {
            return _sourceBitmapData;
        }

        public function set sourceBitmapData( value:BitmapData ):void
        {
            _sourceBitmapData = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}