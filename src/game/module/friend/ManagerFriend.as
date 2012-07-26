package game.module.friend
{
	import com.utils.StringUtils;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-7  ����11:32:02 
	 * 好友管理
	 */
	public class ManagerFriend extends EventDispatcher
	{
		private static var _instance : ManagerFriend;

		public function ManagerFriend(target : IEventDispatcher = null)
		{
			super(target);
			StoC;
			CtoS;
			// initViews();
		}

		public static function getInstance() : ManagerFriend
		{
			if (_instance == null)
			{
				_instance = new ManagerFriend();
			}
			return _instance;
		}

		// public static function get instance():ManagerFriend
		// {
		// if (_instance == null)
		// {
		// _instance = new ManagerFriend();
		// }
		// return _instance;
		// }
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		// public var friendApplyIco : FriendApplyIcoButton;
		// private function initViews() : void
		// {
		// friendApplyIco = new FriendApplyIcoButton();
		// }
		/** 协议(客户端至服务器) -- 好友 */
		public function get CtoS() : ProtoCtoSFriend
		{
			return ProtoCtoSFriend.instance;
		}

		/** 协议(服务器至客户端) -- 好友 */
		public function get StoC() : ProtoStoCFriend
		{
			return ProtoStoCFriend.instance;
		}

		/** 数据模型 -- 好友 */
		public function get modelFriend() : ModelFriend
		{
			return ModelFriend.instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 获取最近联系人列表 */
		public function getLastLinkData() : Vector.<VoFriendItem>
		{
			return modelFriend.lastLinkData;
		}

		/** 加入最近联系人 */
		public function addLastLinkByName(playerName : String) : VoFriendItem
		{
			if (!playerName) return null;
			return modelFriend.addLastLinkByName(playerName);
		}

		/** 查找最近联系人 */
		public function findLastLinkByName(playerName : String) : VoFriendItem
		{
			if (!playerName) return null;
			return modelFriend.findLastLinkByName(playerName);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 检查是否在好友列表中,根据玩家ID */
		public function isInFriendListByPlayerId(playerId : uint) : Boolean
		{
			return modelFriend.isInFriendListByPlayerId(playerId);
		}

		/** 检查是否在好友列表中,根据玩家名称 */
		public function isInFriendListByPlayerName(playerName : String) : Boolean
		{
			return modelFriend.isInFriendListByPlayerName(playerName);
		}

		/** 检查是否在黑名单中,根据玩家ID */
		public function isInBackListByPlayerId(playerId : uint) : Boolean
		{
			return modelFriend.isInBackListByPlayerId(playerId);
		}

		/** 检查是否在黑名单中,根据玩家名称 */
		public function isInBackListByPlayerName(playerName : String) : Boolean
		{
			return modelFriend.isInBackListByPlayerName(playerName);
		}

		/** 发送到服务器 -- 通过名字添加好友 */
		public function addFriendByPlayerName(playerName : String) : void
		{
			// if(CheckAddFriend.check(playerName) == false)
			// {
			// return;
			// }

			if (CheckAddFriend.addFriendCheck(playerName) == false)
			{
				return;
			}

			playerName = StringUtils.trim(playerName);
			if (!playerName) return;

			// 发送到服务器 -- 通过名字添加好友
			CtoS.cs_FollowName(playerName);
		}

		/** 发送到服务器 -- 通过玩家id删除知己 */
		public function deleteFriendByPlayerId(playerId : uint) : void
		{
			if (!playerId) return;
			// 发送到服务器 -- 删除知己
			CtoS.cs_Unfollow(playerId);
		}

		/** 发送到服务器 -- 通过名字添加黑名单 */
		public function moveInBacklistByPlayerName(playerName : String) : void
		{
			if (!playerName) return;
			// 发送到服务器 -- 通过名字添加黑名单
			CtoS.cs_BlockName(playerName);
		}

		/** 发送到服务器 -- 通过玩家id移出黑名单 */
		public function moveOutBacklistByPlayerId(playerId : uint) : void
		{
			if (!playerId) return;
			// 发送到服务器 -- 通过玩家id移出黑名单
			CtoS.cs_Unblock(null, playerId);
		}

		/** 发送到服务器 -- 通过玩家名字移出黑名单 */
		public function moveOutBacklistByPlayerName(playerName : String) : void
		{
			if (!playerName) return;
			// 发送到服务器 -- 通过玩家id移出黑名单
			CtoS.cs_Unblock(playerName);
		}

		/** 发送到服务器 -- 用过玩家id列表更新玩家是否在线 */
		public function updatePlayersIsOnlineByPlayerIds(playerIds : Vector.<uint>) : void
		{
			if (playerIds == null) return;
			// 发送到服务器 -- 通过玩家id移出黑名单
			CtoS.cs_RecentOnline(playerIds);
		}
	}
}
