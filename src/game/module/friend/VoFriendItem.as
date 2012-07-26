package game.module.friend
{
	import com.utils.PotentialColorUtils;
	import game.net.data.StoC.ContactPlayer;

	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-4  ����11:53:49 
	 */
	public class VoFriendItem
	{
		/** 陌生人 0 */
		public static const TYPE_STRANGER : uint = 0;
		/** 我加了她为好友 1 */
		public static const TYPE_I_ADD_SHE : uint = 1;
		/** 她加了我为好友 3 */
		public static const TYPE_SHE_ADD_ME : uint = 3;
		/** 彼此好友 2 */
		public static const TYPE_BOTH : uint = 2;
		/** 黑名单中的 3 */
		public static const TYPE_BACKLIST : uint = 4;
		/** 所在组 */
		public var group : VoFriendGroup;
		/** 所在组ID */
		public var groupId : int = -1;
		/** 服务器ID */
		public var serverId : uint;
		/** id */
		public var id : uint;
		/** 名称 */
		public var name : String;
		/** 是否是男的 */
		public var isMale : Boolean;
		/** 职业 */
		public var job : uint;
		/** 等级 */
		public var level : uint;
		/** 判断颜色属性值 */
		public var colorPropertyValue : Number;
		/** 判断是加载浅色背景还是深色背景 **/
		public var bgNum : int;
		/** 
		 * 好友类型 
		 * 1 陌生人
		 * 2 一厢情愿的好友
		 * 3 彼此好友
		 * 4 黑名单中的
		 * @see #TYPE_STRANGER
		 * @see #TYPE_SINGLE
		 * @see #TYPE_BOTH
		 * @see #TYPE_BACKLIST
		 */
		public var type : uint = TYPE_STRANGER;
		/** 是否在线 */
		public var isOnline : Boolean = false;
		/** 最后联系时间 */
		public var lastLinkTime : uint = 0;
		/** 顺序 */
		public var sequence:int = 0;

		/** 镜像值,根据VoFriendItem */
		public function mirrorValueByVoFriendItem(data : VoFriendItem) : void
		{
			this.group = data.group;
			this.groupId = data.groupId;
			this.serverId = data.serverId;
			this.id = data.id;
			this.name = data.name;
			this.isMale = data.isMale;
			this.job = data.job;
			this.level = data.level;
			this.colorPropertyValue = data.colorPropertyValue;
			this.type = data.type;
			this.isOnline = data.isOnline;
			this.lastLinkTime = data.lastLinkTime;
		}

		/** 镜像值,根据ContactPlayer */
		public function mirrorValueByContactPlayer(data : ContactPlayer) : void
		{
			this.groupId = data.relation ;
			this.group = ModelFriend.instance.friendGroupDic[this.groupId];
			this.serverId = data.serverId;
			this.id = data.id;
			this.name = data.name;
			this.isMale = data.isMale;
			this.job = data.job * 2 - ( data.isMale ? 1 : 0 ) ;
			this.level = data.level;
			this.colorPropertyValue = PotentialColorUtils.getColorLevel(data.potential);
			this.type = data.relation == 1 ? VoFriendItem.TYPE_BOTH : VoFriendItem.TYPE_I_ADD_SHE;
			this.isOnline = data.isOnline;
		}
	}
}
