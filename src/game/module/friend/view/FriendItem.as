package game.module.friend.view
{
	import com.commUI.tips.PlayerTip;
	import com.utils.ColorUtils;
	import com.utils.DrawUtils;
	import com.utils.LabelUtils;
	import com.utils.PotentialColorUtils;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import game.module.chatwhisper.ControllerWhisper;
	import game.module.chatwhisper.ManagerWhisper;
	import game.module.chatwhisper.config.WindowState;
	import game.module.friend.EventFriend;
	import game.module.friend.ManagerFriend;
	import game.module.friend.VoFriendItem;
	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;
	import net.RESManager;

	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-3  ����1:41:39 
	 */
	public class FriendItem extends GCell
	{
		private var _vo : VoFriendItem;
		/** 背景 */
		// private var _bg : DisplayObject;
		private var _bg : Sprite;
		/** 服务器ID 背景 */
		private var _serverIdBg : DisplayObjectContainer;
		/** 服务器ID Label */
		private var _serverIdLabel : TextField;
		/** 玩家性别图标 */
		// private var _sexIco : Bitmap;
		private var _sexIco : Sprite;
		/** 玩家名称 Label */
		private var _nameLabel : TextField;
		/** 等级 */
		private var _levelLabel : TextField;
		/** infoLabel值模板 */
		public static const INFO_TEMPLATE : String = '<font color="@NameColor@">@Name@</font>  <font color="@LevelColor@">Lv.@Level@</font>';
		/** 好友类型Ico */
		private var _friendTypeIco : Bitmap;
		/** 组元件 */
		public var groupElement : FriendGroup;
		/** 是否选中的 */
		private var _isSelected : Boolean;

		public function FriendItem(data : GCellData)
		{
			if (data)
			{
				data.height = 20;
				data.upAsset = new AssetData(SkinStyle.emptySkin);
				data.overAsset = new AssetData(SkinStyle.emptySkin);
				data.selected_upAsset = new AssetData(SkinStyle.emptySkin);
				data.selected_overAsset = new AssetData(SkinStyle.emptySkin);
			}
			super(data);
			initViews();
			this.mouseChildren = false;
		}

		protected function initViews() : void
		{
			// 鼠标划过背景
			// _bg = DrawUtils.roundRect(null, _base.width, _base.height, 0, 5, 0xFFFFFF, 0x1d3855, 0.1, 0.1);
			_bg = UIManager.getUI(new AssetData("Friend_Item_Bg"));
			_bg.width = _base.width - 2;
			_bg.height = _base.height - 2;
			_bg.x = 1;
			_bg.y = 1;
			_bg.visible = false;
			addChild(_bg);

			// 服务器ID
			var tf : TextFormat = new TextFormat();
			tf.size = 10;
			tf.font = UIManager.defaultFont;
			tf.align = TextFormatAlign.CENTER;
			_serverIdLabel = new TextField();
			_serverIdLabel.defaultTextFormat = tf;
			_serverIdLabel.width = 19;
			_serverIdLabel.height = 14;
			_serverIdLabel.text = "123";
			_serverIdLabel.x = 0;
			_serverIdLabel.y = -2 ;
			_serverIdBg = DrawUtils.roundRect(null, 19, 10, 0, 5, 0x663300, 0x1d3855, 0.5, 0) as DisplayObjectContainer;
			_serverIdBg.x = 5;
			_serverIdBg.y = (this.height - 10) / 2 ;
			// TODO:合服以后添加
			// addChild(_serverIdBg);
			// _serverIdBg.addChild(_serverIdLabel);

			// 玩家性别图标
			// _sexIco = new Bitmap();
			// _sexIco.bitmapData = RESManager.getBitmapData(new AssetData("Men_Icon"));
			// _sexIco.scaleX = _sexIco.scaleY = 12 / 15;
			// _sexIco.x = 21;
			// _sexIco.y = (_base.height - _sexIco.height) / 2;
			// addChild(_sexIco);

			// label包含玩家名称、等级信息
			_nameLabel = LabelUtils.createContent1();
			_nameLabel.width = 120;
			_nameLabel.height = 20;
			var text : String = INFO_TEMPLATE;
			text = text.replace(/@NameColor@/gi, PotentialColorUtils.getColorOfStr(35));
			text = text.replace(/@Name@/gi, "大海明月");
			text = text.replace(/@LevelColor@/gi, "#333333");
			text = text.replace(/@Level@/gi, 30);
			// _infoLabel.htmlText = text;
			_nameLabel.x = 35;
			_nameLabel.y = 4 - 2;
			_nameLabel.mouseEnabled = false;
			addChild(_nameLabel);
			// 等级Label
			_levelLabel = LabelUtils.createContent1();
			_levelLabel.textColor = 0x090927;
			_levelLabel.width = 50;
			_levelLabel.height = 20;
			_levelLabel.x = _base.width - 55;
			_levelLabel.y = 4 - 2;
			_levelLabel.mouseEnabled = false;
			addChild(_levelLabel);

			// 好友类型Ico
			_friendTypeIco = new Bitmap();
			_friendTypeIco.x = _base.width - 25;
			_friendTypeIco.y = (_base.height - 17) / 2;
			// addChild(_friendTypeIco);
		}

		/** 初始化事件（添加事件监听） */
		override protected function onShow() : void
		{
			super.onShow();
			
			addEventListener(MouseEvent.MOUSE_OVER, this_mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, this_mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler);
		}
		
		override protected function onHide() : void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, this_mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, this_mouseOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler);
			
			super.onHide();
		}

		private function this_mouseOverHandler(event : MouseEvent) : void
		{
			if (isSelected) return;
			_bg.visible = true;
		}

		private function this_mouseOutHandler(event : MouseEvent) : void
		{
			if (isSelected) return;
			_bg.visible = false;
		}

		protected function this_mouseDownHandler(event : MouseEvent) : void
		{
			clickOrDoubleClickHandler();
			if (vo == null || vo.group == null)
			{
				return;
			}

			this.addEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
		}

		protected function this_mouseUpHandler(event : MouseEvent) : void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler);

			// var eventFriend : EventFriend = new EventFriend(EventFriend.FRIEND_ITEM_STOP_DRAG, true);
			// eventFriend.friendItem = this;
			// dispatchEvent(eventFriend);
		}

		private function this_mouseMoveHandler(event : MouseEvent) : void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler);
			// var eventFriend : EventFriend = new EventFriend(EventFriend.FRIEND_ITEM_START_DRAG, true);
			// eventFriend.friendItem = this;
			// dispatchEvent(eventFriend);
			clearTimeout(clickSetTimeout);
		}

		protected var oldMouseDownTime : uint = 0;
		protected var clickSetTimeout : uint;
		protected var isClick : Boolean = false;

		/** 判断单击还是双击 */
		protected function clickOrDoubleClickHandler() : void
		{
			var date : Date = new Date();
			var offMouseDownTime : uint = date.time - oldMouseDownTime;
			// 双击
			if (offMouseDownTime < 300)
			{
				onDubleClick(null);
				clearTimeout(clickSetTimeout);
			}
			// 单击
			else
			{
				var event : EventFriend = new EventFriend(EventFriend.SELECTED_FRIEND, true);
				dispatchEvent(event);
				clickSetTimeout = setTimeout(onClick, 300);
			}
			oldMouseDownTime = date.time;
		}

		/** 点击 */
		protected function onClick() : void
		{
			if (ManagerFriend.getInstance().isInBackListByPlayerName(vo.name))
			{
				PlayerTip.show(vo.id, vo.name, [PlayerTip.NAME_COPY_PLAYER_NAME, PlayerTip.NAME_MOVE_OUT_BACKLIST]);
			}
			else
			{
				PlayerTip.show(vo.id, vo.name, [PlayerTip.NAME_SHISPER, PlayerTip.NAME_ADD_FRIEND, PlayerTip.NAME_TRADE, PlayerTip.NAME_COPY_PLAYER_NAME, PlayerTip.NAME_LOOK_INFO, PlayerTip.NAME_MOVE_TO_BACKLIST, PlayerTip.NAME_MOVE_OUT_BACKLIST, PlayerTip.NAME_DELETE_FRIEND]);
			}
		}

		/** 双击 */
		private function onDubleClick(event : MouseEvent) : void
		{
			this.doubleClickEnabled = false;
			if (vo && vo.type != VoFriendItem.TYPE_BACKLIST)
			{
				ManagerWhisper.instance.showWindowByPlayerName(vo.name);
			}

			// 如果私聊面板已最小化，此时再双击，私聊面板最大化，私聊Icon消失
			if (ControllerWhisper.instance.windowState == WindowState.WINDOW_STATE_MIN)
			{
				ControllerWhisper.instance.isShowWindow = true;
				ManagerWhisper.instance.showWindowByPlayerName(vo.name);
				ControllerWhisper.instance.windowState = WindowState.WINDOW_STATE_OPEN;
			}
		}

		override public function set source(value : *) : void
		{
			_source = value;
			vo = value;
			updateSexIcon();
		}

		public function get vo() : VoFriendItem
		{
			return _vo;
		}

		public function set vo(vo : VoFriendItem) : void
		{
			_vo = vo;
			if (vo)
			{
				// var text : String = INFO_TEMPLATE;
				// text = text.replace(/@NameColor@/gi, HeroColorUtils.getColorOfStr(vo.colorPropertyValue));
				// text = text.replace(/@Name@/gi, vo.name);
				// text = text.replace(/@LevelColor@/gi, "#333333");
				// text = text.replace(/@Level@/gi, vo.level);
				// _infoLabel.htmlText = text;
				if (vo.isOnline == true)
				{
					_nameLabel.textColor = PotentialColorUtils.colorDic[vo.colorPropertyValue];
					_levelLabel.textColor = 0x090927;
					;
				}
				else
				{
					_nameLabel.textColor = 0x666666;
					_levelLabel.textColor = 0x666666;
				}
				_nameLabel.text = vo.name;
				_levelLabel.text = "Lv." + vo.level;

				// if (vo.isMale)
				// {
				// _sexIco.bitmapData = RESManager.getBitmapData(new AssetData("Man_Icon"));
				// }
				// else
				// {
				// _sexIco.bitmapData = RESManager.getBitmapData(new AssetData("Women_Icon"));
				// }
				// _sexIco.scaleX = _sexIco.scaleY = 12 / 15;

				_serverIdLabel.text = vo.serverId.toString();

				if (vo.type == VoFriendItem.TYPE_BOTH)
				{
					_friendTypeIco.bitmapData = RESManager.getBitmapData(new AssetData("FriendIco_BOTH"));
				}
				else
				{
					_friendTypeIco.bitmapData = null;
				}
			}
		}

		private function updateSexIcon() : void
		{
			if (_sexIco && _sexIco.parent) _sexIco.parent.removeChild(_sexIco);
			if (vo.isMale)
			{
				_sexIco = UIManager.getUI(new AssetData("Man_Icon"));
			}
			else
			{
				_sexIco = UIManager.getUI(new AssetData("Women_Icon"));
			}
			_sexIco.x = 21;
			_sexIco.y = (_base.height - _sexIco.height) / 2 + 3 - 2;
			addChild(_sexIco);
		}

		/** 是否选中的 */
		public function get isSelected() : Boolean
		{
			return _isSelected;
		}

		public function set isSelected(isSelected : Boolean) : void
		{
			_isSelected = isSelected;
			_bg.visible = isSelected;
		}
	}
}
