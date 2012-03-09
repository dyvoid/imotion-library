package test.evo.cell
{
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import nl.imotion.utils.grid.GridCalculator;

    import flash.display.BitmapData;

    import nl.imotion.evo.evolvers.IBitmapEvolver;
    import nl.imotion.utils.range.Range;

    import test.evo.nature.BitmapNature;


    /**
     * @author Pieter van de Sluis
     */
    public class CellNature extends BitmapNature
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _cellWidth      :Number;
        private var _cellHeight     :Number;

        private var _minSurfaceSize :Number = 1024;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function CellNature( sourceBitmapData:BitmapData )
        {
            super( sourceBitmapData );

            minEvoFitness = 0.95;
            maxNumPopulations = 1;
            numEvosPerPopulation = 1;
            targetPopulationFitness = 1;
            minGenerationMomentum = 0;
            useMating = false;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function getComplexityMap():BitmapData
        {
            var result:BitmapData = new BitmapData( sourceBitmapData.width, sourceBitmapData.height, false );

            var minSurfaceSize:Number = _cellWidth * _cellHeight;
            var maxSurfaceSize:Number = 0;

            var evo:CellEvolver;

            evo = CellEvolver( firstEvo );
            do
            {
                var evoSurfaceSize:Number = evo.surfaceSize;

                if ( evoSurfaceSize < minSurfaceSize )
                    minSurfaceSize = evoSurfaceSize;

                if ( evoSurfaceSize > maxSurfaceSize )
                    maxSurfaceSize = evoSurfaceSize;

                evo = CellEvolver( evo.next );
            }
            while ( evo );

            var surfaceSizeRange:Range = new Range( minSurfaceSize, maxSurfaceSize );

            evo = CellEvolver( firstEvo );
            do
            {
                var brightness:Number = 0xff - ( 0xff * surfaceSizeRange.getRelativePosFromValue( evo.surfaceSize ) );
                var color:uint = ( brightness << 16 ) | ( brightness << 8 ) | brightness;

                result.fillRect( new Rectangle( evo.x, evo.y, evo.width, evo.height ), color );

                evo = CellEvolver( evo.next );
            }
            while ( evo );

            result.applyFilter( result, result.rect, new Point( 0, 0 ), new BlurFilter( 30, 30, BitmapFilterQuality.HIGH ) );

            return result;
        }


        override protected function createEvo():IBitmapEvolver
        {
            var evo:CellEvolver = new CellEvolver( sourceBitmapData.width, sourceBitmapData.height, _minSurfaceSize );

            return evo;
        }


        override protected function initializePopulation( useMating:Boolean = true ):void
        {
            var numCols:uint;
            var numRows:uint;

            if ( sourceBitmapData.width > sourceBitmapData.height )
            {
                numRows = 4;
                _cellHeight = sourceBitmapData.height / numRows;

                numCols = int( sourceBitmapData.width / _cellHeight );
                _cellWidth = sourceBitmapData.width / numCols;
            }
            else
            {
                numCols = 4;
                _cellWidth = sourceBitmapData.width / numCols;

                numRows = int( sourceBitmapData.height / _cellWidth );
                _cellHeight = sourceBitmapData.height / numRows;
            }

            var numCells:uint = numCols * numRows;
            var gridCalc:GridCalculator = new GridCalculator( numCols, _cellWidth, _cellHeight, 0, numCells );

            var evo:CellEvolver;

            var i:int;

            for ( i = 0; i < numCells; i++ )
            {
                evo = createEvo() as CellEvolver;
                evo.width = _cellWidth;
                evo.height = _cellHeight;
                evo.x = gridCalc.getCellX( i );
                evo.y = gridCalc.getCellY( i );

                fitnessList[ i ] = evo;
            }

            for ( i = 0; i < numCells; i++ )
            {
                evo = fitnessList[ i ];

                if ( i == 0 )
                {
                    firstEvo = fitnessList[ 0 ];
                }
                else
                {
                    evo.previous = fitnessList[ i - 1 ];
                }

                if ( i < numCells - 1 )
                {
                    evo.next = fitnessList[ i + 1 ];
                }
            }
        }


        override protected function mutateAndEvaluateEvos( firstEvo:IBitmapEvolver ):Number
        {
            var evo:IBitmapEvolver = firstEvo;
            var newPopulationFitness:Number = 1;
            
            do
            {
                if ( !IBitmapEvolver( evo ).momentumIsReady )
                {
                    newPopulationFitness = 0;

                    mutateEvo( evo );
                    var fitness:Number = evaluateEvo( evo );

                    if ( evo.fitness < fitness )
                    {
                        evo.reward( fitness );
                    }
                    else
                    {
                        evo.punish();
                    }
                }
                else if ( evo.fitness < minEvoFitness && CellEvolver( evo ).surfaceSize > _minSurfaceSize )
                {
                    newPopulationFitness = 0;

                    var newEvos:Vector.<CellEvolver> = new Vector.<CellEvolver>();

                    newEvos.push( evo );
                    newEvos.push( createEvo() );
                    newEvos.push( createEvo() );
                    newEvos.push( createEvo() );

                    newEvos[ 3 ].next = evo.next;
                    evo.next = newEvos[ 1 ];
                    evo.reset();


                    var newEvo:CellEvolver;
                    var i:int;

                    for ( i = 1; i < newEvos.length; i++ )
                    {
                        newEvo = newEvos[ i ];
                        newEvo.genome = evo.genome.clone();
                        newEvo.previous = newEvos[ i - 1 ];

                        if ( i < newEvos.length - 1 )
                        {
                            newEvo.next = newEvos[ i + 1 ];
                        }

                        fitnessList.push( newEvo );
                    }

                    var cellEvo:CellEvolver = evo as CellEvolver;
                    var cellWidth:Number = cellEvo.width * 0.5;
                    var cellHeight:Number = cellEvo.height * 0.5;
                    var gridCalc:GridCalculator = new GridCalculator( 2, cellWidth, cellHeight, 0, 4 );
                    var baseX:Number = cellEvo.x;
                    var baseY:Number = cellEvo.y;

                    for ( i = 0; i < newEvos.length; i++ )
                    {
                        newEvo = newEvos[ i ];
                        newEvo.x = baseX + gridCalc.getCellX( i );
                        newEvo.y = baseY + gridCalc.getCellY( i );
                        newEvo.width = cellWidth;
                        newEvo.height = cellHeight;
                    }

                    evo = newEvos[ 3 ];
                }

//                newPopulationFitness += evo.fitness;

                evo = IBitmapEvolver( evo.next );
            }
            while ( evo );
            
            return newPopulationFitness;
        }


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