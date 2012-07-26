package game.module.friend
{
    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-10  ����1:33:39 
     */
    public class UtilFriend
    {
        /** 好友排序 */
        public static function sortFriend(arr : Array = null) : void
        {
            if (arr)
            {
                if (arr == null || arr.length < 2 ) return;
                arr.sortOn(["isOnline", "level", "lastLinkTime", "colorPropertyValue", "name"], [Array.DESCENDING, Array.DESCENDING | Array.NUMERIC, Array.DESCENDING | Array.NUMERIC, Array.DESCENDING | Array.NUMERIC, Array.CASEINSENSITIVE]);
            }
        }
    }
}
