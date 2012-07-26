package game.manager {
	import game.config.StaticConfig;
	import game.core.avatar.AvatarManager;
	import game.module.quest.VoMonster;
	import game.module.quest.VoNpc;
	import game.module.quest.guide.GuideMange;
	import game.net.core.Common;
	import game.net.core.GASignals;

	import gameui.skin.ASSkin;
	import gameui.theme.BlackTheme;

	import net.AssetData;
	import net.LibData;
	import net.RESLoader;
	import net.RESManager;
	import net.SWFLoader;

	import com.shortybmc.CSV;
	import com.utils.UrlUtils;

	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public final class RSSManager {
		public static const TYPE_CSV : String = "csv";
		public static const TYPE_XML : String = "xml";
		public static const TYPE_MAP : String = "map";
		public static const TYPE_TXT : String = "txt";
		/** Npc 列表 **/
		public static var npcList : Dictionary = new Dictionary();
		/** 怪物列表 **/
		public static var mosterList : Dictionary = new Dictionary();
		/** vip等级信息 */
		public static var vipDic : Dictionary = new Dictionary(true);
		private static var __instance : RSSManager;
		// csv文件
		private var _csvDic : Dictionary;
		// xml文件
		private var _xmlDic : Dictionary;
		// 地图xml文件
		private var _mapDic : Dictionary;
		// txt文件
		private var _txtDic : Dictionary;
		private var _res : RESManager;

		public function RSSManager() {
			if (__instance != null)
				throw Error("此类为单类，初始化出错！");
			_csvDic = new Dictionary();
			_xmlDic = new Dictionary();
			_mapDic = new Dictionary();
			_txtDic = new Dictionary();
			_res = RESManager.instance;
		}

		/** 
		 * @author yangyiqiang
		 * @version 1.0
		 * @param 单类
		 * @return ConfigManager
		 */
		public static function getInstance() : RSSManager {
			if ( __instance == null) {
				__instance = new RSSManager();
			}
			return __instance;
		}

		public function startLoad() : void {
			GASignals.gaPreLoadAssetAllStart.dispatch();

			ASSkin.setTheme(AssetData.AS_LIB, new BlackTheme());
			// 主UI
			_res.add(VersionManager.instance.getLoader("assets/swf/ui.swf", "ui"));

			// 配置文件
			_res.add(VersionManager.instance.getLoader("config/config.kt", "config.kt", RESLoader));

			_res.add(VersionManager.instance.getLoader("assets/avatar/shadow.png", "shadowPng0"));
			_res.add(VersionManager.instance.getLoader("assets/avatar/shadow1.png", "shadowPng1"));
			_res.add(VersionManager.instance.getLoader("assets/quest/quest.swf", "quest"));


			_res.add(VersionManager.instance.getLoader("assets/swf/commonAction_" + StaticConfig.langString + ".swf", "commonAction"));

			_res.add(VersionManager.instance.getLoader(("assets/swf/smallLoader.swf"), "smallLoader"));
			
			_res.add(VersionManager.instance.getLoader("assets/swf/titleFont.swf"));
			var url : String = VersionManager.instance.getUrl("assets/avatar/1677721602.swf");

			_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(1677721602).parse, [url]));
			
			_res.add(VersionManager.instance.getLoader(UrlUtils.getLangSWF2("menu.swf"), "lang_menu"));

			_res.add(VersionManager.instance.getLoader(UrlUtils.getLangSWF2("userPanel.swf"), "lang_userPanel"));
			
			GuideMange.getInstance().addToLoad(_res);
			_res.addEventListener(Event.COMPLETE, loadComplete);
			Common.getInstance().loadPanel.model = RESManager.instance.model;
			Common.getInstance().loadPanel.startShow(false);
			_res.startLoad();
		}

		/** 解析语言包 **/
		public function parseLanguagePack(bytes : ByteArray) : void {
		}

		/**
		 * 获取配置文件
		 * @param name 文件名
		 * @param type 类型
		 * @return  
		 */
		public function getData(name : String, type : String = "xml") : * {
			switch(type) {
				case TYPE_XML:
					if (!_xmlDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的xml文件");
					return _xmlDic[name];
				case TYPE_CSV:
					if (!_csvDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的csv文件");
					return _csvDic[name];
				case TYPE_MAP:
					if (!_mapDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的地图文件");
					return _mapDic[name];
				case TYPE_TXT:
					if (!_txtDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的txt文件");
					return _txtDic[name];
			}
		}

		/**
		 * 删除配置文件
		 * @param name
		 * @param type
		 */
		public function deleteData(name : String, type : String = "xml") : void {
			switch(type) {
				case TYPE_XML:
					if (!_xmlDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的xml文件");
					delete _xmlDic[name];
					break;
				case TYPE_CSV:
					if (!_csvDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的csv文件");
					delete _csvDic[name];
					break;
				case TYPE_MAP:
					if (!_mapDic.hasOwnProperty(name)) throw new Error("不存在叫" + name + "的地图文件");
					delete _mapDic[name];
					break;
			}
		}

		public function get mapDic() : Dictionary {
			return _mapDic;
		}

		public  function getNpcById(npcId : int) : VoNpc {
			return npcList[npcId];
		}

		public function getMosterById(mosterId : int) : VoMonster {
			return mosterList[mosterId];
		}

		public function isNpc(id : int) : Boolean {
			return id < 4000;
		}

		public var loginLoadComplete : Boolean = false;
		public var loginLoadCompleteCall : Function;

		/**
		 * 解析载入完成的配置文件
		 * 所有基础数据加载完成后 向服务器请求个人信息
		 */
		private function loadComplete(evt : Event) : void {
			// Common.getInstance().loadPanel.hide();
			GASignals.gaPreLoadAssetAllComplete.dispatch();

			_res.removeEventListener(Event.COMPLETE, loadComplete);
			parseConfig(RESManager.getByteArray("config.kt"));
			ViewManager.instance.initializeViews();
			// Logger.debug("加载完成");
			Common.game_server.sendMessage(0x10);
			loginLoadComplete = true;
			if (loginLoadCompleteCall != null) loginLoadCompleteCall.apply();
		}

		/** 解析config **/
		public function parseConfig(bytes : ByteArray, battleFlg : int = 0) : void {
			bytes.position = 0;
			bytes.uncompress();
			var count : uint = bytes.readShort();
			for (var i : int = 0; i < count; i++) {
				var title : String = bytes.readUTF();
				var type : String = title.split(".")[1];
				var name : String = title.split(".")[0];
				var len : uint = bytes.readInt();
				var context : String = bytes.readUTFBytes(len);
				switch(type) {
					case TYPE_XML:
						_xmlDic[name] = new XML(context);
						break;
					case TYPE_CSV:
						_csvDic[name] = new CSV(context);
						break;
					case TYPE_MAP:
						_mapDic[name] = new XML(context);
						break;
					case TYPE_TXT:
						_txtDic[name] = new String(context);
						break;
				}
			}
			if (battleFlg == 0)
				XmlPraseManage.prase();
			else
				XmlPraseManage.praseBattle();
		}
	}
}
