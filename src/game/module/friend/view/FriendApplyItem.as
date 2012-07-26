package game.module.friend.view
{
	import com.commUI.PhotoItem;
	import com.commUI.button.KTButtonData;
	import com.utils.ColorUtils;
	import com.utils.DrawUtils;
	import com.utils.LabelUtils;
	import com.utils.PotentialColorUtils;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;
	import com.utils.UrlUtils;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import game.module.friend.VoFriendItem;
	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;
	import net.AssetData;
	import net.RESManager;








	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-3  ����5:33:28 
	 */
	public class FriendApplyItem extends GComponent
	{
		private var _vo : VoFriendItem;
		/** 背景 */
		private var _bg : DisplayObject;
		/** 头像 */
		private var _headPhoto : PhotoItem;
		/** 信息Label */
		private var _infoNameLabel : TextField;
		/** 玩家等级 **/
		private var _infoLevelLabel : TextField;
		/** 玩家性别Icon **/
		private var _sexIco : Sprite;
		/** infoLabel值模板 */
		// public static const INFO_TEMPLATE : String = '<font color="@NameColor@">@Name@</font>  <font color="@LevelColor@">Lv.@Level@</font>';
		public static const INFO_TEMPLATE : String = '<font color="@NameColor@">@Name@</font>';
		/** 提示Label */
		private var _promptLabel : TextField;
		/** 添加按钮 */
		public var addButton : GButton;
		/** 删除按钮 */
		public var deleteButton : GButton;
		/** 每个item背景 **/
		private var itemBg : Bitmap = new Bitmap();
		/** 根据该数值添加不同item背景 **/
		private var _itemBgNum : int;

		public function FriendApplyItem(base : GComponentData, itemBgNum : int)
		{
			_itemBgNum = itemBgNum;

			super(base);
			initViews();
			initEvents();
		}

		protected function initViews() : void
		{
			// 背景
			_bg = DrawUtils.roundRect(null, _base.width, _base.height, 0, 0, 0xCCCCCC, 0x1d3855, 0.7, 0.3);
			_bg.alpha = 0.5;
			// addChild(_bg);

			// item背景
			if (_itemBgNum % 2 == 0)
				itemBg.bitmapData = RESManager.getBitmapData(new AssetData("Friend_Apply_View_List_Light_Bg"));
			else
				itemBg.bitmapData = RESManager.getBitmapData(new AssetData("Friend_Apply_View_List_Dark_Bg"));
			itemBg.x = 0;
			itemBg.y = 0;
			itemBg.width = 474;
			itemBg.height = 50;
			addChildAt(itemBg, 0);

			// 头像背景
			var headPhotoBg : Sprite = UIManager.getUI(new AssetData("Whisper_View_Image_Bg"));
			headPhotoBg.x = 0;
			headPhotoBg.y = 0;
			headPhotoBg.width = 65;
			headPhotoBg.height = 50;
			addChild(headPhotoBg);

			// 头像
			_headPhoto = new PhotoItem(65, 50);
			_headPhoto.x = 0;
			_headPhoto.y = 0;
			addChild(_headPhoto);

			// 等级
			_infoLevelLabel = UICreateUtils.createTextField("", null, 50, 17, 1, -1, UIManager.getTextFormat(12, 0xffffff, TextFormatAlign.LEFT));
			addChild(_infoLevelLabel);

			// label包含玩家名称信息
			_infoNameLabel = LabelUtils.createContent2();
			_infoNameLabel.filters = null;
			// _infoNameLabel.defaultTextFormat = TextFormatUtils.contentCenter;
			_infoNameLabel.width = 190;
			_infoNameLabel.height = 20;
			var text : String = INFO_TEMPLATE;
			text = text.replace(/@NameColor@/gi, PotentialColorUtils.getColorOfStr(51));
			text = text.replace(/@Name@/gi, "大海明月");
			// text = text.replace(/@LevelColor@/gi, "#090927");
			// text = text.replace(/@Level@/gi, 51);
			_infoNameLabel.htmlText = text;
			_infoNameLabel.x = 120;
			_infoNameLabel.y = (_base.height - _infoNameLabel.textHeight) / 2;
			_infoNameLabel.mouseEnabled = false;
			addChild(_infoNameLabel);

			// 提示Label
			_promptLabel = LabelUtils.createPrompt1();
			_promptLabel.filters = null;
			_promptLabel.textColor = 0x279F15;
			_promptLabel.text = "已加你为好友";
			_promptLabel.x = 250;
			_promptLabel.y = (_base.height - _promptLabel.textHeight) / 2;
			_promptLabel.mouseEnabled = false;
			addChild(_promptLabel);

			// 删除按钮
			var buttonData : GButtonData = new GButtonData();
			buttonData = new KTButtonData(2);
			// buttonData.upAsset = new AssetData("DeleteButtonSkin2_Up");
			// buttonData.overAsset = new AssetData("DeleteButtonSkin2_Over");
			// buttonData.downAsset = new AssetData("DeleteButtonSkin2_Down");
			buttonData.width = 50;
			buttonData.height = 22;
			buttonData.labelData.text = "忽略";
			deleteButton = new GButton(buttonData);
			deleteButton.x = _base.width - buttonData.width - 3;
			deleteButton.y = (_base.height - deleteButton.height) / 2;
			addChild(deleteButton);

			// 添加知已按钮
			buttonData = new GButtonData();
			buttonData = new KTButtonData(2);
			buttonData.width = 50;
			buttonData.height = 22;
			buttonData.labelData.text = "同意";
			addButton = new GButton(buttonData);
			addButton.x = deleteButton.x - buttonData.width - 3;
			addButton.y = (_base.height - addButton.height) / 2;
			addChild(addButton);
		}

		/** 初始化事件（添加事件监听） */
		private function initEvents() : void
		{
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private function removedFromStageHandler(event : Event) : void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			delete this;
		}

		private function mouseOverHandler(event : MouseEvent) : void
		{
			_bg.alpha = 0.8;
		}

		private function mouseOutHandler(event : MouseEvent) : void
		{
			_bg.alpha = 0.5;
		}

		override public function set source(value : *) : void
		{
			super.source = value;
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
				_headPhoto.url = UrlUtils.getHeroHeadPhotoByJobAndSex(vo.job, vo.isMale);
				var text : String = INFO_TEMPLATE;
				text = text.replace(/@NameColor@/gi, StringUtils.colorToString(PotentialColorUtils.colorDic[vo.colorPropertyValue]));
				text = text.replace(/@Name@/gi, vo.name);
				// text = text.replace(/@LevelColor@/gi, "#FFFFFF");
				// text = text.replace(/@Level@/gi, vo.level);
				_infoNameLabel.htmlText = text;
				_infoLevelLabel.text = String(vo.level);
			}
		}

		private function updateSexIcon() : void
		{
			if (vo.isMale)
			{
				_sexIco = UIManager.getUI(new AssetData("Man_Icon"));
			}
			else
			{
				_sexIco = UIManager.getUI(new AssetData("Women_Icon"));
			}
			_sexIco.x = 100;
			_sexIco.y = (_base.height - _sexIco.height) / 2 + 2;
			addChild(_sexIco);
		}

		public function updateItemBg(bgBoolean : Boolean) : void
		{
			if (bgBoolean)
			{
				itemBg.bitmapData = RESManager.getBitmapData(new AssetData("Friend_Apply_View_List_Light_Bg"));
			}
			else
			{
				itemBg.bitmapData = RESManager.getBitmapData(new AssetData("Friend_Apply_View_List_Dark_Bg"));
			}
			// if (bgBoolean)
			// itemBg = UIManager.getUI(new AssetData("Friend_Apply_View_List_Light_Bg"));
			// else
			// itemBg = UIManager.getUI(new AssetData("Friend_Apply_View_List_Dark_Bg"));
			// RESManager.getBitmapData(asset)
			// itemBg.x = 0;
			// itemBg.y = 0;
			// itemBg.width = 474;
			// itemBg.height = 50;
			// addChildAt(itemBg, 0);
		}
	}
}
