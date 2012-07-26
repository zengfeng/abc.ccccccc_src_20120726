package game.module.chatwhisper.view
{
	import game.core.hero.HeroManager;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.manager.ViewManager;
	import game.module.chatwhisper.EventWhisper;
	import game.module.chatwhisper.config.WindowState;
	import game.module.friend.ManagerFriend;
	import game.module.friend.VoFriendItem;

	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.PhotoItem;
	import com.commUI.button.KTButtonData;
	import com.utils.LabelUtils;
	import com.utils.PotentialColorUtils;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;
	import com.utils.UrlUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����2:28:48 
	 */
	public class WhisperModuleView extends GCommonWindow
	{
		private static var _instance : WhisperModuleView;

		public static function get instance() : WhisperModuleView
		{
			if (_instance == null)
			{
				_instance = new WhisperModuleView();
			}
			return _instance;
		}

		public static const NAME : String = "WhisperModuleView";
		public static const PLAYER_INFO_TEXT_TEMP : String = "<font color ='@COLOR@' ><a href='event:player'>@NAME@</a></font>";

		// public static const PLAYER_INFO_TEXT_TEMP : String = "<font color ='@COLOR@' ><a href='event:@NAME@'>[<u>@NAME@</u>]</a></font> Lv.@LEVEL@";
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public function WhisperModuleView()
		{
			_instance = this;
			this.name = NAME;
			_data = new GTitleWindowData();
			_data.width = 495 + 5;
			_data.height = 352 + 4;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;

			initData();
			super(_data);
			initEvents();

			this.x = (ViewManager.instance.uiContainer.stage.stageWidth - this.width) / 2;
			this.y = (ViewManager.instance.uiContainer.stage.stageHeight - this.height) / 2;
		}

		public var leftPadding : uint = 8;
		public var rightPadding : uint = 8;
		public var topPadding : uint = 45;
		public var bottomPadding : uint = 12;
		public var boxPlayerListWidth : uint = 152;
		public var hGap : uint = 3;
		public var vGap : uint = 3;
		public var msgInputBoxHeight : uint = 80;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 背景 */
		public var bg : DisplayObject;
		/** 玩家列表 */
		public var playerList : PlayerList;
		/** 清空玩家列表按钮 */
		public var clearPlayersButton : GButton;
		/** 当前玩家头像 */
		public var currentPlayerHeadPhoto : PhotoItem;
		/** 当前玩家信息Label */
		public var currentPlayerLabel : TextField;
		/** 玩家等级信息 **/
		private var currentPlayerLevelLabel : TextField;
		/** 交易按钮 */
		public var tradeButton : GButton;
		/** 加为好友按钮 */
		public var addFriendButton : GButton;
		/** 删除好友按钮 */
		public var deleteFriendButton : GButton;
		/** 查看资料按钮 */
		public var lookInfoButton : GButton;
		/** 消息输出框 */
		public var msgTextOutput : MsgTextOutput;
		/** 消息输入框 */
		public var msgTextInput : MsgTextInput;
		/** 最小化窗口按钮 */
		public var minWindowButton : GButton;
		/** 当前玩家VO */
		private var _vo : VoFriendItem;

		override protected function initViews() : void
		{
			title = "私聊";

			var viewBg : Sprite = UIManager.getUI(new AssetData("common_background_02"));
			viewBg.x = 5;
			viewBg.y = 0;
			viewBg.width = 485;
			viewBg.height = 351;
			addChildAt(viewBg, 1);

			// 清空玩家列表按钮
			var buttonData : GButtonData = new GButtonData();
			// buttonData.width = leftBoxWidth;
			// buttonData.height = 25;
			buttonData.x = _width - rightPadding - boxPlayerListWidth + (boxPlayerListWidth - buttonData.width) / 2;
			buttonData.y = _data.height - bottomPadding - buttonData.height;
			buttonData.labelData.text = "全部清除";
			clearPlayersButton = new GButton(buttonData);
			// addChild(clearPlayersButton);

			// 最近联系人Bg
			var lastContactFriendBg : Sprite = UIManager.getUI(new AssetData("Whisper_View_Input_Bg"));
			lastContactFriendBg.x = _width - rightPadding - boxPlayerListWidth - 5 - 2;
			lastContactFriendBg.y = 3;
			lastContactFriendBg.width = 151 + 2;
			lastContactFriendBg.height = 340;
			addChild(lastContactFriendBg);

			// 最近联系人Label背景
			var bg_1 : Sprite = UIManager.getUI(new AssetData("Whisper_View_Dark_Bg"));
			bg_1.x = _width - rightPadding - boxPlayerListWidth - 3;
			bg_1.y = 7;
			bg_1.width = 146;
			bg_1.height = 20;
			addChild(bg_1);

			// 最近联系人Label
			var textFormat : TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.font = UIManager.defaultFont;
			textFormat.size = 12;
			textFormat.bold = true;
			textFormat.color = 0x2F1F00;
			var label : TextField = new TextField();
			label.defaultTextFormat = textFormat;
			label.width = 145;
			label.height = 20;
			label.x = _width - rightPadding - boxPlayerListWidth - 2;
			// label.y = topPadding;
			label.y = 8;
			label.text = "最近联系人";
			label.mouseEnabled = false;
			addChild(label);

			// 玩家列表
			var panelData : GPanelData = new GPanelData();
			// panelData.bgAsset = new AssetData("Whisper_View_Input_Bg");
			panelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			panelData.x = _width - rightPadding - boxPlayerListWidth - 6;
			panelData.y = 28;
			panelData.width = 151;
			panelData.height = 313;
			// panelData.width = boxPlayerListWidth;
			// panelData.height = buttonData.y - panelData.y - vGap;
			playerList = new PlayerList(panelData);
			addChild(playerList);

			// 消息输入框
			var componentData : GComponentData = new GComponentData();
			componentData.x = leftPadding + 3;
			componentData.y = this.height - msgInputBoxHeight - bottomPadding - 21;
			componentData.width = _width - boxPlayerListWidth - rightPadding - hGap - componentData.x - 6;
			componentData.height = msgInputBoxHeight;
			msgTextInput = new MsgTextInput(componentData);
			addChild(msgTextInput);

			// 当前玩家信息Box
			componentData = new GComponentData();
			componentData.x = 12;
			componentData.y = 5;
			componentData.width = _width - boxPlayerListWidth - rightPadding - hGap - componentData.x;
			componentData.height = 48;
			var currentPlayerBox : GComponent = new GComponent(componentData);
			addChild(currentPlayerBox);
			// 玩家image背景
			var ImageBg : Sprite = UIManager.getUI(new AssetData("Whisper_View_Image_Bg"));
			ImageBg.x = 0;
			ImageBg.y = 0;
			ImageBg.width = 65;
			ImageBg.height = 50;
			currentPlayerBox.addChild(ImageBg);
			// 当前玩家头像
			currentPlayerHeadPhoto = new PhotoItem(65, 50);
			currentPlayerHeadPhoto.x = 0;
			currentPlayerHeadPhoto.y = 0;
			currentPlayerBox.addChild(currentPlayerHeadPhoto);

			// 当前玩家等级
			currentPlayerLevelLabel = UICreateUtils.createTextField("", null, 50, 17, 2, 0, UIManager.getTextFormat(12, 0xffffff, TextFormatAlign.LEFT));
			currentPlayerBox.addChild(currentPlayerLevelLabel);

			var style : StyleSheet = new StyleSheet();
			style.setStyle("a:link", {textDecoration:"none"});
			style.setStyle("a:hover", {textDecoration:"underline"});

			// 当前玩家消息
			currentPlayerLabel = LabelUtils.createH2();
			currentPlayerLabel.filters = null;
			currentPlayerLabel.height = 20;
			currentPlayerLabel.x = 80;
			currentPlayerLabel.y = 3;
			currentPlayerLabel.width = 150;
			currentPlayerLabel.height = 22;
			currentPlayerLabel.htmlText = "<font color ='#FF0000' >@大海明月@</font>";
			currentPlayerLabel.selectable = false;
			currentPlayerLabel.mouseEnabled = true;
			currentPlayerLabel.styleSheet = style;
			currentPlayerBox.addChild(currentPlayerLabel);
			// 交易按钮
			buttonData = new GButtonData();
			buttonData = new KTButtonData(2);
			buttonData.labelData.text = "交易";
			buttonData.width = 50;
			buttonData.height = 22;
			buttonData.x = 72;
			buttonData.y = 28;
			tradeButton = new GButton(buttonData);
			currentPlayerBox.addChild(tradeButton);
			//
			// 当聊天对象不是自己的好友时，按钮显示 添加好友；当聊天对象是自己的好友时，按钮显示 删除好友
			//
			// 加为好友按钮
			buttonData = new GButtonData();
			buttonData = new KTButtonData(2);
			buttonData.labelData.text = "添加好友";
			buttonData.width = 65;
			buttonData.height = 22;
			buttonData.x = 127;
			buttonData.y = 28;
			addFriendButton = new GButton(buttonData);
			addFriendButton.visible = true;
			currentPlayerBox.addChild(addFriendButton);
			// 删除好友按钮
			buttonData = new GButtonData();
			buttonData = new KTButtonData(2);
			buttonData.labelData.text = "删除好友";
			buttonData.width = 65;
			buttonData.height = 22;
			buttonData.x = 127;
			buttonData.y = 28;
			deleteFriendButton = new GButton(buttonData);
			deleteFriendButton.visible = false;
			currentPlayerBox.addChild(deleteFriendButton);

			// 查看资料按钮
			buttonData = new GButtonData();
			buttonData = new KTButtonData(2);
			buttonData.labelData.text = "查看信息";
			buttonData.width = 65;
			buttonData.height = 22;
			buttonData.x = 182 + 15;
			buttonData.y = 28;
			lookInfoButton = new GButton(buttonData);
			currentPlayerBox.addChild(lookInfoButton);

			// 消息输出框背景
			var textOutBg : Sprite = UIManager.getUI(new AssetData("Whisper_View_Talk_Bg"));
			textOutBg.x = 13;
			textOutBg.y = 61;
			textOutBg.width = 316;
			textOutBg.height = 181 + 2;
			addChild(textOutBg);

			// 消息输出框
			componentData = componentData.clone();
			// componentData.x = msgTextInput.x;
			// componentData.y = currentPlayerBox.y + currentPlayerBox.height;
			// componentData.width = msgTextInput.width + 6;
			// componentData.height = msgTextInput.y - componentData.y - vGap - 2;
			componentData.x = 13 + 4;
			componentData.y = 61;
			componentData.width = 316 - 4;
			componentData.height = 181 - 1;
			msgTextOutput = new MsgTextOutput(componentData);
			addChild(msgTextOutput);
			swapChildren(msgTextOutput, msgTextInput);

			// 最小化窗口按钮
			buttonData = new GButtonData();
			buttonData.upAsset = new AssetData("MinimizeButton_Up");
			buttonData.overAsset = new AssetData("MinimizeButton_Over");
			buttonData.downAsset = new AssetData("MinimizeButton_Down");
			buttonData.width = 20;
			buttonData.height = 20;
			buttonData.x = _width - 55;
			buttonData.y = -28;
			minWindowButton = new GButton(buttonData);
			addChild(minWindowButton);
			// 设置当前玩家信息
			setCurrentPlayerInfo(null);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 初始化事件（添加事件监听） */
		private function initEvents() : void
		{
			// 点击最小化按钮
			minWindowButton.addEventListener(MouseEvent.CLICK, minWindowButton_clickHandler);
			lookInfoButton.addEventListener(MouseEvent.CLICK, lookInfo_clickHandler);
		}

		/** 设置当前玩家信息 */
		public function setCurrentPlayerInfo(voFriendItem : VoFriendItem) : void
		{
			_vo = voFriendItem;

			if (voFriendItem == null)
			{
				// 当前玩家头像
				currentPlayerHeadPhoto.photo = null;
				// 当前玩家信息Label
				currentPlayerLabel.htmlText = "";
				// 当前玩家等级
				currentPlayerLevelLabel.text = "";
				// 交易按钮
				tradeButton.enabled = false;
				// 加为好友按钮
				addFriendButton.enabled = false;
				// 删除好友按钮
				deleteFriendButton.enabled = false;
				// 查看资料按钮
				lookInfoButton.enabled = false;
				// 发送按钮
				msgTextInput.sendButton.enabled = false;
			}
			else
			{
				// 当前玩家头像
				currentPlayerHeadPhoto.url = UrlUtils.getHeroHeadPhotoByJobAndSex(voFriendItem.job, voFriendItem.isMale);

				// 当前玩家信息Label
				var str : String = PLAYER_INFO_TEXT_TEMP;
				str = str.replace(/@COLOR@/gi, StringUtils.colorToString(PotentialColorUtils.colorDic[voFriendItem.colorPropertyValue]));
				str = str.replace(/@NAME@/gi, voFriendItem.name);
				// str = str.replace(/@LEVEL@/gi, voFriendItem.level);
				if (voFriendItem.isOnline)
				{
					currentPlayerLabel.htmlText = str;
					currentPlayerLabel.textColor = PotentialColorUtils.colorDic[voFriendItem.colorPropertyValue];
				}
				else
				{
					currentPlayerLabel.htmlText = str;
					currentPlayerLabel.textColor = 0x666666;
				}

				currentPlayerLevelLabel.text = String(voFriendItem.level);
				if (MenuManager.getInstance().checkOpen(MenuType.TRADE))
				// 交易按钮
					tradeButton.enabled = true;
				else
					tradeButton.enabled = false;
				addFriendButton.enabled = true;
				deleteFriendButton.enabled = true;
				// 加为好友按钮, deleteFriendButton
				if (ManagerFriend.getInstance().isInFriendListByPlayerName(voFriendItem.name) == true)
				{
					addFriendButton.visible = false;
					deleteFriendButton.visible = true;
				}
				else
				{
					addFriendButton.visible = true;
					deleteFriendButton.visible = false;
				}
				// 查看资料按钮
				lookInfoButton.enabled = true;
				// 发送按钮
				msgTextInput.sendButton.enabled = true;
			}
		}

		/** 点击最小化按钮 */
		private function minWindowButton_clickHandler(event : MouseEvent) : void
		{
			hide();
			windowState = WindowState.WINDOW_STATE_MIN;
		}

		/** 点击查看信息按钮 */
		private function lookInfo_clickHandler(event : MouseEvent) : void
		{
			if (_vo)
				HeroManager.instance.sendViewOtherInfo(_vo.name);
		}

		override protected function onClickClose(event : MouseEvent) : void
		{
			super.onClickClose(event);
			windowState = WindowState.WINDOW_STATE_CLOSE;
		}

		override public function show() : void
		{
			super.show();
			windowState = WindowState.WINDOW_STATE_OPEN;
		}

		override public function hide() : void
		{
			super.hide();
			windowState = WindowState.WINDOW_STATE_MIN;
		}

		private var _windowState : String;

		/** 窗口状态 */
		public function get windowState() : String
		{
			return _windowState;
		}

		public function set windowState(windowState : String) : void
		{
			_windowState = windowState;
			var eventWhisper : EventWhisper = new EventWhisper(EventWhisper.WINDOW_STATE_CHANGE, true);
			dispatchEvent(eventWhisper);
		}
	}
}
