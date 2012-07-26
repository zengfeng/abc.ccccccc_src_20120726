package game.module.friend
{
	import game.net.core.Common;
	import game.net.data.CtoS.CSAddNewFansAll;
	import game.net.data.CtoS.CSBlockId;
	import game.net.data.CtoS.CSBlockName;
	import game.net.data.CtoS.CSFollowName;
	import game.net.data.CtoS.CSRecentContact;
	import game.net.data.CtoS.CSRecentOnline;
	import game.net.data.CtoS.CSShowContactMore;
	import game.net.data.CtoS.CSShowContext;
	import game.net.data.CtoS.CSSpecialOpNotification;
	import game.net.data.CtoS.CSUnblock;
	import game.net.data.CtoS.CSUnfollow;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;


	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-9  ����5:16:23 
	 * 协议(客户端至服务器) -- 好友
	 */
	public class ProtoCtoSFriend extends EventDispatcher
	{
		/** 单例对像 */
		private static var _instance : ProtoCtoSFriend;

		public function ProtoCtoSFriend(target : IEventDispatcher = null)
		{
			super(target);
		}

		/** 获取单例对像 */
		static public function get instance() : ProtoCtoSFriend
		{
			if (_instance == null)
			{
				_instance = new ProtoCtoSFriend();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 发送协议[0x40] -- 第一次请求好友列表 */
		public function cs_ShowContext() : void
		{
			var message : CSShowContext = new CSShowContext();
			Common.game_server.sendMessage(0x40, message);
		}

//		/** 发送协议[0x41] -- 新增好友组 */
//		public function cs_AddFriendGrp(groupName : String) : void
//		{
//			var message : CSAddFriendGrp = new CSAddFriendGrp();
//			message.groupName = groupName;
//			Common.game_server.sendMessage(0x41, message);
//		}
//
//		/** 发送协议[0x42] -- 删除好友组 */
//		public function cs_DelFriendGrp(groupId : int) : void
//		{
//			var message : CSDelFriendGrp = new CSDelFriendGrp();
//			message.groupId = groupId;
//			Common.game_server.sendMessage(0x42, message);
//		}
//
//		/** 发送协议[0x43] -- 修改好友组名 */
//		public function cs_ChgGroupName(groupId : int, groupName : String) : void
//		{
//			var message : CSChgGroupName = new CSChgGroupName();
//			message.groupId = groupId;
//			message.groupName = groupName;
//			Common.game_server.sendMessage(0x43, message);
//		}

		/** 发送协议[0x44] -- 通过名字添加好友 */
		public function cs_FollowName(playerName : String) : void
		{
			var message : CSFollowName = new CSFollowName();
			message.playerName = playerName;
			Common.game_server.sendMessage(0x44, message);
		}

		/** 发送协议[0x47] -- 通过id批量添加好友 */
		public function cs_FollowId(ids : Vector.<uint>) : void
		{
			var message : CSAddNewFansAll = new CSAddNewFansAll();
			Common.game_server.sendMessage(0x47, message);
		}

		/** 发送协议[0x46] -- 删除知己 */
		public function cs_Unfollow(playerId : uint) : void
		{
			var message : CSUnfollow = new CSUnfollow();
			message.playerId = playerId;
			Common.game_server.sendMessage(0x46, message);
		}

//		/** 发送协议[0x47] -- 修改好友的组别 */
//		public function cs_ChgFollowGrp(groupId : uint, playerId : uint) : void
//		{
//			var message : CSChgFollowGrp = new CSChgFollowGrp();
//			message.groupId = groupId;
//			message.friendId = playerId;
//			Common.game_server.sendMessage(0x47, message);
//		}

		/** 发送协议[0x48] -- 通过名字添加黑名单 */
		public function cs_BlockName(playerName : String) : void
		{
			var message : CSBlockName = new CSBlockName();
			message.blockName = playerName;
			Common.game_server.sendMessage(0x48, message);
		}

		/** 发送协议[0x49] -- 通过id添加黑名单 */
		public function cs_BlockId(playerId : uint) : void
		{
			var message : CSBlockId = new CSBlockId();
			message.blockId = playerId;
			Common.game_server.sendMessage(0x49, message);
		}

		/** 发送协议[0x4A] -- 通过玩家id移出黑名单 */
		public function cs_Unblock(playerName : String, playerId : uint = 0) : void
		{
			var message : CSUnblock = new CSUnblock();
			if (playerName) message.blockName = playerName;
			if (playerId) message.blockId = playerId;
			Common.game_server.sendMessage(0x4A, message);

			ModelFriend.instance.moveOutBacklistByName(playerName);
		}

		/** 发送协议[0x4C] -- 除了第一次打开社交面板，传递在线的block和最近联系人 */
		public function cs_ShowContactMore() : void
		{
			var message : CSShowContactMore = new CSShowContactMore();
			Common.game_server.sendMessage(0x4C, message);
		}

		/** 发送协议[0x4D] -- 客户端请求某最近联系人信息 */
		public function cs_RecentContact(playerName : String) : void
		{
			var message : CSRecentContact = new CSRecentContact();
			message.name = playerName;
			Common.game_server.sendMessage(0x4D, message);
		}

		// /** 发送协议[0x4E] -- 忽略好友申请(若为空，则表示全部忽略) */
		// public function cs_CSDismissFans(playerId : uint) : void
		// {
		// var message : CSDismissFans = new CSDismissFans();
		// message.player = playerId;
		// Common.game_server.sendMessage(0x4E, message);
		// }
		
		/** 发送协议[0x5A] -- 同意和忽略好友申请 */
        public function cs_CSAgreeOrDismissFans(playerType : uint, playerId : uint) : void
        {
            var message : CSSpecialOpNotification = new CSSpecialOpNotification();
			message.type = playerType;
			message.id = playerId;
            Common.game_server.sendMessage(0x5A, message);
        }
		
		
		// /** 发送协议[0x4E] -- 忽略好友申请(若为空，则表示全部忽略) */
		// public function cs_CSDismissAllFans() : void
		// {
		// var message : CSDismissFans = new CSDismissFans();
		// Common.game_server.sendMessage(0x4E, message);
		// }

		/** 发送协议[0x4F] -- 请求最近联系人在线状况 */
		public function cs_RecentOnline(ids : Vector.<uint>) : void
		{
			if (ids == null) return;
			var message : CSRecentOnline = new  CSRecentOnline();
			message.players = ids;
			Common.game_server.sendMessage(0x4F, message);
		}
	}
}
