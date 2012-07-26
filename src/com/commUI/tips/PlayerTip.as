package com.commUI.tips {
	import game.core.menu.MenuType;
	import game.core.hero.HeroManager;
	import game.manager.SignalBusManager;
	import game.module.guild.GuildManager;
	import game.core.menu.MenuManager;
	import game.core.user.StateManager;
	import game.manager.ViewManager;
	import game.module.chatwhisper.ControllerWhisper;
	import game.module.chatwhisper.ManagerWhisper;
	import game.module.chatwhisper.config.WindowState;
	import game.module.friend.ManagerFriend;
	import game.module.guild.GuildManager;
	import game.module.guild.GuildProxy;
	import game.module.trade.exchange.ExchangeManager;

	import gameui.manager.UIManager;

	import net.AssetData;

	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.utils.Dictionary;





	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-8  ����3:38:27 
	 */
	public class PlayerTip extends Sprite
	{
		// public static var managerFriend : ManagerFriend = ManagerFriend.getInstance();
		public static const NAME : String = "PlayerTips";
		public var playerId : uint;
		public var playerName : String = "玩家名";
		public var showList : Array;
		/** 容器 */
		private var _content : Sprite;
		/** 背景 */
		private var _bg : DisplayObject;
		private var _items : Vector.<PlayerTipItem>;
		private var itemDic : Dictionary = new Dictionary();
		private static var _instance : PlayerTip;
		private var _paddingLeft : uint = 5;
		private var _paddingRight : uint = 5;
		private var _paddingTop : uint = 5;
		private var _paddingBottom : uint = 5;
		private var _width : Number;
		private var _height : Number;
		/** 私聊 */
		public static const EVENT_SHISPER : String = "event_whisper";
		/** 加为好友 */
		public static const EVENT_ADD_FRIEND : String = "event_addFriend";
		/** 动一下 */
		public static const EVENT_ACT : String = "event_act";
		/** 交易 */
		public static const EVENT_TRADE : String = "event_trade";
		/** 发送邮件 */
		public static const EVENT_EMAIL : String = "event_email";
		/** 复制名称 */
		public static const EVENT_COPY_PLAYER_NAME : String = "event_copyPlayerName";
		/** 查看信息 */
		public static const EVENT_LOOK_INFO : String = "event_lookInfo";
		/** 移至黑名单 */
		public static const EVENT_MOVE_TO_BACKLIST : String = "event_moveToBackList";
		/** 移出黑名单 */
		public static const EVENT_MOVE_OUT_BACKLIST : String = "event_moveOutBackList";
		/** 删除知己 */
		public static const EVENT_DELETE_FRIEND : String = "event_deleteFriend";
		/** 家族邀请 */
		public static const EVENT_INVITE_CLAN : String = "event_inviteClan";
		/** 转让族长 */
		public static const EVENT_LEADER_CHANGE : String = "event_leaderChange";
		/** 提升为副族长 */
		public static const EVENT_UP_VICE : String = "event_upVice";
		/** 降低职位 */
		public static const EVENT_DOWN_VICE : String = "event_downVice";
		/** 踢出家族 */
		public static const EVENT_OUT_CLAN : String = "event_outClan";
		/** 私聊 */
		public static const NAME_SHISPER : String = "私聊";
		/** 加为好友 */
		public static const NAME_ADD_FRIEND : String = "加为好友";
		/** 动一下 */
		public static const NAME_ACT : String = "动一下";
		/** 交易 */
		public static const NAME_TRADE : String = "交易";
		/** 发送邮件 */
		public static const NAME_EMAIL : String = "发送邮件";
		/** 复制名称 */
		public static const NAME_COPY_PLAYER_NAME : String = "复制名称";
		/** 查看信息 */
		public static const NAME_LOOK_INFO : String = "查看信息";
		/** 移至黑名单 */
		public static const NAME_MOVE_TO_BACKLIST : String = "移至黑名单";
		/** 移出黑名单 */
		public static const NAME_MOVE_OUT_BACKLIST : String = "移出黑名单";
		/** 删除知己 */
		public static const NAME_DELETE_FRIEND : String = "删除好友";
		/** 家族邀请 */
		public static const NAME_INVITE_CLAN : String = "家族邀请";
		/** 转让族长 */
		public static const NAME_LEADER_CHANGE : String = "转让族长";
		/** 提升为副族长 */
		public static const NAME_UP_VICE : String = "提升副族长";
		/** 降低职位 */
		public static const NAME_DOWN_VICE : String = "降低职位";
		/** 踢出家族 */
		public static const NAME_OUT_CLAN : String = "踢出家族";

		public function PlayerTip()
		{
			this.name = NAME;
			_bg = UIManager.getUI(new AssetData("GToolTip_backgroundSkin"));
			_bg.width = 50;
			_bg.height = 200;
			addChild(_bg);
			_content = new Sprite();
			addChild(_content);
			initItems();
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(PlayerTipItem.EVENT_SEND_COMMIT, closeHandler);
		}

		/** 关闭事件 */
		private function closeHandler(event : Event) : void
		{
			var item : PlayerTipItem = event.target as PlayerTipItem;

			if (item == null)
			{
				hide();
				return;
			}

			switch(item.eventName)
			{
				// 私聊
				case PlayerTip.EVENT_SHISPER:
					ManagerWhisper.instance.showWindowByPlayerName(playerName);
					// 如果私聊面板已最小化，此时再双击，私聊面板最大化，私聊Icon消失
					if (ControllerWhisper.instance.windowState == WindowState.WINDOW_STATE_MIN)
					{
						ControllerWhisper.instance.isShowWindow = true;
						ManagerWhisper.instance.showWindowByPlayerName(playerName);
						ControllerWhisper.instance.windowState = WindowState.WINDOW_STATE_OPEN;
					}
					// ManagerChat.instance.setPlayerName(playerName);
					break;
				// 加为好友
				case PlayerTip.EVENT_ADD_FRIEND:
					ManagerFriend.getInstance().addFriendByPlayerName(playerName);
					break;
				// 动一下
				case PlayerTip.EVENT_ACT:
					break;
				// 交易
				case PlayerTip.EVENT_TRADE:
					// TODO : 交易中的serverId暂定为0，合服后需要修改
					ExchangeManager.instance.startExchangeWithPlayer(playerName, 0);
					break;
				// 发送邮件
				case PlayerTip.EVENT_EMAIL:
					MenuManager.getInstance().openMenuView(21);
					break;
				// 复制名称
				case PlayerTip.EVENT_COPY_PLAYER_NAME:
					System.setClipboard(playerName);
					break;
				// 查看信息
				case PlayerTip.EVENT_LOOK_INFO:
					HeroManager.instance.sendViewOtherInfo(playerName);
					break;
				// 移至黑名单
				case PlayerTip.EVENT_MOVE_TO_BACKLIST:
					ManagerFriend.getInstance().moveInBacklistByPlayerName(playerName);
					break;
				// 移出黑名单
				case PlayerTip.EVENT_MOVE_OUT_BACKLIST:
					ManagerFriend.getInstance().moveOutBacklistByPlayerName(playerName);
					break;
				// 删除知己
				case PlayerTip.EVENT_DELETE_FRIEND:
					ManagerFriend.getInstance().deleteFriendByPlayerId(playerId);
					break;
				// 家族邀请
				case PlayerTip.EVENT_INVITE_CLAN:
					GuildProxy.cs_guildinvite( playerId,playerName );
					break;
				// 转让族长
				case PlayerTip.EVENT_LEADER_CHANGE:
					GuildManager.instance.setMemberPosition( playerId , 2) ;
					break;
				// 提升为副族长
				case PlayerTip.EVENT_UP_VICE:
					GuildManager.instance.setMemberPosition( playerId, 1 );
					break;
				// 降低职位
				case PlayerTip.EVENT_DOWN_VICE:
					GuildManager.instance.setMemberPosition( playerId, 0);
					break;
				// 踢出家族
				case PlayerTip.EVENT_OUT_CLAN:
					GuildManager.instance.removeGuildMember( playerId );
//					GuildProxy.cs_guildremove(playerId);
					break;
			}
			this.hide();
		}

		/** 场景按下事件 */
		private static function stage_mouseDownHandler(event : MouseEvent) : void
		{
			var tip : PlayerTip = UIManager.root.getChildByName(NAME) as PlayerTip;
			if (tip)
			{
				tip.hide();
			}
		}

		private function mouseDownHandler(event : MouseEvent) : void
		{
			event.stopPropagation();
		}

		static public function get instance() : PlayerTip
		{
			if (_instance == null)
			{
				_instance = new PlayerTip();
				_instance.alpha = 0;
			}
			return _instance;
		}

		/** 初始化Itmes */
		private function initItems() : void
		{
			if (_items) return;
			_items = new Vector.<PlayerTipItem>();
			var voPlayerTipItem : PlayerTipItem ;
			// 私聊
			voPlayerTipItem = new PlayerTipItem(EVENT_SHISPER, NAME_SHISPER);
			_items.push(voPlayerTipItem);
			itemDic[NAME_SHISPER] = voPlayerTipItem;
			// 加为好友
			voPlayerTipItem = new PlayerTipItem(EVENT_ADD_FRIEND, NAME_ADD_FRIEND);
			_items.push(voPlayerTipItem);
			itemDic[NAME_ADD_FRIEND] = voPlayerTipItem;
			// 动一下
			voPlayerTipItem = new PlayerTipItem(EVENT_ACT, NAME_ACT);
			_items.push(voPlayerTipItem);
			itemDic[NAME_ACT] = voPlayerTipItem;
			// 交易
			voPlayerTipItem = new PlayerTipItem(EVENT_TRADE, NAME_TRADE);
			_items.push(voPlayerTipItem);
			itemDic[NAME_TRADE] = voPlayerTipItem;
			// 发送邮件
			voPlayerTipItem = new PlayerTipItem(EVENT_EMAIL, NAME_EMAIL);
			_items.push(voPlayerTipItem);
			itemDic[NAME_EMAIL] = voPlayerTipItem;
			// 复制名称
			voPlayerTipItem = new PlayerTipItem(EVENT_COPY_PLAYER_NAME, NAME_COPY_PLAYER_NAME);
			_items.push(voPlayerTipItem);
			itemDic[NAME_COPY_PLAYER_NAME] = voPlayerTipItem;
			// 查看信息
			voPlayerTipItem = new PlayerTipItem(EVENT_LOOK_INFO, NAME_LOOK_INFO);
			_items.push(voPlayerTipItem);
			itemDic[NAME_LOOK_INFO] = voPlayerTipItem;
			// 移至黑名单
			voPlayerTipItem = new PlayerTipItem(EVENT_MOVE_TO_BACKLIST, NAME_MOVE_TO_BACKLIST);
			_items.push(voPlayerTipItem);
			itemDic[NAME_MOVE_TO_BACKLIST] = voPlayerTipItem;
			// 移出黑名单
			voPlayerTipItem = new PlayerTipItem(EVENT_MOVE_OUT_BACKLIST, NAME_MOVE_OUT_BACKLIST);
			_items.push(voPlayerTipItem);
			itemDic[NAME_MOVE_OUT_BACKLIST] = voPlayerTipItem;
			// 删除知己
			voPlayerTipItem = new PlayerTipItem(EVENT_DELETE_FRIEND, NAME_DELETE_FRIEND);
			_items.push(voPlayerTipItem);
			itemDic[NAME_DELETE_FRIEND] = voPlayerTipItem;
			// 家族邀请
			voPlayerTipItem = new PlayerTipItem(EVENT_INVITE_CLAN, NAME_INVITE_CLAN);
			_items.push(voPlayerTipItem);
			itemDic[NAME_INVITE_CLAN] = voPlayerTipItem;
			// 转让族长
			voPlayerTipItem = new PlayerTipItem(EVENT_LEADER_CHANGE, NAME_LEADER_CHANGE);
			_items.push(voPlayerTipItem);
			itemDic[NAME_LEADER_CHANGE] = voPlayerTipItem;
			// 提升为副族长
			voPlayerTipItem = new PlayerTipItem(EVENT_UP_VICE, NAME_UP_VICE);
			_items.push(voPlayerTipItem);
			itemDic[NAME_UP_VICE] = voPlayerTipItem;
			// 降低职位
			voPlayerTipItem = new PlayerTipItem(EVENT_DOWN_VICE, NAME_DOWN_VICE);
			_items.push(voPlayerTipItem);
			itemDic[NAME_DOWN_VICE] = voPlayerTipItem;
			// 踢出家族
			voPlayerTipItem = new PlayerTipItem(EVENT_OUT_CLAN, NAME_OUT_CLAN);
			_items.push(voPlayerTipItem);
			itemDic[NAME_OUT_CLAN] = voPlayerTipItem;
		}

		/** 更新视图 */
		private function updateView() : void
		{
			var item : PlayerTipItem;
			var postionX : uint = _paddingLeft;
			var postionY : uint = _paddingTop;
			var maxItemWidth : Number = 65;
			var gap : uint = 2;
			_width = 0;
			_height = 0;
			for (var i : int = 0; i < _content.numChildren; i++)
			{
				_content.removeChildAt(i);
			}

			var result : uint;
			if (showList == null)
			{
				for (i = 0; i < _items.length; i++)
				{
					item = _items[i];
					item.enable = true;
					item.visible = false;
					result = check(item);

					if (result != ITEM_HIDE)
					{
						item.enable = result == ITEM_ENABLE;
						item.x = postionX;
						item.y = postionY;
						postionY += 20 + gap;
						// maxItemWidth = Math.max(maxItemWidth, 100);
						item.visible = true;
						_content.addChild(item);
					}
				}
			}
			else
			{
				for (i = 0; i < _items.length; i++)
				{
					_items[i].visible = false;
				}

				for (i = 0; i < showList.length; i++)
				{
					item = itemDic[showList[i]];
					item.enable = true;
					// item.visible = false;
					result = check(item);

					if (result != ITEM_HIDE)
					{
						item.enable = result == ITEM_ENABLE;
						item.x = postionX;
						item.y = postionY;
						postionY += 20 + gap;
						// maxItemWidth = Math.max(maxItemWidth, 100);
						item.visible = true;
						_content.addChild(item);
					}
				}
			}

			_width = _paddingLeft + maxItemWidth + _paddingRight;
			_height = postionY + _paddingBottom - gap;
			_bg.width = _width;
			_bg.height = _height;
		}

		private static const ITEM_ENABLE : uint = 0;
		private static const ITEM_DISABLE : uint = 1;
		private static const ITEM_HIDE : uint = 2;

		private function check(item : PlayerTipItem) : uint
		{
			var result : uint = ITEM_ENABLE;
			switch(item.eventName)
			{
				// 私聊
				case EVENT_SHISPER:
					result = ManagerFriend.getInstance().isInBackListByPlayerName(playerName) == true ? ITEM_DISABLE : ITEM_ENABLE;
					break ;
//					break;
//				// 动他一下
//					result = ITEM_HIDE ;
//					break ;
				// 交易
				case EVENT_TRADE:
					if( !MenuManager.getInstance().checkOpen(MenuType.TRADE) )
						result = ITEM_HIDE ;
					else if( ManagerFriend.getInstance().isInBackListByPlayerName(playerName) )
						result = ITEM_DISABLE ;
					else 
						result = ITEM_ENABLE ;
					break;
				// 发送邮件
				case EVENT_ACT:
				case EVENT_EMAIL:
					// 如果是黑名单中
					result = ITEM_HIDE ;
					break ;
				// 加为好友
				case EVENT_ADD_FRIEND:
					// 如果在好友列表中
					result = ManagerFriend.getInstance().isInFriendListByPlayerName(playerName) == true ? ITEM_DISABLE : ITEM_ENABLE;
					if (result == ITEM_ENABLE)
					{
						// 如果是黑名单中
						result = ManagerFriend.getInstance().isInBackListByPlayerName(playerName) == true ? ITEM_DISABLE : result;
					}
					break;
				// 移至黑名单
				case EVENT_MOVE_TO_BACKLIST:
					// 如果是黑名单中
					result = ManagerFriend.getInstance().isInBackListByPlayerName(playerName) == false ? ITEM_ENABLE : ITEM_HIDE;
					// if (playerId <= 0) result = ITEM_HIDE;
					break;
				// 移出黑名单
				case EVENT_MOVE_OUT_BACKLIST:
					// 如果是黑名单中
					result = ManagerFriend.getInstance().isInBackListByPlayerName(playerName) == true ? ITEM_ENABLE : ITEM_HIDE;
					// if (playerId <= 0) result = ITEM_HIDE;
					break;
				// 删除知己
				case EVENT_DELETE_FRIEND:
					// 如果在好友列表中
					result = ManagerFriend.getInstance().isInFriendListByPlayerName(playerName) == true ? ITEM_ENABLE : ITEM_HIDE;
					if (playerId <= 0) result = ITEM_HIDE;
					break;
				// 家族邀请
				case EVENT_INVITE_CLAN:
					// 如果是黑名单中
					result = ( ManagerFriend.getInstance().isInBackListByPlayerName(playerName) == true || GuildManager.instance.selfguild == null ) ? ITEM_DISABLE : ITEM_ENABLE;
					if (showList == null)
						result = ITEM_HIDE;
					break;
				// 转让族长
				case EVENT_LEADER_CHANGE:
					if (showList == null)
						result = ITEM_HIDE;
					break;
				// 提升为副族长
				case EVENT_UP_VICE:
					if (showList == null)
						result = ITEM_HIDE;
					break;
				// 降低职位
				case EVENT_DOWN_VICE:
					if (showList == null)
						result = ITEM_HIDE;
					break;
				// 踢出家族
				case EVENT_OUT_CLAN:
					if (showList == null)
						result = ITEM_HIDE;
					break;
			}
			return result;
		}

		public static function close() : void
		{
			PlayerTip.instance.hide();
		}

		public static function show(playerId : uint = 0, playerName : String = null, showList : Array = null) : void
		{
			var tip : PlayerTip;

			tip = instance;
			tip.playerId = playerId;
			tip.playerName = playerName;
			tip.showList = showList;
			tip.updateView();
			tip.alpha = 0;
			UIManager.stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);

			tip.x = UIManager.stage.mouseX;
			tip.y = UIManager.stage.mouseY;
			if (tip.x + tip.width + 10 > ViewManager.instance.uiContainer.stage.stageWidth)
			{
				tip.x = UIManager.stage.mouseX - tip.width;
			}

			if (tip.y + tip.height + 10 > ViewManager.instance.uiContainer.stage.stageHeight)
			{
				tip.y = UIManager.stage.mouseY - tip.height;
			}

			UIManager.root.addChild(tip);

			var fun : Function = function(displayObject : DisplayObject) : void
			{
			};
			TweenLite.to(tip, 0.5, {alpha:1, onUpdate:fun, onUpdateParams:[tip]});
		}

		public function hide() : void
		{
			UIManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
			
			if (this.parent == null) return;
			var fun : Function = function(displayObject : DisplayObject) : void
			{
				if (displayObject.alpha <= 0)
				{
					if (displayObject.parent)
					{
						displayObject.parent.removeChild(displayObject);
					}
				}
			};
			TweenLite.to(this, 0.5, {alpha:0, onUpdate:fun, onUpdateParams:[this]});
		}
	}
}
import gameui.manager.UIManager;

