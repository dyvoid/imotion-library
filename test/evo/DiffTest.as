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

package test.evo
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Matrix;

    import test.evo.brush.BrushEvolver;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(width="1024",height="700")]
    public class DiffTest extends Sprite
    {
        private var holder:Sprite;
        private var sourceImg:Bitmap;

        private var evo:BrushEvolver;


        private var fitness:Number;


        public function DiffTest():void
        {
            if ( stage ) init();
            else addEventListener( Event.ADDED_TO_STAGE, init );
        }


        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, init );

            holder = new Sprite();
            holder.x = holder.y = 70;
            this.addChild( holder );

            sourceImg = new Bitmap( new TestPic() as BitmapData );
            sourceImg.x = sourceImg.width + 20;
            holder.addChild( sourceImg );

            evo = new BrushEvolver( sourceImg.width, sourceImg.height );
            evo.reset( 0.5, 1 );

            evolve();
//            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }


        private function enterFrameHandler( e:Event ):void
        {
            evolve();
        }


        private function evolve():void
        {
            var bm:Bitmap = evo.draw();
            var bmWidth:uint = bm.width;
            var bmHeight:uint = bm.height;

            var sourceSegment:BitmapData = new BitmapData( bmWidth, bmHeight, false );
            var matrix:Matrix = new Matrix()
            matrix.tx = -bm.x;
            matrix.ty = -bm.y;
            sourceSegment.draw( sourceImg, matrix );

            var difference:uint = 0;
            var pixelCount:uint = 0;

            var bmPix:uint;
            var sourcePix:uint;
            var difPix:uint;

            var rDiff:Number;
            var gDiff:Number;
            var bDiff:Number;


//            var dif:BitmapData = bm.bitmapData.compare( sourceSegment ) as BitmapData;
            var dif:BitmapData = sourceSegment.compare( bm.bitmapData ) as BitmapData;
            /*
             //

             for ( var j:int = 0; j < bmHeight; j++ )
             {
             for ( var k:int = 0; k < bmWidth; k++ )
             {
             bmPix = bm.bitmapData.getPixel32( k, j );

             if ( ( bmPix >> 24 & 0xFF ) == 0xff )
             //                    if ( bmPix != 0x00000000 )
             {
             difPix = dif.getPixel( k, j );

             rDiff = ( difPix >> 16 & 0xFF );
             gDiff = ( difPix >> 8 & 0xFF );
             bDiff = ( difPix & 0xFF );

             difference += rDiff;
             difference += gDiff;
             difference += bDiff;

             pixelCount ++;
             }

             }
             }*/

            for ( var j:int = 0; j < bmHeight; j++ )
            {
                for ( var k:int = 0; k < bmWidth; k++ )
                {
                    bmPix = bm.bitmapData.getPixel32( k, j );

                    if ( bmPix != 0x00000000 )
//                    if ( ( bmPix >> 24 & 0xFF ) == 0xff )
                    {
                        sourcePix = sourceSegment.getPixel( k, j );

                        rDiff = ( bmPix >> 16 & 0xFF ) - ( sourcePix >> 16 & 0xFF );
                        gDiff = ( bmPix >> 8 & 0xFF ) - ( sourcePix >> 8 & 0xFF );
                        bDiff = ( bmPix & 0xFF ) - ( sourcePix & 0xFF );

                        difference += ( rDiff > 0 ) ? rDiff : -rDiff;
                        difference += ( gDiff > 0 ) ? gDiff : -gDiff;
                        difference += ( bDiff > 0 ) ? bDiff : -bDiff;

                        pixelCount ++;
                    }

                }
            }

            /*difPix = dif.getPixel( 25, 25 );
             difference=0;
             rDiff = ( difPix >> 16 & 0xFF );
             gDiff = ( difPix >> 8 & 0xFF );
             bDiff = ( difPix & 0xFF );

             difference += rDiff;
             difference += gDiff;
             difference += bDiff;
             trace( "r:"+(difPix >> 16 & 0xFF));
             trace("rDiff:"+rDiff)
             trace( "g:"+(difPix >> 8 & 0xFF ));
             trace("gDiff:"+gDiff)
             trace( "b:"+(difPix & 0xFF));
             trace("bDiff:"+bDiff)
             trace("pixel::"+(bm.width*bm.height)+"::"+pixelCount)

             pixelCount=1;

             difference = difference / pixelCount;

             trace( "diff:"+difference);*/


            /*bmPix = bm.bitmapData.getPixel32( 25, 25 );
             sourcePix = sourceSegment.getPixel( 25, 25 );
             difference=0;
             rDiff = ( bmPix >> 16 & 0xFF ) - ( sourcePix >> 16 & 0xFF );
             gDiff = ( bmPix >> 8 & 0xFF ) - ( sourcePix >> 8 & 0xFF );
             bDiff = ( bmPix & 0xFF ) - ( sourcePix & 0xFF );

             difference += ( rDiff > 0 ) ? rDiff : -rDiff;
             difference += ( gDiff > 0 ) ? gDiff : -gDiff;
             difference += ( bDiff > 0 ) ? bDiff : -bDiff;
             trace( "r:"+(bmPix >> 16 & 0xFF) + "::" + ( sourcePix >> 16 & 0xFF ) );
             trace("rDiff:"+rDiff)
             trace( "g:"+(bmPix >> 8 & 0xFF )+ "::" + (sourcePix >> 8 & 0xFF));
             trace("gDiff:"+gDiff)
             trace( "b:"+(bmPix & 0xFF) + "::" + ( sourcePix & 0xFF ));
             trace("bDiff:"+bDiff)
             trace("pixel::"+(bm.width*bm.height)+"::"+pixelCount)

             pixelCount=1;*/

            difference = difference / pixelCount;

            trace( "pixel::" + (bm.width * bm.height) + "::" + pixelCount )
            trace( "diff:" + difference );

            //765 is the worst fitness, where every color value is 255
            var fitness:Number = 1 - ( difference / 765 );

            trace( "fitness:" + fitness );

            if ( evo.fitness < fitness )
            {
                evo.reward( fitness );

                if ( evo.bestMatch && this.contains( evo.bestMatch ) )
                    holder.removeChild( evo.bestMatch );

                holder.addChild( evo.bestMatch = bm );
            }
            else
            {
                evo.punish( fitness );
            }


            var difB:Bitmap = new Bitmap( dif );

            var sourb:Bitmap = new Bitmap( sourceSegment );
            sourb.x = sourb.width + 10;

            var bmb:Bitmap = new Bitmap( bm.bitmapData.clone() );
            bmb.x = bm.width * 2 + 20;

            var bmb2:Bitmap = new Bitmap( bm.bitmapData.clone() );
            bmb2.alpha = 0.5;
            bmb2.x = bm.x + sourceImg.width + 20;
            bmb2.y = bm.y;
            holder.addChild( bmb2 );

            this.addChild( difB );
            this.addChild( sourb );
            this.addChild( bmb );

        }


    }

}