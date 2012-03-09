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

package test.evo.shapeshifter
{
    import flash.display.BitmapData;

    import nl.imotion.evo.genes.CollectionGene;
    import nl.imotion.evo.genes.IntGene;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.evolvers.BitmapEvolver;
    import nl.imotion.evo.evolvers.IEvolver;
    import nl.imotion.evo.genes.LimitMethod;
    import nl.imotion.evo.genes.NumberGene;
    import nl.imotion.evo.genes.UintGene;
    import nl.imotion.utils.range.Range;

    import test.evo.util.Texture;


    /**
     * @author Pieter van de Sluis
     * Date: 19-sep-2010
     * Time: 20:06:56
     */
    public class ShapeShifterEvolver extends BitmapEvolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _minSize        :Number;
        private var _maxSize        :Number;

        private var _sizeRange      :Range;

        private var _complexityMap   :BitmapData;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function ShapeShifterEvolver( areaWidth:Number, areaHeight:Number, complexityMap:BitmapData = null )
        {
            super( new ShapeShifter(), areaWidth, areaHeight );

            _complexityMap = complexityMap;

            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function reset():IEvolver
        {
            genome.editGene( "size", { minVal: minSize, maxVal: maxSize } );
            genome.resetGenes( [ "x", "y", "rotation", "distortionRatio", "seed" ] );

            return super.reset();
        }


        override public function mutate( mutationDampening:Number = 0, updateMomentum:Boolean = false ):Genome
        {
            super.mutate( mutationDampening, updateMomentum );

            if ( _complexityMap )
            {
                var x:Number = genome.getGeneByPropName( "x" ).baseValue * areaWidth;
                var y:Number = genome.getGeneByPropName( "y" ).baseValue * areaHeight;

                var pixelVal:uint = _complexityMap.getPixel( x, y );

                var sizeRatio:Number = 1 - ( ( ( pixelVal >> 16 ) & 0xFF ) / 0xff );
                genome.getGeneByPropName( "size" ).baseValue = sizeRatio;
            }

            return genome;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            genome = new Genome();

            genome.addGene( new UintGene( "x", 0, areaWidth, 0 ) );
            genome.addGene( new UintGene( "y", 0, areaHeight, 0 ) );
            genome.addGene( new IntGene( "rotation", -180, 180, 0.1, LimitMethod.WRAP ) );

//            genome.addGene( new NumberGene( "scaleX", 0.5, 2, 0.1 ) );
//            genome.addGene( new NumberGene( "scaleY", 0.5, 2, 0.1 ) );

            genome.addGene( new CollectionGene( "texture", [ Texture.NOISE ], 0.1 ) );
            genome.addGene( new NumberGene( "textureOffsetX", 0, 1, 0.01, LimitMethod.WRAP ) );
            genome.addGene( new NumberGene( "textureOffsetY", 0,1, 0.01, LimitMethod.WRAP ) );
            genome.addGene( new NumberGene( "textureOffsetRotation", 0, 1, 0.01, LimitMethod.WRAP ) );

            genome.addGene( new UintGene( "seed", 0, 0xffffff, 0 ) );
            genome.addGene( new UintGene( "numPoints", 4, 15, 0.3 ) );
            genome.addGene( new UintGene( "size", 50, 100, 0 ) );
            genome.addGene( new NumberGene( "distortionRatio", 0.2, 0.8, 0.1 ) );

            genome.addGene( new NumberGene( "redMultiplier", 0, 2, 0.1 ) );
            genome.addGene( new NumberGene( "greenMultiplier", 0, 2, 0.1 ) );
            genome.addGene( new NumberGene( "blueMultiplier", 0, 2, 0.1 ) );

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

            if ( _maxSize )
            {
                _sizeRange = new Range( _minSize, _maxSize );
            }
        }


        public function get maxSize():Number
        {
            return _maxSize;
        }

        public function set maxSize( value:Number ):void
        {
            _maxSize = value;

            if ( _minSize )
            {
                _sizeRange = new Range( _minSize, _maxSize );
            }
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

    }
}