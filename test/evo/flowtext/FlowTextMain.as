package test.evo.flowtext
{
    import flash.text.Font;

    import test.evo.scribbler.*;
    import flash.display.Bitmap;

    import mx.core.BitmapAsset;

    import test.evo.base.BaseMain;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(backgroundColor="#ffffff",width="1100",height="800",frameRate="31")]
    public class FlowTextMain extends BaseMain
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        [Embed(source="../assets/freedom_silhouette.png")]
        private var SourceImage:Class;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function FlowTextMain()
        {
            Font.registerFont( Arial );
            Font.registerFont( Andalus );
            Font.registerFont( Junkos );

            var image:Bitmap = new SourceImage();
            var nature:FlowTextNature = new FlowTextNature( image.bitmapData );

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