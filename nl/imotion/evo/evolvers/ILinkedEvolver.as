package nl.imotion.evo.evolvers
{
    /**
     * @author Pieter van de Sluis
     */
    public interface ILinkedEvolver extends IEvolver
    {

        function get previous():ILinkedEvolver;


        function set previous( value:ILinkedEvolver ):void;


        function get next():ILinkedEvolver;


        function set next( value:ILinkedEvolver ):void;

    }
    
}