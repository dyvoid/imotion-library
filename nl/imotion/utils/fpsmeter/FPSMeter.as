package nl.imotion.utils.fpsmeter
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import nl.imotion.display.EventManagedSprite;
	
	/**
	 * @author Pieter van de Sluis
	 */
	public class FPSMeter extends EventManagedSprite
	{
		// ____________________________________________________________________________________________________
		// PROPERTIES
		
		private var _timeList			:Array = [];
		private var _fpsList			:Array = [];
		
		private var _fps				:uint;
		private var _numMeasurements	:uint;
		
		private var _lastTime			:Number;
		
		private var _autoStop			:Boolean = false;
		private var _isStarted			:Boolean = false;
		
		// ____________________________________________________________________________________________________
		// CONSTRUCTOR
		
		public function FPSMeter( autoStop:Boolean = true, numMeasurements:uint = 15 ) 
		{
			_autoStop = autoStop;
			_numMeasurements = numMeasurements;
		}
		
		// ____________________________________________________________________________________________________
		// PUBLIC
		
		public function start():void
		{
			if ( !_isStarted )
			{
				_isStarted = true;
				
				_lastTime = getTimer();	
				
				startEventInterest( this, Event.ENTER_FRAME, enterFrameHandler );
			}
		}
		
		
		public function stop():void
		{
			if ( _isStarted )
			{
				_isStarted = false;
				
				_timeList = [];
				_fpsList  = [];
				_lastTime = NaN;
				
				stopEventInterest( this, Event.ENTER_FRAME, enterFrameHandler );
			}
		}
		
		// ____________________________________________________________________________________________________
		// PRIVATE
		
		private function calcFPS():void
		{
			var newTime:uint = getTimer();
			
			var listLength:uint = _timeList.length;
			_timeList[ listLength++ ] = newTime - _lastTime;
			
			var diff:int = listLength - _numMeasurements;
			if ( diff > 0 )
			{
				_timeList.splice( 0, diff );
				listLength = _timeList.length;
			}
			
			var totalTime:uint = 0;
			for ( var i:int = 0; i < listLength; i++ ) 
			{
				totalTime += _timeList[ i ];
			}
			_fps = Math.round( 1000 / ( totalTime / listLength ) );
			
			_lastTime = newTime;
			
			if ( _autoStop )
			{
				checkStableFPS();
			}
		}
		
		
		private function checkStableFPS():void
		{
			var fpsListLength:uint = _fpsList.length;
			_fpsList[ fpsListLength++ ] = _fps;
			
			var fpsDiff:int = fpsListLength - _numMeasurements;
			if ( fpsDiff > 0 )
			{
				_fpsList.splice( 0, fpsDiff );
				fpsListLength = _fpsList.length;
			}
			
			if ( fpsListLength == _numMeasurements )
			{
				var fpsCheck:uint = _fpsList[ 0 ];
				var fpsIsStable	:Boolean = true;
				
				for ( var j:int = 1; j < fpsListLength; j++ ) 
				{
					if ( _fpsList[ j ] != fpsCheck )
					{
						fpsIsStable = false;
						break;
					}
				}
				if ( fpsIsStable )
				{
					stop();
				}
			}
		}
		
		// ____________________________________________________________________________________________________
		// PROTECTED
		
		
		
		// ____________________________________________________________________________________________________
		// GETTERS / SETTERS
		
		public function get fps():uint { return _fps; }
		
		public function get numMeasurements():uint { return _numMeasurements; }
		public function set numMeasurements( value:uint ):void 
		{
			if ( value > 0 )
			{
				_numMeasurements = value;
			}
		}
		
		public function get isStarted():Boolean { return _isStarted; }
		
		public function get autoStop():Boolean { return _autoStop; }
		public function set autoStop( value:Boolean ):void 
		{
			if ( _autoStop != value )
			{
				_autoStop = value;
			
				_fpsList = [];
			}
		}
		
		public function get timePerFrame():uint
		{
			if ( _fps != 0 )
			{
				return 1000 / _fps;
			}
			
			return 0;
		}
		
		// ____________________________________________________________________________________________________
		// EVENT HANDLERS
		
		private function enterFrameHandler( e:Event ):void
		{
			calcFPS();
		}
		
	}

}