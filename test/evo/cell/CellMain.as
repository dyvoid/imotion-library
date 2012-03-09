package test.evo.cell
{
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.html.script.Package;
    import flash.net.FileReference;
    import flash.text.TextField;

    import nl.imotion.evo.evolvers.Evolver;

    import test.evo.nature.EvolveStatus;
    import test.evo.scribbler.*;
    import flash.display.Bitmap;

    import mx.core.BitmapAsset;

    import test.evo.base.BaseMain;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(backgroundColor="#ffffff",width="1100",height="800",frameRate="31")]
    public class CellMain extends BaseMain
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        [Embed(source="../assets/charlize.png")]
        private var SourceImage:Class;

        private var _nature:CellNature;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function CellMain()
        {
            var image:Bitmap = new SourceImage();
            _nature = new CellNature( image.bitmapData );

            initView();

            start( _nature );
        }


        private function initView():void
        {
            var exportButton:Sprite = new Sprite();
            exportButton.buttonMode = true;
            exportButton.mouseChildren = false;

            var exportText:TextField = new TextField();
            exportText.text = "export XML";
            exportText.width  = exportText.textWidth + 5;
            exportText.height = exportText.textHeight + 5;
            exportButton.addChild( exportText );

            exportButton.x = stage.stageWidth  - exportButton.getBounds( this ).width  - 10;
            exportButton.y = stage.stageHeight - exportButton.getBounds( this ).height - 30;
            this.addChild( exportButton );

            exportButton.addEventListener( MouseEvent.CLICK, handleExportButtonClick );
        }


        private function handleExportButtonClick( e:MouseEvent ):void
        {
            var xml:XML = _nature.getXML();

            var fileRef:FileReference = new FileReference();
            fileRef.save( xml, "result.xml" );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        override protected function evolve():void
        {
            super.evolve();

            if ( _nature.status.type == EvolveStatus.FINISHED_All )
            {
                var complexityMap:BitmapData = _nature.getComplexityMap();

                resultContainer.addChild( new Bitmap( complexityMap ) );
            }
        }


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}