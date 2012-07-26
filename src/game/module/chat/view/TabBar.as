package game.module.chat.view
{
	import com.commUI.toggleButton.KTToggleButtonData;
	import com.utils.FilterUtils;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import game.module.chat.ChatUntils;
	import game.module.chat.EventChat;
	import game.module.chat.VoChannel;
	import game.module.chat.config.ChannelId;
	import game.module.chat.config.ChatConfig;
	import gameui.controls.GToggleButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GToggleButtonData;
	import gameui.group.GToggleGroup;
	import net.AssetData;





	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����4:37:54 
	 */
	public class TabBar extends GComponent
	{
		/** 间距 */
		protected var gap : uint = 1;
		/** 边距 */
		protected var paddingH : uint = 2;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 当前选中的频道 */
		private var _selectedVo : VoChannel;
		/** 组 */
		public var group : GToggleGroup;
		public var itemDic : Dictionary = new Dictionary();
		public var items : Vector.<GToggleButton> = new Vector.<GToggleButton>();
		protected var poupList : PoupList;

		function TabBar() : void
		{
			_base = new GComponentData();
			_base.height = 24;
			super(_base);
			initEvents();
		}

		/** 初始化视图 */
		override protected function create() : void
		{
			// 组
			group = new GToggleGroup();

			// tab按钮
			var vo : VoChannel;
			var item : GToggleButton;
			var toggleButtonData : GToggleButtonData = new KTToggleButtonData(KTToggleButtonData.NORMAL_TOGGLE_BUTTON);
			toggleButtonData.width = 45;
			toggleButtonData.height = 20;
			toggleButtonData.disabledColor = 0x666666;

			var postionX : int = paddingH;
			var i : uint;
			var channelId : int = 0;
			for (i = 0; i < ChatConfig.outputChannels.length; i++)
			{
				channelId = ChatConfig.outputChannels[i];
				vo = ChatConfig.channelVoDic[channelId];
				toggleButtonData = toggleButtonData.clone();
				// if (vo.id == ChannelId.NOTIC) toggleButtonData.width = 60;
				toggleButtonData.x = postionX;
				postionX += toggleButtonData.width + gap;
				toggleButtonData.labelData.textFieldFilters = ChatUntils.textEdgeFilter;
				toggleButtonData.labelData.textFormat.font = ChatUntils.font;
				toggleButtonData.labelData.text = vo.name.replace(/ /gi, "");
				toggleButtonData.labelData.textColor = 0x82bffa;
				toggleButtonData.textRollOverColor = 0xFFFFFF;
				item = new GToggleButton(toggleButtonData);
				item.source = vo;
				item.enabled = vo.enable;
				if (item.enabled == false) item.filters = [FilterUtils.disableFilter()];
				item.group = group;
				itemDic[vo.id] = item;
				items.push(item);
				addChild(item);
				item.addEventListener(MouseEvent.CLICK, poupListFun);
			}
			selectedVo = ChatConfig.defaultOutputChannel;
		}

		/** 子项布局 */
		protected function layoutItems() : void
		{
			var postionX : int = paddingH;
			var item : GToggleButton;
			var vo : VoChannel;
			for (var i : int = 0; i < items.length; i++)
			{
				item = items[i];
				vo = item.source;
				if (vo.id == ChannelId.WHISPER && isShowWhisper == false) continue;
				item.x = postionX;
				postionX += item.width + gap;
			}
		}

		/** 是否显示私聊 */
		private var _isShowWhisper : Boolean = true;

		/** 是否显示私聊 */
		public function set isShowWhisper(value : Boolean) : void
		{
			if (_isShowWhisper == value) return;
			_isShowWhisper = value;
			var item : GToggleButton = itemDic[ChannelId.WHISPER];
			if (item) item.visible = value;
			layoutItems();
		}

		public function get isShowWhisper() : Boolean
		{
			return _isShowWhisper;
		}

		protected function poupListFun(event : MouseEvent) : void
		{
			var item : GToggleButton = event.currentTarget as GToggleButton;
			var vo : VoChannel = item.source as VoChannel;
			if (vo.id == selectedVo.id)
			{
				// if(poupList && poupList.channelId == vo.id);
				var globalPoint : Point = item.localToGlobal(new Point(0, 0));
				if (poupList == null)
				{
					poupList = new PoupList(this.stage, globalPoint);
					poupList.channelId = vo.id;
				}
				poupList.globalPoint = globalPoint;
				poupList.channelId = vo.id;
				var channelDefaultAccpet : Array = ChatConfig.channelDefaultAccept[vo.id];
				if (channelDefaultAccpet == null || channelDefaultAccpet.length <= 3)
				{
					poupList.isOpen = false;
				}
				else
				{
					poupList.isOpen = !poupList.isOpen;
				}
			}
			else
			{
				if (poupList) poupList.isOpen = false;
			}

			selectedVo = vo;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		protected function initEvents() : void
		{
			// 按下事件
			this.addEventListener(MouseEvent.MOUSE_DOWN, eventStopPropagation);
		}

		/** 阻止事件流传递 */
		protected function eventStopPropagation(event : MouseEvent) : void
		{
			event.stopPropagation();
		}

		public function get selectedVo() : VoChannel
		{
			return _selectedVo;
		}

		public function set selectedVo(selectedVo : VoChannel) : void
		{
			if (_selectedVo == selectedVo)
			{
				// poupListFun(null);
				return;
			}
			_selectedVo = selectedVo;
			var index : int = items.indexOf(itemDic[_selectedVo.id]);
			if (index == -1) index = 0;
			group.selectionModel.index = index;
			// 抛出事件
			var event : EventChat = new EventChat(EventChat.CHANNEL_CHANGE, true);
			event.voChannel = _selectedVo;
			dispatchEvent(event);
		}
	}
}
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.geom.Point;
import flash.utils.Dictionary;
import game.module.chat.ChatUntils;
import game.module.chat.VoChannel;
import game.module.chat.config.ChatConfig;
import game.module.chat.view.PoupPanel;
import gameui.controls.GCheckBox;
import gameui.data.GCheckBoxData;
import gameui.data.GPanelData;
import net.AssetData;




class PoupList extends PoupPanel
{
	/** 竖间距 */
	protected var gap : uint = 0;
	/** 边距 */
	protected var leftPadding : uint = 5;
	protected var rightPadding : uint = 5;
	protected var paddingV : uint = 5;
	protected var itemWidth : uint = 50;
	protected var itemHeight : uint = 18;
	protected var minHeight : uint = 20;
	// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
	private var _channelId : int = -1;
	public var channelDefaultAccpet : Array;
	public var channelAccpet : Array;
	public var itemDic : Dictionary = new Dictionary();
	public var items : Vector.<GCheckBox>;

	function PoupList(parentContainer : DisplayObjectContainer, globalPoint : Point, panelData : GPanelData = null)
	{
		if (panelData == null)
		{
			panelData = new GPanelData();
			panelData.bgAsset = new AssetData("GToolTip_backgroundSkin");
			panelData.width = 60;
		}
		super(parentContainer, globalPoint, panelData);
	}

	/** 更新子项 */
	protected function updateItems() : void
	{
		clearItems();
		createItems();
	}

	/** 清理子项 */
	protected function clearItems() : void
	{
		if (items == null) return;
		var item : GCheckBox;
		for (var i : int = 0; i < items.length; i++)
		{
			item = items[i] as GCheckBox;
			if (item && item.parent)
			{
				item.parent.removeChild(item);
			}
		}
	}

	/** 创建子项 */
	protected function createItems() : void
	{
		itemDic = new Dictionary();
		items = new Vector.<GCheckBox>();
		var channelId : uint = 0;
		var vo : VoChannel;
		var item : GCheckBox;
		var checkBoxData : GCheckBoxData = new GCheckBoxData();
		checkBoxData.selected = false;
		checkBoxData.x = leftPadding;

		var postionX : int = leftPadding;
		var postionY : int = paddingV;
		var i : uint;
		var k : uint = 0;
		for (i = 0; i < channelDefaultAccpet.length; i++)
		{
			channelId = channelDefaultAccpet[i];
			vo = ChatConfig.channelVoDic[channelId];
			if (vo.isOpen == false) continue;
			checkBoxData = checkBoxData.clone();
			checkBoxData.labelData.textFieldFilters = ChatUntils.textEdgeFilter;
			checkBoxData.labelData.textFormat.font = ChatUntils.font;
			checkBoxData.labelData.text = vo.name;
			checkBoxData.selected = channelAccpet.indexOf(channelId) != -1;
			item = new GCheckBox(checkBoxData);
			item.source = vo;
			item.enabled = vo.id == this.channelId ? false : vo.enable;
			itemDic[vo.id] = item;
			items.push(item);
			item.x = postionX;
			item.y = postionY;
			postionY += item.height + gap;
			add(item);

			item.addEventListener(Event.CHANGE, item_changeHandler);
			k++;
		}
		this.width = item.width + leftPadding + rightPadding ;
		this.height = (item.height + gap) * k + paddingV * 2 - gap;
	}

	private function item_changeHandler(event : Event) : void
	{
		var item : GCheckBox = event.currentTarget as GCheckBox;
		var vo : VoChannel = item.source as VoChannel;
		var channelId : uint = vo.id;
		if (item.selected == true && channelAccpet.indexOf(channelId) == -1)
		{
			channelAccpet.push(channelId);
		}
		else if (item.selected == false && channelAccpet.indexOf(channelId) != -1)
		{
			channelAccpet.splice(channelAccpet.indexOf(channelId), 1);
		}
	}

	/** 频道Id */
	public function get channelId() : uint
	{
		return _channelId;
	}

	/**
	 * @private
	 */
	public function set channelId(value : uint) : void
	{
		if (_channelId == value) return;
		_channelId = value;
		channelDefaultAccpet = ChatConfig.channelDefaultAccept[_channelId];
		channelAccpet = ChatConfig.channelAccept[_channelId];
		if (channelDefaultAccpet == null || channelDefaultAccpet.length <= 1)
		{
			return;
		}
		updateItems();
	}
}
