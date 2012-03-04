/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2009-2011 Pieter van de Sluis
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
    import nl.imotion.evo.*;


    /**
     * @author Pieter van de Sluis
     * Date: 13-sep-2010
     * Time: 22:07:02
     */
    public class Evolver implements IEvolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const ERROR_NO_GENOME:String = "Genome has not been set";

        private var _previousGenome     :Genome;
        private var _genome             :Genome;

        private var _fitness            :Number = 0;

        private var _mutationEffect     :Number = 1;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Evolver( genome:Genome = null, fitness:Number = 0 )
        {
            _genome  = genome;
            _fitness = fitness;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function mutate( mutationDampening:Number = 0, updateMomentum:Boolean = true ):Genome
        {
            if ( !genome ) throw new Error( ERROR_NO_GENOME );

            _previousGenome  = _genome.clone();

            return genome.mutate( mutationDampening, updateMomentum );
        }


        public function reward( fitness:Number ):Genome
        {
            if ( !genome ) throw new Error( ERROR_NO_GENOME );

            _previousGenome = null;

            _fitness = fitness;

            return _genome;
        }


        public function punish():Genome
        {
            if ( !genome ) throw new Error( ERROR_NO_GENOME );

            if ( _previousGenome )
                _genome = _previousGenome.clone();

            _previousGenome = null;

            return _genome;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        protected function get previousGenome():Genome
        {
            return _previousGenome;
        }


        protected function set previousGenome( value:Genome ):void
        {
            _previousGenome = value;
        }


        public function get genome():Genome
        {
            return _genome;
        }


        public function set genome( value:Genome ):void
        {
            _genome = value;
            _fitness = 0;
        }


        public function get mutationEffect():Number
        {
            return _mutationEffect;
        }


        public function set mutationEffect( value:Number ):void
        {
            _mutationEffect = value;
        }


        public function get fitness():Number
        {
            return _fitness;
        }


        public function set fitness( value:Number ):void
        {
            _fitness = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }
}