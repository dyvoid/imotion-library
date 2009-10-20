		public function destroy():void
		{
			if ( _eventManager != null )
			{
				_eventManager.removeAllListeners();
				_eventManager = null;
			}
			
			if ( this.parent != null )
			{
				parent.removeChild( this );
			}
		}