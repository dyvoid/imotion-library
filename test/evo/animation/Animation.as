package nl.toyota.veiliguitenthuis.view.world.components.animation
{
    import com.greensock.TimelineMax;
    import com.greensock.TweenAlign;
    import com.greensock.TweenMax;
    import com.greensock.easing.Linear;

    import flash.display.FrameLabel;
    import flash.display.MovieClip;
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;

    import nl.toyota.veiliguitenthuis.util.StageRef;

    import nl.toyota.veiliguitenthuis.view.components.buttons.state.StateRange;
    import nl.usmedia.lib.display.EventManagedMovieClip;
    import nl.usmedia.lib.util.math.Rnd;


    /**
     * Package:    nl.toyota.veiliguitenthuis.view.world.components.animation
     * Class:      Animation
     *
     * @author     pieter.van.de.sluis
     * @since      7/19/11
     */
    public class Animation extends EventManagedMovieClip implements IAnimation
    {
        private var _stateRanges        :Dictionary;
        private var _animationRanges    :Vector.<StateRange>;

        private var _currStateRange :StateRange;

        private var _id             :String;

        private var _isPlaying      :Boolean = true;
        private var _isPaused       :Boolean = false;
        private var _isStopped      :Boolean = false;

        private var _isActive       :Boolean = true;

        private var _defaultEaseFunction    :Function = Linear.easeNone;

        private var _timeScale      :Number = 31 / 25;  // Application fps: 31, Animations fps: 25

        private var _minDelay       :Number = 0;
        private var _maxDelay       :Number = 0;

        private var _animTarget     :MovieClip;

        private var _timeline       :TimelineMax;
        private var _idleTimer      :Timer;

        private var _isEnabled      :Boolean = true;
        
        private var _queue          :Vector.<String>;

        //_________________________________________________________________________________________________________
        //                                                                                    C O N S T R U C T O R

        public function Animation()
        {
            super();
            init();
        }

        //_________________________________________________________________________________________________________
        //                                                                              P U B L I C   M E T H O D S

        override public function play():void
        {
            if ( !_isEnabled || _isPlaying ) return;

            _isPlaying = true;
            _isPaused  = false;
            _isStopped = false;

            startIdle();
        }


        private function startIdle():void
        {
            if ( !isNaN( minDelay ) && !isNaN( maxDelay) )
            {
                _idleTimer.reset();
                _idleTimer.delay = Rnd.integer( minDelay, maxDelay ) * 1000;
                _idleTimer.start();

                var idleStateRange:StateRange = _stateRanges[ AnimationStateName.IDLE ];

                if ( idleStateRange.length == 0 )
                {
                    _animTarget.gotoAndStop( AnimationStateName.IDLE );
                }
                else
                {
                    addAnimationToQueue( AnimationStateName.IDLE );
                }
            }
            else
            {
                playRandomAnimation();
            }
        }


        private function playRandomAnimation():void
        {
            var animRangeIndex:uint  = Math.floor( Math.random() * _animationRanges.length );
            var animRangeName:String = _animationRanges[ animRangeIndex].stateName;

            addAnimationToQueue( animRangeName );
        }


        public function pause():void
        {
            if ( _isPaused ) return;

            _isPlaying = false;
            _isPaused  = true;
            _isStopped = false;
            
            if ( _timeline )
                _timeline.pause();
        }


        override public function stop():void
        {
            if ( _isStopped ) return;

            _isPlaying = false;
            _isPaused  = false;
            _isStopped = true;

            if ( _timeline )
                _timeline.kill();

            if ( _idleTimer )
            {
                _idleTimer.stop();
                _idleTimer.reset();
            }

            addAnimationToQueue( AnimationStateName.HOLD );
        }


        public function setActive( isActive:Boolean ):void
        {
            if ( _isActive == isActive ) return;

            _isActive = isActive;
            visible = isActive;
        }

        //_________________________________________________________________________________________________________
        //                                                                          G E T T E R S  /  S E T T E R S

        public function get id():String
        {
            return _id;
        }

        public function set id( value:String ):void
        {
            _id = value;
        }


        public function get isActive():Boolean
        {
            return _isActive;
        }



        public function get currStateRange():StateRange
        {
            return _currStateRange;
        }


        public function get isPlaying():Boolean
        {
            return _isPlaying;
        }


        public function get isPaused():Boolean
        {
            return _isPaused;
        }


        public function get isEnabled():Boolean
        {
            return _isEnabled;
        }


        public function set isEnabled( value:Boolean ):void
        {
            _isEnabled = value;
        }


        public function get defaultEaseFunction():Function
        {
            return _defaultEaseFunction;
        }


        public function set defaultEaseFunction( value:Function ):void
        {
            _defaultEaseFunction = value;
        }


        public function get animTarget():MovieClip
        {
            return _animTarget;
        }


        public function set animTarget( value:MovieClip ):void
        {
            if ( _animTarget == value ) return;

            _animTarget = value;
            gatherStateRanges();
            stop();
            pause();
        }

        public function get timeScale():Number
        {
            return _timeScale;
        }


        public function set timeScale( value:Number ):void
        {
            _timeScale = value;
        }


        public function get minDelay():Number
        {
            return _minDelay;
        }


        public function set minDelay( value:Number ):void
        {
            _minDelay = value;
        }


        public function get maxDelay():Number
        {
            return _maxDelay;
        }


        public function set maxDelay( value:Number ):void
        {
            _maxDelay = value;
        }

        //_________________________________________________________________________________________________________
        //                                                                              E V E N T   H A N D L E R S

        private function idleTimerTickHandler( e:TimerEvent ):void
        {
            playRandomAnimation();
        }

        //_________________________________________________________________________________________________________
        //                                                                        P R O T E C T E D   M E T H O D S

        protected function addAnimationToQueue( stateName:String, delay:Number = 0, easeFunction:Function = null ):void
        {
            var targetStateRange:StateRange = _stateRanges[ stateName ];
            var startFrameNr:uint;
            var endFrameNr:uint;
            var length:uint;

            if ( _stateRanges.length == 0 || !targetStateRange )
            {
                startFrameNr = 1;
                endFrameNr   = _animTarget.currentScene.numFrames;
                length       = endFrameNr - startFrameNr;
            }
            else
            {
                startFrameNr = targetStateRange.startFrameNr;
                endFrameNr   = targetStateRange.endFrameNr;
                length       = targetStateRange.length;
            }

            _currStateRange = targetStateRange;
            easeFunction = ( easeFunction != null ) ? easeFunction : _defaultEaseFunction;

            if ( !_timeline || _timeline.totalProgress == 1 )
            {
                _timeline = new TimelineMax( { align: TweenAlign.SEQUENCE, onComplete: onAnimationRangeComplete } );
            }
            
            _timeline.append( TweenMax.to( _animTarget, 0, { frame: startFrameNr, delay: delay } ) );

            if ( length != 0 )
            {
                var animDuration:Number = ( length * _timeScale ) * ( 1 / StageRef.getStage().frameRate );

                _timeline.append( TweenMax.to( _animTarget, animDuration,
                        { frame: endFrameNr,
                          ease: easeFunction } ) );
            }

            dispatchEvent( new AnimationEvent( AnimationEvent.STATE_START, targetStateRange ) );
        }


        protected function onAnimationRangeComplete():void
        {
            dispatchEvent( new AnimationEvent( AnimationEvent.STATE_END, _currStateRange ) );

            if ( _currStateRange.stateName.indexOf( AnimationStateName.LOOP ) != -1 )
            {
                addAnimationToQueue( _currStateRange.stateName );
            }
            else if ( _currStateRange.stateName == AnimationStateName.HOLD )
            {
                _timeline.kill();
                _timeline = null;
            }
            else
            {
                startIdle();
            }
        }

        //_________________________________________________________________________________________________________
        //                                                                            P R I V A T E   M E T H O D S

        private function init():void
        {
            if ( name.indexOf( "anim_" ) != -1 )
            {
                _id = name.substr( 5 );
            }
            
            animTarget = this;

            _idleTimer = new Timer( 0, 0 );
            startEventInterest( _idleTimer, TimerEvent.TIMER, idleTimerTickHandler );

            initAssets();
            initListeners();
        }


        private function initAssets():void
        {
            
        }


        private function initListeners():void
        {

        }


        private function gatherStateRanges():void
        {
            _stateRanges = new Dictionary();

            var stateRange:StateRange;

            var labels:Array = _animTarget.currentScene.labels;

            if ( labels.length > 0 )
            {
                for ( var i:int = 0; i < labels.length; i++ )
                {
                    var frameLabel:FrameLabel = labels[i];

                    if ( stateRange )
                    {
                        stateRange.endFrameNr = frameLabel.frame - 1;
                    }

                    stateRange = new StateRange( frameLabel.name, frameLabel.frame );

                    _stateRanges[ frameLabel.name ] = stateRange;
                }

                if ( stateRange )
                {
                    stateRange.endFrameNr = _animTarget.totalFrames;
                }
            }
            else
            {
                _stateRanges[ AnimationStateName.LOOP ] = new StateRange( AnimationStateName.LOOP, 1, _animTarget.totalFrames );
            }

            if ( _stateRanges[ AnimationStateName.HOLD ] == null )
            {
                _stateRanges[ AnimationStateName.HOLD ] = new StateRange( AnimationStateName.HOLD, 1, 1 );
            }
            
            if ( _stateRanges[ AnimationStateName.IDLE ] == null )
            {
                _stateRanges[ AnimationStateName.IDLE ] = new StateRange( AnimationStateName.IDLE, 1, 1 );
            }
            
            
            _animationRanges = new Vector.<StateRange>();

            for each ( stateRange in _stateRanges )
            {
                if ( stateRange.stateName != AnimationStateName.HOLD && stateRange.stateName != AnimationStateName.IDLE )
                {
                    _animationRanges.push( stateRange );
                }
            }
        }

    }

}