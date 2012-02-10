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
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.genes.CollectionGene;
    import nl.imotion.evo.genes.IntGene;
    import nl.imotion.evo.genes.LimitMethod;
    import nl.imotion.evo.genes.NumberGene;
    import nl.imotion.evo.genes.UintGene;


    /**
     * @author Pieter van de Sluis
     * Date: 18-sep-2010
     * Time: 22:43:22
     */
    public class RibbonEvolver extends EvolverSprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES


        private var _areaWidth:Number;
        private var _areaHeight:Number;

        private var brush:RibbonBrush;
        private var brushClass:Class;
        private var brushes:Array = [ Brush1VC, Brush2VC, Brush3VC, Brush4VC, Brush5VC ];

        public var nextEvolver:RibbonEvolver;
        public var bestMatch:Bitmap;
        public var minScale:Number = 0.1;
        public var maxScale:Number = 2;


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function RibbonEvolver( areaWidth:Number, areaHeight:Number )
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

            genome.addGene( new NumberGene( "minScale", Math.random(), 0.1, 0.03, 0.04 ) );
            genome.addGene( new NumberGene( "maxScale", Math.random(), 0.1, 0.04, 0.1 ) );
            genome.addGene( new UintGene( "lifeLength", Math.random(), 0.1, 3, 180 ) );
            genome.addGene( new NumberGene( "noiseSeed", Math.random(), 0.1, 0, 1 ) );
            genome.addGene( new UintGene( "x", Math.random(), 0, 0, _areaWidth ) );
            genome.addGene( new UintGene( "y", Math.random(), 0, 0, _areaHeight ) );
            genome.addGene( new IntGene( "startRotation", Math.random(), 0.2, -180, 180, LimitMethod.WRAP ) );
            genome.addGene( new NumberGene( "dRotation", Math.random(), 0.1, -12, 12 ) );
//            genome.addGene( new CollectionGene( "dRotation", Math.random(), 0.01,[ -12, -9, -6, -3, 3, 6, 9, 12 ] ) );
            genome.addGene( new CollectionGene( "brushClass", Math.random(), 0.1, brushes ) );
            genome.addGene( new UintGene( "startSpeed", Math.random(), 0.5, 2, 4 ) );
            genome.addGene( new UintGene( "colorR", Math.random(), 0.1, 0, 255, LimitMethod.CUT_OFF ) );
            genome.addGene( new UintGene( "colorG", Math.random(), 0.1, 0, 255, LimitMethod.CUT_OFF ) );
            genome.addGene( new UintGene( "colorB", Math.random(), 0.1, 0, 255, LimitMethod.CUT_OFF ) );

            return this;
        }


        public function reset( maxLifeLength:Number ):EvolverSprite
        {
            var lifeLengthGene:UintGene = genome.getGeneByPropName( "lifeLength" ) as UintGene;
            lifeLengthGene.maxVal = maxLifeLength;

            var xGene:UintGene = genome.getGeneByPropName( "x" ) as UintGene;
            xGene.baseValue = Math.random();
            var yGene:UintGene = genome.getGeneByPropName( "y" ) as UintGene;
            yGene.baseValue = Math.random();

            fitness = 0;
            bestMatch = null;
            previousGenome = null;

            return this;
        }


        public function draw():Bitmap
        {
            brush = new RibbonBrush();
            this.addChild( brush );
            genome.apply( brush );
            brush.update();

            var bounds:Rectangle = brush.getRect( this );
            var matrix:Matrix = new Matrix();
            matrix.tx = -bounds.left;
            matrix.ty = -bounds.top;

            var bmd:BitmapData = new BitmapData( bounds.width, bounds.height, true, 0x00000000 );
            bmd.draw( this, matrix, null, null, new Rectangle( 0, 0, _areaWidth, _areaHeight ) );

            var bm:Bitmap = new Bitmap( bmd );
            bm.x = brush.x - ( brush.x - bounds.left );
            bm.y = brush.y - ( brush.y - bounds.top );

            removeChild( brush );
            brush = null;

            return bm;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}