package test.evo.flowtext
{
    import flash.display.Sprite;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;


    /**
     * @author Pieter van de Sluis
     */
    public class FlowText extends Sprite
    {
        private var _brightness     :Number;

        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var textField:TextField;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function FlowText()
        {
            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function update():void
        {
            var grayScale:uint = Math.round( _brightness * 0xFF );

            textField.textColor = grayScale << 16 | grayScale << 8 | grayScale;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            textField = new TextField();
            var tf:TextFormat = new TextFormat();
//            tf.font = "junkos typewriter";
//            tf.font = "Arial";
            tf.font = "Andalus";
            tf.size = 15;

            textField.defaultTextFormat = tf;
            textField.setTextFormat( tf );
            textField.antiAliasType = AntiAliasType.ADVANCED;
            textField.embedFonts = true;

            this.addChild( textField );

            text = "test";
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get text():String
        {
            return textField.text;
        }


        public function set text( value:String ):void
        {
            textField.text = value;

            textField.width = textField.textWidth + 5;
            textField.height = textField.textHeight + 5;
            textField.x = -textField.width / 2;
            textField.y = -textField.height / 2;
        }


        public function get scale():Number
        {
            return ( scaleX + scaleY ) * 0.5;
        }


        public function set scale( value:Number ):void
        {
            scaleX =
            scaleY = value;
        }


        public function get brightness():Number
        {
            return _brightness;
        }


        public function set brightness( value:Number ):void
        {
            _brightness = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}