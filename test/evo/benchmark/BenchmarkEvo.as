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
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.evolvers.Evolver;
    import nl.imotion.evo.genes.CollectionGene;
    import nl.imotion.evo.genes.IntGene;
    import nl.imotion.evo.genes.LimitMethod;
    import nl.imotion.evo.genes.NumberGene;
    import nl.imotion.evo.genes.UintGene;

    import nl.imotion.evo.evolvers.IEvolver;
    import test.evo.util.Texture;
    import test.evo.shapeshifter.ShapeShifter;


    /**
     * @author Pieter van de Sluis
     * Date: 30-okt-2010
     * Time: 10:11:26
     */
    public class BenchmarkEvo extends Evolver implements IEvolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _areaWidth:uint = 320;
        private var _areaHeight:uint = 320;

        private var _container:Sprite;

        private var _shapeShifter:ShapeShifter;

        private var _lastDraw:Bitmap;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function BenchmarkEvo()
        {
            super();
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function init():Evolver
        {
            genome = new Genome();

            genome.addGene( new UintGene( "x", 0, _areaWidth, 0, "bounce", 0.5 ) );
            genome.addGene( new UintGene( "y", 0, _areaHeight, 0, "bounce", 0.5 ) );

            genome.addGene( new IntGene( "rotation", -180, 180, 0, LimitMethod.WRAP, 0.5 ) );
            genome.addGene( new CollectionGene( "texture", [ Texture.ABSTRACT ], 0, "wrap", 0.5 ) );

            genome.addGene( new UintGene( "seed", 0, 0xffffff, 0, "bounce", 0.1 ) );
            genome.addGene( new UintGene( "numPoints", 4, 15, 0, "bounce", 0.5 ) );
            genome.addGene( new UintGene( "size", 50, 100, 0, "bounce", 0.5 ) );
            genome.addGene( new NumberGene( "distortionRatio", 0.6, 0.8, 0, "bounce", 0.5 ) );

            genome.addGene( new NumberGene( "colorR", 0, 1, 0, "bounce", 0.5 ) );
            genome.addGene( new NumberGene( "colorG", 0, 1, 0, "bounce", 0.5 ) );
            genome.addGene( new NumberGene( "colorB", 0, 1, 0, "bounce", 0.5 ) );

            _container = new Sprite();

            _shapeShifter = new ShapeShifter();
            _container.addChild( _shapeShifter );

            return this;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


        public function draw():Bitmap
        {
            genome.apply( _shapeShifter );
            _shapeShifter.update();

            var bounds:Rectangle = _shapeShifter.getRect( _container );

            var leftExtra:Number = ( bounds.left < 0 ) ? -bounds.left : 0;
            var topExtra:Number = ( bounds.top < 0 ) ? -bounds.top : 0;
            var rightExtra:Number = ( bounds.right > _areaWidth ) ? bounds.right - _areaWidth : 0;
            var bottomExtra:Number = ( bounds.bottom > _areaHeight ) ? bounds.bottom - _areaHeight : 0;

            var matrix:Matrix = new Matrix();
            matrix.tx = -bounds.left - leftExtra;
            matrix.ty = -bounds.top - topExtra;

            var bWidth:Number = Math.max( 1, bounds.width - leftExtra - rightExtra );
            var bHeight:Number = Math.max( 1, bounds.height - topExtra - bottomExtra );

            var bmd:BitmapData = new BitmapData( bWidth, bHeight, true, 0x00000000 );
            bmd.draw( _container, matrix );

            _lastDraw = new Bitmap( bmd );
            _lastDraw.x = _shapeShifter.x - ( _shapeShifter.x - bounds.left ) + leftExtra;
            _lastDraw.y = _shapeShifter.y - ( _shapeShifter.y - bounds.top ) + topExtra;

            var bm:Bitmap = new Bitmap( bmd );
            bm.transform.matrix = _lastDraw.transform.matrix;

            return bm;
        }


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get previous():IEvolver
        {
            return null;
        }


        public function set previous( value:IEvolver ):void
        {
        }


        public function get next():IEvolver
        {
            return null;
        }


        public function set next( value:IEvolver ):void
        {
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}