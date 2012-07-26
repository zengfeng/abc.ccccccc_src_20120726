package game.module.friend.view
{
	import game.core.user.UserData;
	import game.manager.ViewManager;
	import game.module.friend.ControllerFriendView;
	import game.module.friend.ModelFriend;

	import gameui.containers.GViewStack;
	import gameui.controls.GButton;
	import gameui.controls.GToggleButton;
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.data.GToggleButtonData;
	import gameui.data.GToolTipData;
	import gameui.group.GToggleGroup;
	import gameui.manager.UIManager;

	import model.SingleSelectionModel;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.PhotoItem;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.LabelUtils;
	import com.utils.PotentialColorUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;

	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-2  8:39:08 
	 * 好友主视图
	 */
	public final class FriendView extends GCommonWindow
	{
		public static const NAME : String = "FriendView";

		/** 用户数据信息 */
		private function get userData() : UserData
		{
			return UserData.instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 添加知已按钮 */
		public var searchFriendButton : GButton;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 自己信息区块 */
		// private var _selfInfoBox : Sprite;
		/** 自己信息区块 -- 头像 */
		public var selfHeadPhoto : PhotoItem;
		/** 自己信息区块 -- 名称 */
		public var selfPlayerNameLabel : TextField;
		/** 自己信息区块 -- 知己数量 */
		public var selfFriendNumLabel : TextField;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** Tab按钮栏区块 */
		private var _tabBarBox : Sprite;
		/** Tab按钮栏区块 -- 知己按钮 */
		public var firendTabButton : GToggleButton;
		/** Tab按钮栏区块 -- 最近联系人按钮 */
		private var _lastLinkTabButton : GToggleButton;
		/** Tab按钮栏区块 -- 黑名单按钮 */
		private var _blacklistTabButton : GToggleButton;
		/** Tab按钮栏组 */
		private var _tabGroup : GToggleGroup;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** viewStack区块 */
		private var _viewStack : GViewStack;
		/** viewStack区块 -- 知己面板 */
		private var _friendPanel : FriendPanel;
		/** viewStack区块 -- 最近联系人按钮 */
		private var _lastLinkPanel : LastlinkPanel;
		/** viewStack区块 -- 黑名单按钮 */
		private var _blacklistPanel : BlacklistPanel;
		/** 控制器 */
		public var controllerFriendView : ControllerFriendView;

		public function FriendView()
		{
			this.name = NAME;
			_data = new GTitleWindowData();
			_data.width = 210;
			_data.height = 415;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;
			initData();
			super(_data);
			// _data.align = new GAlign();
			// _data.align.top = 50;
			// _data.align.right = 50;
			initEvents();

			controllerFriendView = new ControllerFriendView(this);
		}

		private var _defaultPostion : Point;

		/** 默认位置 */
		public function get defaultPostion() : Point
		{
			if (_defaultPostion) return _defaultPostion;
			if (ViewManager.instance.uiContainer.stage == null) return null;
			_defaultPostion = new Point();
			_defaultPostion.x = ViewManager.instance.uiContainer.stage.stageWidth - this.width - 50;
			_defaultPostion.y = 60;
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
			title = "知己";
			// this.x = ViewManager.instance.uiContainer.stage.stageWidth - _base.width - 30;
			// this.y = (ViewManager.instance.uiContainer.stage.height - _base.height) / 2;

			/* --------- 自己信息区块 --------- */
			// _selfInfoBox = new Sprite();
			// _selfInfoBox.x = 5;
			// _selfInfoBox.y = 0;
			// 自己信息区块 -- 背景
			var imageBg : Sprite = UIManager.getUI(new AssetData("Friend_View_HeroPic_Bg"));
			imageBg.x = 5;
			imageBg.y = 0;
			imageBg.width = 184;
			imageBg.height = 54;
			addChild(imageBg);
			// 自己信息区块 -- 头像
			selfHeadPhoto = new PhotoItem(65, 50);
			selfHeadPhoto.x = 5;
			selfHeadPhoto.y = 2;
			addChild(selfHeadPhoto);
			// 自己信息区块 -- 名称
			selfPlayerNameLabel = LabelUtils.createH2();
			selfPlayerNameLabel.text = userData.playerName;
			if (userData.myHero) selfPlayerNameLabel.textColor = PotentialColorUtils.getColor(userData.myHero.potential);
			selfPlayerNameLabel.x = selfHeadPhoto.width + 20;
			selfPlayerNameLabel.y = 5;
			selfPlayerNameLabel.mouseEnabled = false;
			addChild(selfPlayerNameLabel);
			// 自己信息区块 -- 知己数量
			selfFriendNumLabel = LabelUtils.createPrompt1();
			selfFriendNumLabel.text = "好友: 0/30";
			selfFriendNumLabel.x = selfHeadPhoto.width + 20;
			selfFriendNumLabel.y = selfPlayerNameLabel.y + selfPlayerNameLabel.textHeight + 3;
			selfFriendNumLabel.mouseEnabled = true;
			selfFriendNumLabel.selectable = false;
			addChild(selfFriendNumLabel);

			// 添加知已按钮
			var buttonData : GButtonData = new GButtonData();
			buttonData.labelData.text = "添加好友";
			searchFriendButton = new GButton(buttonData);
			searchFriendButton.width = 80;
			searchFriendButton.height = 30;
			searchFriendButton.x = (this.width - searchFriendButton.width) / 2;
			searchFriendButton.y = this.height - searchFriendButton.height - 5;
			addChild(searchFriendButton);

			/* --------- Tab按钮栏区块 --------- */
			_tabBarBox = new Sprite();
			_tabBarBox.x = 5;
			_tabBarBox.y = imageBg.y + imageBg.height + 2;
			var gap : int = 0;
			var toggleButtonData : GToggleButtonData = new GToggleButtonData();
			toggleButtonData.width = 65;
			toggleButtonData.height = 28;
			// Tab按钮栏区块 -- 知己按钮
			toggleButtonData.upAsset = new AssetData("Friend_View_Tab_Icon_1_Up");
			toggleButtonData.overAsset = new AssetData("Friend_View_Tab_Icon_1_Over");
			toggleButtonData.downAsset = new AssetData("Friend_View_Tab_Icon_1_Over");
			toggleButtonData.selectedUpAsset = new AssetData("Friend_View_Tab_Icon_1_Up_Select");
			toggleButtonData.selectedOverAsset = new AssetData("Friend_View_Tab_Icon_1_Over_Select");
			toggleButtonData.selectedDownAsset = new AssetData("Friend_View_Tab_Icon_1_Over_Select");
			toggleButtonData.labelData.align = new GAlign();
			toggleButtonData.labelData.align.left = 27;
			toggleButtonData.labelData.align.verticalCenter = 0;
			// toggleButtonData.labelData.text = "0";
			toggleButtonData.toolTipData = new GToolTipData;
			firendTabButton = new GToggleButton(toggleButtonData);
			firendTabButton.toolTip.source = "知己";
			_tabBarBox.addChild(firendTabButton);
			// Tab按钮栏区块 -- 最近联系人按钮
			toggleButtonData.upAsset = new AssetData("Friend_View_Tab_Icon_2_Up");
			toggleButtonData.overAsset = new AssetData("Friend_View_Tab_Icon_2_Over");
			toggleButtonData.downAsset = new AssetData("Friend_View_Tab_Icon_2_Over");
			toggleButtonData.selectedUpAsset = new AssetData("Friend_View_Tab_Icon_2_Up_Select");
			toggleButtonData.selectedOverAsset = new AssetData("Friend_View_Tab_Icon_2_Over_Select");
			toggleButtonData.selectedDownAsset = new AssetData("Friend_View_Tab_Icon_2_Over_Select");
			toggleButtonData.labelData.text = "";
			_lastLinkTabButton = new GToggleButton(toggleButtonData);
			_lastLinkTabButton.x = firendTabButton.width + gap;
			_lastLinkTabButton.toolTip.source = "最近联系人";
			_tabBarBox.addChild(_lastLinkTabButton);
			// Tab按钮栏区块 -- 黑名单按钮
			toggleButtonData.upAsset = new AssetData("Friend_View_Tab_Icon_3_Up");
			toggleButtonData.overAsset = new AssetData("Friend_View_Tab_Icon_3_Over");
			toggleButtonData.downAsset = new AssetData("Friend_View_Tab_Icon_3_Over");
			toggleButtonData.selectedUpAsset = new AssetData("Friend_View_Tab_Icon_3_Up_Select");
			toggleButtonData.selectedOverAsset = new AssetData("Friend_View_Tab_Icon_3_Over_Select");
			toggleButtonData.selectedDownAsset = new AssetData("Friend_View_Tab_Icon_3_Over_Select");
			toggleButtonData.labelData.text = "";
			_blacklistTabButton = new GToggleButton(toggleButtonData);
			_blacklistTabButton.x = _lastLinkTabButton.x + _lastLinkTabButton.width + gap;
			_blacklistTabButton.toolTip.source = "黑名单";
			_tabBarBox.addChild(_blacklistTabButton);
			// Tab按钮栏组
			_tabGroup = new GToggleGroup();
			firendTabButton.group = _tabGroup;
			_lastLinkTabButton.group = _tabGroup;
			_blacklistTabButton.group = _tabGroup;
			_tabGroup.selectionModel.index = 0;
			addChild(_tabBarBox);

			/* --------- viewStack区块 --------- */
			// 背景 Layer1
			var bodyBg1 : DisplayObject = UIManager.getUI(new AssetData("common_background_02"));
			bodyBg1.x = 5;
			bodyBg1.y = _tabBarBox.y + firendTabButton.height - 6;
			bodyBg1.width = _base.width - bodyBg1.x * 2 - 5;
			bodyBg1.height = searchFriendButton.y - bodyBg1.y - 5;
			addChildAt(bodyBg1, 2);
			//			//  背景 Layer2
			// var bodyBg2 : DisplayObject = UIManager.getUI(new AssetData("Friend_View_Bg_1"));
			// bodyBg2.x = bodyBg1.x + 2;
			// bodyBg2.y = bodyBg1.y + 25;
			// bodyBg2.width = bodyBg1.width - 4;
			// bodyBg2.height = bodyBg1.height - 27;
			// addChild(bodyBg2);

			// ----------- //
			var componentData : GComponentData = new GComponentData();
			componentData.x = bodyBg1.x;
			componentData.y = bodyBg1.y;
			componentData.width = bodyBg1.width;
			componentData.height = bodyBg1.height;
			// viewStack区块
			_viewStack = new GViewStack(componentData);

			// viewStack区块 -- 知己面板
			componentData = componentData.clone();
			componentData.x = 0;
			componentData.y = 0;
			_friendPanel = new FriendPanel(componentData);
			_viewStack.add(_friendPanel);

			// viewStack区块 -- 最近联系人面板
			var panelData : GPanelData = new GPanelData();
			panelData.bgAsset = new AssetData("Friend_View_Bg_1");
			panelData.x = 4;
			panelData.y = 25;
			panelData.width = componentData.width - panelData.x * 2;
			panelData.height = componentData.height - panelData.y - 4;
			panelData.verticalScrollPolicy = GPanelData.ON;
			_lastLinkPanel = new LastlinkPanel(panelData);
			_viewStack.add(_lastLinkPanel);

			// viewStack区块 -- 黑名单面板
			_blacklistPanel = new BlacklistPanel(panelData);
			_viewStack.add(_blacklistPanel);
			_viewStack.selectionModel.index = _tabGroup.selectionModel.index;
			addChild(_viewStack);
		}

		/** 初始化事件（添加事件监听） */
		private function initEvents() : void
		{
			// tab按钮选择事件
			_tabGroup.selectionModel.addEventListener(Event.CHANGE, tabGroup_changeHandler);
		}

		/** tab按钮选择事件 */
		private function tabGroup_changeHandler(event : Event) : void
		{
			_viewStack.selectionModel.index = (event.currentTarget as SingleSelectionModel).index;
		}

		/** 最近联系人更新 */
		public function lastlinkPanel_update() : void
		{
			_lastLinkPanel.updateItems();
		}

		/** 最近黑名单更新 */
		public function blacklistPanel_update() : void
		{
			_blacklistPanel.updateItems();
		}

		override public function show() : void
		{
			moveToDefaultPostion();

			ToolTipManager.instance.registerToolTip(selfFriendNumLabel, ToolTip, provideToolTip);

			super.show();
		}

		override public function hide() : void
		{
			ToolTipManager.instance.destroyToolTip(selfFriendNumLabel);

			super.hide();
		}

		private function provideToolTip() : String
		{
			return "可加好友上限为" + String(ModelFriend.instance.friendMax) + "位";
		}
	}
}
import game.module.friend.ModelFriend;
import game.module.friend.VoFriendItem;
import game.module.friend.view.FriendItem;

import gameui.cell.GCellData;
import gameui.containers.GPanel;
import gameui.data.GPanelData;

/** 最近联系面板 */
class LastlinkPanel extends GPanel
{
	public var paddingTop : uint = 30;
	public var paddingBottom : uint = 10;
	public var paddingLeft : uint = 10;
	public var paddingRight : uint = 10;

	public function LastlinkPanel(data : GPanelData)
	{
		super(data);
		updateItems();
	}

	public function updateItems() : void
	{
		scrollRecordPostion();
		this.clearContent();
		var item : FriendItem;
		var cellData : GCellData = new GCellData();
		cellData.x = 0;
		cellData.width = _data.width - 10;
		var postionY : uint = 0;
		var friendListData : Vector.<VoFriendItem> = ModelFriend.instance.lastLinkData;
		for (var i : int = 0; i < friendListData.length ; i++)
		{
			cellData.index = i;
			cellData.y = postionY;
			item = new FriendItem(cellData);
			item.source = friendListData[i];
			this.add(item);
			postionY += item.height;
		}
		scrollPostionSetRecordPostion();
	}

	/** 滚动条,录制的位置 */
	private var _scrollRecordPostion : Number = 0;

	/** 滚动条,录制位置 */
	public function scrollRecordPostion() : void
	{
		_scrollRecordPostion = v_sb.value;
	}

	/** 滚动条,移到录制的位置 */
	public function scrollPostionSetRecordPostion() : void
	{
		v_sb.resetValue(v_sb.pageSize, 0, v_sb.max, _scrollRecordPostion);
	}
}
/** 黑名单面板 */
class BlacklistPanel extends GPanel
{
	public function BlacklistPanel(data : GPanelData)
	{
		super(data);
		updateItems();
	}

	public function updateItems() : void
	{
		scrollRecordPostion();
		this.clearContent();
		var item : FriendItem;
		var cellData : GCellData = new GCellData();
		cellData.width = _data.width - 10;
		var postionY : uint = 0;
		var friendListData : Vector.<VoFriendItem> = ModelFriend.instance.backlistData;
		for (var i : int = 0; i < friendListData.length ; i++)
		{
			cellData.index = i;
			cellData.y = postionY;
			item = new FriendItem(cellData);
			item.source = friendListData[i];
			this.add(item);
			postionY += item.height;
		}
		scrollPostionSetRecordPostion();
	}

	/** 滚动条,录制的位置 */
	private var _scrollRecordPostion : Number = 0;

	/** 滚动条,录制位置 */
	public function scrollRecordPostion() : void
	{
		_scrollRecordPostion = v_sb.value;
	}

	/** 滚动条,移到录制的位置 */
	public function scrollPostionSetRecordPostion() : void
	{
		v_sb.resetValue(v_sb.pageSize, 0, v_sb.max, _scrollRecordPostion);
	}
}

