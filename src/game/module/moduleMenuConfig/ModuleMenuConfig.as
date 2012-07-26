/**
 Jul 2, 2012
 USEAGE :
 */
package game.module.moduleMenuConfig {
	import game.manager.ViewManager;
	import game.module.daily.DailyNotice;
	import game.core.menu.MenuManager;
	import game.manager.SignalBusManager;
	import game.module.chat.ControllerChat;
	import game.module.notification.ICOMenuManager;
	import game.module.quest.QuestDisplayManager;

	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;

	import flash.utils.Dictionary;

	// class start ~~~~~
	public class ModuleMenuConfig {
		private static var _single:ModuleMenuConfig=null;
		private var currentMapModuleId:uint=0;
		private var currentPanelModuleId:uint=0;
		private var visibleMenuModule4Panel:Dictionary=new Dictionary();
		private var visibleMenuModule4Map:Dictionary=new Dictionary();

		public static function getInstance():ModuleMenuConfig {
			if (_single == null) {
				_single=new ModuleMenuConfig(new Singleton());
			}
			return _single;
		}

		public function ModuleMenuConfig(singleton:Singleton) {
			SignalBusManager.enterSceneModePanel.add(enterPanel);
			SignalBusManager.exitSceneModePanel.add(exitPanel);
			MWorld.sInstallReady.add(enterMap);
		}

		private function enterMap():void {
			var mapId:uint=MapUtil.currentMapId;
			currentMapModuleId=mapId;

			updateModuleMenu();
		}

		private function enterPanel(panelId:uint):void {
			// 此面板没有模式
			if (visibleMenuModule4Panel[panelId] == null)
				return;

			currentPanelModuleId=panelId;
			updateModuleMenu();
		}

		private function exitPanel(panelId:uint):void {
			if (currentPanelModuleId != panelId)
				return;

			currentPanelModuleId=0;
			updateModuleMenu();
		}

		private function updateModuleMenu():void {
			var menuConfig:MenuConfig;

			// 有面板模式
			if (currentPanelModuleId != 0) {
				menuConfig=visibleMenuModule4Panel[currentPanelModuleId];
			} else {
				menuConfig=visibleMenuModule4Map[currentMapModuleId];

				// 如果这张题图没有特别配置，默认使用0号地图配置
				if (menuConfig == null)
					menuConfig=visibleMenuModule4Map[0];
			}

			// 执行配置
			implementModuleConfig(menuConfig);

		}

		private function implementModuleConfig(menuConfig:MenuConfig):void {
			// 主菜单 MAIN
			MenuManager.getInstance().visible(menuConfig.getStatus(MenuConfig.MAIN), MenuManager.BOTTOM_MENU);
			MenuManager.getInstance().setShowList(menuConfig.getSubStatus(MenuConfig.MAIN));

			//右上地图菜单
			MenuManager.getInstance().visible(menuConfig.getStatus(MenuConfig.MAP), MenuManager.MAP_MENU);

			// 上菜单 TOP
			MenuManager.getInstance().visible(menuConfig.getStatus(MenuConfig.TOP), MenuManager.TOP_MENU);

			// 聊天 CHAT
			// TODO: 以后改成移除
			ViewManager.chat.visible=menuConfig.getStatus(MenuConfig.CHAT);

			// 任务 MISSION
			QuestDisplayManager.getInstance().questView.visible=menuConfig.getStatus(MenuConfig.MISSION);

			// 提示ICON TIP
			if (menuConfig.getStatus(MenuConfig.TIP))
				ICOMenuManager.getInstance().show();
			else
				ICOMenuManager.getInstance().hide();

			// 系统活动提示 SYSTEM
			DailyNotice.instance.visible=menuConfig.getStatus(MenuConfig.SYSTEM);
		}

		public function parseXmlData(xmlData:XML):void {
			var dataList:XMLList=xmlData.children();
			for (var i:uint=0; i < dataList.length(); i++) {
				// 按配置文件解析模块对应菜单配置
				var menuConfig:MenuConfig=new MenuConfig();
				menuConfig.setStatus(dataList[i].@visibleMenuModule, dataList[i].@visibleSubMenu);

				var panelIdString:String=dataList[i].@panelId;
				var panelIds:Array=panelIdString.split(",");
				for (var j:uint=0; j < panelIds.length; j++) {
					visibleMenuModule4Panel[panelIds[j]]=menuConfig;
				}
				var mapIdString:String=dataList[i].@mapId;
				var mapIds:Array=mapIdString.split(",");
				for (var k:uint=0; k < mapIds.length; k++) {
					visibleMenuModule4Map[mapIds[k]]=menuConfig;
				}
			}
		}
		// class end ~~~~~
	}
}

class Singleton {
}