import com.utils.FilterUtils;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

class PlayerTipItem extends Sprite
{
	public var eventName : String;
	public var labelName : String;
	private var _textField : TextField;
	private var _enable : Boolean = true;
	public static const EVENT_SEND_COMMIT : String = "event_sendCommit";

	function PlayerTipItem(eventName : String, labelName : String) : void
	{
		this.eventName = eventName;
		this.labelName = labelName;
		initViews();
		initEvent();
	}

	/** 初始化视图 */
	private function initViews() : void
	{
		_textField = new TextField();
		_textField.width = 65;
		_textField.height = 16;
		_textField.defaultTextFormat = linkUp;
		_textField.text = labelName;
		_textField.filters = [FilterUtils.defaultTextEdgeFilter];
		addChild(_textField);
	}

	private function initEvent() : void
	{
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		addEventListener(MouseEvent.CLICK, clickHandler);
	}

	/** 鼠标点击 */
	private function clickHandler(event : MouseEvent) : void
	{
		if (enable == false) return;
		dispatchEvent(new Event(EVENT_SEND_COMMIT, true));
	}

	/** 鼠标按下 */
	private function mouseDownHandler(event : MouseEvent) : void
	{
		if (enable == false) return;
		_textField.defaultTextFormat = linkDown;
	}

