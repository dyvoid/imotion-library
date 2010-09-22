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

package nl.imotion.evo.genes
{
    /**
     * @author Pieter van de Sluis
     * Date: 13-sep-2010
     * Time: 22:09:12
     */
    public class Gene
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _propName:String;

        private var _value:Number = 0.5;

        private var _mutationEffect:Number = 0.5;

        private var _limitMethod:String;

        private var _momentum:Number = 0;
        private var _momentumEffect:Number = 0.5;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Gene( propName:String, value:Number, mutationEffect:Number, limitMethod:String = "bounce" )
        {
            _propName = propName;
            _value = value;
            _mutationEffect = mutationEffect;
            _limitMethod = limitMethod;
        }


        // ____________________________________________________________________________________________________
        // PUBLIC

        public function mutate( globalMutationEffect:Number = 1, mutationSeed:Number = -1, updateMomentum:Boolean = false ):Gene
        {
            mutationSeed = ( mutationSeed >= 0 && mutationSeed <= 1 ) ? mutationSeed : Math.random();

            var newVal:Number = _value + ( ( mutationSeed * 2 - 1 ) * globalMutationEffect * _mutationEffect ) + _momentum;

            if ( newVal < -1 ) newVal = -1;
            if ( newVal >  2 ) newVal =  2;

            if ( newVal < 0 || newVal > 1 )
            {
                switch ( _limitMethod )
                {
                    case LimitMethod.BOUNCE:
                        newVal = ( newVal < 0 ) ? -newVal : 1 - ( newVal - 1 );
                    break;

                    case LimitMethod.WRAP:
                        newVal = ( newVal < 0 ) ?  1 + newVal : newVal - 1;
                    break;

                    case LimitMethod.CUT_OFF:
                        newVal = ( newVal < 0 ) ? 0 : 1;
                    break;
                }
            }

            if ( updateMomentum )
                _momentum = ( newVal - _value ) * _momentumEffect;
//            _momentum = 0;
            
            _value = newVal;

            return this;
        }


        public function getValue():*
        {
            throw new Error( "This method should be overridden in a subclass" );

            return null;
        }


        public function clone():Gene
        {
            return new Gene( _propName, _value, _mutationEffect );
        }


        public function toXML():XML
        {
            var xml:XML =
                    <gene type="gene" propName={propName} value={value} mutationEffect={mutationEffect} limitMethod={limitMethod} />

            return xml;
        }


        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS
        

        public function get propName():String
        {
            return _propName;
        }


        public function get value():Number
        {
            return _value;
        }


        public function set value( value:Number ):void
        {
            _value = value;
        }


        public function get mutationEffect():Number
        {
            return _mutationEffect;
        }

        public function set mutationEffect( value:Number ):void
        {
            _mutationEffect = value;
        }


        public function get limitMethod():String
        {
            return _limitMethod;
        }


        public function set limitMethod( value:String ):void
        {
            _limitMethod = value;
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}