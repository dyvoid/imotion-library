/**
 * @author    Pieter van de Sluis
 */
package test.evo.util
{
    public class Trig
    {
        public static function radToDeg( radians:Number ):Number
        {
            return radians * (180 / Math.PI);
        }


        public static function degToRad( degrees:Number ):Number
        {
            return degrees * ( Math.PI / 180 );
        }
    }

}
