package test.evo.cell
{
    import flash.display.BitmapData;
    import flash.html.script.Package;

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

            start( _nature );
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