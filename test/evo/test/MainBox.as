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

package test.evo.test
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;

    import test.evo.test.BoxEvolver;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(width="800",height="600")]
    public class MainBox extends Sprite
    {
        private var box:Shape;
        private var boxColor:uint = 0xffffff;
        private var evo:BoxEvolver
        private var fitness:Number;

        private var rewardEvo:Shape;


        public function MainBox():void
        {
            if ( stage ) init();
            else addEventListener( Event.ADDED_TO_STAGE, init );
        }


        private function init( e:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, init );


            box = new Shape();
            box.graphics.beginFill( boxColor );
            box.graphics.drawRect( -50, -50, 100, 100 );
            box.x = Math.random() * 400 + 200;
            box.y = Math.random() * 200 + 200;
            box.width = Math.random() * 100 + 50;
            box.height = Math.random() * 100 + 50;
            this.addChild( box );

            evo = new BoxEvolver();
            evo.alpha = 0.3;
            evo.x = 200;
            evo.y = 200;
            this.addChild( evo );

            rewardEvo = new Shape();
//            rewardEvo.blendMode = BlendMode.ADD;
            this.addChild( rewardEvo );

            evo.init();
            calcFitness();

            addEventListener( Event.ENTER_FRAME, enterFrameHandler );
        }


        private function enterFrameHandler( e:Event ):void
        {
            evolve();
        }


        private function evolve():void
        {
            var repetitions:uint = 1;


            for ( var i:int = 0; i < repetitions; i++ )
            {
                var prevFitness:Number = fitness;
                calcFitness();
//                trace(prevFitness+"::"+fitness+"::"+evo.variation)

                if ( fitness < prevFitness )
                {
                    evo.reward();
                    this.removeChild( rewardEvo );
                    rewardEvo.graphics.clear();
                    rewardEvo.graphics.beginFill( 0x00ff00, 0.5 )
                    rewardEvo.graphics.drawRect( -evo.width / 2, -evo.height / 2, evo.width, evo.height );
                    rewardEvo.x = evo.x;
                    rewardEvo.y = evo.y;
                    this.addChild( rewardEvo );
                }
                else
                {
                    evo.punish();
                    fitness = prevFitness;
                }
            }

        }


        private function calcFitness():void
        {
            /*fitness = Math.abs( evo.width - box.width ) + Math.abs( evo.height - box.height ) +
             Math.abs( evo.x - box.x ) + Math.abs( evo.y - box.y )*/

            var evoRect:Rectangle = evo.getRect( this );
            var boxRect:Rectangle = box.getRect( this );

            fitness = 0;
            fitness += Math.pow( Math.abs( evoRect.left - boxRect.left ) / 800, 4 );
            fitness += Math.pow( Math.abs( evoRect.right - boxRect.right ) / 800, 4 );
            fitness += Math.pow( Math.abs( evoRect.top - boxRect.top ) / 600, 4 );
            fitness += Math.pow( Math.abs( evoRect.bottom - boxRect.bottom ) / 600, 4 );
        }


    }

}