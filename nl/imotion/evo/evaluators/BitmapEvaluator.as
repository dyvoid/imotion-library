package nl.imotion.evo.evaluators
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.geom.Matrix;

    import nl.imotion.evo.evolvers.IBitmapEvolver;


    /**
     * @author Pieter van de Sluis
     */
    public class BitmapEvaluator implements IFitnessEvaluator
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _sourceBitmapData:BitmapData;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function BitmapEvaluator( sourceBitmapData:BitmapData = null )
        {
            _sourceBitmapData = sourceBitmapData;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function evaluate( data:* ):Number
        {
            if ( !data is IBitmapEvolver ) throw new Error( "data should be of type Bitmap" );

            var bm:Bitmap = IBitmapEvolver( data ).getBitmap();

            var diffMap:BitmapData = new BitmapData( bm.width, bm.height, false );
            diffMap.draw( _sourceBitmapData, new Matrix( 1, 0, 0, 1, -bm.x, -bm.y ) );
            diffMap.draw( bm.bitmapData, null, null, BlendMode.DIFFERENCE );

            var difference:int = 0;
            var numUsedPixels:int = 0;

            var sourceVector:Vector.<uint> = diffMap.getVector( diffMap.rect );
            var bmVector:Vector.<uint> = bm.bitmapData.getVector( bm.bitmapData.rect );

            var i:int = 0;
            var numSourcePixels:int = sourceVector.length;
            var sourcePix:uint;

            do
            {
                if ( ( bmVector[ i ] >> 24 & 0xFF ) != 0x00 )
                {
                    sourcePix = sourceVector[ i ];

                    difference += ( sourcePix >> 16 & 0xFF );
                    difference += ( sourcePix >> 8 & 0xFF );
                    difference += ( sourcePix & 0xFF );

                    numUsedPixels++;
                }
            } while ( ++i < numSourcePixels );

            difference = difference / numUsedPixels;

            //765 is the worst fitness, where every color channel difference is 255
            return 1 - ( difference / 765 );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        public function get sourceBitmapData():BitmapData
        {
            return _sourceBitmapData;
        }

        public function set sourceBitmapData( value:BitmapData ):void
        {
            _sourceBitmapData = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}