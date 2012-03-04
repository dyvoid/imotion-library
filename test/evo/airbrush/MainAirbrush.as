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
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.utils.getTimer;

    import nl.imotion.evo.evolvers.IEvolver;

    import nl.imotion.utils.momentum.MomentumCalculator;

    import test.evo.*;


    /**
     * @author Pieter van de Sluis
     * Date: 19-sep-2010
     * Time: 19:47:55
     */
    [SWF(backgroundColor="#000000",width="1024",height="700",frameRate="31")]
    public class MainAirbrush extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var firstEvo:IEvolver;

        private var targetPopulationFitness:Number = 0.99;
        private var minGenerationMomentum:Number = 0.0001;

        private var populationFitness:Number;

        private var sourceImg:Bitmap;

        private var holder:Sprite;
        private var layer:Sprite;

        private var startTime:Number;

        private var numGenerations:uint = 0;

        private var numPopulations:uint = 1;
        private var maxNumPopulations:uint = 10;

        private var numEvos:uint = 0;
        private var minSize:uint = 0;
        private var maxSize:uint = 0;

        private var startMinSize:Number = 60;
        private var startMaxSize:Number = 90;
        private var endMinSize:Number = 2;
        private var endMaxSize:Number = 4;

        private var startEvos:uint = 50;
        private var endEvos:uint = 450;

        private var evoList:Array = [];

        private var momentumCalc:MomentumCalculator;


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function MainAirbrush()
        {
            sourceImg = new Bitmap( new Pieter() as BitmapData );
            sourceImg.x = 100 + sourceImg.width + 50;
            sourceImg.y = 50;
            this.addChild( sourceImg );

            holder = new Sprite();
            holder.x = holder.y = 50;
            this.addChild( holder );

            numEvos = startEvos;
            minSize = startMinSize;
            maxSize = startMaxSize;

            firstEvo = new AirbrushEvolver( sourceImg.width, sourceImg.height );
            evoList[ 0 ] = firstEvo;

            resetAndCreateEvos();

            startTime = getTimer();

//            var s:ShapeShifter = new ShapeShifter();
//            s.update();
//            holder.addChild(s)

//            evolve();

            momentumCalc = new MomentumCalculator( 8 );

            addEventListener( Event.ENTER_FRAME, enterFrameHandler );
        }


        public function getValue( minVal:int, maxVal:int ):int
        {

//            return minVal + Math.round( Math.random() * ( maxVal - minVal ) );
            return minVal + Math.floor( Math.random() * (  maxVal + 0.99999999 - minVal ) );
        }


        private function resetAndCreateEvos():void
        {
            var evoCount:Number = 1;
            var evo:IEvolver = firstEvo;

            do
            {
                AirbrushEvolver( evo ).reset( minSize, maxSize );

                if ( !evo.next && evoCount < numEvos )
                {
                    evo.next = new AirbrushEvolver( sourceImg.width, sourceImg.height );
                    evo.next.previous = evo;
                    evoList.push( evo.next );
                }

                evoCount++;

                evo = evo.next;

            }
            while ( evo );

            layer = new Sprite();
            holder.addChild( layer );
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        private function enterFrameHandler( e:Event ):void
        {
            evolve();
        }


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function evolve():void
        {
            var evo:IEvolver;

            evo = firstEvo;

            var matrix:Matrix = new Matrix();
            var newPopulationFitness:Number = 0;

            do
            {
                var bm:Bitmap = evo.draw();
                var bmWidth:uint = bm.width;
                var bmHeight:uint = bm.height;

                var sourceSegment:BitmapData = new BitmapData( bmWidth, bmHeight, false );
                matrix.tx = -bm.x;
                matrix.ty = -bm.y;

                sourceSegment.draw( sourceImg, matrix );

                var difference:uint = 0;
                var numUsedPixels:uint = 0;

                var bmPix:uint;
                var sourcePix:uint;

                var rDiff:Number;
                var gDiff:Number;
                var bDiff:Number;

                var sourceVector:Vector.<uint> = sourceSegment.getVector( sourceSegment.rect );
                var bmVector:Vector.<uint> = bm.bitmapData.getVector( bm.bitmapData.rect );

                var numPixels:Number = sourceVector.length;

                for ( var j:int = 0; j < numPixels; j++ )
                {
                    bmPix = bmVector[ j ];

                    if ( bmPix != 0x00000000 )
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

                //765 is the worst fitness, where every color channel difference is 255
                var fitness:Number = 1 - ( difference / 765 );

                if ( evo.fitness < fitness )
                {
                    var s:AirbrushEvolver = evo as AirbrushEvolver;
                    if ( s.bestDraw && layer.contains( s.bestDraw ) )
                        layer.removeChild( s.bestDraw );

                    evo.reward( fitness );

                    layer.addChild( s.bestDraw );
                }
                else
                {
                    evo.punish( fitness );
                }

                newPopulationFitness += evo.fitness;

                evo = evo.next;

            }
            while ( evo );

            newPopulationFitness = newPopulationFitness / numEvos;
            momentumCalc.addSample( newPopulationFitness );
            numGenerations++;
            trace( "[" + numPopulations + "/" + maxNumPopulations + ":" + numGenerations + "] Fitness:" + newPopulationFitness + ". Momentum:" + momentumCalc.momentum );

            if ( newPopulationFitness > targetPopulationFitness || momentumCalc.momentum < minGenerationMomentum )
            {
                trace( "finished population: " + ( numPopulations ) );

                evoList.sortOn( "fitness", Array.DESCENDING | Array.NUMERIC );

                for each ( var evolver:AirbrushEvolver in evoList )
                {
                    if ( evolver.bestDraw )
                    {
                        layer.addChildAt( evolver.bestDraw, 0 );
                    }
                }

                if ( numPopulations == maxNumPopulations )
                {
                    removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
                    trace( "Done. Total time: " + ( getTimer() - startTime ) );
                    return;
                }

                var relPop:Number = ( numPopulations / ( maxNumPopulations - 1 ) );
                numEvos = relPop * ( endEvos - startEvos ) + startEvos;
                minSize = ( 1 - relPop ) * ( startMinSize - endMinSize ) + endMinSize;
                maxSize = ( 1 - relPop ) * ( startMaxSize - endMaxSize ) + endMaxSize;

                resetAndCreateEvos();

                momentumCalc = new MomentumCalculator();

                numGenerations = 0;
                populationFitness = 0;
                numPopulations++;
            }
            else
            {
                populationFitness = newPopulationFitness;
            }
        }


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}