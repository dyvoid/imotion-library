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

package test.burst
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    import nl.imotion.burst.Burst;
    import nl.imotion.burst.components.core.IBurstComponent;
    import nl.imotion.burst.parsers.CanvasParser;
    import nl.imotion.burst.parsers.DisplayObjectParser;
    import nl.imotion.burst.parsers.SimpleGridParser;
    import nl.imotion.burst.parsers.StackPanelParser;

    import test.burst.components.Box;
    import test.burst.components.BoxParser;
    import test.burst.components.Circle;
    import test.burst.components.SpacerParser;
    import test.burst.components.TextAreaParser;


    /**
     * @author Pieter van de Sluis
     */
    public class Main extends Sprite
    {
        private var result:DisplayObject;
        private var burst:Burst;
        private var xml:XML;


        public function Main():void
        {
            if ( stage ) init();
            else addEventListener( Event.ADDED_TO_STAGE, init );

            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
        }


        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, init );

            var loader:URLLoader = new URLLoader();
            loader.addEventListener( Event.COMPLETE, xmlLoadCompleteHandler );
            loader.load( new URLRequest( "burst.xml" ) );
        }


        private function xmlLoadCompleteHandler( e:Event ):void
        {
            xml = new XML( e.target.data );

            burst = new Burst();

            burst.bindParser( "Canvas", CanvasParser );
            burst.bindParser( "StackPanel", StackPanelParser );
            burst.bindParser( "Box", BoxParser );
            burst.bindParser( "Spacer", SpacerParser );
            burst.bindParser( "TextArea", TextAreaParser );
            burst.bindParser( "Grid", SimpleGridParser );

            burst.bindParser( "Circle", DisplayObjectParser, Circle );

            doBurst();

            var box:Box = new Box();
            box.y = result.height + 25;
            box.addEventListener( MouseEvent.CLICK, boxClickHandler );
            this.addChild( box );
        }


        protected function doBurst():void
        {
            if ( result )
            {
                removeChild( result );
                IBurstComponent( result ).destroy();
                result = null;
                //return;
            }
            result = burst.parse( xml );

            if ( !this.contains( result ) )
                this.addChild( result );
        }


        private function boxClickHandler( e:MouseEvent ):void
        {
            doBurst();
        }

    }

}