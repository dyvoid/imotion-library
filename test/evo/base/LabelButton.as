package test.evo.base
{
    import com.greensock.motionPaths.RectanglePath2D;

    import flash.display.Sprite;
    import flash.filters.BevelFilter;
    import flash.geom.Rectangle;
    import flash.text.TextField;


    /**
     * @author Pieter van de Sluis
     */
    public class LabelButton extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function LabelButton( label:String )
        {
            init( label );
        }


        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init( label:String ):void
        {
            var tfLabel:TextField = new TextField();
            tfLabel.text = label;
            tfLabel.textColor = 0xffffff;
            tfLabel.width  = tfLabel.textWidth + 5;
            tfLabel.height = tfLabel.textHeight + 5;
            tfLabel.x = 4;
            tfLabel.y = 3;
            this.addChild( tfLabel );

            var bounds:Rectangle = tfLabel.getBounds( this );

            graphics.beginFill( 0x666666 );
            graphics.drawRect( 0, 0, bounds.width + 5, bounds.height + 5 );
            graphics.endFill();

            filters = [ new BevelFilter( 2, 45, 0xffffff, 1, 0, 1, 2, 2, 1 ) ];

            buttonMode = true;
            mouseChildren = false;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }
}