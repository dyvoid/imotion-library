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

package test.evo.brush
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.genes.Gene;
    import nl.imotion.evo.genes.LimitMethod;
    import nl.imotion.evo.genes.NumberGene;
    import nl.imotion.evo.genes.UintGene;
    import nl.imotion.neuralnetwork.BackPropagationNet;
    import nl.imotion.neuralnetwork.training.Exercise;


    /**
     * @author Pieter van de Sluis
     * Date: 16-sep-2010
     * Time: 22:48:15
     */
    public class BrushEvolver extends EvolverSprite

    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _areaWidth:Number;
        private var _areaHeight:Number;

        private var brush:Brush;
        private var brushClass:Class;
        private var brushes:Array = [ Brush1VC, Brush2VC, Brush3VC, Brush4VC, Brush5VC ];

        public var nextEvolver:BrushEvolver;
        public var bestMatch:Bitmap;
        public var minScale:Number = 0.1;
        public var maxScale:Number = 2;

        private var _neuralNet:BackPropagationNet;

        private var _prevMutations:Array;

        private var useNet:Boolean = false;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function BrushEvolver( areaWidth:Number, areaHeight:Number )
        {
            _areaWidth = areaWidth;
            _areaHeight = areaHeight;

            init();
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        override public function init():EvolverSprite
        {
            genome = new Genome( 1 );

            genome.addGene( new NumberGene( "scaleX", Math.random(), 0.1, minScale, maxScale ) );
            genome.addGene( new NumberGene( "scaleY", Math.random(), 0.1, minScale, maxScale ) );
//            genome.addGene( new NumberGene( "x", Math.random(), 0.05, 0, _areaWidth ) );
//            genome.addGene( new NumberGene( "y", Math.random(), 0.05, 0, _areaHeight ) );
            genome.addGene( new NumberGene( "rotation", Math.random(), 0.1, -180, 180, LimitMethod.WRAP ) );
            genome.addGene( new UintGene( "colorR", Math.random(), 0.1, 0, 255, LimitMethod.CUT_OFF ) );
            genome.addGene( new UintGene( "colorG", Math.random(), 0.1, 0, 255, LimitMethod.CUT_OFF ) );
            genome.addGene( new UintGene( "colorB", Math.random(), 0.1, 0, 255, LimitMethod.CUT_OFF ) );

            createNet();

            return this;
        }


        public function reset( minScale:Number = 0.2, maxScale:Number = 1 ):EvolverSprite
        {
            this.minScale = minScale;
            this.maxScale = maxScale;

            /*var xGene:NumberGene = genome.getGeneByPropName( "x" ) as NumberGene;
             xGene.mutationEffect = ( ( 50 - ( minScale * 50 ) ) / 3 ) / _areaWidth;
             xGene.value = Math.random();
             var yGene:NumberGene = genome.getGeneByPropName( "y" ) as NumberGene;
             yGene.mutationEffect = ( ( minScale * 50 ) / 3 ) / _areaHeight;
             yGene.value = Math.random();*/

            var scaleXGene:NumberGene = genome.getGeneByPropName( "scaleX" ) as NumberGene;
            var scaleYGene:NumberGene = genome.getGeneByPropName( "scaleY" ) as NumberGene;
            scaleXGene.minVal =
                    scaleYGene.minVal = minScale;
            scaleXGene.maxVal =
                    scaleYGene.maxVal = maxScale;

            if ( brush && this.contains( brush ) )
                removeChild( brush );

            brushClass = brushes[ Math.floor( Math.random() * brushes.length ) ];
            this.addChild( brush = new brushClass() );
//            this.addChild( brush = new Brush());

//            brush.scaleX = minScale;
//            brush.scaleY = minScale;
            brush.x = Math.random() * _areaWidth;
            brush.y = Math.random() * _areaHeight;

            fitness = 0;
            bestMatch = null;
            previousGenome = null;

            createNet();

            return this;
        }


        override public function reward( fitness:Number ):Genome
        {
            previousGenome = genome.clone();

            doMutation( fitness, true );

            this.fitness = fitness;

            return genome;
        }


        private function doMutation( fitness:Number, updateMomentum:Boolean ):void
        {
            if ( useNet )
            {
                if ( _prevMutations )
                {
                    var exercise:Exercise = new Exercise( 100, 0, false );
                    exercise.addPatterns( _prevMutations, [ fitness ] );

                    _neuralNet.startTraining( exercise );
                }

                var nrOfAttempts:uint = 5;
                var attempts:Array = [];
                var numGenes:uint = genome.genes.length;
                var result:Number = 2;

                for ( var i:int = 0; i < nrOfAttempts; i++ )
                {
                    attempts = [];

                    for ( var j:int = 0; j < numGenes; j++ )
                    {
                        attempts[ j ] = Math.random();
                    }

                    var calc:Number = _neuralNet.run( attempts )[ 0 ];
                    if ( calc < result )
                    {
                        _prevMutations = attempts;
                        result = calc;
                    }
                }

                for ( var k:int = 0; k < numGenes; k++ )
                {
                    var gene:Gene = genome.genes[k];

                    gene.mutate( variation, _prevMutations[k], updateMomentum );
                }
            }
            else
            {
                genome.mutate( variation, updateMomentum );
            }
        }


        override public function punish( fitness:Number ):Genome
        {
            if ( previousGenome )
                genome = previousGenome.clone();

            doMutation( fitness, false );

            return genome;
        }


        public function getBrush():Sprite
        {
            genome.apply( brush );

            return brush;
        }


        public function draw():Bitmap
        {
            genome.apply( brush );

            var bounds:Rectangle = brush.getRect( this );
            var matrix:Matrix = new Matrix();
            matrix.tx = -bounds.left;
            matrix.ty = -bounds.top;

            var bmd:BitmapData = new BitmapData( Math.max( 1, bounds.width ), Math.max( 1, bounds.height ), true, 0x00000000 );
            bmd.draw( this, matrix, null, null, new Rectangle( 0, 0, _areaWidth, _areaHeight ) );

            var bm:Bitmap = new Bitmap( bmd );
            bm.x = brush.x - ( brush.x - bounds.left );
            bm.y = brush.y - ( brush.y - bounds.top );

            return bm;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


        private function createNet():void
        {
//            _neuralNet = new BackPropagationNet();
//            _neuralNet.create( genome.genes.length, 1, 1, 5 );
        }


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function clickHandler( e:MouseEvent ):void
        {
            trace( genome.toXML() );
        }

    }
}