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
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.genes.LimitMethod;
    import nl.imotion.evo.genes.UintGene;

    import test.evo.*;


    /**
     * @author Pieter van de Sluis
     * Date: 19-sep-2010
     * Time: 20:06:56
     */
    public class AirbrushEvolver extends EvolverSprite implements IEvolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _areaWidth:Number;
        private var _areaHeight:Number;

        private var _previous:IEvolver;
        private var _next:IEvolver;

        private var _minSize:Number;
        private var _maxSize:Number;

        private var _airbrush:Airbrush;

        private var _lastDraw:Bitmap;
        private var _bestDraw:Bitmap;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function AirbrushEvolver( areaWidth:Number, areaHeight:Number )
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

            genome.addGene( new UintGene( "x", 0, _areaWidth, 0.01 ) );
            genome.addGene( new UintGene( "y", 0, _areaHeight, 0.01 ) );
            genome.addGene( new UintGene( "size", 50, 100, 0.2 ) );
            genome.addGene( new UintGene( "seed", 0, 0xffffffff, 0 ) );

            genome.addGene( new UintGene( "colorR", 0, 0xFF, 0.2, LimitMethod.CUT_OFF ) );
            genome.addGene( new UintGene( "colorG", 0, 0xFF, 0.2, LimitMethod.CUT_OFF ) );
            genome.addGene( new UintGene( "colorB", 0, 0xFF, 0.2, LimitMethod.CUT_OFF ) );

            _airbrush = new Airbrush();
            this.addChild( _airbrush );

            return this;
        }


        public function reset( minSize:Number, maxSize:Number ):IEvolver
        {
            _minSize = minSize;
            _maxSize = maxSize;

            var sizeGene:UintGene = genome.getGeneByPropName( "size" ) as UintGene;
            sizeGene.minVal = minSize;
            sizeGene.maxVal = maxSize;

            genome.resetGenes();
            previousGenome = null;

            fitness = 0;
            _lastDraw =
            _bestDraw = null;

            return this;
        }


        public function draw():Bitmap
        {
            genome.apply( _airbrush );
            _airbrush.update();

            var bounds:Rectangle = _airbrush.getRect( this );
            var matrix:Matrix = new Matrix();
            matrix.tx = -bounds.left;
            matrix.ty = -bounds.top;

            var bmd:BitmapData = new BitmapData( Math.max( 1, bounds.width ), Math.max( 1, bounds.height ), true, 0x00000000 );
            bmd.draw( this, matrix );

            _lastDraw = new Bitmap( bmd );
            _lastDraw.x = _airbrush.x - ( _airbrush.x - bounds.left );
            _lastDraw.y = _airbrush.y - ( _airbrush.y - bounds.top );

            var bm:Bitmap = new Bitmap( bmd );
            bm.transform.matrix = _lastDraw.transform.matrix;

            return bm;
        }


        override public function reward( fitness:Number ):Genome
        {
            _bestDraw = _lastDraw;
            _lastDraw = null;
//            variation = 1 - fitness;

            return super.reward( fitness );
        }


        override public function punish( fitness:Number ):Genome
        {
            _lastDraw = null;
//            variation = Math.min( 1, variation + ( variation * 0.01 ) );

            return super.punish( fitness );
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get previous():IEvolver
        {
            return _previous;
        }


        public function set previous( value:IEvolver ):void
        {
            _previous = value;
        }


        public function get next():IEvolver
        {
            return _next;
        }


        public function set next( value:IEvolver ):void
        {
            _next = value;
        }


        public function get lastDraw():Bitmap
        {
            return _lastDraw;
        }


        public function get bestDraw():Bitmap
        {
            return _bestDraw;
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

    }
}