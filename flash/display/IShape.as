package flash.display
{
	import flash.display.Graphics;

	public interface IShape extends IDisplayObject
	{
		/// Specifies the Graphics object belonging to this Shape object, where vector drawing commands can occur.
		function get graphics () : Graphics;
	}
}
