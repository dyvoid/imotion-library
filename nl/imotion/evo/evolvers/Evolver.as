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
    import nl.imotion.evo.*;


    /**
     * @author Pieter van de Sluis
     * Date: 13-sep-2010
     * Time: 22:07:02
     */
    public class Evolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _genome:Genome;

        private var _previousGenome:Genome;

        private var _momentum:Number;

        private var _variation:Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Evolver( genome:Genome )
        {
            _genome = genome;
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        public function init():Evolver
        {
            return this;
        }


        public function reward():Genome
        {
            return null;
        }


        public function punish():Genome
        {
            return null;
        }


        public function create( genome:Genome ):Evolver
        {
            return null;
        }


        public function clone():Evolver
        {
            return null;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE

        /*        private function addNumberGene( propertyName:String, variation:Number, minVal:Number, maxVal:Number ):void
         {

         }


         private function addIntGene( propertyName:String, variation:Number, minVal:int, maxVal:int ):void
         {

         }


         private function addBooleanGene( propertyName:String, variation:Number ):void
         {

         }*/

        // ____________________________________________________________________________________________________
        // PROTECTED

        /*        protected function addConstrainedGene( propertyName:String, variation:Number, minVal:Number, maxVal:Number ):void
         {

         }


         protected function addCollectionGene( propertyName:String, variation:Number, collection:Array ):void
         {

         }*/

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