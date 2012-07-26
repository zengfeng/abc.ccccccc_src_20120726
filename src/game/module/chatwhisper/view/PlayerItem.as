package game.module.chatwhisper.view
{
	import game.module.chatwhisper.EventWhisper;
	import game.module.chatwhisper.ModelWhisper;
	import game.module.chatwhisper.VoPlayerMsg;
	import game.module.friend.VoFriendItem;

	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.utils.FilterUtils;
	import com.utils.LabelUtils;
	import com.utils.PotentialColorUtils;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;





	/**
	 * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-11-19 ����4:00:58
	 */
	public class PlayerItem extends GCell
	{
		private var _vo : VoFriendItem;
		/** 背景 */
		// private var _bg : DisplayObject;
		private var _bg : Sprite;
		/** 服务器ID 背景 */
		private var _serverIdBg : DisplayObjectContainer;
		/** 服务器ID Label */
		private var _serverIdLabel : TextField;
		/** 玩家名称Label */
		private var _nameLabel : TextField;
		/** 新消息数量 背景 */
		private var _newMsgNumBg : DisplayObjectContainer;
		/** 新消息数量 Label */
		private var _newMsgNumLabel : TextField;
		/** 关闭按钮 */
		private var _closeButton : GButton;
		/** 是否有新的消息 */
		private var _isHaveNewMsg : Boolean;
		/** 是否选中的 */
		private var _isSelected : Boolean;

		public function PlayerItem(width : uint, height : uint = 20)
		{
			_data = new GCellData();
			_data.width = width;
			_data.height = height;
			_data.upAsset = new AssetData(SkinStyle.emptySkin);
			_data.overAsset = new AssetData(SkinStyle.emptySkin);
			_data.selected_upAsset = new AssetData(SkinStyle.emptySkin);
			_data.selected_overAsset = new AssetData(SkinStyle.emptySkin);
			super(data);

			initViews();
			initEvents();
		}

		protected function initViews() : void
		{
			// 背景
			// _bg = DrawUtils.roundRect(null, _base.width, _base.height, 0, 5, 0xFFFFFF, 0x1d3855, 0.1, 0.1);
			_bg = UIManager.getUI(new AssetData("Friend_Item_Bg"));
			_bg.width = _base.width - 4;
			_bg.height = _base.height - 2;
			_bg.x = 3;
			_bg.y = 1;
			_bg.visible = false;
			addChild(_bg);
			// 服务器ID
			var textFormat : TextFormat = new TextFormat();
			textFormat.size = 10;
			textFormat.font = UIManager.defaultFont;
			textFormat.align = TextFormatAlign.CENTER;
			_serverIdLabel = new TextField();
			_serverIdLabel.mouseEnabled = false;
			_serverIdLabel.defaultTextFormat = textFormat;
			_serverIdLabel.width = 19;
			_serverIdLabel.height = 14;
			_serverIdLabel.text = "123";
			_serverIdLabel.x = 0;
			_serverIdLabel.y = -2 ;
			// _serverIdBg = DrawUtils.roundRect(null, 19, 10, 0, 5, 0x663300, 0x1d3855, 0.5, 0) as DisplayObjectContainer;
			_serverIdBg = UIManager.getUI(new AssetData("Bg_Num_1"));
			_serverIdBg.x = 1;
			_serverIdBg.y = (this.height - 10) / 2 ;
			// addChild(_serverIdBg);
			// _serverIdBg.addChild(_serverIdLabel);

			// 新消息数量
			_newMsgNumBg = UIManager.getUI(new AssetData("numberMount"));
			_newMsgNumBg.x = _width - 25 - _newMsgNumBg.width;
			_newMsgNumBg.y = (this.height - _newMsgNumBg.height) / 2 ;
			addChild(_newMsgNumBg);
			_newMsgNumLabel = new TextField();
			_newMsgNumLabel.mouseEnabled = false;
			_newMsgNumLabel.defaultTextFormat = textFormat;
			_newMsgNumLabel.autoSize = TextFieldAutoSize.CENTER;
			_newMsgNumLabel.textColor = 0xffffff;
			_newMsgNumLabel.width = _newMsgNumBg.width;
			_newMsgNumLabel.height = _newMsgNumBg.height;
			_newMsgNumLabel.text = "12";
			_newMsgNumLabel.x = 3;
			_newMsgNumLabel.y = 2;
			_newMsgNumBg.addChild(_newMsgNumLabel);
			_newMsgNumBg.visible = false;

			// label包含玩家名称、等级信息
			_nameLabel = LabelUtils.createContent1();
			_nameLabel.mouseEnabled = false;
			_nameLabel.width = 120;
			_nameLabel.height = 20;
			_nameLabel.x = 20;
			_nameLabel.y = 4 - 2;
			addChild(_nameLabel);

			// 删除按钮
			var buttonData : GButtonData = new GButtonData();
			buttonData.upAsset = new AssetData("Delete_Button_Up");
			buttonData.overAsset = new AssetData("Delete_Button_Over");
			buttonData.downAsset = new AssetData("Delete_Button_Down");
			buttonData.width = 12;
			buttonData.height = 12;
			buttonData.y = (_base.height - buttonData.height) / 2;
			buttonData.x = _base.width - buttonData.width - 5;
			_closeButton = new GButton(buttonData);
			_closeButton.visible = false;
			addChild(_closeButton);
		}

		/** 初始化事件（添加事件监听） */
		private function initEvents() : void
		{
			addEventListener(MouseEvent.MOUSE_OVER, this_mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, this_mouseOutHandler);
			addEventListener(MouseEvent.CLICK, selectedHandler);
			_closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
		}

		/** 选中玩家 */
		private function selectedHandler(event : MouseEvent) : void
		{
			var eventWhisper : EventWhisper = new EventWhisper(EventWhisper.SELECTED_PLAYER_LIST_ITEM, true);
			eventWhisper.voFriendItem = this.vo;
			dispatchEvent(eventWhisper);
		}

		/** 关闭按钮点击事件 */
		private function closeButton_clickHandler(event : MouseEvent) : void
		{
			var eventWhisper : EventWhisper = new EventWhisper(EventWhisper.CLOSE_PLAYER_LIST_ITEM, true);
			eventWhisper.voFriendItem = vo;
			dispatchEvent(eventWhisper);
			event.stopPropagation();
		}

		private function this_mouseOverHandler(event : MouseEvent) : void
		{
			if (isSelected) return;
			_bg.visible = true;
			_closeButton.visible = true;
		}

		private function this_mouseOutHandler(event : MouseEvent) : void
		{
			if (isSelected) return;
			_bg.visible = false;
			_closeButton.visible = false;
		}

		override public function set source(value : *) : void
		{
			_source = value;
			vo = value;
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
				// 玩家下线时，名字灰掉
				if (vo.isOnline == true)
				{
					_nameLabel.textColor = PotentialColorUtils.colorDic[vo.colorPropertyValue];

					// ControllerWhisper.instance.currentPlayerLabel.textColor = PotentialColorUtils.getColor(vo.colorPropertyValue);
					// ControllerWhisper.instance.view.currentPlayerLabel.textColor = PotentialColorUtils.getColor(vo.colorPropertyValue);
				}
				else
				{
					_nameLabel.textColor = 0x666666;

					// ControllerWhisper.instance.view.currentPlayerLabel.textColor = 0x666666;
				}

				_nameLabel.text = vo.name;
				_serverIdLabel.text = vo.serverId.toString();

				// if (vo.type == VoFriendItem.TYPE_BOTH)
				// {
				// _friendTypeIco.bitmapData = RESManager.getBitmapData(new AssetData("FriendIco_BOTH"));
				// }
				// else
				// {
				// _friendTypeIco.bitmapData = null;
				// }
			}
		}

		/** 是否有新的消息 */
		public function get isHaveNewMsg() : Boolean
		{
			return _isHaveNewMsg;
		}

		public function set isHaveNewMsg(isHaveNewMsg : Boolean) : void
		{
			_isHaveNewMsg = isHaveNewMsg;
			var voPlayerMsg : VoPlayerMsg = ModelWhisper.instance.getVoPlayerMsg(vo.name);
			if (_isHaveNewMsg == true && isSelected == false)
			{
				// FilterUtils.addIcoGlow(this);
				// FilterUtils.addIcoGlow(_newMsgNumLabel);
				FilterUtils.addIcoGlow(_newMsgNumBg);
				_newMsgNumBg.visible = true;
				if (voPlayerMsg)
				{
					_newMsgNumLabel.text = voPlayerMsg.newMsgNum.toString();
				}
			}
			else
			{
				// FilterUtils.removeIcoGlow(this);
				// FilterUtils.removeIcoGlow(_newMsgNumLabel);
				FilterUtils.removeIcoGlow(_newMsgNumBg);
				this.filters = [];
				_newMsgNumBg.visible = false;
				if (voPlayerMsg) voPlayerMsg.newMsgNum = 0;
			}
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
			_closeButton.visible = isSelected;
		}
	}
}
