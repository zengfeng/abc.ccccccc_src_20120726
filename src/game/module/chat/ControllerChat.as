package game.module.chat
{
	import game.manager.ViewManager;
	import game.core.hero.VoHero;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.definition.ID;
	import game.manager.SignalBusManager;
	import game.module.chat.config.ChannelId;
	import game.module.chat.config.ChatConfig;
	import game.module.chat.config.Face;
	import game.module.chat.config.ScriptConfig;
	import game.module.chat.view.BoxInput;
	import game.module.chat.view.BoxNotic;
	import game.module.chat.view.BoxOutput;
	import game.module.chat.view.ChannelComboBox;
	import game.module.chat.view.ChatModuleView;
	import game.module.chat.view.EnterButton;
	import game.module.chat.view.MsgTextInput;
	import game.module.chat.view.TabBar;
	import game.module.chat.view.ToolBar;
	import game.module.friend.ManagerFriend;
	import game.module.guild.GuildManager;
	import game.net.core.Common;

	import gameui.controls.GButton;

	import com.commUI.quickshop.SingleQuickShop;
	import com.protobuf.Message;
	import com.utils.RegExpUtils;
	import com.utils.StringUtils;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����4:50:05 
	 */
	public class ControllerChat  implements IControllerChat
	{
		private static var __instance : ControllerChat;

		public function ControllerChat()
		{
		}

		public static function get instance() : ControllerChat
		{
			if ( __instance == null)
			{
				__instance = new ControllerChat();
			}
			return __instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		protected var cToS : ProtoCtoSChat = ProtoCtoSChat.instance;
		protected var sToC : ProtoStoCChat = ProtoStoCChat.instance;
		protected var modelChat : ModelChat = ModelChat.instance;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 主视图 */
		protected var _view : ChatModuleView;
		/** 频道选择按钮 */
		public var channelComboBox : ChannelComboBox;
		/** 发送按钮 */
		public var sendButton : EnterButton;
		/** 消息输入框 */
		public var msgTextInput : MsgTextInput;
		/** 内容输入框 */
		public var contentTextInput : TextField;
		/** Tab按钮栏 */
		public var tabBar : TabBar;
		/** 输出(消息)栏 */
		public var boxOutput : BoxOutput;
		/** 输入(消息)栏 */
		public var boxInput : BoxInput;
		/** 工具栏 */
		public var toolBar : ToolBar;
		/** 大喇叭栏 */
		public var boxNotic : BoxNotic;
		/** 私聊还原按钮 */
		public var whisperRRestoreButton : GButton;

		public function get view() : DisplayObjectContainer
		{
			if (_view == null)
			{
				_view = new ChatModuleView();
			}
			return _view;
		}

		public function set view(view : DisplayObjectContainer) : void
		{
			Face.load();
			_view = view as ChatModuleView;
			tabBar = boxOutput.tabBar;
			boxInput = _view.boxInput;
			whisperRRestoreButton = _view.whisperRRestoreButton;
			initEvents();
			isShowWhisper = false;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		protected function initEvents() : void
		{
			//            //  发送消息事件
			// msgTextInput.addEventListener(EventChat.SEND_MSG, sendMsgHandler);
			// 发送消息事件
			boxInput.addEventListener(EventChat.SEND_MSG, sendMsgHandler);
			// 收到消息事件
			modelChat.addEventListener(EventChat.ADD_MSG, addMsgHandler);
			// 输出(消息)栏 频道改变事件
			boxOutput.addEventListener(EventChat.CHANNEL_CHANGE, boxOutput_channelChangeHandler);
			// 选择表情事件
			toolBar.addEventListener(EventChat.SELECTED_FACE, selectedFaceHandler);
			// 选择频道事件
			boxNotic.addEventListener(EventChat.SELECTED_CHANNEL, selectedChannelHandler);
			// 选择选家事件
			msgTextInput.addEventListener(EventChat.SELECTED_PLAYER, selectedPlayerHandler);
			// 私聊还原按钮 点击事件
			whisperRRestoreButton.addEventListener(MouseEvent.CLICK, whisperRRestoreButton_clickHandler);
			// 清除消息事件
			toolBar.addEventListener(EventChat.CLEAR_MSG, clearMsgHandler);
			// 发送炫耀物品事件
			SignalBusManager.sendToChatItem.add(sendItemHandler);
			// 发送炫耀将领事件
			SignalBusManager.sendToChatHero.add(sendHeroHandler);
			// 发送炫耀将领事件
			SignalBusManager.sendToChatObject.add(sendObjectHandler);
			// 发送好友上线下线
			// 不显示好友上下线了 -_-  (ProtoStoCFriend)
			// SignalBusManager.sendToChatFriendIsOnline.add(sendToChatFriendIsOnline);
			// SendToChatHelper.dispatcher.addEventListener(SendToChatEvent.ITEM, sendItemHandler);
			// CC协议监听[0xFFF8] Ctrl+物品
			Common.game_server.addCallback(0xFFF8, cc_sendItemToChat);
		}

		/** 发送好友上线下线 */
		private function sendToChatFriendIsOnline(playerName : String, playerId : uint, colorPropertyValue : uint, isOnline : Boolean) : void
		{
			var str : String = ChatTag.player(playerId, playerName, colorPropertyValue);
			str += isOnline ? "已上线" : "已下线";
			ManagerChat.instance.prompt(str);
		}

		/** 发送对象 */
		private function sendObjectHandler(data : *) : void
		{
			if (data is Item)
				sendItemHandler(data);
			else if (data is VoHero)
				sendHeroHandler(data);
		}

		/** 发送物品事件 */
		private function sendHeroHandler(data : *) : void
		{
			ManagerChat.instance.insertHero(data);
		}

		/** 发送物品事件 */
		private function sendItemHandler(item : Item) : void
		{
			ManagerChat.instance.insertItem(item);
		}

		/** CC协议监听[0xFFF8] Ctrl+物品 */
		private function cc_sendItemToChat(msg : Message) : void
		{
			// ManagerChat.instance.insertGoods(msg.id, msg.name, msg.color);
		}

		/** 私聊还原按钮 点击事件 */
		private function whisperRRestoreButton_clickHandler(event : MouseEvent) : void
		{
			isShowWhisper = false;
		}

		/** 选择选家事件 */
		private function selectedPlayerHandler(event : EventChat) : void
		{
			msgTextInput.playerName = event.playerName;
		}

		/** 选择频道事件 */
		private function selectedChannelHandler(event : EventChat) : void
		{
			var voChannel : VoChannel = event.voChannel;
			tabBar.selectedVo = voChannel;
		}

		/** 选择表情事件 */
		private function selectedFaceHandler(event : EventChat) : void
		{
			var str : String = ScriptConfig.FACE;
			str = str.replace("ID", event.faceId);
			msgTextInputInsertContent(str);
		}

		/** 输入框插入内容 */
		public function msgTextInputInsertContent(str : String) : void
		{
			msgTextInput.insertContent(str);
		}

		// //  输出(消息)栏 频道改变事件
		private function boxOutput_channelChangeHandler(event : EventChat) : void
		{
			channelComboBox.selectedVo = event.voChannel;

			if (channelComboBox.selectedVo.id == ChannelId.WHISPER && isShowWhisper == true)
			{
				whisperRRestoreButton.visible = true;
			}
			else
			{
				whisperRRestoreButton.visible = false;
			}

			var  channelId : int = channelComboBox.selectedVo.id;
			var time : int = channelSendTimeDic[channelId] ? channelSendTimeDic[channelId] : 0;
			time = getTimer() - time;
			var cdTime : int = ChatConfig.channelSendCDTimeDic[channelId] ? ChatConfig.channelSendCDTimeDic[channelId] : 0;

			if (ChatConfig.channelSendCDLimitList.indexOf(channelId) != -1 && time < cdTime)
			{
				var cdFrame : int = int((time / cdTime) * 100);
				time = cdTime - time;
				sendButton.openCD(time, cdFrame);
			}
			else
			{
				sendButton.closeCD();
			}
		}

		private function clearMsgHandler(event : EventChat) : void
		{
			if (boxOutput.msgTextFlowGroup.selectedItem) boxOutput.msgTextFlowGroup.selectedItem.clear();
		}

		private var msgBuffList : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
		private var preAddMsgTime : Number = 0;

		/** 收到消息事件 */
		private function addMsgHandler(event : EventChat) : void
		{
			var voMsg : VoChatMsg = event.voMsg;
			// if (getTimer() - preAddMsgTime < 200)
			// {
			// msgBuffList.push(voMsg);
			// return;
			// }
			// preAddMsgTime = getTimer();
			//
			// if (msgBuffList.length > 0)
			// {
			// msgBuffList.push(voMsg);
			//
			// while (msgBuffList.length > 0)
			// {
			// voMsg = msgBuffList.shift();
			// boxOutput.appendMsg(voMsg);
			// if (voMsg.channelId == ChannelId.NOTIC)
			// {
			// boxNotic.addMsg(voMsg);
			// }
			// }
			// return;
			// }

			boxOutput.appendMsg(voMsg);
			if (voMsg.channelId == ChannelId.NOTIC)
			{
				boxNotic.addMsg(voMsg);
			}
		}
		
		/** 发送到当前频道消息 */
		public function sendMsgToCurrentChannel(info : String) : void
		{
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = channelComboBox.selectedVo.id;
			if (vo.channelId == ChannelId.NOTIC)
			{
				var item : Item = ItemManager.instance.getPileItem(ID.CHAT_NOTIC_PROP);
				if (item.nums < 1)
				{
					SingleQuickShop.show(ID.CHAT_NOTIC_PROP);
					vo.content = "你的“大喇叭”道具没了,请尽快去“商场”购买";
					vo.channelId = ChannelId.PROMPT;
					cToS.sendmsg(vo);
					return;
				}
			}
			// 如果是家族
			else if (vo.channelId == ChannelId.CLAN && GuildManager.instance.selfguild == null)
			{
				vo.content = "您现在还是一个独行者";
				vo.channelId = ChannelId.PROMPT;
				cToS.sendmsg(vo);
				return;
			}

			vo.recPlayerName = StringUtils.trim(msgTextInput.playerName);
			vo.content = info;
			vo.playerName = ChatConfig.selfPlayerName;
			cToS.sendmsg(vo);
		}

		private var preMsg : String = "";
		private var preChannelId : int;
		public var channelSendTimeDic : Dictionary = new Dictionary();

		/** 发送消息事件 */
		private function sendMsgHandler(event : EventChat) : void
		{
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = channelComboBox.selectedVo.id;
			vo.recPlayerName = StringUtils.trim(msgTextInput.playerName);
			vo.content = StringUtils.trim(msgTextInput.content);
			vo.playerName = ChatConfig.selfPlayerName;
			msgTextInput.pushContentCache(vo.content);
			var info:String = vo.content.toLowerCase();
			if (info.indexOf("gm ") == 0)
			{
				info = info.replace("gm ", "");
				switch(info)
				{
					case "debugstartuphaha":
						ViewManager.debugView.startup();
						return;
						break;
					case "debugexithaha":
						ViewManager.debugView.exit();
						return;
						break;
				}
			}

			//            //  如果刷消息
			// if (vo.channelId == preChannelId && preMsg == vo.content)
			// {
			// vo.content = "请不要发与上一条相同的消息";
			// vo.channelId = ChannelId.PROMPT;
			// cToS.sendmsg(vo);
			// return;
			// }

			// 等级限制
			// var levelLimit : int = ChatConfig.channelLevelLimtDic[vo.channelId];
			// if (levelLimit > UserData.instance.level)
			// {
			// vo.content = '"' + ChannelName.dic[vo.channelId] + '"频道需要您等级在 ' + levelLimit + ' 级以上';
			// vo.channelId = ChannelId.PROMPT;
			// cToS.sendmsg(vo);
			// return;
			// }

			// 如果是家族
			if (vo.channelId == ChannelId.CLAN && GuildManager.instance.selfguild == null)
			{
				vo.content = "您现在还是一个独行者";
				vo.channelId = ChannelId.PROMPT;
				cToS.sendmsg(vo);
				return;
			}

			// 如果是私聊
			if (vo.channelId == ChannelId.WHISPER)
			{
				// 如果没输入玩家
				if (!vo.recPlayerName || vo.recPlayerName == MsgTextInput.TEXT_INTPU_PROMPT_PLAYER)
				{
					vo.content = MsgTextInput.TEXT_INTPU_PROMPT_PLAYER;
					vo.channelId = ChannelId.PROMPT;
					cToS.sendmsg(vo);
					return;
				}

				// 如果是给自己发
				if (vo.recPlayerName == ChatConfig.selfPlayerName)
				{
					vo.content = "请不要对自己自言自语哦,亲";
					vo.channelId = ChannelId.PROMPT;
					cToS.sendmsg(vo);
					return;
				}

				// 是否在黑名单中
				if (ManagerFriend.getInstance().isInBackListByPlayerName(vo.recPlayerName))
				{
					vo.content = vo.recPlayerName + "在您黑名单中";
					vo.channelId = ChannelId.PROMPT;
					cToS.sendmsg(vo);
					return;
				}
			}

			// 如果没输入内容
			if (!vo.content || vo.content == MsgTextInput.TEXT_INTPU_PROMPT_CONTENT)
			{
				vo.content = MsgTextInput.TEXT_INTPU_PROMPT_CONTENT;
				vo.channelId = ChannelId.PROMPT;
				cToS.sendmsg(vo);
				return;
			}
			// 如果内容过长
			if (StringUtils.UTFLength(vo.content) > ChatConfig.contentMaxLength)
			{
				vo.content = "消息内容太长，最多可以发送" + Math.floor(ChatConfig.contentMaxLength / 2) + "个汉字或" + ChatConfig.contentMaxLength + "个字母数字";
				vo.channelId = ChannelId.PROMPT;
				cToS.sendmsg(vo);
				return;
			}

			var time : int = 0;
			// 如果发送太快
			if (ChatConfig.channelSendCDLimitList.indexOf(vo.channelId) != -1)
			{
				time = channelSendTimeDic[vo.channelId] ? channelSendTimeDic[vo.channelId] : 0;
				time = getTimer() - time;
				// 临时略过GM命令
				if (vo.content.indexOf(".") == 0 || vo.content.indexOf("/") == 0)
				{
				}
				else if (ChatConfig.channelSendCDLimitList.indexOf(vo.channelId) != -1 && time < ChatConfig.channelSendCDTimeDic[vo.channelId])
				{
					vo.content = "你发的得太快了";
					vo.channelId = ChannelId.PROMPT;
					cToS.sendmsg(vo);
					return;
				}
			}
			// 如果是大喇叭
			else if (vo.channelId == ChannelId.NOTIC)
			{
				var item : Item = ItemManager.instance.getPileItem(ID.CHAT_NOTIC_PROP);
				if (item.nums < 1)
				{
					SingleQuickShop.show(ID.CHAT_NOTIC_PROP);
					vo.content = "你的“大喇叭”道具没了,请尽快去“商场”购买";
					vo.channelId = ChannelId.PROMPT;
					cToS.sendmsg(vo);
					return;
				}
			}

			if (vo.channelId != ChannelId.PROMPT)
			{
				msgTextInput.content = "";
			}

			if (vo.content.toLowerCase() == ".help")
			{
				vo.content = "";
				vo.content += ".addhero_将领id 添加英雄              \n";
				vo.content += ".item_物品id_数量 添加物品              \n";
				vo.content += ".gold 添加元宝              \n";
				vo.content += ".goldb 绑定元宝              \n";
				vo.content += ".silver 银币              \n";
				vo.content += ".honor 声望              \n";
				vo.content += ".topup 充值              \n";
				vo.content += ".vip 设置VIP              \n";
				vo.content += ".reset 所有功能重置              \n";
				vo.content += ".level  设置等级              \n";
				vo.content += ".exp 经验              \n";
				vo.content += ".setquest 任务id 选择任务             \n";
				vo.content += ".gexp 宗族加经验              \n";
				vo.content += ".gareset 重置家族活动的次数              \n";
				vo.content += ".gdstart 家族寻宝重置              \n";
				vo.content += ".gestart 家族运镖重置              \n";
				vo.content += ".setConvoy 1 num 龟拜次数            \n";
				vo.content += ".setConvoy 2 robNum 龟拜打劫次数              \n";

				vo.channelId = ChannelId.PROMPT;
				cToS.sendmsg(vo);
				return;
			}
			else if (vo.content.toLowerCase() == ".convoy")
			{
				vo.content = "";
				vo.content += "[m:20:蜀山{龟仙拜佛出发点}:5000:3000] \n";
				vo.content += "[m:20:蜀山{龟仙拜佛地点2}:3968:2272] \n";
				vo.content += "[m:20:蜀山{龟仙拜佛地点1}:2448:3824] \n";
				vo.content += "[m:20:蜀山{龟仙拜佛地点3}:5072:4544] \n";
				vo.content += "[m:20:蜀山{龟仙拜佛地点4}:7296:3616] \n";
			}
			else
			{
				vo.content = RegExpUtils.getFilterStr(vo.content);
			}
			// vo.content = ChatItemInput.getFilterStr(vo.content);
			cToS.sendmsg(vo);
			preMsg = vo.content;
			preChannelId = vo.channelId;
			if (ChatConfig.channelSendCDLimitList.indexOf(vo.channelId) != -1)
			{
				channelSendTimeDic[vo.channelId] = getTimer();
				time = ChatConfig.channelSendCDTimeDic[vo.channelId];
				sendButton.openCD(time, 1);
			}
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 设置玩家名称 */
		public function setPlayerName(playerName : String) : void
		{
			if (msgTextInput == null) return;
			msgTextInput.playerName = playerName;
		}

		/** 设置输入频道 */
		public function setInputChannel(channelId : uint) : void
		{
			var voChannel : VoChannel = ChatConfig.channelVoDic[channelId];
			if (voChannel == null) return;
			channelComboBox.selectedVo = voChannel;
		}

		/** 设置输出频道 */
		public function setOutputChannel(channelId : uint) : void
		{
			var voChannel : VoChannel = ChatConfig.channelVoDic[channelId];
			if (voChannel == null) return;
			boxOutput.selectedChannel = voChannel;
		}

		/** 提示 */
		public function prompt(str : String, isHTMLFormat : Boolean = false) : void
		{
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = ChannelId.PROMPT;
			vo.content = str;
			vo.isHTMLFormat = isHTMLFormat;
			cToS.sendmsg(vo);
		}

		/** 系统 */
		public function system(str : String, isHTMLFormat : Boolean = false) : void
		{
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = ChannelId.SYSTEM;
			vo.content = str;
			vo.isHTMLFormat = isHTMLFormat;
			cToS.sendmsg(vo);
		}

		/** 家族提示消息 */
		public function clanPrompt(str : String) : void
		{
			var vo : VoChatMsg = new VoChatMsg();
			vo.channelId = ChannelId.CLAN;
			vo.playerName = null;
			vo.content = str;

			modelChat.addMsg(vo);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 是否显示私聊 */
		private var _isShowWhisper : Boolean = true;

		/** 是否显示私聊 */
		public function set isShowWhisper(value : Boolean) : void
		{
			if (_isShowWhisper == value) return;
			_isShowWhisper = value;
			tabBar.isShowWhisper = _isShowWhisper;
			channelComboBox.isShowWhisper = _isShowWhisper;

			if (_isShowWhisper == true)
			{
				tabBar.selectedVo = ChatConfig.whisperVo;
			}
			else
			{
				if (tabBar.selectedVo.id == ChannelId.WHISPER)
				{
					tabBar.selectedVo = ChatConfig.defaultOutputChannel;
				}

				// ManagerWhisper.instance.isShowWindow = true;
			}
		}

		public function get isShowWhisper() : Boolean
		{
			return _isShowWhisper;
		}
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
	}
}
