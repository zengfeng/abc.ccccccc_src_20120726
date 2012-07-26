package game.module.friend.view
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import game.module.friend.ControllerFriendPanel;
	import game.module.friend.ManagerFriend;
	import game.module.friend.ModelFriend;
	import gameui.cell.GCellData;
	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GPanelData;
	import net.AssetData;




	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-3  ����12:05:15 
	 * 知己面板
	 */
	public final class FriendPanel extends GComponent
	{
		// /** 背景 */
		// private var _bg:DisplayObject;
		/** 添加组按钮 */
		public var createGroupButton : GButton;
		/** 列表容器 */
		public var panel : GPanel;
		public var managerFriend : ManagerFriend = ManagerFriend.getInstance();
		public var modelFriend : ModelFriend = ModelFriend.instance;
		public var controllerFriendPanel : ControllerFriendPanel;
		public var cellData : GCellData;
		public var itemGap : uint = 5;
		public var items : Dictionary = new Dictionary();

		public function FriendPanel(base : GComponentData)
		{
			super(base);
			initViews();
			controllerFriendPanel = new ControllerFriendPanel(this);
		}

		protected function initViews() : void
		{
			// 添加组按钮
			// var icoData : GIconData = new GIconData();
			// icoData.asset = new AssetData("AddIco");
			var buttonData : GButtonData = new GButtonData();
			buttonData.upAsset = new AssetData("AddButtonSkin_Up");
			buttonData.overAsset = new AssetData("AddButtonSkin_Over");
			buttonData.downAsset = new AssetData("AddButtonSkin_Down");
			buttonData.rollOverColor = 0xaaaaff;
			buttonData.width = 100;
			buttonData.height = 24;
			buttonData.x = 20;
			buttonData.y = 5;
			// buttonData.labelData.iconData = icoData;
			// buttonData.labelData.autoSize = TextFieldAutoSize.LEFT;
			buttonData.labelData.align.left = 30;
			buttonData.labelData.text = "添加分组";
			createGroupButton = new GButton(buttonData);
			// 添加分组功能取消了
			// addChild(createGroupButton);
			// createGroupButton.label.icon.x = -20;

			// 列表容器
			var panelData : GPanelData = new GPanelData();
			panelData.bgAsset = new AssetData("Friend_View_Bg_1");
			panelData.x = 4;
			panelData.y = 25;
			panelData.verticalScrollPolicy = GPanelData.ON;
			panelData.width = _base.width - panelData.x * 2;
			panelData.height = _base.height - panelData.y - 4;
			panel = new GPanel(panelData);
			addChild(panel);
			// 列表选项视图数据
			cellData = new GCellData();
			cellData.x = 0;
			cellData.width = panelData.width - 10;
			cellData.height = 20;
		}

		/** 列表布局更新 */
		public function updateListLayout() : void
		{
			var postionY : uint = 0;
			for (var i : int = 0; i < panel.content.numChildren; i++)
			{
				var item : DisplayObject = panel.content.getChildAt(i);
				if (item.height > 0)
				{
					item.y = postionY;
					postionY += item.height + itemGap;
				}
			}

			panel.reset();
		}

		/** 滚动条,移到最底下 */
		public function scrollPostionSetMax() : void
		{
			panel.reset();
			panel.v_sb.resetValue(panel.v_sb.pageSize, 0, panel.v_sb.max, panel.v_sb.max);
		}

		/** 滚动条,录制的位置 */
		private var _scrollRecordPostion : Number = 0;

		/** 滚动条,录制位置 */
		public function scrollRecordPostion() : void
		{
			_scrollRecordPostion = panel.v_sb.value;
		}

		/** 滚动条,移到录制的位置 */
		public function scrollPostionSetRecordPostion() : void
		{
			panel.v_sb.resetValue(panel.v_sb.pageSize, 0, panel.v_sb.max, _scrollRecordPostion);
		}
	}
}

