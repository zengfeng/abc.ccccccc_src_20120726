package game.module.chatwhisper.view
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import game.module.chatwhisper.ControllerWhisper;
	import game.module.chatwhisper.EventWhisper;
	import game.module.chatwhisper.config.WhisperConfig;
	import game.module.friend.VoFriendItem;
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;



	/**
	 * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-11-20 ����3:17:51
	 */
	public class PlayerList extends GPanel
	{
		public var itemDic : Dictionary = new Dictionary();
		public var selecteItem : PlayerItem;
		public var gap : uint = 0;

		public function PlayerList(data : GPanelData)
		{
			data.verticalScrollPolicy = GPanelData.ON;
			super(data);
			v_sb.height = data.height;
			v_sb.visible = true;

			// setTimeout(test, 3000);
		}

		public function test() : void
		{
			ControllerWhisper.instance.playerList = this;
			ControllerWhisper.instance.initPlayerList();
		}

		/** 添加好友 */
		public function addPlayer(vo : VoFriendItem) : PlayerItem
		{
			if (itemDic[vo.name]) return itemDic[vo.name];

			while (content.numChildren > WhisperConfig.playerListMaxRow)
			{
				content.removeChildAt(content.numChildren - 1);
			}

			var item : PlayerItem = new PlayerItem(_data.width - _data.scrollBarData.width, 20);
			item.vo = vo;
			itemDic[vo.name] = item;
			content.addChildAt(item, 0);
			return item;
		}

		/** 关闭好友 */
		public function closePlayer(vo : VoFriendItem) : void
		{
			var item : PlayerItem = itemDic[vo.name];
			if (item && item.parent)
			{
				item.parent.removeChild(item);
				// 列表布局
				layoutItems();
			}
			delete itemDic[vo.name];
		}

		/** 关闭所有好友 */
		public function closeAllPlayers() : void
		{
			itemDic = new Dictionary();
			while (content.numChildren > 0)
			{
				content.removeChildAt(0);
			}
			selecteItem = null;
		}

		/** 选择玩家 */
		public function selectPlayer(vo : VoFriendItem) : void
		{
			if (selecteItem && selecteItem.vo.name == vo.name) return;

			var item : PlayerItem = itemDic[vo.name];
			if (item == null)
			{
				item = addPlayer(vo);
				// 列表布局
				layoutItems();
			}
			// var index:int = content.getChildIndex(item);
			// if(index != 0)
			// {
			// content.swapChildrenAt(0, index);
			// }

			if (selecteItem)
			{
				selecteItem.isSelected = false;
			}
			selecteItem = item;
			selecteItem.isSelected = true;
			selecteItem.isHaveNewMsg = false;
			// 列表布局
			layoutItems();
		}

		/** 新消息 */
		public function newMsg(vo : VoFriendItem) : void
		{
			if (selecteItem && selecteItem.vo.name == vo.name) return;
			var item : PlayerItem = itemDic[vo.name];
			if (item == null)
			{
				item = addPlayer(vo);
			}
			item.isHaveNewMsg = true;
			var index : int = content.getChildIndex(item);
			if (index != 0)
			{
				content.swapChildrenAt(0, index);
			}
			if (selecteItem == null)
			{
				setSelectedItem(item);
			}
			// 列表布局
			layoutItems();
		}

		/** 列表布局 */
		public function layoutItems() : void
		{
			var item : DisplayObject;
			var postionY : uint = 0;
			for (var i : int = 0; i < content.numChildren; i++)
			{
				item = content.getChildAt(i);
				item.y = postionY;
				postionY += item.height + gap;
			}
			reset();
		}

		/** 选中玩家 */
		private function setSelectedItem(item : PlayerItem) : void
		{
			var eventWhisper : EventWhisper = new EventWhisper(EventWhisper.SELECTED_PLAYER_LIST_ITEM, true);
			eventWhisper.voFriendItem = item.vo;
			dispatchEvent(eventWhisper);
		}
	}
}
