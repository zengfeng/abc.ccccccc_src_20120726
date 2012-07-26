package game.module.chat.view
{
	import game.manager.ViewManager;

	import worlds.apis.MMouse;

	import com.utils.DrawUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	import game.module.chat.ControllerChat;
	import game.module.chat.EventChat;
	import game.module.chat.ManagerChat;
	import game.module.chat.VoChannel;
	import game.module.chat.VoChatMsg;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-14  ����9:57:48 
	 */
	public class BoxOutput extends GComponent
	{
		/** Tab按钮栏 */
		public var tabBar : TabBar;
		/** 频道消息组 */
		public var msgTextFlowGroup : MsgTextFlowGroup;
		/** 工具栏 */
		public var toolBar : ToolBar;
		protected var toolBarPaddingRight : int = 2;
		public var bg : Sprite;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 控制器 */
		public var controller : ControllerChat = ManagerChat.instance.controllerChat as ControllerChat;

		public function BoxOutput()
		{
			_base = new GComponentData();
			super(_base);
			// 设置控制器元件
			setController();
			initEvents();
		}

		/** 设置控制器元件 */
		private function setController() : void
		{
		}

		/** 初始化视图 */
		override protected function create() : void
		{
			// 背景
			bg = UIManager.getUI(new AssetData("common_background_12"));
			bg.mouseEnabled = false;
			bg.mouseChildren = false;
			bg.alpha = 0;
			addChild(bg);
			// Tab按钮栏
			tabBar = new TabBar();
			addChild(tabBar);
			// 频道消息组
			msgTextFlowGroup = new MsgTextFlowGroup();
			msgTextFlowGroup.x = 0;
			msgTextFlowGroup.y = 0;
			addChild(msgTextFlowGroup);
			// 工具栏
			toolBar = new ToolBar();
			addChild(toolBar);
		}

		/** 布局 */
		override protected function layout() : void
		{
			// 背景
			bg.width = this.width;
			bg.height = this.height;
			// Tab按钮栏
			tabBar.x = 0;
			tabBar.y = this.height - tabBar.height;
			// 频道消息组
			msgTextFlowGroup.setSize(this.width, this.height - tabBar.height);
			// 工具栏
			toolBar.x = this.width - toolBar.width - toolBarPaddingRight;
			toolBar.y = this.height - toolBar.height - 4;
		}

		private var _bgVisible : Boolean = false;

		public function get bgVisible() : Boolean
		{
			return _bgVisible;
		}

		public function set bgVisible(value : Boolean) : void
		{
			if (_bgVisible == value) return;
			_bgVisible = value;
			bg.alpha = value == true ? 1 : 0;
			for (var i : int = 0; i < msgTextFlowGroup.items.length; i++)
			{
				msgTextFlowGroup.items[i].vScrollBar.visible = value;
			}
		}

		/** 添加事件监听 */
		protected function initEvents() : void
		{
			// 频道改变事件
			tabBar.addEventListener(EventChat.CHANNEL_CHANGE, channelChangeHandler);
			this.addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}

		private function mouseClickHandler(event : MouseEvent) : void
		{
			if (ManagerChat.showTiping == true)
			{
				if (getTimer() - MsgTextFlow.linkClickTime > 500) ManagerChat.showTiping = false;
				return;
			}

			if ((event.target == this || (event.target as DisplayObject).parent is MsgTextFlow ) && getTimer() - MsgTextFlow.linkClickTime > 1000)
			{
				if (ViewManager.chat.parent == ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER))
				{
					MMouse.clickEvent();
				}
			}
		}

		/** 频道改变事件 */
		private function channelChangeHandler(event : EventChat) : void
		{
			msgTextFlowGroup.selectedVo = event.voChannel;
		}

		/** 添加消息 */
		public function appendMsg(voMsg : VoChatMsg) : void
		{
			msgTextFlowGroup.appendMsg(voMsg);
		}

		/** 选择频道 */
		public function set selectedChannel(voChannel : VoChannel) : void
		{
			msgTextFlowGroup.selectedVo = voChannel;
		}
	}
}
import flash.utils.Dictionary;

import game.module.chat.VoChannel;
import game.module.chat.VoChatMsg;
import game.module.chat.config.ChannelId;
import game.module.chat.config.ChatConfig;
import game.module.chat.view.MsgTextFlow;

import gameui.core.GComponent;
import gameui.core.GComponentData;

class MsgTextFlowGroup extends GComponent
{
	public var items : Vector.<MsgTextFlow> = new Vector.<MsgTextFlow>();
	public var itemDic : Dictionary = new Dictionary();
	private var _selectedVo : VoChannel;
	private var _selectedItem : MsgTextFlow;

	function MsgTextFlowGroup() : void
	{
		_base = new GComponentData();
		super(_base);
	}

	/** 初始化视图 */
	override protected function create() : void
	{
		var vo : VoChannel;
		var item : MsgTextFlow;
		var channelId : int;
		for (var i : uint = 0; i < ChatConfig.outputChannels.length; i++)
		{
			channelId = ChatConfig.outputChannels[i];
			vo = ChatConfig.channelVoDic[channelId];
			item = new MsgTextFlow();
			item.channelId = vo.id;
			itemDic[vo.id] = item;
			items.push(item);
		}
		selectedVo = ChatConfig.defaultOutputChannel;
	}

	/** 布局 */
	override protected function layout() : void
	{
		if (_selectedItem) _selectedItem.setSize(this.width, this.height);
	}

	/** 添加消息 */
	public function appendMsg(voMsg : VoChatMsg) : void
	{
		if (voMsg.channelId == ChannelId.PROMPT || voMsg.channelId == ChannelId.SYSTEM_NOTIC)
		{
			selectedItem.appendMsg(voMsg);
			return;
		}

		var item : MsgTextFlow;
		for (var i : int = 0; i < items.length; i++)
		{
			item = items[i];
			item.appendMsg(voMsg);
		}
	}

	// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
	public function get selectedItem() : MsgTextFlow
	{
		return _selectedItem;
	}

	public function get selectedVo() : VoChannel
	{
		return _selectedVo;
	}

	public function set selectedVo(vo : VoChannel) : void
	{
		if (_selectedVo == vo) return;
		_selectedVo = vo;
		if (selectedItem) selectedItem.parent.removeChild(selectedItem);
		_selectedItem = itemDic[_selectedVo.id];
		_selectedItem.setSize(this.width, this.height);
		addChildAt(_selectedItem, 0);
	}
}