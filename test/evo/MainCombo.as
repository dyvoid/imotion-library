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
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Matrix;
    import flash.utils.Timer;
    import flash.utils.getTimer;

    import nl.imotion.utils.momentum.MomentumCalculator;

    import test.evo.scribbler.ScribblerEvolver;
    import test.evo.shapeshifter.ShapeShifterEvolver;


    /**
     * @author Pieter van de Sluis
     * Date: 19-sep-2010
     * Time: 19:47:55
     */
    [SWF(backgroundColor="#000000",width="1024",height="700",frameRate="31")]
    public class MainCombo extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var firstEvo:IVisualEvolver;

        private var targetPopulationFitness:Number = 0.99;
        private var minGenerationMomentum:Number = 0.0001;

        private var populationFitness:Number;

        private var sourceImg:Bitmap;

        private var holder:Sprite;
        private var layer:Sprite;

        private var startTime:Number;

        private var numGenerations:uint = 0;

        private var numPopulations:uint = 1;
        private var maxNumPopulations:uint = 15;

        private var numEvos:uint = 0;
        private var minSize:uint = 0;
        private var maxSize:uint = 0;

        private var startMinSize:Number = 50;
        private var startMaxSize:Number = 90;
        private var endMinSize:Number = 3;
        private var endMaxSize:Number = 6;

        private var startEvos:uint = 25;
        private var endEvos:uint = 150;

        private var evoList:/*IVisualEvolver*/Array = [];

        private var momentumCalc:MomentumCalculator;

        private var _displayEnabled:Boolean = true;
        private var _btDisplay:Sprite;

        private var _timer:Timer;


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function MainCombo()
        {
            sourceImg = new Bitmap( new Pieter() as BitmapData );
            sourceImg.x = 100 + sourceImg.width + 50;
            sourceImg.y = 50;
//            this.addChild( sourceImg );

            holder = new Sprite();
            holder.x = holder.y = 50;
            this.addChild( holder );

            _btDisplay = new Sprite();
            _btDisplay.buttonMode = true;
            _btDisplay.graphics.beginFill( 0x000077 )
            _btDisplay.graphics.drawCircle( stage.stageWidth - 50, stage.stageHeight - 50, 20 );
            _btDisplay.addEventListener( MouseEvent.CLICK, btDisplayHandler )
            this.addChild( _btDisplay );

            numEvos = startEvos;
            minSize = startMinSize;
            maxSize = startMaxSize;

            firstEvo = new ScribblerEvolver( sourceImg.width, sourceImg.height );
            evoList[ 0 ] = firstEvo;

            resetAndCreateEvos();

            startTime = getTimer();

            momentumCalc = new MomentumCalculator( 8 );

            addEventListener( Event.ENTER_FRAME, enterFrameHandler );
            /*            _timer = new Timer( 50, 0 );
             _timer.addEventListener( TimerEvent.TIMER, timerTickHandler );
             _timer.start();*/
        }


        private function timerTickHandler( event:TimerEvent ):void
        {
            evolve();
        }


        public function getValue( minVal:int, maxVal:int ):int
        {

//            return minVal + Math.round( Math.random() * ( maxVal - minVal ) );
            return minVal + Math.floor( Math.random() * (  maxVal + 0.99999999 - minVal ) );
        }


        private function resetAndCreateEvos():void
        {
            var evoCount:Number = 1;
            var evo:IVisualEvolver = firstEvo;

            do
            {
                if ( !evo.next && evoCount < numEvos )
                {
                    evo.next = ( Math.random() > 0.1 ) ? new ShapeShifterEvolver( sourceImg.width, sourceImg.height ) : new ScribblerEvolver( sourceImg.width, sourceImg.height );
                    evo.next.previous = evo;
                    evoList.push( evo.next );
                }

                evo.reset( minSize, maxSize );

                evoCount++;

                evo = IVisualEvolver( evo.next );

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
            var evo:IVisualEvolver;
            var bm:Bitmap, bmWidth:uint, bmHeight:uint, sourceSegment:BitmapData;
            var difference:uint, numPixels:uint, numUsedPixels:uint, bmPix:uint, sourcePix:uint;
            var rDiff:int, gDiff:int, bDiff:int;
            var sourceVector:Vector.<uint>, bmVector:Vector.<uint>;
            var fitness:Number;

            evo = firstEvo;
            var newPopulationFitness:Number = 0;
            var matrix:Matrix = new Matrix();

            do
            {
                if ( IVisualEvolver( evo ).momentum != 0 )
                {
                    bm = evo.draw();
                    bmWidth = bm.width;
                    bmHeight = bm.height;

                    sourceSegment = new BitmapData( bmWidth, bmHeight, false );
                    matrix.tx = -bm.x;
                    matrix.ty = -bm.y;

                    sourceSegment.draw( sourceImg, matrix );
                    sourceSegment.draw( bm.bitmapData, null, null, BlendMode.DIFFERENCE );

                    difference = 0;
                    numUsedPixels = 0;

                    sourceVector = sourceSegment.getVector( sourceSegment.rect );
                    bmVector = bm.bitmapData.getVector( bm.bitmapData.rect );

                    numPixels = sourceVector.length;

                    for ( var j:int = 0; j < numPixels; j++ )
                    {
                        if ( ( bmVector[ j ] >> 24 & 0xFF ) != 0x00 )
                        {
                            sourcePix = sourceVector[ j ];

                            difference += ( sourcePix >> 16 & 0xFF );
                            difference += ( sourcePix >> 8 & 0xFF );
                            difference += ( sourcePix & 0xFF );

                            numUsedPixels++;
                        }
                    }

                    /*for ( var j:int = 0; j < numPixels; j++ )
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
                     }*/

                    difference = difference / numUsedPixels;

                    //765 is the worst fitness, where every color channel difference is 255
                    fitness = 1 - ( difference / 765 );

                    if ( evo.fitness < fitness )
                    {
                        if ( evo.bestDraw && layer.contains( evo.bestDraw ) )
                            layer.removeChild( evo.bestDraw );

                        evo.reward( fitness );

                        if ( _displayEnabled )
                            layer.addChild( evo.bestDraw );
                    }
                    else
                    {
                        evo.punish( fitness );
                    }
                }

                newPopulationFitness += evo.fitness;

                evo = IVisualEvolver( evo.next );

            }
            while ( evo );

            newPopulationFitness = newPopulationFitness / numEvos;
            momentumCalc.addSample( newPopulationFitness );
            numGenerations++;
            trace( "[" + numPopulations + "/" + maxNumPopulations + ":" + numGenerations + "] Fitness:" + newPopulationFitness + ". Momentum:" + momentumCalc.momentum );

            if ( newPopulationFitness > targetPopulationFitness || ( momentumCalc.isReady && ( momentumCalc.momentum < minGenerationMomentum ) ) )
            {
                trace( "finished population: " + ( numPopulations ) );

                evoList.sortOn( "fitness", Array.DESCENDING | Array.NUMERIC );

                for each ( var evolver:IVisualEvolver in evoList )
                {
                    if ( evolver.bestDraw )
                    {
                        layer.addChildAt( evolver.bestDraw, 0 );
                    }
                }

                var layerBmd:BitmapData = new BitmapData( sourceImg.width, sourceImg.height, true, 0x00000000 )
                layerBmd.draw( layer );

                holder.addChild( new Bitmap( layerBmd ) )
                holder.removeChild( layer );

                if ( numPopulations == maxNumPopulations )
                {
                    removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
//                    _timer.removeEventListener( TimerEvent.TIMER, timerTickHandler );
                    trace( "Done. Total time: " + ( getTimer() - startTime ) );
                    return;
                }

                var relPop:Number = ( numPopulations / ( maxNumPopulations - 1 ) );
//                relPop = ( 1 - Math.sin( Math.PI / 2 + relPop * Math.PI ) ) / 2; // Nice ease in/out equation
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

        private function btDisplayHandler( e:MouseEvent ):void
        {
            _displayEnabled = !_displayEnabled;
        }


    }
}