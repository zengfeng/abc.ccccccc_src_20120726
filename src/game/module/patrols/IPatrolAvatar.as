package game.module.patrols
{
    /**
     * @author 1
     */
    public interface IPatrolAvatar
    {
        function patrolCall(patrol : Patrol) : void;

        function toString() : String;
    }
}
