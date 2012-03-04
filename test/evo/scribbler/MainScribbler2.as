package test.evo.scribbler
{
    import flash.display.Bitmap;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;

    import test.evo.nature.BitmapNature;
    import test.evo.nature.EvolveStatus;


    /**
     * @author Pieter van de Sluis
     */


    [SWF(backgroundColor="#ffffff",width="1100",height="900",frameRate="31")]
    public class MainScribbler2 extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        [Embed(source="../../../../lib/pieter_silhouette_4.jpg")]
        private var SourceImage:Class;

        private var _nature:BitmapNature;

        private var _sourceImg:Bitmap;

        private var _mainContainer      :Sprite;
        private var _resultContainer    :Sprite;
        private var _previewContainer   :Sprite;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function MainScribbler2()
        {
            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            initViews();

            _sourceImg = new SourceImage();

            _nature = new ScribblerNature( _sourceImg.bitmapData );

            this.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
        }


        private function initViews():void
        {
            _mainContainer = new Sprite();
            _mainContainer.x =
            _mainContainer.y = 50;
            this.addChild( _mainContainer );

            _resultContainer = new Sprite();
            _mainContainer.addChild( _resultContainer );

            _previewContainer = new Sprite();
            _mainContainer.addChild( _previewContainer );
        }


        private function evolve():void
        {
            var status:EvolveStatus = _nature.evolve();

            trace( "[" + status.populationNr + "/" + _nature.maxNumPopulations + ":" + status.generationNr + "] Fitness:" + status.fitness + ". Momentum:" + status.momentum + ". Time:" + status.generationTime );

            clearPreviewContainer();

            switch( status.type )
            {
                case EvolveStatus.FINISHED_GENERATION:
                    _previewContainer.addChild( _nature.getQuickPreview() );
                break;

                case EvolveStatus.FINISHED_POPULATION:
                case EvolveStatus.FINISHED_All:
                    trace( "Finished population: " + ( status.populationNr ) + ". Population time: " + status.populationTime );

                    _resultContainer.addChild( new Bitmap( _nature.getBitmapData() ) );
                break;
            }

            if ( status.type == EvolveStatus.FINISHED_All )
            {
                trace( "Finished all. Total time: " + status.totalTime );

                this.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
            }
        }


        private function clearPreviewContainer():void
        {
            while( _previewContainer.numChildren > 0 )
            {
                _previewContainer.removeChildAt( 0 );
            }
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function enterFrameHandler( e:Event ):void
        {
            evolve();
        }

    }
    
}