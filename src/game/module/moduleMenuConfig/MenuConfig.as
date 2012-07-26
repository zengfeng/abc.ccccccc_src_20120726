/**
 Jul 3, 2012
 USEAGE :
 */
package game.module.moduleMenuConfig {
	import flash.utils.Dictionary;

	// class start ~~~~~
	public class MenuConfig {
		// 1.右下导航图标
		// 2.上面的菜单
		// 3.右上的地图菜单
		// 4.聊天框
		// 5.任务追踪框
		// 6.提示ICON
		// 7.系统活动提示
		public static const MAIN:int=1;
		public static const TOP:int=2;
		public static const MAP:int=3;
		public static const CHAT:int=4;
		public static const MISSION:int=5;
		public static const TIP:int=6;
		public static const SYSTEM:int=7;

		private var _menuModule:Dictionary=new Dictionary();
		private var _subMenuStatus:Dictionary=new Dictionary();

		public function MenuConfig():void {
			_menuModule[MAIN]=false;
			_menuModule[TOP]=false;
			_menuModule[MAP]=false;
			_menuModule[CHAT]=false;
			_menuModule[MISSION]=false;
			_menuModule[TIP]=false;
			_menuModule[SYSTEM]=false;
		}

		public function getStatus(itemId:int):Boolean {
			return _menuModule[itemId];
		}

		public function getSubStatus(itemId:int):Array {
			return _subMenuStatus[itemId];
		}

		public function setStatus(menuModuleString:String, subMenu:String):void {
			if (subMenu != "") {
				var subMenuArray:Array=subMenu.split(";");
				for (var j:uint=0; j < subMenuArray.length; j++) {
					var subString:String=subMenuArray[j];
					// 获取第j组,子菜单配置字符串
					var subMenuConfigArray:Array=subString.split(":");
					// 解析第j组的配置
					var subMenuConfigStr:String=subMenuConfigArray[1];
					var subMenuConfig:Array=[];

					if (subMenuConfigStr.indexOf("all") > -1) {
						subMenuConfig=null
					} else {
						subMenuConfig=subMenuConfigStr.split(",");
						// 将配置放入配置数组
						for (var x:* in subMenuConfig) {
							subMenuConfig[x]=Number(subMenuConfig[x]);
						}
					}

					_subMenuStatus[Number(subMenuConfigArray[0])]=subMenuConfig; // 将配置数组放入子菜单配置堆栈
				}
					// for j
			}

			if (menuModuleString != "") {
				var statusArray:Array=menuModuleString.split(",");
				for (var i:uint=0; i < statusArray.length; i++) {
					// 设置模块菜单的状态
					_menuModule[int(statusArray[i])]=true;
				}
					// for i
			}
		}
		// function end
	}
	// class end
}
