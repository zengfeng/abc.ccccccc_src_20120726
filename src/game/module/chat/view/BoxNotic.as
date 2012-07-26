package game.module.chat.view
{
	import net.BDSWFLoader;

	import game.manager.VersionManager;

	import net.LibData;
	import net.AssetData;
	import net.RESManager;

	import gameui.controls.BDPlayer;

	import com.utils.DrawUtils;

	import flash.display.Sprite;
	import flash.text.engine.RenderingMode;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.LeadingModel;

	import game.module.chat.ChatUntils;
	import game.module.chat.VoChatMsg;
	import game.module.chat.config.ChatConfig;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;

	/**
	 * 公告区块
	 * */
	public class BoxNotic extends GComponent
	{
		/** 消息组件 */
		private var textFlow : TextFlow;
		/** 消息容器控制器 */
		private var _containerController : ContainerController;
		/** 消息容器 */
		private var _container : Sprite;
		/** 消息缓存 */
		protected var msgListBuffer : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
		protected var paddingLeft : uint = 10;
		protected var paddingRight : uint = 10;
		private var effect : BDPlayer;

		public function BoxNotic()
		{
			_base = new GComponentData();
			_base.width = 406;
			_base.height = 55;

			super(_base);

			this.visible = false;
		}

		/** 初始化子组件 */
		override protected function create() : void
		{
			// 消息容器
			_container = new Sprite();
			_container.x = 5;
			_container.y = 4;
			var containerWidth : int = this.width - _container.x * 2;
			var containerHeight : int = this.height - _container.y * 2;
			_container.filters = ChatUntils.textEdgeFilter;
			addChild(_container);
			// 消息组件
			textFlow = new TextFlow();
			textFlow.fontFamily = ChatUntils.font;
			textFlow.interactionManager = new SelectionManager;
			textFlow.fontSize = 12;
			textFlow.lineHeight = 23;
			textFlow.leadingModel = LeadingModel.IDEOGRAPHIC_TOP_DOWN;
			textFlow.renderingMode = RenderingMode.NORMAL;

			_containerController = new ContainerController(_container, containerWidth, containerHeight);
			textFlow.flowComposer.addController(_containerController);
			textFlow.flowComposer.updateAllControllers();

			var data : GComponentData = new GComponentData();
			effect = new BDPlayer(data);
			effect.setBDData(RESManager.getBDData(new AssetData("1", "chatNoticEffect")));
			RESManager.instance.load(new LibData(VersionManager.instance.getUrl("assets/avatar/192937988.swf"), "chatNoticEffect"), effectLoadComplete, ["chatNoticEffect"], BDSWFLoader);
		}

		private function effectLoadComplete(key : String) : void
		{
			var data : GComponentData = new GComponentData();
			effect = new BDPlayer(data);
			effect.setBDData(RESManager.getBDData(new AssetData("1", key)));
			addChild(effect);
			effect.x = width / 2 + 2;
			effect.y = height / 2 - 7;
			if (visible)
			{
				effect.play(80, null, 0);
			}
			else
			{
				effect.stop();
			}
		}

		/** 布局 */
		override protected function layout() : void
		{
			DrawUtils.roundRect(this, this.width, this.height, 0, 3, 0x000000, 0, 0.4, 0);
			// _container.width = this.width - _container.x * 2;
			// _container.height = this.height - _container.y * 2;
			// updateControllers();
		}

		/** 添加消息 */
		public function addMsg(voMsg : VoChatMsg) : void
		{
			msgListBuffer.push(voMsg);
			if (isOpen == false) showMsg();
		}

		/** 显示消息 */
		public function showMsg() : void
		{
			clearTimeout(showNextMsgTimer);
			if (msgListBuffer.length == 0)
			{
				isOpen = false;
				return;
			}

			isOpen = true;
			clear();
			var voMsg : VoChatMsg = msgListBuffer.shift();
			var flowElement : FlowElement = MsgTemplate.message(voMsg);
			textFlow.addChildAt(0, flowElement);
			textFlow.removeChildAt(1);
			updateControllers();
			showNextMsgTimer = setTimeout(showMsg, ChatConfig.noticShowTime);
		}

		private var showNextMsgTimer : uint;

		/** 清屏 */
		public function clear() : void
		{
			while (textFlow.numChildren > 1)
			{
				textFlow.removeChildAt(0);
			}
			// 更新容器显示
			updateControllers();
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

		private var _isOpen : Boolean = false;

		public function get isOpen() : Boolean
		{
			return _isOpen;
		}

		public function set isOpen(isOpen : Boolean) : void
		{
			if (_isOpen == isOpen) return;
			_isOpen = isOpen;
			this.visible = isOpen;
			if (effect)
			{
				if (visible)
				{
					effect.play(80, null, 0);
				}
				else
				{
					effect.stop();
				}
			}
		}
	}
}