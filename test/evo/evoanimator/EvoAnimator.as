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

package test.evo.evoanimator
{
    import com.greensock.TimelineMax;
    import com.greensock.TweenAlign;
    import com.greensock.TweenMax;
    import com.greensock.easing.Back;
    import com.greensock.easing.FastEase;
    import com.greensock.easing.Quint;
    import com.greensock.easing.Sine;
    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.LoaderMax;

    import com.greensock.loading.XMLLoader;

    import flash.display.Sprite;

    import flash.text.Font;

    import nl.imotion.evo.Genome;

    import nl.imotion.evo.genes.Gene;

    import test.evo.flowtext.FlowText;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(backgroundColor="#ffffff",width="800",height="640",frameRate="24")]
    public class EvoAnimator extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var loader:LoaderMax;
        private var xmls:Array = [ "xml/evo_logo.xml", "xml/pieter.xml", "xml/horse.xml",  ];

        private var genomes:Vector.<Genome>;
        private var flowTexts:Vector.<FlowText>;

        private var baseValList:Array;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function EvoAnimator()
        {
            Font.registerFont( Arial );
            Font.registerFont( Andalus );

            FastEase.activate( [ Quint ] );

            loader = new LoaderMax();
            loader.append( new XMLLoader( xmls[0] ) );
            loader.append( new XMLLoader( xmls[1] ) );
            loader.append( new XMLLoader( xmls[2] ) );
            loader.addEventListener( LoaderEvent.COMPLETE, loaderCompleteHandler );
            loader.load();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function loaderCompleteHandler( e:LoaderEvent ):void
        {
            var xml:XML = loader.getContent( xmls[0] ) as XML;

            genomes = new Vector.<Genome>();
            flowTexts = new Vector.<FlowText>();

            var genomeNode:XML;

            for each ( genomeNode in xml.children() )
            {
                var genome:Genome = new Genome();
                genome.fromXML( genomeNode );
                genomes.push( genome );

                var flowText:FlowText = new FlowText();
                genome.apply( flowText );
                flowText.update();
                this.addChild( flowText );
                flowTexts.push( flowText );
            }

            baseValList = [];

            for each ( var xmlName:String in xmls )
            {
                xml = loader.getContent( xmlName ) as XML;

                var picArr:Array = [];

                for each ( genomeNode in xml.children() )
                {
                    var genomeArr:Array = [];

                    for each ( var geneNode:XML in genomeNode.children() )
                    {
                        genomeArr.push( Number( geneNode.@baseValue.toString() ) );
                    }

                    picArr.push( genomeArr );
                }

                baseValList.push( picArr );
            }

            TweenMax.delayedCall( 3, startAnim );
        }


        private function startAnim():void
        {
            var timeLine:TimelineMax = new TimelineMax( { onComplete: startAnim } );
            
            baseValList.push( baseValList.shift() );
            var baseValArr:Array = baseValList[ 0 ];

//            for ( var i:int = 0; i < 10; i++ )
            for ( var i:int = 0; i < baseValArr.length; i++ )
            {
                var genomeArr:Array = baseValArr[i];

                var genome:Genome = genomes[i];
                var genes:Vector.<Gene> = genome.genes;

                var genomeTimeLine:TimelineMax = new TimelineMax(
                    { align: TweenAlign.NORMAL, onUpdate: animUpdate, onUpdateParams: [ genome, flowTexts[i]] } );

                for ( var j:int = 0; j < genomeArr.length; j++ )
                {
                    var geneVal:Number = genomeArr[j];

                    genomeTimeLine.insert( new TweenMax( genes[j], 1, { baseValue: geneVal, ease: Quint.easeInOut } ) );
                }
                timeLine.insert( genomeTimeLine );
            }

            timeLine.append( new TweenMax( this, 0, {} ) );
        }


        private function animUpdate( genome:Genome, flowText:FlowText ):void
        {
            genome.apply( flowText );
            flowText.update();
        }

    }

}