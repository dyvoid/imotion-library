package test.evo.shapeshifter
{
    import flash.display.Bitmap;

    import test.evo.base.BaseMain;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(backgroundColor="#ffffff",width="1100",height="800",frameRate="31")]
    public class ShapeShiferMain extends BaseMain
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        [Embed(source="../assets/freedom.png")]
        private var SourceImage:Class;

        [Embed(source="../assets/freedom_complexity_map.png")]
        private var ComplexityMap:Class;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function ShapeShiferMain()
        {
            var image:Bitmap = new SourceImage();
            var complexityMap:Bitmap = new ComplexityMap();
            var nature:ShapeShifterNature = new ShapeShifterNature( image.bitmapData, complexityMap.bitmapData );
//            nature.useMating = false;

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