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

package test.utils
{
    import flash.display.Sprite;
    import flash.events.Event;

    import nl.imotion.utils.range.Range;


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

            var range1:Range = new Range( -1, 1 );
            var range2:Range = new Range( 0, 1 );

            trace( range1.translate( 1, range2 ) );

            /*var reflectTest:ReflectTest = new ReflectTest();

             var arr:Array = Reflector.getProperties( reflectTest, AccessType.READ );

             for each( var prop:PropertyDefinition in arr )
             {
             trace( prop.name + "::" + prop.isReadable + "::" + prop.isWriteable );
             }

             trace("=====");

             var singleProp:PropertyDefinition = Reflector.getProperty( reflectTest, "writeOnly" );
             if ( singleProp )
             trace( singleProp.name + "::" + singleProp.isReadable + "::" + singleProp.isWriteable );*/
        }

    }

}