package game.core.avatar
{
	/**
	 * @author yangyiqiang
	 */
	public class AvatarType
	{
		// 类型 决定加载资源
		/** 角色 */
		public static const PLAYER_RUN : int = 0;
		/** 战斗正面 */
		public static const PLAYER_BATT_FRONT : int = 1;
		/** 战斗背面 */
		public static const PLAYER_BATT_BACK : int = 2;
		/** npc */
		public static const NPC_TYPE : int = 3;
		/** monster */
		public static const MONSTER_TYPE : int = 4;
		/** 宠物*/
		public static const PET_TYPE : int = 5;
		/**法术技能效果*/
		public static const SKILL_TYPE_SPELL : int = 6;
		/**buff*/
		public static const BUFF_TYPE : int = 7;
		/**地面效果*/
		public static const SKILL_TYPE_GROUND : int = 8;
		/** 座骑 */
		public static const SEAT_TYPE : int = 9;
		/** 变身avatar*/
		public static const CHANGE_AVATAR : int = 10;
		/** 通用特效，序列帧 */
		public static const COMMON_EFFECT : int = 11;
		// 标识 决定调用的avatar类  例如 MY_AVATAR 调用 AvatarMySelf
		/** 自己*/
		public static const MY_AVATAR : int = 101;
		/** Performer 剧情动*/
		public static const  PERFORMER_TYPE : int = 102;
		/** 护送任务avatar*/
		public static const FLLOW_TYPE : int = 103;
		/** 双人avatar*/
		public static const COUPLE_TYPE : int = 104 ;
		/** 钓鱼avatar*/
		public static const FISHER_TYPE : int = 105;
		/** 龟仙avatar*/
		public static const TURTLE_AVATAR : int = 106;
		/** 进贡镖车avatar */
		public static const DRAY_AVATER : int = 107;
		/** 通用 
		 *  1: 升级               1677721601
		 *  2: 任务标识	          1677721602
		 *  3: 人物出现前的暗影	  1677721603
		 *  4: 人物出现动画	      1677721604
		 */
		public static const AVATAR_SHOW : int = 1677721604;
		// public static const COMM_TYPE : int = 100;
	}
}
