package game.module.gem.identify
{
	import com.commUI.alert.Alert;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.config.ItemConfigManager;
	import game.core.user.StateManager;
	import game.net.core.Common;
	import game.net.data.CtoS.CSGemIdentify;
	import game.net.data.StoC.SCGemIdentifyResult;
	import log4a.Logger;




	/**
	 * @author jian
	 */
	public class GemIdentifyControl extends EventDispatcher
	{
		private static var MEET_LUCK_MESSAGES : Array = [85, 130, 131];
		private var _item : Item;
		private var _master : GemMasterVO;
		private var _wantLuck : Boolean = false;
		private var _lock : Boolean = false;
		private var _identifiedGem : Item;

		public function set item(value : Item) : void
		{
			_item = value;
		}

		public function get item() : Item
		{
			return _item;
		}

		public function set master(value : GemMasterVO) : void
		{
			_master = value;
		}

		public function get master() : GemMasterVO
		{
			return _master;
		}

		public function set wantLuck(value : Boolean) : void
		{
			_wantLuck = value;
		}

		public function get identifiedGem() : Item
		{
			return _identifiedGem;
		}

		public function identify() : void
		{
			if (_lock)
			{
				//trace("原石鉴定等待服务器返回");
				return;
			}

			sendIdentifyMessage();
		}

		/*
		 * 发送鉴定数据包
		 */
		private function sendIdentifyMessage() : void
		{
			_lock = true;

			var msg : CSGemIdentify = new CSGemIdentify();
			msg.compactId = (_item.id - 500) | (_wantLuck ? 1 : 0) << 8 | _master.id << 11;

			Common.game_server.addCallback(0x2A0, onIdentifyResult);
			Common.game_server.sendMessage(0x2A0, msg);
		}

		/*
		 * 发送是否仙缘数据包
		 */
		private function sendIdenfityLuckMessage(useLuck : Boolean, id : uint) : void
		{
			_lock = true;
			var msg : CSGemIdentify = new CSGemIdentify();
			msg.compactId = (id - 500) | (useLuck ? 0x40 : 0x30);

			Common.game_server.addCallback(0x2A0, onIdentifyResult);
			Common.game_server.sendMessage(0x2A0, msg);
		}

		/*
		 * 鉴定结果
		 */
		private function onIdentifyResult(msg : SCGemIdentifyResult) : void
		{
			Common.game_server.removeCallback(0x2A0, onIdentifyResult);
			_lock = false;

			var luck : Boolean = (msg.compactId >> 16 & 0x1) != 0;
			var id : uint = msg.compactId & 0x7FFF;

			if (luck)
			{
				if (id != _item.id)
				{
					Logger.error("非法数据包");
					return;
				}

				askConfirmLuck();
			}
			else
			{
				var bind : Boolean = (msg.compactId >> 15 & 0x1) != 0;
				showIdentifyResult(id, bind);
			}
		}

		/*
		 * 询问是否仙缘继续
		 */
		private function askConfirmLuck() : void
		{
			var nMsg : uint = MEET_LUCK_MESSAGES.length;
			var msgIndex : uint = uint(Math.floor(Math.random() * nMsg));

			var moneyName : String = ItemConfigManager.instance.getConfig(_master.money).name;
			StateManager.instance.checkMsg(MEET_LUCK_MESSAGES[msgIndex], [_master.price + moneyName], confirmLuckCallback);
		}

		/*
		 * 询问是否仙缘继续2
		 */
		private function confirmLuckCallback(type : String) : Boolean
		{
			var useLuck : Boolean;

			if (type == Alert.OK_EVENT)
				useLuck = true;
			else
				useLuck = false;

			sendIdenfityLuckMessage(useLuck, _item.id);
			return true;
		}

		/*
		 * 显示鉴定结果
		 */
		private function showIdentifyResult(id : uint, bind : Boolean) : void
		{
			var item : Item = ItemManager.instance.newItem(id, bind);
			_identifiedGem = item;

			//trace("获得" + item.name);
			var event : Event = new Event(Event.COMPLETE);
			dispatchEvent(event);
		}
	}
}
