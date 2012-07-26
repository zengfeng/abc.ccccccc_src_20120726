package game.module.patrols
{
    /**
     * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-12-1 ����7:43:00
     */
    public class PatrolStatus
    {
        /** 站立 */
        public static const STAND : uint = 1;
        /** 移动 */
        public static const MOVE : uint = 2;
        /** 战斗 */
        public static const BATTLE : uint = 3;
        /** 退出 */
        public static const QUIT : uint = 4;
        /** 追踪 */
        public static const TRACK : uint = 5;
        /** 停止 */
        public static const STOP : uint = 6;
		/** 挂了 */
		public static const DIE:uint = 7;
    }
}
