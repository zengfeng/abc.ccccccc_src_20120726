package game.module.friend
{
	import game.manager.MouseManager;
	import game.manager.ViewManager;
	import game.module.friend.view.FriendCreateGroupView;
	import game.module.friend.view.FriendGroup;
	import game.module.friend.view.FriendItem;
	import game.module.friend.view.FriendPanel;

	import gameui.cell.GCellData;
	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GScrollBar;

	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;

	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;




	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-9  ����8:40:14 
	 */
	public class ControllerFriendPanel extends EventDispatcher
	{
		public var groups : Vector.<FriendGroup> = new Vector.<FriendGroup>();
		public var groupDic : Dictionary = new Dictionary();
		public var view : FriendPanel;
		public var panel : GPanel;
		public var content : DisplayObjectContainer;
		public var vScrollBar : GScrollBar;
		public var createGroupButton : GButton;
		public var cellData : GCellData;
		public var itemGap : uint = 5;
		public var managerFriend : ManagerFriend = ManagerFriend.getInstance();
		public var modelFriend : ModelFriend = ModelFriend.instance;

		public function ControllerFriendPanel(view : FriendPanel)
		{
			this.view = view;
			super(view);
			initView();
			initEvents();
		}

		/** 初始化视图 */
		private function initView() : void
		{
			panel = view.panel;
			content = view.panel.content;
			vScrollBar = view.panel.v_sb;
			createGroupButton = view.createGroupButton;
			cellData = view.cellData;
			itemGap = view.itemGap;
			// 更新列表
			updateList();
		}

		/** 更新列表 */
		public function updateList() : void
		{
			panel.clearContent();
			var friendListData : Vector.<VoFriendGroup> = modelFriend.friendListData;
			if (friendListData.length == 0) return;
			groupDic = new Dictionary();
			groups = new Vector.<FriendGroup>();
			var item : FriendGroup;
			var cellData : GCellData = cellData.clone();
			var postionY : uint = 0;
			for (var i : int = 0; i < friendListData.length ; i++)
			{
				cellData.index = i;
				cellData.y = postionY;
				item = new FriendGroup(cellData);
				item.source = friendListData[i];
				panel.add(item);
				groupDic[item.vo.id] = item;
				groups.push(item);
				postionY += item.height + itemGap;
			}

			// 只给组名添加tooltip
			ToolTipManager.instance.registerToolTip(groups[0].switchButton_forToolTip, ToolTip, "已相互添加为好友");
			ToolTipManager.instance.registerToolTip(groups[1].switchButton_forToolTip, ToolTip, "对方未添加我为好友");
		}

		/** 更新组列表 */
		public function updateGroupList(group : FriendGroup) : void
		{
			if (group == null) return;
			// 滚动条,录制位置
			view.scrollRecordPostion();
			// 更新显示
			group.updateView();
			if (group.isSelected)
			{
				group.isSelected = true;
			}
			// 列表布局更新
			view.updateListLayout();
			// 滚动条,移到录制的位置
			view.scrollPostionSetRecordPostion();
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 初始化事件（添加事件监听） */
		private function initEvents() : void
		{
			view.addEventListener(EventFriend.FRIEND_ITEM_START_DRAG, friendItemStartDragHandler);
			// 创建组按钮点击事件
			createGroupButton.addEventListener(MouseEvent.CLICK, createGroupButton_clickHandler);
			view.addEventListener(EventFriend.HEIGHT_CHANGE, heightChangeHandler);

			// 数据模型 -- 好友列表加载完成事件
			modelFriend.addEventListener(EventFriend.FRIEND_LIST_DATA_LOAD_COMPLETED, modelFriend_friendListLoadCompleted);
		}

		/** 初始数据模型事件 */
		private function initModelEvents() : void
		{
			// 数据模型 -- 添加组事件
			modelFriend.addEventListener(EventFriend.ADD_GROUP, modelFriend_addGroupHandler);
			// 数据模型 -- 删除组事件
			modelFriend.addEventListener(EventFriend.REMOVE_GROUP, modelFriend_removeGroupHandler);
			// 数据模型 -- 组重命名事件
			modelFriend.addEventListener(EventFriend.GROUP_RENAME, modelFriend_groupRenameHandler);

			// 数据模型 -- 添加好友
			modelFriend.addEventListener(EventFriend.ADD_FRIEND, modelFriend_addFriendHandler);
			// 数据模型 -- 删除好友
			modelFriend.addEventListener(EventFriend.Remove_FRIEND, modelFriend_removeFriendHandler);
			// 数据模型 -- 好友数据更新
			modelFriend.addEventListener(EventFriend.UPDATE_FRIEND, modelFriend_updateFriendHandler);

			// 数据模型 -- 组移除好友
			modelFriend.addEventListener(EventFriend.GROUP_REMOVE_FRIEND, modelFriend_groupRemoveFriendHandler);
			// 数据模型 -- 组加入好友
			modelFriend.addEventListener(EventFriend.GROUP_ADD_FRIEND, modelFriend_groupAddFriendHandler);
			modelFriend.addEventListener(EventFriend.ONLINE_FRIEND_COUNT_CHANGE, refreshOnline);

		}

		/** 数据模型 -- 好友数据更新 */
		private function modelFriend_updateFriendHandler(event : EventFriend) : void
		{
			var voFriendItem : VoFriendItem = event.voFriendItem;
			if (voFriendItem.group == null) return;
			var group : FriendGroup = groupDic[voFriendItem.groupId] as FriendGroup;
			if (group.isSelected)
			{
				group.updateItems();
			}
		}

		/** 数据模型 -- 添加组事件 */
		private function modelFriend_friendListLoadCompleted(event : EventFriend) : void
		{
			updateList();
			initModelEvents();
		}

		/** 数据模型 -- 组加入好友 */
		private function modelFriend_groupAddFriendHandler(event : EventFriend) : void
		{
			var voFriendGroup : VoFriendGroup = event.voFriendGroup;
			var group : FriendGroup = groupDic[voFriendGroup.id] as FriendGroup;
			updateGroupList(group);
		}

		/** 数据模型 -- 组移除好友 */
		private function modelFriend_groupRemoveFriendHandler(event : EventFriend) : void
		{
			var voFriendGroup : VoFriendGroup = event.voFriendGroup;
			var group : FriendGroup = groupDic[voFriendGroup.id] as FriendGroup;
			updateGroupList(group);
		}

		/** 数据模型 -- 删除好友 */
		private function modelFriend_removeFriendHandler(event : EventFriend) : void
		{
			var voFriendGroup : VoFriendGroup = event.voFriendGroup;
			var group : FriendGroup = groupDic[voFriendGroup.id] as FriendGroup;
			updateGroupList(group);
		}

		/** 数据模型 -- 添加好友 */
		private function modelFriend_addFriendHandler(event : EventFriend) : void
		{
			var voFriendGroup : VoFriendGroup = event.voFriendGroup;
			var group : FriendGroup = groupDic[voFriendGroup.id] as FriendGroup;
			updateGroupList(group);
		}

		/** 数据模型 -- 组重命名事件 */
		private function modelFriend_groupRenameHandler(event : EventFriend) : void
		{
			var voFriendGroup : VoFriendGroup = event.voFriendGroup;
			var group : FriendGroup = groupDic[voFriendGroup.id] as FriendGroup;
			group.source = group.source;
		}

		/** 数据模型 -- 删除组事件 */
		private function modelFriend_removeGroupHandler(event : EventFriend) : void
		{
			var voFriendGroup : VoFriendGroup = event.voFriendGroup;
			var group : FriendGroup = groupDic[voFriendGroup.id] as FriendGroup;
			if (group)
			{
				// 滚动条,录制位置
				view.scrollRecordPostion();
				panel.content.removeChild(group);
				// 如果默认组开了就重设置数据
				group = groupDic[modelFriend.DEFAULT_GROUP_ID_1] as FriendGroup;
				group.source = modelFriend.friendGroupDic[modelFriend.DEFAULT_GROUP_ID_1];

				if (group.isSelected)
				{
					group.isSelected = true;
				}
				// 列表布局更新
				view.updateListLayout();
				// 滚动条,移到录制的位置
				view.scrollPostionSetRecordPostion();
			}
		}

		/** 数据模型 -- 添加组事件 */
		private function modelFriend_addGroupHandler(event : EventFriend) : void
		{
			var voFriendGroup : VoFriendGroup = event.voFriendGroup;
			var group : FriendGroup;

			var cellData : GCellData = cellData.clone();
			if (content.numChildren > 0)
			{
				group = content.getChildAt((content.numChildren - 1)) as FriendGroup;
				cellData.y = group.y + group.height + itemGap;
			}

			group = new FriendGroup(cellData);
			group.source = voFriendGroup;
			panel.add(group);
			groupDic[group.vo.id] = group;
			groups.push(group);
			// 滚动条,移到最底下
			view.scrollPostionSetMax();
		}
		
		private function refreshOnline(evt:EventFriend):void
		{
			for each( var group:FriendGroup in groups )
			{
				group.refreshOnline();
			}
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 创建组按钮事件 */
		private function createGroupButton_clickHandler(event : MouseEvent) : void
		{
			if (modelFriend.friendListData.length > modelFriend.groupMax)
			{
				// ViewManager.showAlert("最多只能创建" + modelFriend.groupMax + "个组");
				return;
			}

			var friendCreateGroupView : FriendCreateGroupView = ViewManager.instance.uiContainer.getChildByName(FriendCreateGroupView.NAME) as FriendCreateGroupView;
			if (friendCreateGroupView == null)
			{
				friendCreateGroupView = new FriendCreateGroupView();
			}

			if (friendCreateGroupView.parent)
			{
				friendCreateGroupView.hide();
			}
			else
			{
				friendCreateGroupView.show();
			}
		}

		/** 高度改变事件 */
		private function heightChangeHandler(event : EventFriend) : void
		{
			view.updateListLayout();
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var _startDragItem : FriendItem;
		private var _dragItemOfClone : FriendItem;
		private var _startDragIsSelectedGroup : Vector.<FriendGroup>;
		private var _groupRectangles : Vector.<Rectangle>;

		private function friendItemStartDragHandler(event : EventFriend) : void
		{
			// 滚动条,录制位置
			view.scrollRecordPostion();

			_startDragItem = event.friendItem;
			if (_dragItemOfClone == null)
			{
				_dragItemOfClone = new FriendItem(_startDragItem.data);
				_dragItemOfClone.name = "FriendDragItemOfClone";
			}
			_dragItemOfClone.source = _startDragItem.source;
			_dragItemOfClone.groupElement = _startDragItem.groupElement;

			var globalPostion : Point = _startDragItem.localToGlobal(new Point(0, 0));
			_dragItemOfClone.x = globalPostion.x;
			_dragItemOfClone.y = globalPostion.y;
			_startDragItem.stage.addChild(_dragItemOfClone);

			var group : FriendGroup;
			_startDragIsSelectedGroup = new Vector.<FriendGroup>();
			for (var i : int = 0; i < groups.length; i++)
			{
				group = groups[i];
				if (group.isSelected == true)
				{
					_startDragIsSelectedGroup.push(group);
				}
				group.isSelected = false;
			}

			// 拖拽范围
			_groupRectangles = new Vector.<Rectangle>();
			for (i = 0; i < groups.length; i++)
			{
				group = groups[i];

				var rectangle : Rectangle = new Rectangle();
				var point : Point = group.localToGlobal(new Point(0, 0));
				rectangle.x = point.x;
				rectangle.y = point.y;
				rectangle.width = group.width;
				rectangle.height = group.height;
				_groupRectangles.push(rectangle);
			}

			_dragItemOfClone.addEventListener(MouseEvent.MOUSE_MOVE, dragItemOfClone_mouseMoveHandler);
			_dragItemOfClone.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			_dragItemOfClone.startDrag();
		}

		private function dragItemOfClone_mouseMoveHandler(event : MouseEvent) : void
		{
			if (getMouseHitGroupRectangle() != null)
			{
				MouseManager.cursor = MouseManager.CORRECT;
			}
			else
			{
				MouseManager.cursor = MouseManager.WARNING;
			}
		}

		protected function getMouseHitGroupRectangle() : Rectangle
		{
			if (_groupRectangles == null || _groupRectangles.length <= 0) return null;
			var rectangle : Rectangle = _groupRectangles[0];
			if (_dragItemOfClone.stage.mouseX < rectangle.x || _dragItemOfClone.stage.mouseX > rectangle.x + rectangle.width)
			{
				return null;
			}

			for (var i : int = 0; i < _groupRectangles.length; i++)
			{
				rectangle = _groupRectangles[i];
				if (_dragItemOfClone.stage.mouseY > rectangle.y && _dragItemOfClone.stage.mouseY < rectangle.y + rectangle.height)
				{
					return rectangle;
					break;
				}
			}
			return null;
		}

		protected function stage_mouseUpHandler(event : MouseEvent) : void
		{
			_dragItemOfClone.removeEventListener(MouseEvent.MOUSE_MOVE, dragItemOfClone_mouseMoveHandler);
			_dragItemOfClone.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			_dragItemOfClone.stopDrag();
			MouseManager.cursor = MouseManager.ARROW;
			var group : FriendGroup;
			var histGroup : FriendGroup;
			var i : int = 0;

			var rectangle : Rectangle = getMouseHitGroupRectangle();
			if (rectangle)
			{
				var index : int = _groupRectangles.indexOf(rectangle);
				histGroup = groups[index];
			}
			else
			{
				histGroup = null;
			}
			_groupRectangles = null;

//			if (histGroup != null && histGroup != _startDragItem.groupElement)
//			{
//				// 发送协议 -- 修改好友的组别
//				ProtoCtoSFriend.instance.cs_ChgFollowGrp(histGroup.vo.id, _startDragItem.vo.id);
//			}

			for (i = 0; i < _startDragIsSelectedGroup.length; i++)
			{
				group = _startDragIsSelectedGroup[i];
				group.isSelected = true;
			}
			_dragItemOfClone.parent.removeChild(_dragItemOfClone);
			// 滚动条,移到录制的位置
			view.scrollPostionSetRecordPostion();
		}
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
	}
}
