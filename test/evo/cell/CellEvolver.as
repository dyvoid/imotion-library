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

package test.evo.cell
{
    import test.evo.shapeshifter.*;
    import nl.imotion.evo.genes.CollectionGene;
    import nl.imotion.evo.genes.IntGene;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.evolvers.BitmapEvolver;
    import nl.imotion.evo.evolvers.IEvolver;
    import nl.imotion.evo.genes.LimitMethod;
    import nl.imotion.evo.genes.NumberGene;
    import nl.imotion.evo.genes.UintGene;

    import test.evo.util.Texture;


    /**
     * @author Pieter van de Sluis
     * Date: 19-sep-2010
     * Time: 20:06:56
     */
    public class CellEvolver extends BitmapEvolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _x:Number = 0;
        private var _y:Number = 0;

        private var _width:Number = 0;
        private var _height:Number = 0;

        private var _minSurfaceSize:Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function CellEvolver( areaWidth:Number, areaHeight:Number, minSurfaceSize:Number )
        {
            super( new Cell(), areaWidth, areaHeight );

            _minSurfaceSize = minSurfaceSize;

            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function mutate( mutationDampening:Number = 0, updateMomentum:Boolean = false ):Genome
        {
            super.mutate( mutationDampening, updateMomentum );

            genome.apply( evoTarget );

            return genome;
        }


        override public function reset():IEvolver
        {
            momentumCalc.reset();
            fitness = 0;

            return this;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            genome = new Genome();

            genome.addGene( new NumberGene( "x", 0, areaWidth, 0, LimitMethod.CUT_OFF, 0 ) );
            genome.addGene( new NumberGene( "y", 0, areaHeight, 0, LimitMethod.CUT_OFF, 0 ) );

            genome.addGene( new NumberGene( "width", 0, areaWidth, 0, LimitMethod.CUT_OFF, 0 ) );
            genome.addGene( new NumberGene( "height", 0, areaHeight, 0, LimitMethod.CUT_OFF, 0 ) );

            genome.addGene( new UintGene( "colorR", 0x00, 0xFF, 0.15, LimitMethod.BOUNCE ) );
            genome.addGene( new UintGene( "colorG", 0x00, 0xFF, 0.15, LimitMethod.BOUNCE ) );
            genome.addGene( new UintGene( "colorB", 0x00, 0xFF, 0.15, LimitMethod.BOUNCE ) );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        private function get cell():Cell
        {
            return evoTarget as Cell;
        }


        public function get x():Number
        {
            return cell.x;
        }


        public function set x( value:Number ):void
        {
            genome.editGene( "x", { baseValue: value / areaWidth } );
            genome.apply( evoTarget );
        }


        public function get y():Number
        {
            return cell.y;
        }


        public function set y( value:Number ):void
        {
            genome.editGene( "y", { baseValue: value / areaHeight } );
            genome.apply( evoTarget );
        }


        public function get width():Number
        {
            return cell.width;
        }


        public function set width( value:Number ):void
        {
            genome.editGene( "width", { baseValue: value / areaWidth } );
            genome.apply( evoTarget );
        }


        public function get height():Number
        {
            return cell.height;
        }


        public function set height( value:Number ):void
        {
            genome.editGene( "height", { baseValue: value / areaHeight } );
            genome.apply( evoTarget );
        }


        public function get surfaceSize():Number
        {
            return cell.surfaceSize;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

    }
}