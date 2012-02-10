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

package test.mvc
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldType;

    import nl.imotion.display.EventManagedSprite;


    /**
     * ...
     * @author Pieter van de Sluis
     */
    public class TestView extends EventManagedSprite
    {
        public static const EVENT_REQUEST_BTN_CLICKED:String = "eventRequestBtnClicked";
        public static const EVENT_DESTROY_BTN_CLICKED:String = "eventDestroyBtnClicked";

        public var tfName:TextField;

        private var btDestroy:Sprite;
        private var btName:Sprite;


        public function TestView()
        {
            btName = new Sprite();
            btName.x =
                    btName.y = 30;
            btName.graphics.beginFill( 0x00FF00 );
            btName.graphics.drawRect( 0, 0, 100, 20 );
            btName.graphics.endFill();

            this.addChild( btName );

            btDestroy = new Sprite();
            btDestroy.x = 200;
            btDestroy.y = 30;
            btDestroy.graphics.beginFill( 0xFF0000 );
            btDestroy.graphics.drawRect( 0, 0, 100, 20 );
            btDestroy.graphics.endFill();

            this.addChild( btDestroy );

            startEventInterest( [ btName, btDestroy ], MouseEvent.CLICK, onBtnClick );

            tfName = new TextField();
            tfName.type = TextFieldType.INPUT;
            tfName.border = true;
            tfName.multiline = true;
            tfName.wordWrap = true;
            tfName.x = 30;
            tfName.y = 60;

            this.addChild( tfName );
        }


        private function onBtnClick( e:MouseEvent ):void
        {
            switch ( e.target )
            {
                case btName:
                    this.dispatchEvent( new Event( EVENT_REQUEST_BTN_CLICKED ) );
                    break;

                case btDestroy:
                    this.dispatchEvent( new Event( EVENT_DESTROY_BTN_CLICKED ) );
                    break;

            }

        }

    }

}