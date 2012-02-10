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
    import flash.display.BlendMode;
    import flash.events.MouseEvent;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.genes.NumberGene;


    /**
     * @author Pieter van de Sluis
     * Date: 14-sep-2010
     * Time: 21:43:08
     */
    public class BoxEvolver extends EvolverSprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _color:uint;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function BoxEvolver()
        {
            super();

            this.graphics.beginFill( 0xff0000 );
            this.graphics.drawRect( -50, -50, 100, 100 );
            this.blendMode = BlendMode.ADD;

            this.addEventListener( MouseEvent.CLICK, clickHandler );
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        override public function init():EvolverSprite
        {
            genome = new Genome( 0.5 );
            genome.addGene( new NumberGene( "width", Math.random(), 1, 1, 500 ) );
            genome.addGene( new NumberGene( "height", Math.random(), 1, 1, 500 ) );
            genome.addGene( new NumberGene( "x", Math.random(), 1, 100, 700 ) );
            genome.addGene( new NumberGene( "y", Math.random(), 1, 100, 500 ) );

            genome.apply( this );

            return super.init();
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


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