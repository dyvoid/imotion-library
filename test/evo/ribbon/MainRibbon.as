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
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.utils.getTimer;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(width="1024",height="700")]
    public class MainRibbon extends Sprite
    {
        private var firstEvo:RibbonEvolver;

        private var numEvos:uint = 50;
        private var evoIncrease:Number = 0;
        private var generationIncreaseFactor:Number = 1.05;
        private var lifeLengthFactor:Number = 0.8;
        private var targetPopulationFitness:Number = 0.99;

        private var populationFitness:Number = 0;

        private var sourceImg:Bitmap;
        private var sourceImgBlurred:BitmapData;

        private var numGenerations:uint = 0;
        private var maxGenerations:uint = 220;

        private var numLoops:uint = 0;
        private var maxLoops:uint = 30;

        private var matrix:Matrix = new Matrix();

        private var lifeLength:Number = 180;

        private var startTime:Number;

        private var holder:Sprite;


        private var fitness:Number;


        public function MainRibbon():void
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

            sourceImg = new Bitmap( new Pieter() as BitmapData );
            sourceImg.x = sourceImg.width + 20;
            holder.addChild( sourceImg );

            sourceImgBlurred = sourceImg.bitmapData.clone();
//            sourceImgBlurred.applyFilter( sourceImgBlurred, sourceImgBlurred.rect, new Point( 0, 0), new BlurFilter(10,10))

            firstEvo = new RibbonEvolver( sourceImg.width, sourceImg.height );

            var prevEvo:RibbonEvolver = firstEvo;
            var newEvo:RibbonEvolver;

            for ( var i:int = 0; i < numEvos; i++ )
            {
                newEvo = new RibbonEvolver( sourceImg.width, sourceImg.height );

                prevEvo.nextEvolver = newEvo;
                prevEvo = newEvo;
            }

            startTime = getTimer();

//            evolve();
            addEventListener( Event.ENTER_FRAME, enterFrameHandler );

            /*var ribbonBrush:RibbonBrush = new RibbonBrush();
             this.addChild( ribbonBrush);
             ribbonBrush.x= ribbonBrush.y = 100;
             ribbonBrush.update();*/
        }


        private function enterFrameHandler( e:Event ):void
        {
            evolve();
        }


        private function evolve():void
        {
            var evo:RibbonEvolver;

            evo = firstEvo;

            var newPopulationFitness:Number = 0;

            do
            {
                var bm:Bitmap = evo.draw();
                var bmWidth:uint = bm.width;
                var bmHeight:uint = bm.height;

                var sourceSegment:BitmapData = new BitmapData( bmWidth, bmHeight, false );
                //var m:Matrix = new Matrix()
                matrix.tx = -bm.x;
                matrix.ty = -bm.y;

                sourceSegment.draw( sourceImgBlurred, matrix );

                var difference:uint = 0;
                var pixelCount:uint = 0;

                var bmPix:uint;
                var sourcePix:uint;

                var rDiff:Number;
                var gDiff:Number;
                var bDiff:Number;

                for ( var j:int = 0; j < bmHeight; j++ )
                {
                    for ( var k:int = 0; k < bmWidth; k++ )
                    {
                        bmPix = bm.bitmapData.getPixel32( k, j );

                        if ( bmPix != 0x00000000 )
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

                difference = difference / pixelCount;

                //765 is the worst fitness, where every color channel difference is 255
                var fitness:Number = 1 - ( difference / 765 );

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

                newPopulationFitness += evo.fitness;


                /*if ( evo == firstEvo )
                 {
                 var difB:Bitmap = new  Bitmap(dif);

                 var sourb:Bitmap = new Bitmap(sourceSegment);
                 sourb.x = sourb.width + 10;

                 var bmb:Bitmap = new Bitmap( bm.bitmapData.clone() );
                 bmb.x = bm.width*2 + 20;

                 this.addChild( difB);
                 this.addChild( sourb);
                 this.addChild( bmb);

                 }*/

                evo = evo.nextEvolver;

            }
            while ( evo.nextEvolver )

            newPopulationFitness = newPopulationFitness / numEvos;
            numGenerations++;
            trace( "generation " + numGenerations + " finished. Fitness:" + newPopulationFitness )

            if ( newPopulationFitness > targetPopulationFitness || newPopulationFitness == populationFitness )
            {
                trace( "finished population: " + (numLoops + 1) );
                maxGenerations *= generationIncreaseFactor;

                if ( numLoops == maxLoops )
                {
                    removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
                    trace( "Done. Total time: " + ( getTimer() - startTime ) );
                    return;
                }

                lifeLength = 5 + ( lifeLength * lifeLengthFactor );

                evo = firstEvo;
                evo.reset( lifeLength );

                var evoCount:Number = 1;
                numEvos += evoIncrease;

                while ( evo.nextEvolver )
                {
                    evo = evo.nextEvolver;
                    evo.reset( lifeLength );

                    if ( !evo.nextEvolver && evoCount < numEvos )
                    {
                        evo.nextEvolver = new RibbonEvolver( sourceImg.width, sourceImg.height );
                    }

                    evoCount++;
                }

                numGenerations = 0;
                populationFitness = 0;
                numLoops++;
            }

            populationFitness = newPopulationFitness;
        }


        private function calcFitness():void
        {

        }


    }

}