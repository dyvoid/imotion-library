package test.evo.cell
{
    import nl.imotion.utils.grid.GridCalculator;

    import flash.display.BitmapData;

    import nl.imotion.evo.evolvers.IBitmapEvolver;

    import test.evo.nature.BitmapNature;


    /**
     * @author Pieter van de Sluis
     */
    public class CellNature extends BitmapNature
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES



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

        override protected function createEvo():IBitmapEvolver
        {
            var evo:CellEvolver = new CellEvolver( sourceBitmapData.width, sourceBitmapData.height );

            return evo;
        }


        override protected function resetEvo( evo:IBitmapEvolver ):void
        {
            var s:CellEvolver = evo as CellEvolver;

            super.resetEvo( evo );
        }


        override protected function initializePopulation( useMating:Boolean = true ):void
        {
            var numCols:uint;
            var numRows:uint;
            var cellWidth:Number;
            var cellHeight:Number;

            if ( sourceBitmapData.width > sourceBitmapData.height )
            {
                numRows = 4;
                cellHeight = sourceBitmapData.height / numRows;

                numCols = int( sourceBitmapData.width / cellHeight );
                cellWidth = sourceBitmapData.width / numCols;
            }
            else
            {
                numCols = 4;
                cellWidth = sourceBitmapData.width / numCols;

                numRows = int( sourceBitmapData.height / cellWidth );
                cellHeight = sourceBitmapData.height / numRows;
            }

            var numCells:uint = numCols * numRows;
            var gridCalc:GridCalculator = new GridCalculator( numCols, cellWidth, cellHeight, 0, numCells );

            var evo:CellEvolver;

            var i:int;

            for ( i = 0; i < numCells; i++ )
            {
                evo = createEvo() as CellEvolver;
                evo.width = cellWidth;
                evo.height = cellHeight;
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
            var newPopulationFitness:Number = 0;

            do
            {
                if ( !IBitmapEvolver( evo ).momentumIsReady )
                {
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
                else if ( evo.fitness < minEvoFitness )
                {
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

                newPopulationFitness += evo.fitness;

                evo = IBitmapEvolver( evo.next );
            }
            while ( evo );

            return 0;
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