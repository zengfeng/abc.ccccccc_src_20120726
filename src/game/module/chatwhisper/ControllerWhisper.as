package game.module.chatwhisper {
	import game.core.menu.MenuManager;
	import game.core.user.StateManager;
	import game.manager.ViewManager;
	import game.module.chat.EventChat;
	import game.module.chat.ManagerChat;
	import game.module.chat.ProtoCtoSChat;
	import game.module.chat.VoChatMsg;
	import game.module.chat.config.ChannelId;
	import game.module.chat.config.ChatConfig;
	import game.module.chat.config.ScriptConfig;
	import game.module.chatwhisper.config.WhisperConfig;
	import game.module.chatwhisper.config.WindowState;
	import game.module.chatwhisper.view.MsgTextInput;
	import game.module.chatwhisper.view.MsgTextOutput;
	import game.module.chatwhisper.view.PlayerItem;
	import game.module.chatwhisper.view.PlayerList;
	import game.module.chatwhisper.view.WhisperIcoButton;
	import game.module.chatwhisper.view.WhisperModuleView;
	import game.module.friend.EventFriend;
	import game.module.friend.ManagerFriend;
	import game.module.friend.ModelFriend;
	import game.module.friend.VoFriendItem;
	import game.module.trade.exchange.ExchangeManager;

	import gameui.controls.GButton;

	import utils.DictionaryUtil;

	import com.commUI.tips.PlayerTip;
	import com.utils.RegExpUtils;
	import com.utils.StringUtils;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;





	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����2:41:25 
	 */
	public class ControllerWhisper extends EventDispatcher
	{
		/** 单例对像 */
		private static var _instance : ControllerWhisper;

		public function ControllerWhisper(target : IEventDispatcher = null)
		{
			super(target);
			// 添加消息
			modelWhisper.addEventListener(EventWhisper.ADD_MSG, addMsgHandler);
			// 有离线消息消息
			modelWhisper.addEventListener(EventWhisper.HAVE_OFFLINE_MSG, haveOfflineMsgHandler);
			icoButton.addEventListener(MouseEvent.CLICK, icoButton_clickHandler);
		}

		/** 有离线消息消息 */
		private function haveOfflineMsgHandler(event : EventWhisper) : void
		{
			icoButton.show();
			view;
			windowState = WindowState.WINDOW_STATE_MIN;
		}

		private function icoButton_clickHandler(event : MouseEvent) : void
		{
			isShowWindow = true;
			icoButton.hide();
		}

		/** 获取单例对像 */
		static public function get instance() : ControllerWhisper
		{
			if (_instance == null)
			{
				_instance = new ControllerWhisper();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public var modelFriend : ModelFriend = ModelFriend.instance;
		public var managerFriend : ManagerFriend = ManagerFriend.getInstance();
		public var cToS : ProtoCtoSWhisper = ProtoCtoSWhisper.instance;
		public var sToC : ProtoStoCWhisper = ProtoStoCWhisper.instance;
		public var modelWhisper : ModelWhisper = ModelWhisper.instance;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 玩家列表 */
		public var playerList : PlayerList;
		/** 消息输出框 */
		public var msgTextOutput : MsgTextOutput;
		/** 消息输入框 */
		public var msgTextInput : MsgTextInput;
		/** 清空玩家列表按钮 */
		public var clearPlayersButton : GButton;
		/** 交易按钮 */
		public var tradeButton : GButton;
		/** 加为好友按钮 */
		public var addFriendButton : GButton;
		/** 删除好友按钮 */
		public var deleteFriendButton : GButton;
		/** 查看资料按钮 */
		public var lookInfoButton : GButton;
		/** 当前玩家信息Label */
		public var currentPlayerLabel : TextField;
		/** 主视图 */
		private var _view : WhisperModuleView;
		/** 消息ICO按钮 */
		private var _icoButton : WhisperIcoButton;

		/** 消息ICO按钮 */
		public function get icoButton() : WhisperIcoButton
		{
			if (_icoButton) return _icoButton;
			_icoButton = new WhisperIcoButton();
			return _icoButton;
		}

		public function get view() : WhisperModuleView
		{
			if (_view) return _view;
			_view = WhisperModuleView.instance;
			initView(_view);
			return _view;
		}

		/** 初始化视图 */
		public function initView(view : WhisperModuleView) : void
		{
			playerList = view.playerList;
			msgTextOutput = view.msgTextOutput;
			msgTextInput = view.msgTextInput;
			clearPlayersButton = view.clearPlayersButton;
			tradeButton = view.tradeButton;
			addFriendButton = view.addFriendButton;
			deleteFriendButton = view.deleteFriendButton;
			lookInfoButton = view.lookInfoButton;
			currentPlayerLabel = view.currentPlayerLabel;

			// 初始化玩家列表
			initPlayerList();

			// 事件监听
			initEvents();
		}

		/** 初始化玩家列表 */
		public function initPlayerList() : void
		{
			var players : Vector.<VoFriendItem> = managerFriend.getLastLinkData();
			var i : int = 0;
			var indexEnd : uint = Math.min(players.length, WhisperConfig.playerListMaxRow);
			var vo : VoFriendItem;
			for ( i = 0; i < indexEnd; i++)
			{
				vo = players[i];
				playerList.addPlayer(vo);
			}
			playerList.layoutItems();
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 事件监听 */
		public function initEvents() : void
		{
			// 发送消息
			msgTextInput.addEventListener(EventWhisper.SEND_MSG, sendMsgHandler);
			//            //  添加消息
			// modelWhisper.addEventListener(EventWhisper.ADD_MSG, addMsgHandler);
			// 选择表情事件
			msgTextInput.addEventListener(EventChat.SELECTED_FACE, selectedFaceHandler);
			// 选择玩家事件
			playerList.addEventListener(EventWhisper.SELECTED_PLAYER_LIST_ITEM, selectedPlayerHandler);
			// 关闭玩家事件
			playerList.addEventListener(EventWhisper.CLOSE_PLAYER_LIST_ITEM, closePlayerHandler);
			// 清除所有玩家事件
			clearPlayersButton.addEventListener(MouseEvent.CLICK, clearPlayerListHandler);
			// 窗口状态改变事件
			view.addEventListener(EventWhisper.WINDOW_STATE_CHANGE, windowStateChangeHandler);
			// 交易
			tradeButton.addEventListener(MouseEvent.CLICK, tradeHandler);
			// 加为好友
			addFriendButton.addEventListener(MouseEvent.CLICK, addFriendHandler);
			// 删除好友
			deleteFriendButton.addEventListener(MouseEvent.CLICK, deleteFriendHandler);
			// 查看消息
			lookInfoButton.addEventListener(MouseEvent.CLICK, lookInfoHandler);
			// 当前玩家信息Label 点击链接事件
			currentPlayerLabel.addEventListener(TextEvent.LINK, currentPlayerLabel_linkHandler);
			// 好友数据模型 -- 好友数据更新
			modelFriend.addEventListener(EventFriend.UPDATE_FRIEND, modelFriend_updateFriendHandler);
			// 好友数据模型 -- 删除好友
			modelFriend.addEventListener(EventFriend.Remove_FRIEND, modelFriend_removeFriendHandler);
			// 好友数据模型 -- 添加好友
			modelFriend.addEventListener(EventFriend.ADD_FRIEND, modelFriend_addFriendHandler);
		}

		/** 好友数据模型 -- 添加好友 */
		private function modelFriend_addFriendHandler(event : EventFriend) : void
		{
			var voFriendItem : VoFriendItem = event.voFriendItem;
			if (playerList.selecteItem.vo.name == voFriendItem.name) view.setCurrentPlayerInfo(voFriendItem);
		}

		/** 好友数据模型 -- 删除好友 */
		private function modelFriend_removeFriendHandler(event : EventFriend) : void
		{
			var voFriendItem : VoFriendItem = event.voFriendItem;
			if (playerList.selecteItem.vo.name == voFriendItem.name) view.setCurrentPlayerInfo(voFriendItem);
		}

		/** 好友数据模型 -- 好友数据更新 */
		private function modelFriend_updateFriendHandler(event : EventFriend) : void
		{
			var voFriendItem : VoFriendItem = event.voFriendItem;
			var item : PlayerItem = playerList.itemDic[voFriendItem.name];
			if (item)
			{
				item.vo = voFriendItem;
				if (playerList.selecteItem == item)
				{
					view.setCurrentPlayerInfo(voFriendItem);
				}
			}
		}

		/** 当前玩家信息Label 点击链接事件 */
		private function currentPlayerLabel_linkHandler(event : TextEvent) : void
		{
			if (playerList && playerList.selecteItem)
			{
				PlayerTip.show(playerList.selecteItem.vo.id, playerList.selecteItem.vo.name, [PlayerTip.NAME_INVITE_CLAN, PlayerTip.NAME_COPY_PLAYER_NAME]);
			}
		}

		/** 查看消息 */
		private function lookInfoHandler(event : MouseEvent = null) : void
		{
		}

		/** 删除好友 */
		private function deleteFriendHandler(event : MouseEvent) : void
		{
			if (playerList && playerList.selecteItem)
			{
				ManagerFriend.getInstance().deleteFriendByPlayerId(playerList.selecteItem.vo.id);
			}
		}

		/** 加为好友 */
		private function addFriendHandler(event : MouseEvent = null) : void
		{
			if (playerList && playerList.selecteItem)
			{
				if (ModelFriend.instance.friendCount < ModelFriend.instance.friendMax)
				{
					ManagerFriend.getInstance().addFriendByPlayerName(playerList.selecteItem.vo.name);
				}
				else
				{
					StateManager.instance.checkMsg(66);
				}
			}
		}

		/** 交易 */
		private function tradeHandler(event : MouseEvent = null) : void
		{
			// TODO : 交易中的serverId暂定为0，合服后需要修改
			ExchangeManager.instance.startExchangeWithPlayer(currentPlayerLabel.text, 0);
		}

		/** 窗口状态改变事件 */
		private function windowStateChangeHandler(event : EventWhisper) : void
		{
			switch(windowState)
			{
				case WindowState.WINDOW_STATE_MIN:
					icoButton.show();
					break;
				case WindowState.WINDOW_STATE_CLOSE:
					ManagerChat.instance.isShowWhisper = true;
					icoButton.hide();
					break;
				case WindowState.WINDOW_STATE_OPEN:
					icoButton.hide();
					ManagerChat.instance.isShowWhisper = false;
					var items : Array = DictionaryUtil.getValues(playerList.itemDic);
					var item : PlayerItem;
					var playerIds : Vector.<uint> = new Vector.<uint>();
					for (var i : int = 0; i < items.length; i++)
					{
						item = items[i];
						if (item && item.vo) playerIds.push(item.vo.id);
					}
					managerFriend.updatePlayersIsOnlineByPlayerIds(playerIds);
					break;
			}
		}

		/** 清除所有玩家事件 */
		private function clearPlayerListHandler(event : MouseEvent) : void
		{
			closeAllPlayers();
		}

		/** 关闭玩家事件 */
		private function closePlayerHandler(event : EventWhisper) : void
		{
			closePlayer(event.voFriendItem);
		}

		/** 选择玩家事件 */
		private function selectedPlayerHandler(event : EventWhisper) : void
		{
			showPlayer(event.voFriendItem);
		}

		/** 选择表情事件 */
		private function selectedFaceHandler(event : EventChat) : void
		{
			var str : String = ScriptConfig.FACE;
			str = str.replace("ID", event.faceId);
			msgTextInput.insertContent(str);
			msgTextInput.stage.focus = msgTextInput.contentTextInput;
		}

		// 添加消息
		private function addMsgHandler(event : EventWhisper) : void
		{
			if (!view)
			{
				icoButton.countCount = icoButton.countCount + 1;
				icoButton.show();
			}
			else if (windowState != WindowState.WINDOW_STATE_OPEN && event.voMsg.channelId != ChannelId.DATE)
			{
				icoButton.countCount = icoButton.countCount + 1;
				icoButton.show();
			}

			var voPlayerMsg : VoPlayerMsg = event.voPlayerMsg;
			if (playerList.selecteItem && playerList.selecteItem.vo.name == voPlayerMsg.voPlayer.name)
			{
				msgTextOutput.appendMsg(event.voMsg);
			}
			else
			{
				playerList.newMsg(voPlayerMsg.voPlayer);
			}
		}

		// 发送消息
		private function sendMsgHandler(event : EventWhisper) : void
		{
			if (playerList.selecteItem == null) return;
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = ChannelId.WHISPER;
			vo.recPlayerName = playerList.selecteItem.vo.name;
			vo.content = RegExpUtils.getFilterStr(StringUtils.trim(msgTextInput.content));
			vo.playerName = ChatConfig.selfPlayerName;
			msgTextInput.pushContentCache(vo.content);

			// 如果对方不在线并且不是互为好友
			// if (playerList.selecteItem.vo.isOnline == false && playerList.selecteItem.vo.type != VoFriendItem.TYPE_BOTH)
			// {
			// vo.content = "对方离线，只有互为好友才能发送离线消息";
			// vo.channelId = ChannelId.PROMPT;
			// modelWhisper.addMsg(vo);
			// return;
			// }

			// 如果是给自己发
			if (vo.recPlayerName == ChatConfig.selfPlayerName)
			{
				vo.content = "请不要对自己自言自语哦,亲";
				vo.channelId = ChannelId.PROMPT;
				modelWhisper.addMsg(vo);
				return;
			}

			// 是否在黑名单中
			if (ManagerFriend.getInstance().isInBackListByPlayerName(vo.recPlayerName))
			{
				vo.content = vo.recPlayerName + "在您黑名单中";
				vo.channelId = ChannelId.PROMPT;
				modelWhisper.addMsg(vo);
				return;
			}

			// 如果没输入内容
			if (!vo.content || vo.content == MsgTextInput.TEXT_INTPU_PROMPT_CONTENT)
			{
				vo.content = MsgTextInput.TEXT_INTPU_PROMPT_CONTENT;
				vo.channelId = ChannelId.PROMPT;
				modelWhisper.addMsg(vo);
				return;
			}

			// 如果内容过长
			if (StringUtils.UTFLength(vo.content) > ChatConfig.contentMaxLength)
			{
				vo.content = "消息内容太长，最多可以发送" + Math.floor(ChatConfig.contentMaxLength / 2) + "个汉字或" + ChatConfig.contentMaxLength + "个字母数字";
				vo.channelId = ChannelId.PROMPT;
				modelWhisper.addMsg(vo);
				return;
			}

			if (vo.channelId != ChannelId.PROMPT)
			{
				msgTextInput.content = "";
			}
			ProtoCtoSChat.instance.sendmsg(vo);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 是否显示窗口 */
		private var  _isShowWindow : Boolean = false;

		/** 是否显示窗口 */
		public function set isShowWindow(value : Boolean) : void
		{
			_isShowWindow = value;
			if (value)
			{
				view.show();
			}
			else
			{
				view.hide();
			}
		}

		public function get isShowWindow() : Boolean
		{
			return _isShowWindow;
		}

		/** 显示某某玩家的私聊窗口 */
		public function showWindowByPlayerName(playerName : String) : void
		{
			view;
			var voFriendItem : VoFriendItem = managerFriend.findLastLinkByName(playerName);
			if (voFriendItem == null)
			{
				voFriendItem = ManagerFriend.getInstance().addLastLinkByName(playerName);
			}
			showPlayer(voFriendItem);
			// view.show();

			// 检查私聊面板是否已经开启。若已开启，私聊面板就不用在重新打开一次。
			if (MenuManager.getInstance().getMenuState(128)) return;
			MenuManager.getInstance().openMenuView(128);
		}

		/** 显示玩家 */
		private function showPlayer(voFriendItem : VoFriendItem) : void
		{
			if (playerList.selecteItem == null || playerList.selecteItem.vo.name != voFriendItem.name)
			{
				var msgs : Vector.<VoChatMsg> = modelWhisper.getPlayerMsgs(voFriendItem.name);
				msgTextOutput.appendMsgs(msgs);
			}
			view.setCurrentPlayerInfo(voFriendItem);
			playerList.selectPlayer(voFriendItem);
			ViewManager.instance.uiContainer.stage.focus = msgTextInput.contentTextInput;
		}

		/** 关闭所有玩家 */
		private function closeAllPlayers() : void
		{
			view.setCurrentPlayerInfo(null);
			msgTextOutput.appendMsgs(null);
			playerList.closeAllPlayers();
		}

		/** 关闭玩家 */
		private function closePlayer(voFriendItem : VoFriendItem) : void
		{
			// 如果删除的这个是选中的
			if (playerList.selecteItem && playerList.selecteItem.vo.name == voFriendItem.name)
			{
				// 如果列表中就只有这个当前要删除的玩家
				if (playerList.content.numChildren <= 1)
				{
					// playerList.selecteItem = null;
					// view.setCurrentPlayerInfo(null);
					// msgTextOutput.appendMsgs(null);
				}
				else
				{
					var item : PlayerItem = playerList.itemDic[voFriendItem.name];
					var index : uint = playerList.content.getChildIndex(item);
					// 如果当前删除的这个不是在第一个就设置上一个为选择的
					if (index > 0)
					{
						item = playerList.content.getChildAt(index - 1) as PlayerItem;
						// showPlayer(item.vo);
					}
					// 否则 设置下一个为选择的
					else
					{
						item = playerList.content.getChildAt(index + 1) as PlayerItem;
						// showPlayer(item.vo);
					}
				}
			}
			playerList.closePlayer(voFriendItem);
		}

		/** 窗口状态 */
		public function get windowState() : String
		{
			return view.windowState;
		}

		public function set windowState(windowState : String) : void
		{
			view.windowState = windowState;
		}
	}
}
