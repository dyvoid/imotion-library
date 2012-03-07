package test.evo.voronoi
{
    import com.nodename.Delaunay.Voronoi;
    import com.nodename.geom.LineSegment;

    import flash.display.BitmapData;

    import flash.display.Sprite;
    import flash.events.Event;

    import flash.geom.Point;
    import flash.geom.Rectangle;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(backgroundColor="#ffffff",width="1024",height="700",frameRate="31")]
    public class VoronoiTest extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _result:Sprite;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        private var _voronoi:Voronoi;


        private var _points:Vector.<Point>;


        public function VoronoiTest()
        {
            _result = new Sprite();
            this.addChild( _result );
            this.x = 50;
            this.y = 50;

            var rect:Rectangle = new Rectangle( 0, 0, 500, 500 );

            _points = new Vector.<Point>();
            var p1:Point = new Point( 100, 100 );
            var p2:Point = new Point( 400, 400 );
            var p3:Point = new Point( 150, 400 );
            var p4:Point = new Point( 200, 200 );

            _points.push( p1 );
            _points.push( p2 );
            _points.push( p3 );
            _points.push( p4 );

            /*for ( var i:int = 0; i < 1000; i++ )
            {
                points.push( new Point( Math.random() * rect.width, Math.random() * rect.height ) );
            }*/

            /*points.push( new Point( rect.left, rect.top  ) );
            points.push( new Point( rect.right, rect.top  ) );
            points.push( new Point( rect.left, rect.bottom  ) );
            points.push( new Point( rect.right, rect.bottom  ) );*/

            var colors:Vector.<uint> = new Vector.<uint>();
            colors.push( 0xff0000 );
            colors.push( 0x00ff00 );
            colors.push( 0x0000ff );

            _voronoi = new Voronoi( _points, null, rect );

//            var segments:Vector.<LineSegment> = voronoi.regions();
//            drawLineSegments( segments );

//            var t:Vector.<Point> = voronoi.region( p3 );
//            drawRegion( t );

            for each ( var p:Point in _points )
            {
                _result.graphics.beginFill( 0 );
                _result.graphics.drawCircle( p.x, p.y, 2 );
                _result.graphics.endFill();
            }

            this.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
        }


        private function enterFrameHandler( e:Event ):void
        {
            _points[ 0 ].x = _points[ 0 ].x + 1;

            var rect:Rectangle = new Rectangle( 0, 0, 500, 500 );
            _voronoi = new Voronoi( _points, null, rect );
            var regions:Vector.<Vector.<Point>> = _voronoi.regions();
            drawRegions( regions );
        }


        private function drawRegion( region:Vector.<Point> ):void
        {
            _result.graphics.beginFill( Math.random() * 0xffffff );
            _result.graphics.moveTo( region[ 0 ].x, region[ 0 ].y );

            for ( var j:int = 1; j < region.length; j++ )
            {
                var p:Point = region[j];
                _result.graphics.lineTo( p.x, p.y );
            }

            _result.graphics.endFill();
        }


        private function drawRegions( regions:Vector.<Vector.<Point>> ):void
        {
            for each ( var region:Vector.<Point> in regions )
            {
                drawRegion( region );
            }
        }


        private function drawLineSegments( segments:Vector.<LineSegment> ):void
        {
//            _result.graphics.beginFill( 0xff0000 );
            _result.graphics.lineStyle( 1 );
//            _result.graphics.moveTo( segments[ 0 ].p0.x, segments[ 0 ].p0.y );
//

            for each ( var l:LineSegment in segments )
            {
                _result.graphics.moveTo( l.p0.x, l.p0.y );
                _result.graphics.lineTo( l.p1.x, l.p1.y );
            }

//            _result.graphics.endFill();
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


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