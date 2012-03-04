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
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.net.FileReference;
    import flash.utils.getTimer;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.evaluators.BitmapEvaluator;
    import nl.imotion.evo.evolvers.IEvolver;
    import nl.imotion.evo.evolvers.ILinkedEvolver;
    import nl.imotion.evo.evolvers.IBitmapEvolver;
    import nl.imotion.utils.momentum.MomentumCalculator;

    import test.evo.*;


    /**
     * @author Pieter van de Sluis
     * Date: 15-okt-2010
     * Time: 20:10:15
     */

    [SWF(backgroundColor="#ffffff",width="1100",height="900",frameRate="31")]
    public class MainScribbler extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var firstEvo:IBitmapEvolver;

        private var targetPopulationFitness:Number = 0.99;
        private var minGenerationMomentum:Number = 0.0000001;

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

        private var startMinSize:Number = 20;
        private var startMaxSize:Number = 40;
        private var endMinSize:Number = 2;
        private var endMaxSize:Number = 6;

        private var startEvos:uint = 200;
        private var endEvos:uint = 1000;

        private var evaluator:BitmapEvaluator;

        private var redeployTreshold:Number = 0.7;

        //For good result: use small sizes, as below
        /*private var startMinSize:Number = 2;
        private var startMaxSize:Number = 13;
        private var endMinSize:Number = 2;
        private var endMaxSize:Number = 6;

        private var startEvos:uint = 200;
        private var endEvos:uint = 1600;*/

        private var evoList:/*IBitmapEvolver*/Array = [];

        private var momentumCalc:MomentumCalculator;

        private var _displayEnabled:Boolean = true;
        private var _btDisplay:Sprite;

        [Embed(source="../../../../lib/pieter_silhouette_4.jpg")]
        private var SourceImage:Class;


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function MainScribbler()
        {
            /*var sourceBMD:BitmapData = new Pieter();
            var resizedBMD:BitmapData = new BitmapData( sourceBMD.width*2, sourceBMD.height*2, false );
            var matrix:Matrix = new Matrix();
            matrix.scale( 2, 2 );
            resizedBMD.draw( sourceBMD, matrix, null, null, null, true );*/

            sourceImg = new SourceImage();
//            sourceImg = new Bitmap( resizedBMD );
            sourceImg.x = 100 + sourceImg.width + 50;
            sourceImg.y = 50;
//            this.addChild( sourceImg );

            evaluator = new BitmapEvaluator( sourceImg.bitmapData );

            holder = new Sprite();
//            holder.graphics.beginFill( 0x0000ff, 1 )
//            holder.graphics.lineStyle( 1, 0xffffff );
//            holder.graphics.drawRect(0,0,sourceImg.width,sourceImg.height);
            holder.x = holder.y = 50;
            this.addChild( holder );

            _btDisplay = new Sprite();
            _btDisplay.buttonMode = true;
            _btDisplay.graphics.beginFill( 0x000077 )
            _btDisplay.graphics.drawCircle( stage.stageWidth - 50, stage.stageHeight - 50, 20 );
            _btDisplay.alpha = 0.5;
            _btDisplay.addEventListener( MouseEvent.CLICK, btDisplayHandler )
            this.addChild( _btDisplay );

            numEvos = startEvos;
            minSize = startMinSize;
            maxSize = startMaxSize;

            firstEvo = new ScribblerEvolver( sourceImg.width, sourceImg.height );
            evoList[ 0 ] = firstEvo;

            resetAndCreateEvos();

            startTime = getTimer();

//            var s:ShapeShifter = new ShapeShifter();
//            s.update();
//            holder.addChild(s)

//            evolve();

            momentumCalc = new MomentumCalculator( 30 );

            addEventListener( Event.ENTER_FRAME, enterFrameHandler );
        }


        private function resetAndCreateEvos():void
        {
            var evoCount:Number = 1;
            var evo:ILinkedEvolver = firstEvo;

            if ( evoList.length > 1 && numPopulations > 1 )
            {
                var genome1:Genome = evoList[ 0 ].genome.clone();
                var genome2:Genome = evoList[ 1 ].genome.clone();
            }

            do
            {
                if ( !evo.next && evoCount < numEvos )
                {
                    evo.next = new ScribblerEvolver( sourceImg.width, sourceImg.height );
                    evo.next.previous = evo;
                    evoList.push( evo.next );
                }

                if ( evoList.length > 1 && numPopulations > 1 )
                {
                    evo.genome = genome1.mate( genome2 );
                }

                resetEvo( evo );

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
            var evo:IBitmapEvolver = firstEvo;
            var newPopulationFitness:Number = 0;

            do
            {
                if ( IBitmapEvolver( evo ).momentum != 0 || !IBitmapEvolver( evo ).momentumIsReady )
                {
                    evo.mutate();
                    var fitness:Number = evaluator.evaluate( evo );

                    if ( evo.fitness < fitness )
                    {
                        evo.reward( fitness );
                    }
                    else
                    {
                        evo.punish();
                    }
                }
                else if ( evo.fitness < redeployTreshold )
                {
                    var genome1:Genome = evoList[ 0 ].genome.clone();
                    var genome2:Genome = evoList[ 1 ].genome.clone();

                    evo.genome = genome1.mate( genome2 );
                    resetEvo( evo );
                }

                newPopulationFitness += evo.fitness;

                evo = IBitmapEvolver( evo.next );
            }
            while ( evo );

            if ( _displayEnabled )
            {
                clearLayer();

                evo = firstEvo;

                do
                {
                    layer.addChild( ScribblerEvolver( evo ).getBitmap() );

                    evo = IBitmapEvolver( evo.next );
                }
                while ( evo );
            }

            newPopulationFitness = newPopulationFitness / numEvos;
            momentumCalc.addSample( newPopulationFitness );
            numGenerations++;
            trace( "[" + numPopulations + "/" + maxNumPopulations + ":" + numGenerations + "] Fitness:" + newPopulationFitness + ". Momentum:" + momentumCalc.momentum );

            evoList.sortOn( "fitness", Array.DESCENDING | Array.NUMERIC );

            if ( newPopulationFitness > targetPopulationFitness || ( momentumCalc.isReady && ( Math.abs( momentumCalc.momentum ) < minGenerationMomentum ) ) )
            {
                trace( "finished population: " + ( numPopulations ) );

                clearLayer();
                for each ( var evolver:ScribblerEvolver in evoList )
                {
                    if ( evolver.fitness > redeployTreshold )
                        layer.addChildAt( evolver.getBitmap(), 0 );
                }

                var layerBmd:BitmapData = new BitmapData( sourceImg.width, sourceImg.height, true, 0x00000000 )
                layerBmd.draw( layer );

                holder.addChild( new Bitmap( layerBmd ) );
                holder.removeChild( layer );

                if ( numPopulations == maxNumPopulations )
                {
                    removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
                    trace( "Done. Total time: " + ( getTimer() - startTime ) );
                    _btDisplay.alpha = 1;
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


        private function resetEvo( evo:ILinkedEvolver ):void
        {
            var s:ScribblerEvolver = evo as ScribblerEvolver;

            s.minSize = minSize;
            s.maxSize = maxSize;
            s.reset();
        }


        private function clearLayer():void
        {
            while ( layer.numChildren != 0 )
            {
                layer.removeChildAt( 0 );
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

            var evo:IBitmapEvolver = firstEvo;

            var xml:XML = <root />;

            do
            {
                xml.appendChild( evo.genome.toXML() );

                evo = evo.next as IBitmapEvolver;
            }
            while ( evo );

            var fileRef:FileReference = new FileReference();
            fileRef.save( xml );
        }


    }
}