package game.module.chat.view
{
	import game.module.chat.LinkConfig;

	import worlds.apis.MTo;

	import com.commUI.tips.HeroTip;
	import com.commUI.tips.ItemTip;
	import com.commUI.tips.PlayerTip;

	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.engine.RenderingMode;
	import flash.utils.getTimer;

	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.container.ScrollPolicy;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.InlineGraphicElementStatus;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.FlowElementMouseEvent;
	import flashx.textLayout.events.StatusChangeEvent;
	import flashx.textLayout.events.TextLayoutEvent;
	import flashx.textLayout.formats.LeadingModel;

	import game.core.user.UserData;
	import game.module.chat.ChatUntils;
	import game.module.chat.ManagerChat;
	import game.module.chat.VoChatMsg;
	import game.module.chat.config.ChannelId;
	import game.module.chat.config.ChannelMaxMsg;
	import game.module.chat.config.ChatConfig;

	import gameui.controls.GScrollBar;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GScrollBarData;
	import gameui.events.GScrollBarEvent;

	public class MsgTextFlow extends GComponent
	{
		/** 文本组件 */
		protected var textFlow : TextFlow;
		/** 消息容器 */
		protected var container : Sprite;
		/** 容器控制器 */
		protected var containerController : ContainerController;
		/** 滚动条 */
		public var vScrollBar : GScrollBar;
		protected var containerWidth : uint = 400;
		protected var containerHeight : uint = 200;
		public static var textEdgeFilter : DropShadowFilter = new DropShadowFilter(0, 0, 0x000000, 1, 2, 2, 13, 1, false, false);
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var _channelId : uint;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		protected var leftPadding : uint = 3;
		protected var rightPadding : uint = 0;
		protected var topPadding : uint = 14;
		protected var bottomPadding : uint = 3;

		public function MsgTextFlow()
		{
			_base = new GComponentData();
			_base.width = 0;
			_base.height = 0;
			super(_base);
			initEvents();
		}

		/** 初始化子组件 */
		override protected function create() : void
		{
			mouseEnabled = false;
			// 滚动条
			var scrollBarData : GScrollBarData = new GScrollBarData();
			scrollBarData.height = this.height - topPadding - bottomPadding;
			scrollBarData.x = this.width - scrollBarData.width - rightPadding;
			scrollBarData.y = topPadding;
			vScrollBar = new GScrollBar(scrollBarData);
			addChild(vScrollBar);
			vScrollBar.visible = false;

			// 文本组件
			textFlow = new TextFlow();
			textFlow.fontFamily = ChatUntils.font;
			// textFlow.interactionManager = new SelectionManager;
			textFlow.fontSize = 12;
			textFlow.lineHeight = 23;
			textFlow.leadingModel = LeadingModel.IDEOGRAPHIC_CENTER_DOWN;
			// textFlow.leadingModel = LeadingModel.IDEOGRAPHIC_TOP_DOWN;
			textFlow.renderingMode = RenderingMode.NORMAL;
			textFlow.paddingBottom = 10;

			// 消息容器
			container = new Sprite();
			container.mouseChildren = false;
			// container.mouseEnabled = false;
			container.x = leftPadding;
			container.y = topPadding;
			container.filters = ChatUntils.textEdgeFilter;
			addChild(container);
			// 容器控制器
			containerWidth = vScrollBar.x - container.x;
			containerHeight = vScrollBar.height;

			textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, graphicStatusChangeEvent);
			// this.mouseEnabled = false;
			// containerController = new ContainerController(container, containerWidth, containerHeight);
			// containerController.verticalScrollPolicy = ScrollPolicy.ON;
			// textFlow.flowComposer.addController(containerController);
			// textFlow.flowComposer.updateAllControllers();
		}

		private function graphicStatusChangeEvent(event : StatusChangeEvent) : void
		{
			if (event.status == InlineGraphicElementStatus.READY || event.status == InlineGraphicElementStatus.SIZE_PENDING)
			{
				textFlow.flowComposer.updateAllControllers();
			}
		}

		/** 更新布局前文件高 */
		private var layoutPreTextFlowScrollMax : int = 0;

		/** 布局 */
		override protected function layout() : void
		{
			if (width == 0 || height == 0) return;

			textFlow.removeEventListener(TextLayoutEvent.SCROLL, textFlow_scrollHandler);
			vScrollBar.removeEventListener(GScrollBarEvent.SCROLL, vScrollBar_scrollHandler);
			// 滚动条
			vScrollBar.x = this.width - vScrollBar.width - rightPadding;
			vScrollBar.height = this.height - topPadding - bottomPadding;
			// 文本组件
			containerWidth = vScrollBar.x - container.x;
			containerHeight = vScrollBar.height;

			// 更新布局前文件高
			layoutPreTextFlowScrollMax = textFlowScrollMax;
			// trace("layoutPreTextFlowScrollMax = " + layoutPreTextFlowScrollMax);

			if (containerController == null)
			{
				textFlow.flowComposer.removeAllControllers();
				containerController = new ContainerController(container, containerWidth, containerHeight);
				containerController.verticalScrollPolicy = ScrollPolicy.ON;
				textFlow.flowComposer.addController(containerController);
			}
			else
			{
				containerController.setCompositionSize(containerWidth, containerHeight);
			}

			setScrollRectangleMax();
			// lastRemoveAndAdd();
			// if (layoutPreTextFlowScrollMax < containerHeight)
			// {
			//                //  更新容器显示
			// updateControllers();
			// }

			textFlow.addEventListener(TextLayoutEvent.SCROLL, textFlow_scrollHandler);
			vScrollBar.addEventListener(GScrollBarEvent.SCROLL, vScrollBar_scrollHandler);
		}

		/** 添加事件监听 */
		protected function initEvents() : void
		{
			vScrollBar.addEventListener(GScrollBarEvent.SCROLL, vScrollBar_scrollHandler);
			textFlow.addEventListener(TextLayoutEvent.SCROLL, textFlow_scrollHandler);
			textFlow.addEventListener(FlowElementMouseEvent.CLICK, textFlow_clickHandler);
		}

		public static var linkClickTime : int = 0;

		protected function textFlow_clickHandler(event : FlowElementMouseEvent) : void
		{
			ManagerChat.showTiping = true;
			linkClickTime = getTimer();
			var linkElement : LinkElement = event.flowElement as LinkElement;
			var href : String = linkElement.href.replace("event:", "");
			var target : String = linkElement.target;
			var id : int;
			var arr : Array;
			var x : int;
			var y : int;
			PlayerTip.close();
			ItemTip.close();
			if (href.indexOf("link_") != -1)
			{
				var linkArr : Array = href.split("_");
				linkArr.shift();
				LinkConfig.instance.run(parseInt(linkArr.shift()), linkArr);
				return;
			}
			switch(href)
			{
				case MsgTextFlowEvent.CLICK_PLAYER:
					if (target == UserData.instance.playerName) return;
					PlayerTip.show(0, target, [PlayerTip.NAME_SHISPER, PlayerTip.NAME_TRADE, PlayerTip.NAME_ADD_FRIEND, PlayerTip.NAME_INVITE_CLAN, PlayerTip.NAME_COPY_PLAYER_NAME, PlayerTip.NAME_LOOK_INFO, PlayerTip.NAME_MOVE_TO_BACKLIST, PlayerTip.NAME_MOVE_OUT_BACKLIST]);
					break;
				case MsgTextFlowEvent.CLICK_ITEM:
					ItemTip.showInfo(target);
					break;
				case MsgTextFlowEvent.CLICK_HERO:
					HeroTip.showInfo(target);
					break;
				case MsgTextFlowEvent.CLICK_GOODS:
					id = parseInt(target);
					ItemTip.show(id);
					break;
				case MsgTextFlowEvent.CLICK_MAP:
					arr = target.split("_");
					id = parseInt(arr[0]);
					x = parseInt(arr[1]);
					y = parseInt(arr[2]);
					MTo.toMap(1, x, y, id);
					break;
				default:
					break;
			}
		}

		/** 滚动条 滚动事件 */
		private function vScrollBar_scrollHandler(event : GScrollBarEvent) : void
		{
			textFlow.removeEventListener(TextLayoutEvent.SCROLL, textFlow_scrollHandler);
			try
			{
				if (containerController) containerController.verticalScrollPosition = event.position;
			}
			catch(error : Error)
			{
				// trace("vScrollBar_scrollHandler出错 if(containerController) containerController.verticalScrollPosition = event.position;");
			}

			textFlow.addEventListener(TextLayoutEvent.SCROLL, textFlow_scrollHandler);
		}

		/** 文本组件 在控制器容器中滚动了文本时由 TextFlow 对象调度。 事件 */
		private function textFlow_scrollHandler(event : TextLayoutEvent) : void
		{
			// 更新滚动条值 -- 当前值
			updateScrollBarValue();
		}

		private var isFirstAppendMsg : Boolean = true;
		private var isRemoveDefaultElement : Boolean = false;

		private var hasAppend:Boolean = false;
		/** 添加消息 */
		public function appendMsg(vo : VoChatMsg) : void
		{
			var arr : Array = ChatConfig.channelAccept[channelId];
			if (arr.indexOf(vo.channelId) == -1)
			{
				return;
			}

			while (textFlow.numChildren > ChannelMaxMsg.getValue(channelId))
			{
				textFlow.removeChildAt(0);
			}

			var flowElement : FlowElement = MsgTemplate.message(vo);

			textFlow.addChild(flowElement);
			if(textFlow.numChildren == 2)
			{
				if(hasAppend == false)
				{
					textFlow.removeChildAt(0);
					hasAppend = true;
				}
			}

			if (width == 0 || height == 0) return;

			if (Math.abs(vScrollBar.value - vScrollBar.max) > 23)
			{
				// 当前显示区更新滚动值
				updateScrollRectangleValue();
			}
			else
			{
				// 设置显示区最底
				setScrollRectangleMax();
			}
		}

		/** 设置显示区最底 */
		private function setScrollRectangleMax() : void
		{
			// 更新容器显示
			updateControllers();
			setTextFlowScrollMax();
			// 更新滚动条值 --  到最底
			updateScrollBarMax();
		}

		/** 当前显示区更新滚动值 */
		private function updateScrollRectangleValue() : void
		{
			// 更新容器显示
			updateControllers();
			if (containerController)
			{
				containerController.verticalScrollPosition += 1;
				containerController.verticalScrollPosition -= 1;
			}
			// 更新滚动条值 --  到最底
			updateScrollBarValue();
		}

		/** 更新滚动条值 -- 当前值 */
		private function updateScrollBarValue() : void
		{
			textFlow.removeEventListener(TextLayoutEvent.SCROLL, textFlow_scrollHandler);
			var pageSize : Number = containerHeight;
			var min : Number = 0;
			var max : Number = textFlowScrollMax - containerHeight;
			max = max <= 0 ? pageSize : max;
			var value : Number = containerController.verticalScrollPosition;
			vScrollBar.resetValue(pageSize, min, max, value);
			textFlow.addEventListener(TextLayoutEvent.SCROLL, textFlow_scrollHandler);
		}

		/** 更新滚动条值 -- 到最底 */
		private function updateScrollBarMax() : void
		{
			textFlow.removeEventListener(TextLayoutEvent.SCROLL, textFlow_scrollHandler);
			var pageSize : Number = containerHeight;
			var min : Number = 0;
			var max : Number = textFlowScrollMax - containerHeight;
			max = max <= 0 ? 0 : max;
			var value : Number = max;
			vScrollBar.resetValue(pageSize, min, max, value);
			textFlow.addEventListener(TextLayoutEvent.SCROLL, textFlow_scrollHandler);
		}

		/** 删除最后一个再加上 */
		private function lastRemoveAndAdd() : void
		{
			if (textFlow.numChildren > 0)
			{
				var flowElement : FlowElement = textFlow.removeChildAt(textFlow.numChildren - 1);
				textFlow.addChild(flowElement);
			}
		}

		/** 文本框滚动最底 */
		public function setTextFlowScrollMax() : void
		{
			var textHeight : int = textFlowScrollMax;
			if (textHeight == 0) return;

			containerController.verticalScrollPosition = textHeight;
			// if (textHeight < containerHeight)
			// {
			// containerController.verticalScrollPosition = 0;
			// }
			// else
			// {
			// containerController.verticalScrollPosition = textHeight;
			// }
		}

		/** 文本框滚动最大值 */
		public function get textFlowScrollMax() : int
		{
			if (!containerController || !containerController.getContentBounds()) return 0;
			var rect : Rectangle = containerController.getContentBounds();
			var textHeight : int = Math.ceil(rect.height);
			return textHeight;
		}

		/** 清屏 */
		public function clear() : void
		{
			while (textFlow.numChildren > 0)
			{
				textFlow.removeChildAt(0);
			}
			isRemoveDefaultElement = false;
			isFirstAppendMsg = true;
			containerController.setCompositionSize(containerWidth, containerHeight);
			// 设置显示区最底
			setScrollRectangleMax();
		}

		/** 更新容器显示 */
		public function updateControllers() : void
		{
			try
			{
				textFlow.flowComposer.updateAllControllers();
			}
			catch(error : Error)
			{
				// trace("textFlow.flowComposer.updateAllControllers()出错");
			}
		}

		public function get channelId() : uint
		{
			return _channelId;
		}

		public function set channelId(value : uint) : void
		{
			_channelId = value;
			if (value == ChannelId.SYSTEM)
			{
				var p : ParagraphElement = new ParagraphElement();
				textFlow.addChild(p);
			}
		}
	}
}