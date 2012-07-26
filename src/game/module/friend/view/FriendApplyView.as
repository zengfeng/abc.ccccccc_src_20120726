package game.module.friend.view
{
	import game.core.menu.MenuType;
	import game.core.menu.MenuManager;
	import game.core.user.StateManager;
	import game.manager.ViewManager;
	import game.module.chat.ManagerChat;
	import game.module.friend.EventFriend;
	import game.module.friend.ModelFriend;
	import game.module.friend.ProtoCtoSFriend;
	import game.module.friend.VoFriendItem;
	import game.net.core.Common;
	import game.net.data.CtoC.CCVIPLevelChange;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.alert.Alert;
	import com.utils.UICreateUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-3  ����4:35:46 
	 */
	public final class FriendApplyView extends GCommonWindow
	{
		/** 背景 */
		private var _bg : DisplayObject;
		/** 提示Label */
		private var _promptLabel : TextField;
		/** 当前申请人数 **/
		private var _nowApplyLabel : TextField;
		/** 全部添加按钮 */
		private var _addAllButton : GButton;
		/** 全部忽略 **/
		private var _deleteAllButton : GButton;
		/** 列表容器 */
		private var _panel : GPanel;
		/** 是否正在显示 */
		private var _isShowing : Boolean = false;
		private var _itemDic : Dictionary = new Dictionary();

		public function FriendApplyView()
		{
			_data = new GTitleWindowData();
			_data.width = 507;
			_data.height = 411;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;
			initData();
			super(_data);
			initEvents();
		}

		private var _defaultPostion : Point;

		/** 默认位置 */
		public function get defaultPostion() : Point
		{
			if (_defaultPostion) return _defaultPostion;
			if (ViewManager.instance.uiContainer.stage == null) return null;
			_defaultPostion = new Point();
			_defaultPostion.x = ViewManager.instance.uiContainer.stage.stageWidth - this.width - 400;
			_defaultPostion.y = 100;
			return _defaultPostion;
		}

		/** 移动到默认位置 */
		public function moveToDefaultPostion() : void
		{
			if (defaultPostion == null) return;
			this.x = defaultPostion.x;
			this.y = defaultPostion.y;
		}

		override protected function initViews() : void
		{
			super.initViews();
			title = "知己申请";

			// 背景
			_bg = UIManager.getUI(new AssetData("common_background_02"));
			_bg.x = 5;
			_bg.y = 0;
			_bg.width = 492;
			_bg.height = 406;
			addChildAt(_bg, 1);

			// 提示Label
			_promptLabel = new TextField();
			var textFormat : TextFormat = new TextFormat();
			textFormat.size = 12;
			// textFormat.font = UIManager.defaultFont;
			// textFormat.bold = true;
			// _promptLabel.defaultTextFormat = textFormat;
			// _promptLabel.width = 18;
			// _promptLabel.text = "知己上限: 0/30";
			_promptLabel.text = "好友上限:" + String(ModelFriend.instance.friendCount) + "/" + String(ModelFriend.instance.friendMax);
			_promptLabel.x = 20;
			_promptLabel.y = 6;
			_promptLabel.mouseEnabled = false;
			addChild(_promptLabel);

			_nowApplyLabel = UICreateUtils.createTextField("", null, 100, 20, 127, 6);
			// _nowApplyLabel.text = "当前申请人数:" + String(ModelFriend.instance.friendApplyListData.length);
			_nowApplyLabel.mouseEnabled = false;
			addChild(_nowApplyLabel);

			// 列表标题栏
			var listTitleBg : Sprite = UIManager.getUI(new AssetData("Friend_Apply_View_Title_Bg"));
			listTitleBg.x = 9;
			listTitleBg.y = 31;
			listTitleBg.width = 484;
			listTitleBg.height = 24;
			addChild(listTitleBg);

			var title_1 : TextField = UICreateUtils.createTextField("姓名", null, 190, 20, 73 - 27, 33, UIManager.getTextFormat(12, 0xffffff, TextFormatAlign.CENTER));
			addChild(title_1);

			var title_2 : TextField = UICreateUtils.createTextField("状态", null, 72, 20, 262, 33, UIManager.getTextFormat(12, 0xffffff, TextFormatAlign.CENTER));
			addChild(title_2);

			var title_3 : TextField = UICreateUtils.createTextField("操作", null, 104, 20, 376, 33, UIManager.getTextFormat(12, 0xffffff, TextFormatAlign.CENTER));
			addChild(title_3);

			// 列表背景
			var listBg : Sprite = UIManager.getUI(new AssetData("Friend_Apply_View_List_Bg"));
			listBg.x = 9;
			listBg.y = 57;
			listBg.width = 484 - 10;
			listBg.height = 300 + 1;
			addChild(listBg);

			// 列表容器
			var panelData : GPanelData = new GPanelData();
			panelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			panelData.x = 9;
			panelData.y = 57;
			panelData.width = 484;
			panelData.height = 300;
			panelData.verticalScrollPolicy = GPanelData.ON;
			_panel = new GPanel(panelData);
			addChild(_panel);

			// 全部添加按钮
			var buttonData : GButtonData = new GButtonData();
			buttonData.labelData.text = "全部同意";
			buttonData.width = 80;
			buttonData.height = 30;
			buttonData.x = 150;
			buttonData.y = _base.height - 45;
			_addAllButton = new GButton(buttonData);
			addChild(_addAllButton);

			_deleteAllButton = UICreateUtils.createGButton("全部忽略", 80, 30, 274, _base.height - 45);
			addChild(_deleteAllButton);
		}

		/** 初始化事件（添加事件监听） */
		private function initEvents() : void
		{
			_addAllButton.addEventListener(MouseEvent.CLICK, addAllButton_clickHandler);
			_deleteAllButton.addEventListener(MouseEvent.CLICK, deleteAllButton_clickHandler);
		}

		/** 清空列表 */
		private function clearItems() : void
		{
			_panel.clearContent();
		}

		private var _itemGap : uint = 0;
		private var listLength : int;

		/** 创建列表 */
		private function createItems() : void
		{
			_itemDic = new Dictionary();
			var item : FriendApplyItem;
			var componentData : GComponentData = new GComponentData();
			componentData.x = 0;
			componentData.width = _panel.width - 10;
			componentData.height = 50;
			var postionY : uint = 0;
			var friendApplyListData : Vector.<VoFriendItem> = ModelFriend.instance.friendApplyListData;
			var vo : VoFriendItem;
			// i用来判断每个item背景的选择
			var i : int = 0;
			while (friendApplyListData.length > 0)
			{
				vo = friendApplyListData.shift() as VoFriendItem;
				if (vo == null) continue;
				componentData.y = postionY;
				postionY += componentData.height + _itemGap;
				item = new FriendApplyItem(componentData, i);
				vo.bgNum = i;
				item.source = vo;
				_panel.add(item);
				_itemDic[vo.id] = item;
				item.deleteButton.addEventListener(MouseEvent.CLICK, item_deleteButton_clickHandler);
				item.addButton.addEventListener(MouseEvent.CLICK, item_addButton_clickHandler);

				i++;
			}

			listLength = i;
		}

		/** 点击添加所有按钮 */
		private function addAllButton_clickHandler(event : MouseEvent) : void
		{
			// 发送到服务器 -- 通过id批量添加好友
			var ids : Vector.<uint> = new Vector.<uint>();

			if (ModelFriend.instance.friendCount + _panel.content.numChildren <= ModelFriend.instance.friendMax)
			{
				for (var i : int = 0; i < _panel.content.numChildren; i++)
				{
					var item : FriendApplyItem = _panel.content.getChildAt(i) as FriendApplyItem;
					ids.push(item.vo.id);
				}
				// ProtoCtoSFriend.instance.cs_FollowId(ids);
				ProtoCtoSFriend.instance.cs_CSAgreeOrDismissFans(1, 0);

				// this.hide();
				MenuManager.getInstance().closeMenuView(126);
				// StateManager.instance.checkMsg(71);
			}
			else
			{
				if (ModelFriend.instance.friendCount < ModelFriend.instance.friendMax)
				{
					// for (var j : int = 0; j < (ModelFriend.instance.friendMax - ModelFriend.instance.friendCount); j++)
					// {
					// var item_1 : FriendApplyItem = _panel.content.getChildAt(j) as FriendApplyItem;
					// ids.push(item_1.vo.id);
					// }
					// ProtoCtoSFriend.instance.cs_FollowId(ids);
					StateManager.instance.checkMsg(70, ModelFriend.instance.friendMax - ModelFriend.instance.friendCount);
				}
				else
				{
					StateManager.instance.checkMsg(66);
				}
			}
		}

		/** 点击全部忽略按钮 **/
		private function deleteAllButton_clickHandler(event : MouseEvent) : void
		{
			StateManager.instance.checkMsg(69, [], closeFriendApplyView);
		}

		private function closeFriendApplyView(type : String) : Boolean
		{
			switch(type)
			{
				case Alert.OK_EVENT:
					for (var i : int = 0; i < _panel.content.numChildren; i++)
					{
						var item : FriendApplyItem = _panel.content.getChildAt(i) as FriendApplyItem;
						deleteItem(item);
					}
					ProtoCtoSFriend.instance.cs_CSAgreeOrDismissFans(0x11, 0);
					// this.hide();
					MenuManager.getInstance().closeMenuView(126);
					break;
			}

			return true;
		}

		// /** 协议监听 -- 通过id批量添加好友 */
		// private function sc_FollowId(message : SCFollowId) : void
		// {
		// updateLabelText();
		//
		// message;
		//			//  this.hide();
		// MenuManager.getInstance().closeMenuView(126);
		// }
		/** 点击添加按钮 */
		private function item_addButton_clickHandler(event : MouseEvent) : void
		{
			if (ModelFriend.instance.friendCount < ModelFriend.instance.friendMax)
			{
				var button : GButton = event.currentTarget as GButton;
				var item : FriendApplyItem = button.parent as FriendApplyItem;
				// 验证
				if (check(item) == false)
				{
					return;
				}

				// 发送到服务器 -- 通过名字添加好友
				// ProtoCtoSFriend.instance.cs_FollowName(item.vo.name);
				ProtoCtoSFriend.instance.cs_CSAgreeOrDismissFans(1, item.vo.id);

				deleteItem(item);

				// StateManager.instance.checkMsg(71);
			}
			else
			{
				StateManager.instance.checkMsg(66);
			}

			// updateLabelText();
			promptLabel_setValue();
		}

		// /** 协议监听 -- 通过名字添加好友 */
		// private function sc_FollowName(message : SCFollowName) : void
		// {
		// if (_itemDic && _itemDic[message.id])
		// {
		// var item : FriendApplyItem = _itemDic[message.id] as FriendApplyItem;
		// deleteItem(item);
		// }
		//
		// updateLabelText();
		// }
		/** 点击删除按钮 */
		private function item_deleteButton_clickHandler(event : MouseEvent) : void
		{
			var button : GButton = event.currentTarget as GButton;
			var item : FriendApplyItem = button.parent as FriendApplyItem;
			ProtoCtoSFriend.instance.cs_CSAgreeOrDismissFans(0x11, item.vo.id);
			deleteItem(item);

			_nowApplyLabel.text = "当前申请人数:" + String(_panel.content.numChildren);
			// updateLabelText();
		}

		/** 设置值, 知己数量 */
		private function promptLabel_setValue(event : EventFriend = null) : void
		{
			// var str : String = "知己上限: `Count`/`Max`";
			// str = str.replace(/`Count`/, ModelFriend.instance.friendCount);
			// str = str.replace(/`Max`/, ModelFriend.instance.friendCount);
			// _promptLabel.text = str;

			// updateLabelText();
			if (MenuManager.getInstance().getMenuState(MenuType.FRIEND))
			{
				_promptLabel.text = "好友上限:" + String(ModelFriend.instance.friendCount) + "/" + String(ModelFriend.instance.friendMax);
			}
			else
			{
				_promptLabel.text = "好友上限:" + String(ModelFriend.instance.friendCount + ModelFriend.instance.friendsNums) + "/" + String(ModelFriend.instance.friendMax);
			}
			_nowApplyLabel.text = "当前申请人数:" + String(_panel.content.numChildren);
			// _nowApplyLabel.text = "当前申请人数:" + String(listLength);
		}

		private var _friendsNums : uint = ModelFriend.instance.friendsNums;

		private function updateLabelText() : void
		{
			_friendsNums++;
			_promptLabel.text = "好友上限:" + String(_friendsNums) + "/" + String(ModelFriend.instance.friendMax);

			// _nowApplyLabel.text = "当前申请人数:" + String(ModelFriend.instance.friendApplyListData.length);
			_nowApplyLabel.text = "当前申请人数:" + String(_panel.content.numChildren);
		}

		private function deleteItem(item : FriendApplyItem) : void
		{
			if (item == null) return;

			item.deleteButton.addEventListener(MouseEvent.CLICK, item_deleteButton_clickHandler);
			item.addButton.addEventListener(MouseEvent.CLICK, item_addButton_clickHandler);
			_panel.content.removeChild(item);
			delete _itemDic[item.vo.id];
			var displayObject : DisplayObject;
			var postionY : uint = 0;
			for (var i : int = 0; i < _panel.content.numChildren; i++)
			{
				displayObject = _panel.content.getChildAt(i);
				displayObject.y = postionY;
				postionY += displayObject.height + _itemGap;
				if (displayObject is FriendApplyItem)
				{
					(displayObject as FriendApplyItem).updateItemBg(i % 2 == 0 ? true : false);
				}
			}
			_panel.reset();

			// TODO
			if (_panel.content.numChildren == 0)
			{
				// this.hide();
				MenuManager.getInstance().closeMenuView(126);
			}
		}

		/** 验证 */
		private function check(item : FriendApplyItem) : Boolean
		{
			var isOk : Boolean = true;
			// 如果已经是好友
			if (ModelFriend.instance.isInFriendListByPlayerName(item.vo.name) == true)
			{
				isOk = false;
				ManagerChat.instance.prompt("[" + item.vo.name + "]已经是您的好友！");
				deleteItem(item);
			}
			return isOk;
		}

		override protected function onShow() : void
		{
			super.onShow();
			// NotificationProxy.reqFriend();
		}

		/** 数据模型 -- 新增好友申请事件 */
		private  function modelFriend_addFriendApplyHandler(event : EventFriend) : void
		{
			clearItems();
			// 创建列表
			createItems();
			promptLabel_setValue();
			// _promptLabel.text = "好友上限:" + String(ModelFriend.instance.friendsNums) + "/" + String(ModelFriend.instance.friendMax);
			// _nowApplyLabel.text = "当前申请人数:" + String(listLength);
		}

		override public function show() : void
		{
			// //  临时的
			// testData();
			_isShowing = true;
			// 移动到默认位置
			moveToDefaultPostion();
			// 创建列表
			createItems();
			// promptLabel_setValue();
			// 数据模型 -- 新增好友申请事件
			ModelFriend.instance.addEventListener(EventFriend.ADD_FRIEND_APPLY, modelFriend_addFriendApplyHandler);
			// 数据模型 -- 好友数据发生改变
			ModelFriend.instance.addEventListener(EventFriend.FRIEND_COUNT_CHANGE, promptLabel_setValue);

			// 协议监听 -- 通过名字添加好友
			// Common.game_server.addCallback(0x44, sc_FollowName);
			// 协议监听 -- 通过id批量添加好友
			// Common.game_server.addCallback(0x45, sc_FollowId);
			// CC协议监听[0xFFF7] VIP等级改变
			Common.game_server.addCallback(0xFFF7, cc_VIPLevelChange);

			super.show();
			// ProtoCtoSFriend.instance.cs_ClearNewFans();
		}

		override public function hide() : void
		{
			// 数据模型 -- 新增好友申请事件
			ModelFriend.instance.removeEventListener(EventFriend.ADD_FRIEND_APPLY, modelFriend_addFriendApplyHandler);
			// 数据模型 -- 好友数据发生改变
			ModelFriend.instance.removeEventListener(EventFriend.FRIEND_COUNT_CHANGE, promptLabel_setValue);
			// 协议监听 -- 通过名字添加好友
			// Common.game_server.removeCallback(0x44, sc_FollowName);
			// 协议监听 -- 通过id批量添加好友
			// Common.game_server.removeCallback(0x45, sc_FollowId);

			// 清空列表
			clearItems();
			super.hide();
			_isShowing = false;
			_itemDic = null;
			// 发送隐藏事件
			var event : EventFriend = new EventFriend(EventFriend.HIDE, true);
			dispatchEvent(event);
		}

		/** CC协议监听[0xFFF7] VIP等级改变 */
		private function cc_VIPLevelChange(msg : CCVIPLevelChange) : void
		{
			// updateLabelText();
			promptLabel_setValue();
		}

		public function get isShowing() : Boolean
		{
			return _isShowing;
		}
		//		//  TODO:临时测试专用
		// public function testData() : void
		// {
		// var list : Vector.<VoFriendItem> = ModelFriend.instance.friendApplyListData;
		// for (var i : int = 0; i < 10; i++)
		// {
		// var vo : VoFriendItem = new VoFriendItem();
		// vo.id = i;
		// vo.name = "AAAAAAA" + i;
		// vo.level = (Math.random() * 100) >> 0;
		// list.push(vo);
		// }
		// }
	}
}
