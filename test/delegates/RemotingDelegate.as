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

package test.delegates
{
    import nl.imotion.delegates.AbstractDelegate;
    import nl.imotion.delegates.IResponder;


    /**
     * @author Pieter van de Sluis
     */
    public class RemotingDelegate extends AbstractDelegate
    {
        protected static var defaultResponder:IResponder;


        public function RemotingDelegate( operationName:String = null, data:Object = null, responder:IResponder = null )
        {
            super( operationName, data, responder );
        }


        override public function execute():void
        {
            switch ( operationName )
            {
                case DelegateOperations.SAVE_USER:

                    break;
            }
        }


        private function onResult( e:ResultEvent, callArgs:Array ):void
        {
            responder.onDelegateResult( operationName, e.result );
        }


        private function onFault( e:FaultEvent, callArgs:Array ):void
        {
            responder.onDelegateFault( operationName, e.error );
        }
    }

}