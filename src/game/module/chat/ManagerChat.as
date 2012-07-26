package game.module.chat
{
	import game.manager.ViewManager;
	import game.core.hero.HeroChatInterface;
	import game.core.hero.VoHero;
	import game.core.item.Item;
	import game.core.item.ItemChatInterface;
	import game.core.user.UserData;
	import game.module.chat.config.ChannelId;

	import gameui.manager.UIManager;

	import net.RESManager;
	import net.SWFLoader;

	import flash.display.DisplayObjectContainer;
//	import game.net.data.CtoS.CSAreaChat;
//	import game.net.data.StoC.SCAreaChat;




	/**
	 * @author 1
	 */
	public class ManagerChat {
		/** 单例对像 */
		private static var _instance : ManagerChat;
		/** 显示TIP中 */
		public static var showTiping : Boolean = false;

		public function ManagerChat() {
		}

		/** 获取单例对像 */
		static public function get instance() : ManagerChat {
			if (_instance == null) {
				_instance = new ManagerChat();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 控制器 */
		private var controller : IControllerChat ;

		public function get view() : DisplayObjectContainer {
			if (!controller) controller = controllerChat;
			return controller.view;
		}

		public function get controllerChat() : IControllerChat {
			if (!controller) {
				try {
					controller = new (UIManager.appDomain.getDefinition("game.module.chat.ControllerChat") as Class) as IControllerChat;
				} catch(e : Error) {
					controller = null;
				} finally {
					if (!controller && RESManager.getLoader("chat")){
						var cls:Class=(RESManager.getLoader("chat") as SWFLoader).getClass("game.module.chat.ControllerChat");
						controller = new cls as IControllerChat;
					}
				}
			}
			return controller;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 设置玩家名称 */
		public function setPlayerName(playerName : String) : void {
			controller.setPlayerName(playerName);

			setInputChannel(ChannelId.WHISPER);
		}

		/** 设置输入频道 */
		public function setInputChannel(channelId : uint) : void {
			controller.setInputChannel(channelId);
		}

		/** 设置输出频道 */
		public function setOutputChannel(channelId : uint) : void {
			controller.setOutputChannel(channelId);
		}

		/** 提示 */
		public function prompt(str : String, isHTMLFormat:Boolean = false) : void {
			controller.prompt(str, isHTMLFormat);
		}

		/** 系统 */
		public function system(str : String, isHTMLFormat:Boolean = false) : void {
			controller.system(str, isHTMLFormat);
		}

		/** 系统公告 */
		public function systemNotic(str : String, isHTMLFormat:Boolean = false) : void {
		}

		/** 家族提示消息 */
		public function clanPrompt(str : String) : void {
			controller.clanPrompt(str);
		}

		/** 是否显示私聊 */
		public function set isShowWhisper(value : Boolean) : void {
			return;
			controller.isShowWhisper = value;
		}

		public function get isShowWhisper() : Boolean {
			return controller.isShowWhisper;
		}

		/** 插入玩家 */
		public function insertPlayer(id : int, name : String, colorPropertyValue : int) : void {
			var str : String = ChatTag.player(id, name, colorPropertyValue);
			controller.msgTextInputInsertContent(str);
		}

		/** 插入物品 */
		public function insertGoods(id : int, name : String, colorPropertyValue : int) : void {
			var str : String = ChatTag.goods(id, name, colorPropertyValue);
			controller.msgTextInputInsertContent(str);
		}

		/** 插入Npc */
		public function insertNpc(id : int, name : String, colorPropertyValue : int) : void {
			var str : String = ChatTag.npc(id, name, colorPropertyValue);
			controller.msgTextInputInsertContent(str);
		}

		/** 插入Item */
		public function insertItem(item : Item) : void {
			if (item == null) return;
			var info : String = ItemChatInterface.encodeItemToString(item);
			var name : String = item.name;
			var color : Number = item.color;

			var str : String = ChatTag.item(info, name, color);
			controller.sendMsgToCurrentChannel(str);
			return;
			var key : String = ChatItemInput.insert(info, name, color);
			controller.msgTextInputInsertContent(key);
		}

		/** 插入Hero */
		public function insertHero(voHero : VoHero) : void {
			if (voHero == null) return;

			var meyHeroId : int = UserData.instance.myHero.id;
			if (voHero.id == meyHeroId) voHero._name = UserData.instance.playerName;
			var info : String = HeroChatInterface.encodeHeroToString(voHero);
			var name : String = voHero._name;
			var color : Number = voHero.potential;

			var str : String = ChatTag.hero(info, name, color);
			controller.sendMsgToCurrentChannel(str);
		}

		public function moveViewToUIContainer() : void
		{
			if (view)
			{
				ViewManager.instance.uiContainer.addChild(view);
			}
		}
		
		public function moveViewToAutoContainer():void
		{
			if (view)
			{
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).addChild(view);
			}
		}
	}
}
