package test.evo.test
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;


    /**
     * @author Pieter van de Sluis
     * Date: 28-okt-2010
     * Time: 20:39:44
     */
    public class DiffMapTest extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _map1:BitmapData;
        private var _map2:BitmapData;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function DiffMapTest()
        {
            init();
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            _map1 = new BitmapData( 1, 1, true, 0xffff0000 );
            _map2 = new BitmapData( 1, 1, true );

//            _map2.setPixel32( 0, 0, 0xff000000 );
//            _map2.setPixel32( 1, 0, 0xffff0000 );
            _map2.setPixel32( 0, 0, 0xff0000ff );

            var map1Vector:Vector.<uint> = _map1.getVector( _map1.rect );
            var map2Vector:Vector.<uint> = _map2.getVector( _map2.rect );

            var map1Pix:Number;
            var map2Pix:Number;

            var rDiff:Number, gDiff:Number, bDiff:Number;
            var difference:Number = 0;

            for ( var j:int = 0; j < 1; j++ )
            {
                map1Pix = map1Vector[ j ];
                map2Pix = map2Vector[ j ];

                rDiff = ( map1Pix >> 16 & 0xFF ) - ( map2Pix >> 16 & 0xFF );
                gDiff = ( map1Pix >> 8 & 0xFF ) - ( map2Pix >> 8 & 0xFF );
                bDiff = ( map1Pix & 0xFF ) - ( map2Pix & 0xFF );

                difference += ( rDiff >= 0 ) ? rDiff : -rDiff;
                difference += ( gDiff >= 0 ) ? gDiff : -gDiff;
                difference += ( bDiff >= 0 ) ? bDiff : -bDiff;
            }

            trace( difference );

            difference = 0;

            var diffMap:BitmapData = new BitmapData( 1, 1, true, 0x00000000 );
            diffMap = _map1.compare( _map2 ) as BitmapData;

            var diffB:Bitmap = new Bitmap( diffMap );
            this.addChild( diffB );
            diffB.x = 100;
            diffB.y = 100;

            var diffVector:Vector.<uint> = diffMap.getVector( diffMap.rect );
            var diffPix:Number;

            for ( j = 0; j < 1; j++ )
            {
                diffPix = diffMap.getPixel32( j, 0 );
                /*if ( diffPix < 0 )
                 diffPix = -diffPix;*/

                trace( diffMap.getPixel32( 0, 0 ).toString( 16 ) );

                rDiff = ( diffPix >> 16 & 0xFF );
                gDiff = ( diffPix >> 8 & 0xFF );
                bDiff = ( diffPix & 0xFF );

                difference += ( rDiff >= 0 ) ? rDiff : -rDiff;
                difference += ( gDiff >= 0 ) ? gDiff : -gDiff;
                difference += ( bDiff >= 0 ) ? bDiff : -bDiff;
            }

            trace( difference );
        }


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}