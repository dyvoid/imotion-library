package  nl.imotion.utils.grid
{
	import flash.geom.Point;
	
	
	/**
	* The <code>GridCalculator</code> class creates a virtual grid, that can be used to calculate individual cell positions.
	* @author Pieter van de Sluis
	*/
	public class GridCalculator
	{
		private var _maxWidth:Number = 0;
		private var _cellWidth:Number = 0;
		private var _cellHeight:Number = 0;
		private var _margin:Number = 0;
		private var _nrOfCells:int = -1;
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		
		/**
		 * Constructs a new <code>GridCalculator</code> 
		 * @param	maxWidth The maximum width of the grid. The <code>GridCalculator</code> will build a row of cells, until this value is reached
		 * @param	cellWidth The width of a cell in the grid
		 * @param	cellHeight The height of a cell in the grid
		 * @param	margin The margin between cells, in pixels
		 * @param	nrOfCells The total number of cells in the grid. Optional, it is only necessary if the <code>height</code> and <code>nrOfRows</code> properties are to be used.
		 */
		public function GridCalculator( maxWidth:Number, cellWidth:Number, cellHeight:Number, margin:Number, nrOfCells:int = -1 )
		{
			_maxWidth = maxWidth;
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
			_margin = margin;
			_nrOfCells = nrOfCells;
		}
		
		
		/**
		 * Gets the position of a cell as a <code>Point</code>
		 * @param	index the index of a cell
		 * @return	the position of the cell
		 */
		public function getCellPos( index:uint ):Point
		{
			if ( index < 0 || ( nrOfCells != -1 && index >= nrOfCells ) )
			{
				return null;
			}
			
			var cellPoint:Point = new Point();
			
			var nrOfCols:uint = this.nrOfCols;
			var colPos:uint = index % nrOfCols;
			var rowPos:uint = uint( index / nrOfCols );
			
			cellPoint.x = ( colPos == 0 ) ? _x : ( this.cellWidth  + this.margin ) * colPos + _x;
			cellPoint.y = ( rowPos == 0 ) ? _y : ( this.cellHeight + this.margin ) * rowPos + _y;
			
			return cellPoint;
		}
		
		
		/**
		 * Gets the x position of a cell
		 * @param	index the index of a cell
		 * @return	the x position of the cell
		 */
		public function getCellX ( index:uint ):Number
		{
			return this.getCellPos( index ).x;
		}
		
		
		/**
		 * Gets the y position of a cell
		 * @param	index the index of a cell
		 * @return	the y position of the cell
		 */
		public function getCellY ( index:uint ):Number
		{
			return this.getCellPos( index ).y;
		}
		
		
		/**
		 * The number of columns in the grid
		 */
		public function get nrOfCols():uint
		{
			return uint( ( this.maxWidth + this.margin ) / ( this.cellWidth + this.margin ) );
		}
		public function set nrOfCols( value:uint ):void
		{
			this.maxWidth = ( this.cellWidth + this.margin ) * value + this.margin;
		}
		
		
		/**
		 * The number of rows in the grid. Can only be calculated if <code>nrOfCells</code> has been set.
		 */
		public function get nrOfRows():uint
		{
			if ( nrOfCells != -1 )
			{
				return Math.ceil( this.nrOfCells / this.nrOfCols );
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * The width of the grid
		 */
		public function get width():Number
		{
			return ( this.cellWidth + this.margin ) * this.nrOfCols - this.margin;
		}
		
		
		/**
		 * The height of the grid. Can only be calculated if <code>nrOfCells</code> has been set.
		 */
		public function get height():Number
		{
			if ( nrOfCells != -1 )
			{
				return ( this.cellHeight + this.margin ) * this.nrOfRows - this.margin;
			}
			else
			{
				return 0;
			}
		}
		
		
		/**
		 * The maximum width of the grid. The <code>GridCalculator</code> will build a row of cells, until this value is reached
		 */
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth( value:Number ):void 
		{
			_maxWidth = value;
		}
		
		
		/**
		 * The width of a cell in the grid
		 */		
		public function get cellWidth():Number { return _cellWidth; }
		public function set cellWidth( value:Number ):void 
		{
			_cellWidth = value;
		}
		
		
		/**
		 * The height of a cell in the grid
		 */
		public function get cellHeight():Number { return _cellHeight; }
		public function set cellHeight( value:Number ):void 
		{
			_cellHeight = value;
		}
		
		
		/**
		 * The margin between cells, in pixels
		 */
		public function get margin():Number { return _margin; }
		public function set margin( value:Number ):void 
		{
			_margin = value;
		}
		
		
		/**
		 * The total number of cells in the grid. Optional, it is only necessary if the <code>height</code> and <code>nrOfRows</code> properties are to be used.
		 */
		public function get nrOfCells():uint { return _nrOfCells; }
		public function set nrOfCells( value:uint ):void 
		{
			_nrOfCells = value;
		}
		
		
		/**
		 * The x position of the grid
		 */
		public function get x():Number { return _x; }
		public function set x( value:Number ):void 
		{
			_x = value;
		}
		
		
		/**
		 * The y position of the grid
		 */
		public function get y():Number { return _y; }
		public function set y( value:Number ):void 
		{
			_y = value;
		}
		
	}
	
}
