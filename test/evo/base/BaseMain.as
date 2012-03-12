package test.evo.base
{
    import flash.display.BitmapData;
    import flash.events.MouseEvent;
    import flash.net.FileReference;
    import flash.text.TextField;
    import flash.utils.ByteArray;

    import mx.graphics.codec.PNGEncoder;

    import test.evo.scribbler.*;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;

    import test.evo.nature.BitmapNature;
    import test.evo.nature.EvolveStatus;


    /**
     * @author Pieter van de Sluis
     */

    public class BaseMain extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _nature:BitmapNature;

        private var _mainContainer      :Sprite;
        private var _resultContainer    :Sprite;
        private var _previewContainer   :Sprite;

        private var _saveButton         :LabelButton;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function BaseMain()
        {

        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function start( nature:BitmapNature ):void
        {
            initViews();

            _nature = nature;

            this.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function initViews():void
        {
            _mainContainer = new Sprite();
            _mainContainer.x =
            _mainContainer.y = 10;
            this.addChild( _mainContainer );

            _resultContainer = new Sprite();
            _mainContainer.addChild( _resultContainer );

            _previewContainer = new Sprite();
            _mainContainer.addChild( _previewContainer );

            _saveButton = new LabelButton( "save image" );
            _saveButton.x = stage.stageWidth  - _saveButton.getBounds( this ).width  - 10;
            _saveButton.y = stage.stageHeight - _saveButton.getBounds( this ).height - 10;
            this.addChild( _saveButton );

            _saveButton.addEventListener( MouseEvent.CLICK, handleSaveButtonClick );
        }


        private function clearPreviewContainer():void
        {
            while( _previewContainer.numChildren > 0 )
            {
                _previewContainer.removeChildAt( 0 );
            }
        }


        private function saveImage():void
        {
            var result:BitmapData = new BitmapData( _mainContainer.width, _mainContainer.height, true, 0x00000000 );
            result.draw( _mainContainer );

            var encoder:PNGEncoder = new PNGEncoder();
            var encodedPNG:ByteArray = encoder.encode( result );

            var fileRef:FileReference = new FileReference();
            fileRef.save( encodedPNG, "result.png" );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED

        protected function evolve():void
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

                    _resultContainer.addChild( new Bitmap( _nature.draw() ) );
                break;
            }

            if ( status.type == EvolveStatus.FINISHED_All )
            {
                trace( "Finished all. Total time: " + status.totalTime );

                this.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
            }
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        protected function get resultContainer():Sprite
        {
            return _resultContainer;
        }


        protected function get previewContainer():Sprite
        {
            return _previewContainer;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function enterFrameHandler( e:Event ):void
        {
            evolve();
        }


        private function handleSaveButtonClick( e:MouseEvent ):void
        {
            saveImage();
        }

    }
    
}