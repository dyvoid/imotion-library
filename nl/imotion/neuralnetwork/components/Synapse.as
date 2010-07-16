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

package nl.imotion.neuralnetwork.components
{
	/**
	 * @author Pieter van de Sluis
	 */
	public class Synapse
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _startNeuron:Neuron;
		private var _endNeuron:Neuron;
		
		private var _weight					:Number;
		
		private var _momentum				:Number = 0;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function Synapse( startNeuron:Neuron, endNeuron:Neuron, weight:Number = NaN ) 
		{
			_startNeuron 	= startNeuron;
			_endNeuron = endNeuron;
			
			_weight			= ( isNaN( weight) ) ? Math.random() * 2 - 1 : weight;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function getOutput():Number
		{
			return _startNeuron.value * _weight;
		}
		
		
		public function toXML():XML
		{
			return <synapse weight={_weight} />;
		}
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get startNeuron():Neuron { return _startNeuron; }
		
		public function get endNeuron():Neuron { return _endNeuron; }
		
		public function get weight():Number { return _weight; }
		public function set weight(value:Number):void 
		{
			_weight = value;
		}
		
		public function get momentum():Number { return _momentum; }
		public function set momentum(value:Number):void 
		{
			_momentum = value;
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		
		
	}

}