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

package test.evo.voronoi
{
    import com.nodename.Delaunay.Voronoi;

    import flash.display.Bitmap;

    import flash.geom.Point;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.evolvers.BitmapEvolver;
    import nl.imotion.evo.evolvers.IEvolver;
    import nl.imotion.evo.genes.IntGene;
    import nl.imotion.evo.genes.LimitMethod;
    import nl.imotion.evo.genes.NumberGene;
    import nl.imotion.evo.genes.UintGene;


    /**
     * @author Pieter van de Sluis
     * Date: 19-sep-2010
     * Time: 20:06:56
     */
    public class VoronoiRegionEvolver extends BitmapEvolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES



        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function VoronoiRegionEvolver( areaWidth:Number, areaHeight:Number )
        {
            super( new VoronoiRegion(), areaWidth, areaHeight );

            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        override public function getBitmap():Bitmap
        {
            bitmap = null;

            return super.getBitmap();
        }


        override public function reset():IEvolver
        {
            genome.resetGenes( [ "colorR", "colorG", "colorB" ] );

            return super.reset();
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            genome = new Genome();

            genome.addGene( new NumberGene( "centerX", 0, areaWidth, 0 ) );
            genome.addGene( new NumberGene( "centerY", 0, areaHeight, 0 ) );

            genome.addGene( new NumberGene( "textureOffsetX", 0.1, 0.9, 0.00, LimitMethod.WRAP ) );
            genome.addGene( new NumberGene( "textureOffsetY", 0.1, 0.9, 0.00, LimitMethod.WRAP ) );
            genome.addGene( new NumberGene( "textureOffsetRotation", 0.5, 0.7, 0.00, LimitMethod.WRAP ) );

            genome.addGene( new NumberGene( "colorR", 0x00, 0xff, 0.3 ) );
            genome.addGene( new NumberGene( "colorG", 0x00, 0xff, 0.3 ) );
            genome.addGene( new NumberGene( "colorB", 0x00, 0xff, 0.3 ) );

            genome.addGene( new NumberGene( "redMultiplier", 0, 2, 0.1 ) );
            genome.addGene( new NumberGene( "greenMultiplier", 0, 2, 0.1 ) );
            genome.addGene( new NumberGene( "blueMultiplier", 0, 2, 0.1 ) );

            genome.apply( evoTarget );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get point():Point
        {
            return VoronoiRegion( evoTarget ).point;
        }


        public function set voronoi( value:Voronoi ):void
        {
            VoronoiRegion( evoTarget ).voronoi = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

    }
}