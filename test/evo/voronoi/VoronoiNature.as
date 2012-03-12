package test.evo.voronoi
{
    import com.nodename.Delaunay.Voronoi;

    import flash.display.Shape;
    import flash.display.Sprite;

    import flash.geom.Point;

    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;

    import nl.imotion.evo.evolvers.IBitmapEvolver;

    import test.evo.nature.BitmapNature;
    import test.evo.nature.EvolveStatus;


    /**
     * @author Pieter van de Sluis
     */
    public class VoronoiNature extends BitmapNature
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _points         :Vector.<Point>;
        private var _voronoi        :Voronoi;

        private var _plotBounds     :Rectangle;

        [Embed(source="../assets/charlize_centerpoint.xml", mimeType="application/octet-stream")]
        private var CenterPointXMLData:Class;

        private var _centerPointXML:XML;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function VoronoiNature( sourceBitmapData:BitmapData )
        {
            super( sourceBitmapData );

            minEvoFitness = 0.5;
            maxNumPopulations = 1;
            numEvosPerPopulation = 100;

            var byteArray:ByteArray = new CenterPointXMLData() as ByteArray;
            _centerPointXML = new XML( byteArray.readUTFBytes( byteArray.length ) );

            _plotBounds = new Rectangle( 0, 0, sourceBitmapData.width, sourceBitmapData.height );
            _points = new Vector.<Point>();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override protected function createEvo():IBitmapEvolver
        {
            var evo:VoronoiRegionEvolver = new VoronoiRegionEvolver( sourceBitmapData.width, sourceBitmapData.height );

            _points[ _points.length ] = evo.point;

            return evo;
        }


        override protected function initializePopulation( useMating:Boolean = true ):void
        {
            if ( _centerPointXML )
            {
                for ( var i:int = 0; i < _centerPointXML.item.length(); i++ )
                {
                    var node:XML = _centerPointXML.item[i];

                    var evo:VoronoiRegionEvolver = createEvo() as VoronoiRegionEvolver;
                    evo.centerX = Number( node.@x );
                    evo.centerY = Number( node.@y );

                    if( i > 0 )
                    {
                        var prevEvo:IBitmapEvolver = fitnessList[ i - 1 ];

                        prevEvo.next = evo;
                        evo.previous = prevEvo;
                    }

                    fitnessList[ fitnessList.length ] =evo;

                    if ( i > 10 )
                        break;
                }

                firstEvo = fitnessList[ 0 ];
            }
            else
            {
                super.initializePopulation( useMating );
            }
        }


        /*override public function getQuickPreview():Sprite
        {
            var regions:Vector.<Vector.<Point>> = _voronoi.regions();

            return drawRegions( regions );
        }*/


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function drawRegion( region:Vector.<Point> ):Shape
        {
            var shape:Shape = new Shape();

            shape.graphics.beginFill( Math.random() * 0xffffff );
            shape.graphics.moveTo( region[ 0 ].x, region[ 0 ].y );

            for ( var j:int = 1; j < region.length; j++ )
            {
                var p:Point = region[j];
                shape.graphics.lineTo( p.x, p.y );
            }

            shape.graphics.endFill();

            return shape;
        }


        private function drawRegions( regions:Vector.<Vector.<Point>> ):Sprite
        {
            var result:Sprite = new Sprite();

            for each ( var region:Vector.<Point> in regions )
            {
                result.addChild( drawRegion( region ) );
            }

            return result;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED

        override protected function mutateAndEvaluateEvos( firstEvo:IBitmapEvolver ):Number
        {
            if ( _voronoi )
                _voronoi.dispose();

            var newPopulationFitness:Number = 0;

            var evo:IBitmapEvolver;


            evo = firstEvo;
            do
            {
//                if ( IBitmapEvolver( evo ).momentum != 0 || !IBitmapEvolver( evo ).momentumIsReady )
//                {
                    mutateEvo( evo );
//                }

                evo = IBitmapEvolver( evo.next );
            }
            while ( evo );

            _voronoi = new Voronoi( _points, null, _plotBounds );

            evo = firstEvo;
            do
            {
                VoronoiRegionEvolver( evo ).voronoi = _voronoi;

                var fitness:Number = evaluateEvo( evo );

                if ( evo.fitness < fitness )
                {
                    evo.reward( fitness );
                }
                else
                {
                    evo.punish();

                    if ( evo.momentum == 0 && evo.fitness < minEvoFitness )
                    {
                        evo.genome = createMatedGenome();
                        resetEvo( evo );
                    }
                }

                newPopulationFitness += evo.fitness;

                evo = IBitmapEvolver( evo.next );
                trace("next");
            }
            while ( evo );

            newPopulationFitness = newPopulationFitness / fitnessList.length;

            return newPopulationFitness;
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}