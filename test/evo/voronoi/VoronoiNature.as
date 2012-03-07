package test.evo.voronoi
{
    import com.nodename.Delaunay.Voronoi;

    import flash.display.Shape;
    import flash.display.Sprite;

    import flash.geom.Point;

    import flash.display.BitmapData;
    import flash.geom.Rectangle;

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

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function VoronoiNature( sourceBitmapData:BitmapData )
        {
            super( sourceBitmapData );

            minEvoFitness = 0.5;
            maxNumPopulations = 1;
            numEvosPerPopulation = 300;

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


        override protected function resetEvo( evo:IBitmapEvolver ):void
        {
            var s:VoronoiRegionEvolver = evo as VoronoiRegionEvolver;

            super.resetEvo( evo );
        }


        override public function evolve():EvolveStatus
        {
            return super.evolve();
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
            var reg:Object = _voronoi.regions();


            evo = firstEvo;
            do
            {
                VoronoiRegionEvolver( evo ).voronoi = _voronoi;

//                if ( IBitmapEvolver( evo ).momentum != 0 || !IBitmapEvolver( evo ).momentumIsReady )
//                {
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
//                }


                newPopulationFitness += evo.fitness;

                evo = IBitmapEvolver( evo.next );
            }
            while ( evo );

            return newPopulationFitness;
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}