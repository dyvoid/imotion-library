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

package nl.imotion.evo.evolvers
{
    import flash.display.Sprite;

    import nl.imotion.evo.Genome;


    /**
     * @author Pieter van de Sluis
     * Date: 14-sep-2010
     * Time: 21:47:11
     */
    public class EvolverSprite extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _genome:Genome;

        private var _previousGenome:Genome;

        private var _momentum:Number;

        private var _variation:Number = 0.1;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function EvolverSprite()
        {
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function init():EvolverSprite
        {
            return this;
        }


        public function reward():Genome
        {
            _previousGenome = _genome.clone();

            _variation -= 0.001;

            _genome.mutate( _variation );
            _genome.apply( this );

            return _genome;
        }


        public function punish():Genome
        {
            if ( _previousGenome )
                _genome = _previousGenome.clone();

//            _variation += 0.0001;

            _genome.mutate( _variation );
            _genome.apply( this );



            return _genome;
        }


        public function create( genome:Genome ):EvolverSprite
        {
            return null;
        }


        public function clone():EvolverSprite
        {
            return null;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get genome():Genome
        {
            return _genome;
        }


        public function set genome( value:Genome ):void
        {
            _genome = value;
        }


        public function get previousGenome():Genome
        {
            return _previousGenome;
        }


        public function get momentum():Number
        {
            return _momentum;
        }


        public function set momentum( value:Number ):void
        {
            _momentum = value;
        }


        public function get variation():Number
        {
            return _variation;
        }


        public function set variation( value:Number ):void
        {
            _variation = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }
}