	/** 鼠标移出 */
	private function mouseOutHandler(event : MouseEvent) : void
	{
		if (enable == false) return;
		_textField.defaultTextFormat = linkUp;
		_textField.text = labelName;
	}

	/** 鼠标移入 */
	private function mouseOverHandler(event : MouseEvent) : void
	{
		if (enable == false) return;

		_textField.defaultTextFormat = linkOver;
		_textField.text = labelName;
	}

	public function get enable() : Boolean
	{
		return _enable;
	}

	public function set enable(enable : Boolean) : void
	{
		_enable = enable;
		if (_enable == false)
		{
			_textField.setTextFormat(linkDisable);
		}
		else
		{
			_textField.setTextFormat(linkUp);
		}
	}

	private static var _linkUp : TextFormat;

	/** 链接Up */
	static public function get linkUp() : TextFormat
	{
		if (_linkUp == null)
		{
			_linkUp = new TextFormat();
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.color = 0xFFFFFF;
			textFormat.size = 12;
			textFormat.leading = 0;
			textFormat.kerning = true;
			textFormat.underline = false;
			_linkUp = textFormat;
		}
		return _linkUp;
	}

	private static var _linkOver : TextFormat;

	/** 链接Over */
	static public function get linkOver() : TextFormat
	{
		if (_linkOver == null)
		{
			_linkOver = new TextFormat();
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.color = 0xd4dc00;
			textFormat.size = 12;
			textFormat.leading = 3;
			textFormat.kerning = true;
			textFormat.underline = true;
			_linkOver = textFormat;
		}
		return _linkOver;
	}

	private static var _linkDown : TextFormat;

	/** 链接Down */
	static public function get linkDown() : TextFormat
	{
		if (_linkDown == null)
		{
			_linkDown = new TextFormat();
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.color = 0xa5d303;
			textFormat.size = 12;
			textFormat.leading = 3;
			textFormat.kerning = true;
			textFormat.underline = true;
			_linkDown = textFormat;
		}
		return _linkDown;
	}

	private static var _linkDisable : TextFormat;

	/** 链接Down */
	static public function get linkDisable() : TextFormat
	{
		if (_linkDisable == null)
		{
			_linkDisable = new TextFormat();
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.color = 0x666666;
			textFormat.size = 12;
			textFormat.leading = 3;
			textFormat.kerning = true;
			textFormat.underline = false;
			_linkDisable = textFormat;
		}
		return _linkDisable;
	}
}
