package test.evo.cell
{
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.html.script.Package;
    import flash.net.FileReference;
    import flash.text.TextField;

    import nl.imotion.evo.evolvers.Evolver;

    import test.evo.base.LabelButton;

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

        [Embed(source="../assets/freedom.png")]
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
            var exportGenomeXMLButton:LabelButton = new LabelButton( "export genome xml" );

            exportGenomeXMLButton.x = stage.stageWidth  - exportGenomeXMLButton.getBounds( this ).width  - 10;
            exportGenomeXMLButton.y = stage.stageHeight - exportGenomeXMLButton.getBounds( this ).height - 40;
            this.addChild( exportGenomeXMLButton );

            exportGenomeXMLButton.addEventListener( MouseEvent.CLICK, handleGenomeExportClick );

            var exportCenterPointXMLButton:LabelButton = new LabelButton( "export center point xml" );

            exportCenterPointXMLButton.x = stage.stageWidth  - exportCenterPointXMLButton.getBounds( this ).width  - 10;
            exportCenterPointXMLButton.y = stage.stageHeight - exportCenterPointXMLButton.getBounds( this ).height - 70;
            this.addChild( exportCenterPointXMLButton );

            exportCenterPointXMLButton.addEventListener( MouseEvent.CLICK, handleCenterPointExportClick );
        }


        private function handleGenomeExportClick( e:MouseEvent ):void
        {
            var xml:XML = _nature.getGenomeXML();

            var fileRef:FileReference = new FileReference();
            fileRef.save( xml, "genome.xml" );
        }


        private function handleCenterPointExportClick( e:MouseEvent ):void
        {
            var xml:XML = _nature.getCenterPointXML();

            var fileRef:FileReference = new FileReference();
            fileRef.save( xml, "centerpoint.xml" );
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
                var complexityMap:BitmapData = _nature.drawComplexityMap();

                resultContainer.addChild( new Bitmap( complexityMap ) );
            }
        }


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}