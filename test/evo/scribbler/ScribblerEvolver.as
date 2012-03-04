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
    import nl.imotion.evo.Genome;
    import nl.imotion.evo.evolvers.BitmapEvolver;
    import nl.imotion.evo.evolvers.IEvolver;
    import nl.imotion.evo.genes.LimitMethod;
    import nl.imotion.evo.genes.NumberGene;
    import nl.imotion.evo.genes.UintGene;


    /**
     * @author Pieter van de Sluis
     * Date: 19-sep-2010
     * Time: 20:06:56
     */
    public class ScribblerEvolver extends BitmapEvolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _minSize        :Number;
        private var _maxSize        :Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function ScribblerEvolver( areaWidth:Number, areaHeight:Number )
        {
            super( new Scribbler(), areaWidth, areaHeight );

            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function reset():IEvolver
        {
            genome.editGene( "stepLength", { minVal: _minSize, maxVal: _maxSize } );
            genome.resetGenes( [ "x", "y", "startAngle", "seed", "mutateSeed" ] );

            return super.reset();
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            genome = new Genome();

            //For good result: keep x/y movement small and straightening high

            genome.addGene( new UintGene( "x", 0, areaWidth, 0.005 ) );
            genome.addGene( new UintGene( "y", 0, areaHeight, 0.005 ) );
            genome.addGene( new NumberGene( "startAngle", 0, Math.PI*2, 0.1, LimitMethod.WRAP ) );

            genome.addGene( new NumberGene( "seed", 0, 1, 0, LimitMethod.WRAP ) );
            genome.addGene( new NumberGene( "mutateSeed", 0, 1, 0.01, LimitMethod.WRAP ) );
            genome.addGene( new UintGene( "stepLength", 1, 75, 0.05 ) );
            genome.addGene( new UintGene( "life", 10, 20, 0.01 ) );
            genome.addGene( new NumberGene( "strokeWidth", 1, 1, 0  ) );
            genome.addGene( new NumberGene( "straightening", 0.85, 0.95, 0.05 ) );

            genome.addGene( new NumberGene( "alpha", 0.5, 1, 0.1 ) );
//            genome.addGene( new NumberGene( "brightness", 0, 0.5, 0.1, LimitMethod.CUT_OFF ) );

//            genome.addGene( new CollectionGene( "colorR", [ 0x00, 0xff ], 0.1, LimitMethod.WRAP, 0 ) );

//            genome.addGene( new NumberGene  ( "colorR", 0x00, 0xFF, 0.1, LimitMethod.CUT_OFF ) );
//            genome.addGene( new NumberGene  ( "colorG", 0x00, 0xFF, 0.1, LimitMethod.CUT_OFF ) );
//            genome.addGene( new NumberGene  ( "colorB", 0x00, 0xFF, 0.1, LimitMethod.CUT_OFF ) );

        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get minSize():Number
        {
            return _minSize;
        }

        public function set minSize( value:Number ):void
        {
            _minSize = value;
        }


        public function get maxSize():Number
        {
            return _maxSize;
        }

        public function set maxSize( value:Number ):void
        {
            _maxSize = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

    }
}