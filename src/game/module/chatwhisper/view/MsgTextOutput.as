package game.module.chatwhisper.view
{
	import com.commUI.tips.PlayerTip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.container.ScrollPolicy;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.FlowElementMouseEvent;
	import flashx.textLayout.events.TextLayoutEvent;
	import game.module.chat.ChatUntils;
	import game.module.chat.VoChatMsg;
	import game.module.chat.view.MsgTemplate;
	import game.module.chat.view.MsgTextFlowEvent;
	import gameui.controls.GScrollBar;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GScrollBarData;
	import gameui.events.GScrollBarEvent;





	/**
	 * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-11-21 ����10:18:28
	 */
	public class MsgTextOutput extends GComponent
	{
		/** 文本组件 */
		protected var textFlow : TextFlow;
		/** 消息容器 */
		protected var container : Sprite;
		/** 容器控制器 */
		protected var containerController : ContainerController;
		/** 滚动条 */
		protected var vScrollBar : GScrollBar;
		protected var containerWidth : uint = 400;
		protected var containerHeight : uint = 200;
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		protected var leftPadding : uint = 0;
		protected var rightPadding : uint = 3;
		protected var topPadding : uint = 0;
		protected var bottomPadding : uint = 0;

		public function MsgTextOutput(base : GComponentData)
		{
			super(base);
			initEvents();
			// testData();
		}

		public function testData() : void
		{
			var msgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
			for (var i : int = 0; i < 30; i++ )
			{
				var voMsg : VoChatMsg = new VoChatMsg();
				voMsg.channelId = 3;
				voMsg.playerName = "大海明月";
				voMsg.serverId = 5;
				voMsg.playerColorPropertyValue = 5;
				voMsg.recPlayerName = "ZF";
				voMsg.recPlayerColorPropertyValue = 30;
				voMsg.content = "我是谁？我是天才，哈哈哈~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#8果然NB" + i;
				appendMsg(voMsg);
				msgs.push(voMsg);
			}
			appendMsgs(msgs);
		}

		/** 初始化子组件 */
		override protected function create() : void
		{
			// 滚动条
			var scrollBarData : GScrollBarData = new GScrollBarData();
			scrollBarData.height = this.height - topPadding - bottomPadding;
			scrollBarData.x = this.width - scrollBarData.width - rightPadding;
			scrollBarData.y = topPadding;
			vScrollBar = new GScrollBar(scrollBarData);
			addChild(vScrollBar);

			// 文本组件
			textFlow = new TextFlow();
			textFlow.fontFamily = ChatUntils.font;
			textFlow.fontSize = 12;
			textFlow.lineHeight = 22;
			textFlow.paddingBottom = 6;
			
			// 消息容器
			container = new Sprite();
			container.mouseChildren = false;
			container.x = leftPadding;
			container.y = topPadding;
			// container.filters = [FilterUtils.defaultTextEdgeFilter];
			addChild(container);
			// 容器控制器
			containerWidth = vScrollBar.x - container.x;
			containerHeight = vScrollBar.height;
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
			//trace("layoutPreTextFlowScrollMax = " + layoutPreTextFlowScrollMax);

			textFlow.flowComposer.removeAllControllers();
			containerController = new ContainerController(container, containerWidth, containerHeight);
			containerController.verticalScrollPolicy = ScrollPolicy.ON;
			textFlow.flowComposer.addController(containerController);

			setScrollRectangleMax();
			lastRemoveAndAdd();
			if (layoutPreTextFlowScrollMax < containerHeight)
			{
				// 更新容器显示
				updateControllers();
			}

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

		protected function textFlow_clickHandler(event : FlowElementMouseEvent) : void
		{
			var linkElement : LinkElement = event.flowElement as LinkElement;
			var href : String = linkElement.href.replace("event:", "");
			;
			var target : String = linkElement.target;
			switch(href)
			{
				case MsgTextFlowEvent.CLICK_PLAYER:
				{
					PlayerTip.show(0, target);
					break;
				}
				default:
				{
					break;
				}
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
				//trace("vScrollBar_scrollHandler出错 if(containerController) containerController.verticalScrollPosition = event.position;");
			}

			textFlow.addEventListener(TextLayoutEvent.SCROLL, textFlow_scrollHandler);
		}

		/** 文本组件 在控制器容器中滚动了文本时由 TextFlow 对象调度。 事件 */
		private function textFlow_scrollHandler(event : TextLayoutEvent) : void
		{
			// 更新滚动条值 -- 当前值
			updateScrollBarValue();
		}

		/** 添加消息 */
		public function appendMsgs(msgs : Vector.<VoChatMsg>) : void
		{
			clear();
			if (msgs == null) return;
			for (var i : int = 0; i < msgs.length; i++)
			{
				var flowElement : FlowElement = MsgTemplate.whisperWindowMessage(msgs[i]);
				textFlow.addChild(flowElement);
			}

			if (width == 0 || height == 0) return;

			if (Math.abs(vScrollBar.value - vScrollBar.max) > 25)
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

		/** 添加消息 */
		public function appendMsg(vo : VoChatMsg) : void
		{
			var flowElement : FlowElement = MsgTemplate.whisperWindowMessage(vo);
			textFlow.addChild(flowElement);

			if (width == 0 || height == 0) return;

			if (Math.abs(vScrollBar.value - vScrollBar.max) > 25)
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
			// 更新容器显示
			updateControllers();
			updateScrollBarMax();
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
				//trace("textFlow.flowComposer.updateAllControllers()出错");
			}
		}
	}
}
