package game.module.notification
{
	import game.module.friend.ModelFriend;
	import game.net.core.Common;
	import game.net.data.CtoS.CSDelNotification;
	import game.net.data.CtoS.CSListContactNotification;
	import game.net.data.CtoS.CSListRewardNotification;
	import game.net.data.CtoS.CSSpecialOpNotification;
	import game.net.data.StoC.NotificationItem;
	import game.net.data.StoC.SCChangeNotification;
	import game.net.data.StoC.SCDelNotification;
	import game.net.data.StoC.SCDelSpecialNotification;
	import game.net.data.StoC.SCListContactNotification;
	import game.net.data.StoC.SCListNotification;
	import game.net.data.StoC.SCListRewardNotification;

	/**
	 * @author yangyiqiang
	 */
	public class NotificationProxy
	{
		private var _icoManager : ICOMenuManager;

		public function NotificationProxy()
		{
			_icoManager = ICOMenuManager.getInstance();
			Common.game_server.addCallback(0x58, listNotification);
			Common.game_server.addCallback(0x59, delNotification);
			Common.game_server.addCallback(0x5A, delSpecialNotification);
			Common.game_server.addCallback(0x5B, changeNotification);            ///*********************
			Common.game_server.addCallback(0x5C, listReward);
			Common.game_server.addCallback(0x5D, listContact);
		}

		private function listNotification(msg : SCListNotification) : void
		{
			for each (var item:NotificationItem in msg.items)
				if (ICOMenuManager.getInstance().getIcoVo(item.typeId))
					_icoManager.addIoc(new VoNotification(item));
		}

		private function delNotification(msg : SCDelNotification) : void
		{
			for each (var uuid:uint in msg.idList)
				_icoManager.removeIoc(uuid);
		}

		private function delSpecialNotification(msg : SCDelSpecialNotification) : void
		{
			if (msg.type == 1)
			{
				_icoManager.updateButtonNum(1,1);
				ModelFriend.instance.sc_removeFriendList(msg);
			}
			else
			{
				_icoManager.changeRewardList(msg.idList);
				_icoManager.updateButtonNum();
			}
		}

		private function changeNotification(msg : SCChangeNotification) : void
		{
			_icoManager.removeIoc(msg.oldId);
			_icoManager.addIoc(new VoNotification(msg.newItem));
		}

		private function listReward(msg : SCListRewardNotification) : void
		{
			_icoManager.showRewardList(msg.items);
		}

		private function listContact(msg : SCListContactNotification) : void
		{
			ModelFriend.instance.sc_FriendApllyList(msg);
		}

		/**
		 * 删除通知
		 */
		public static function delNotifications(list : Vector.<uint>) : void
		{
			var cmd : CSDelNotification = new CSDelNotification();
			cmd.idList = list;
			Common.game_server.sendMessage(0x59, cmd);
		}

		public static function delNotification(id : int) : void
		{
			var cmd : CSDelNotification = new CSDelNotification();
			var list : Vector.<uint>=new Vector.<uint>();
			list.push(id);
			cmd.idList = list;
			Common.game_server.sendMessage(0x59, cmd);
		}

		/**
		 * 操作ICO
		 * type  0 - 领取奖励   1 - 接受好友请求   0x10 - 放弃奖励   0x11 - 删除好友请求
		 * id    处理编号，0表示处理所有
		 */
		public static function opNotification(type : int, id : int) : void
		{
			var cmd : CSSpecialOpNotification = new CSSpecialOpNotification();
			cmd.type = type;
			cmd.id = id;
			Common.game_server.sendMessage(0x5A, cmd);
		}

		/**
		 * 奖励面板
		 */
		public static function reqReward(leastTime : int = 0) : void
		{
			var cmd : CSListRewardNotification = new CSListRewardNotification();
			if (leastTime == 0)
			{
				Common.game_server.sendMessage(0x5C);
			}
			else
			{
				cmd.leastTime = leastTime;
				Common.game_server.sendMessage(0x5C, cmd);
			}
		}

		/**
		 * 请求好友列表
		 */
		public static function reqFriend(leastTime : int = 0) : void
		{
			var cmd : CSListContactNotification = new CSListContactNotification();
			if (leastTime == 0)
			{
				Common.game_server.sendMessage(0x5D);
			}
			else
			{
				cmd.leastTime = leastTime;
				Common.game_server.sendMessage(0x5D, cmd);
			}
		}
	}
}
