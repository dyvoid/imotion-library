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

package test.forms
{
    import flash.display.Sprite;
    import flash.events.Event;

    import nl.imotion.forms.Form;
    import nl.imotion.forms.FormElementSprite;
    import nl.imotion.forms.validators.CompareValidator;
    import nl.imotion.forms.validators.RegExpValidator;
    import nl.imotion.forms.validators.RequiredValidator;
    import nl.imotion.forms.validators.ValidatorError;


    /**
     * @author Pieter van de Sluis
     */
    public class Main extends Sprite
    {

        public function Main():void
        {
            if ( stage ) init();
            else addEventListener( Event.ADDED_TO_STAGE, init );
        }


        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, init );

            var el:FormElementSprite = new FormElementSprite();
            var val:RequiredValidator = new RequiredValidator();
            var val2:CompareValidator = new CompareValidator( el, "bla", "==" );
            val2.defaultErrorMessage = "val 2 is not valid";
            var val3:CompareValidator = new CompareValidator( el, "test", "==" );
            val3.defaultErrorMessage = "val 3 is not valid";
            var val4:RegExpValidator = new RegExpValidator( /henk/ );

            el.addValidator( val2 );
            el.addValidator( val2 );
            el.addValidator( val3 );

            el.value = "";

            var form:Form = new Form();
            form.registerElement( el, "el" );

            trace( form.isValid );
            //trace(form.errors);

            form.errors.forEach( function( item:ValidatorError, index:int, array:Array ):void
            {
                trace( item.errorMessage )
            } );

        }
    }

}