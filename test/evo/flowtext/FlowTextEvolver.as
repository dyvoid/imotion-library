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
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    import nl.imotion.evo.Genome;
    import nl.imotion.evo.evolvers.Evolver;
    import nl.imotion.evo.evolvers.IEvolver;
    import nl.imotion.evo.evolvers.IBitmapEvolver;
    import nl.imotion.evo.genes.CollectionGene;
    import nl.imotion.evo.genes.IntGene;
    import nl.imotion.evo.genes.LimitMethod;
    import nl.imotion.evo.genes.NumberGene;
    import nl.imotion.evo.genes.UintGene;
    import nl.imotion.utils.momentum.MomentumCalculator;

    import test.evo.*;


    /**
     * @author Pieter van de Sluis
     * Date: 19-sep-2010
     * Time: 20:06:56
     */
    public class FlowTextEvolver extends Evolver implements IBitmapEvolver
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _container:Sprite;

        private var _areaWidth:Number;
        private var _areaHeight:Number;

        private var _previous:IEvolver;
        private var _next:IEvolver;

        private var _flowText:FlowText;

        private var _lastDraw:Bitmap;
        private var _bestDraw:Bitmap;

        private var _momentumCalc:MomentumCalculator;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function FlowTextEvolver( areaWidth:Number, areaHeight:Number )
        {
            _areaWidth = areaWidth;
            _areaHeight = areaHeight;

            init();
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        override public function init():Evolver
        {
            genome = new Genome();

            /*var characters:Array = [];

            var firstChar:String = "!";
            var lastChar:String  = "Z";

            for ( var i:int = firstChar.charCodeAt(0); i <= lastChar.charCodeAt(0); i++ )
            {
                characters.push( String.fromCharCode(i) );
            }*/

            var characterList:String = "0123456789cefhijlopqstuvxyCEFHIJLOPQSTUVXY!@#$%^&*(){}[]:\"|;'\\<>?,./~`";
//            var characters:Array =["a","b"];
            var characters:Array = characterList.split("");

            genome.addGene( new CollectionGene( "text", characters, 0.05 ) );

            genome.addGene( new UintGene( "x", 0, _areaWidth, 0.01 ) );
            genome.addGene( new UintGene( "y", 0, _areaHeight, 0.01 ) );

            genome.addGene( new NumberGene( "scale", 0.2, 8, 0  ) );

            genome.addGene( new IntGene( "rotation", -180, 180, 0.1, LimitMethod.WRAP ) );

//            genome.addGene( new NumberGene( "brightness", 0, 1, 0.01, LimitMethod.CUT_OFF ) )

            genome.addGene( new NumberGene( "alpha", 0.5, 1, 0.1 ) );

            _container = new Sprite();

            _flowText = new FlowText();
            _container.addChild( _flowText );

            _momentumCalc = new MomentumCalculator( 40 );

            return this;
        }


        public function reset( minSize:Number, maxSize:Number ):IEvolver
        {
            genome.editGene( "scale", { minVal: minSize, maxVal: maxSize } );
            genome.resetGenes( [ "scale", "x", "y"  ] );
            previousGenome = null;

            fitness = 0;
            _lastDraw =
             _bestDraw = null;

            _momentumCalc.reset();

            return this;
        }


        public function draw():Bitmap
        {
            genome.apply( _flowText );
            _flowText.update();

            var bounds:Rectangle = _flowText.getRect( _container );

            var leftExtra:Number = ( bounds.left < 0 ) ? -bounds.left : 0;
            var topExtra:Number = ( bounds.top < 0 ) ? -bounds.top : 0;
            var rightExtra:Number = ( bounds.right > _areaWidth ) ? bounds.right - _areaWidth : 0;
            var bottomExtra:Number = ( bounds.bottom > _areaHeight ) ? bounds.bottom - _areaHeight : 0;

            var matrix:Matrix = new Matrix();
            matrix.tx = -bounds.left - leftExtra;
            matrix.ty = -bounds.top - topExtra;

            var bWidth:Number = Math.max( 1, bounds.width - leftExtra - rightExtra );
            var bHeight:Number = Math.max( 1, bounds.height - topExtra - bottomExtra );

            var bmd:BitmapData = new BitmapData( bWidth, bHeight, true, 0x00000000 );
            bmd.draw( _container, matrix );

            _lastDraw = new Bitmap( bmd );
            _lastDraw.x = _flowText.x - ( _flowText.x - bounds.left ) + leftExtra;
            _lastDraw.y = _flowText.y - ( _flowText.y - bounds.top ) + topExtra;

            var bm:Bitmap = new Bitmap( bmd );
            bm.transform.matrix = _lastDraw.transform.matrix;

            return bm;
        }


        override public function reward( fitness:Number ):Genome
        {
            _bestDraw = _lastDraw;
            _lastDraw = null;
//            variation = 1 - fitness;

            _momentumCalc.addSample( fitness );

            return super.reward( fitness );
        }


        override public function punish( fitness:Number ):Genome
        {
            _lastDraw = null;
//            variation = Math.min( 1, variation + ( variation * 0.01 ) );

            _momentumCalc.addSample( fitness );

            return super.punish( fitness );
        }


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get previous():IEvolver
        {
            return _previous;
        }


        public function set previous( value:IEvolver ):void
        {
            _previous = value;
        }


        public function get next():IEvolver
        {
            return _next;
        }


        public function set next( value:IEvolver ):void
        {
            _next = value;
        }


        public function get lastDraw():Bitmap
        {
            return _lastDraw;
        }


        public function get bestDraw():Bitmap
        {
            return _bestDraw;
        }


        public function get momentum():Number
        {
            return _momentumCalc.isReady ? _momentumCalc.momentum : 0;
        }


        public function get momentumIsReady():Boolean
        {
            return _momentumCalc.isReady;
        }


        public function get flowText():FlowText
        {
            return _flowText;
        }


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

    }
}