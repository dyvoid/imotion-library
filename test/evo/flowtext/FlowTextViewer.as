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

package test.evo.flowtext
{
    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.LoaderMax;
    import com.greensock.loading.XMLLoader;

    import flash.display.Sprite;

    import flash.net.FileReference;
    import flash.text.Font;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.genes.Gene;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(backgroundColor="#ffffff",width="800",height="640",frameRate="31")]
    
    public class FlowTextViewer extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var loader:LoaderMax;

        private var fileName:String = "xml/pieter.xml";
//        private var fileName:String = "xml/horse.xml";
//        private var fileName:String = "xml/evo_logo.xml";

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function FlowTextViewer()
        {
            Font.registerFont( Arial );

            loader = new LoaderMax();
            loader.append( new XMLLoader( fileName ) );
            loader.addEventListener( LoaderEvent.COMPLETE, loaderCompleteHandler );
            loader.load();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function view():void
        {
            var xml:XML = loader.getContent( fileName ) as XML;

            var genomeNode:XML;

            var newXML:XML = <root />;

            for each ( genomeNode in xml.children() )
            {
                var genome:Genome = new Genome();
                genome.fromXML( genomeNode );

                var flowText:FlowText = new FlowText();
                genome.apply( flowText );
                flowText.update();
                this.addChild( flowText );

                newXML.appendChild( genome.toXML() );
            }

//            var fileRef:FileReference = new FileReference();
//            fileRef.save( newXML );
            

        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function loaderCompleteHandler( e:LoaderEvent ):void
        {
            view();
        }

    }
    
}