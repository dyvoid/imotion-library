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
    import flash.display.DisplayObject;
    import flash.events.Event;

    import nl.imotion.bindmvc.controller.BindController;
    import nl.imotion.bindmvc.model.IBindModel;
    import nl.imotion.notes.DataNote;


    /**
     * @author Pieter van de Sluis
     */
    public class TestController extends BindController
    {

        public function TestController( defaultView:DisplayObject, defaultModel:IBindModel = null )
        {
            super( defaultView, defaultModel );

            startEventInterest( view, TestView.EVENT_REQUEST_BTN_CLICKED, onRequestBtnClicked );
            startEventInterest( view, TestView.EVENT_DESTROY_BTN_CLICKED, onDestroyBtnClicked );

            startNoteInterest( TestModel.NOTE_TEST_RESULT, onTestResult );
        }


        private function onRequestBtnClicked( e:Event ):void
        {
            model.getTestData();
        }


        private function onDestroyBtnClicked( e:Event ):void
        {
            view.destroy();
        }


        private function onTestResult( note:DataNote ):void
        {
            trace( note );

            view.tfName.appendText( note.data as String );
        }


        private function get model():TestModel
        {
            return retrieveModel( TestModel.NAME ) as TestModel;
        }


        private function get view():TestView
        {
            return defaultView as TestView;
        }
    }

}