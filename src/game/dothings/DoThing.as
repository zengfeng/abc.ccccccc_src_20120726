package game.dothings
{
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-4-25 ����6:21:28
     */
    public class DoThing
    {
        public static const THING_DO_WALK : int;
        public static const THING_DO_TRANSPORT : int;
        public static const THING_DO_CHANGE_MAP : int;
        public static const THING_DO_OPEN_WORLD_MAP : int;
        public static const THING_PRACTICE : int;
        public static const THING_QUEST : int;
        public static const THING_QUEST_NPC_DIALOG_PANEL : int;
        public static const THING_STORY : int;
        public static const THING_DUPL_MAP : int;
        public static const THING_DUPL_HOOK : int;
        public static const THING_DUPL_ENTER_PANEL : int;
        public static const THING_DUPL_HOOK_PANEL : int;
        public static const THING_COMPETE : int;
        public static const THING_ACTIVITY_GROUP_BATTLE : int;
        public static const THING_ACTIVITY_BOSS_WAR : int;
        public static const THING_ACTIVITY_CONVOY : int;
        public static const THING_ACTIVITY_FEAST : int;
        public static const THING_ACTIVITY_FISHING : int;
        public static const THING_CLAN : int;
        public static const THING_CLAN_ACTIVITY_BOSS_WAR : int;
        public static const THING_CLAN_ACTIVITY_ESCORT : int;
        public static const DO_WALK_UN_LIST : Array = [THING_PRACTICE, THING_ACTIVITY_GROUP_BATTLE, THING_ACTIVITY_FISHING, THING_QUEST_NPC_DIALOG_PANEL, THING_DUPL_HOOK, THING_DUPL_ENTER_PANEL, THING_DUPL_HOOK_PANEL];
        private static var now : int = 0;

        public static function checkEnWalk() : Boolean
        {
            var value : Boolean = true;

            return value;
        }

        public static function setDoWalk(isDo : Boolean, yesCall : Function = null, args : Array = null) : void
        {
        }
    }
}
