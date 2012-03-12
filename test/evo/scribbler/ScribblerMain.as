package test.evo.scribbler
{
    import flash.display.Bitmap;

    import mx.core.BitmapAsset;

    import test.evo.base.BaseMain;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(backgroundColor="#ffffff",width="1100",height="800",frameRate="31")]
    public class ScribblerMain extends BaseMain
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        [Embed(source="../assets/freedom_silhouette.png")]
        private var SourceImage:Class;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function ScribblerMain()
        {
            var image:Bitmap = new SourceImage();
            var nature:ScribblerNature = new ScribblerNature( image.bitmapData );

            start( nature );
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


    }
}