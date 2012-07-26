package game.module.mapWorld
{
	import flash.utils.setTimeout;
	import worlds.apis.MapUtil;
	import worlds.apis.MTo;
	import worlds.apis.MSelfPlayer;

	import com.commUI.CommonLoading;
	import com.commUI.alert.Alert;
	import com.greensock.TweenLite;
	import com.utils.UIUtil;
	import com.utils.UrlUtils;

	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import game.core.user.UserData;
	import game.net.core.Common;
	import game.net.data.CtoC.CCUserDataChangeUp;

	import gameui.manager.UIManager;

	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-26 ����2:18:06
	 */
	public class WorldMapView extends Sprite
	{
		public function WorldMapView(singleton : Singleton)
		{
			singleton;
			loaderPanel = Common.getInstance().loadPanel;
			resManager = RESManager.instance;
		}

		/** 单例对像 */
		private static var _instance : WorldMapView;

		/** 获取单例对像 */
		static public function get instance() : WorldMapView
		{
			if (_instance == null)
			{
				_instance = new WorldMapView(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		override public function get stage() : Stage
		{
			return UIUtil.stage;
		}

		public function get container() : DisplayObjectContainer
		{
			return UIManager.root;
		}

		private var _controller : WorldMapController;

		public function get controller() : WorldMapController
		{
			if (_controller == null)
			{
				_controller = WorldMapController.instance;
			}
			return _controller;
		}

		// // // // // // // // // //////////////////////////////////////////////////////
		// 加载
		// // // // // // // // // //////////////////////////////////////////////////////
		private var loaderPanel : CommonLoading;
		private var resManager : RESManager;
		public var loaded : Boolean = false;
		public var loading : Boolean = false;
		private var loaderKey : String = "worldMap";
		public var worldMapSWF : *;
		private var worldMapSWFSprit : Sprite;

		public function load() : void
		{
			if (loading == true) return;
			loading = true;
			resManager.add(new SWFLoader(new LibData(UrlUtils.FILE_WORLD_MAP, loaderKey)));
			resManager.addEventListener(Event.COMPLETE, loadComplete);
			loaderPanel.show();
			resManager.startLoad();
			loaderPanel.startShow(false);
		}

		private function loadComplete(event : Event) : void
		{
			loaderPanel.hide();
			resManager.removeEventListener(Event.COMPLETE, loadComplete);
			if (loaded == true)
			{
				Alert.show(loaderKey + "我已经加载过了");
				return;
			}
			loaded = true;
			loading = false;
			// 读取加载
			var loader : SWFLoader = RESManager.getLoader(loaderKey);
			worldMapSWF = loader.getContent() ;
			worldMapSWF.leaveClickCall = leaveClickCall;
			worldMapSWF.toMapCall = clickIconCall;
			worldMapSWFSprit = loader.getContent() as Sprite;
			addChild(worldMapSWFSprit);
			// 清除加载缓存
			resManager.remove(loaderKey);
			show();
		}

		private function leaveClickCall() : void
		{
			if (controller.isAuto)
			{
				MTo.clear();
				MSelfPlayer.setClanName("", "");
			}
			else if (MapUtil.isDuplMap())
			{
				MTo.clear();
				MSelfPlayer.setClanName("", "");
			}
			hide();
		}

		private function clickIconCall(mapId : int) : void
		{
			MTo.clear();
			MSelfPlayer.setClanName("", "");
			controller.toMap(mapId);
		}

		// // // // // // // // // //////////////////////////////////////////////////////
		// 显示
		// // // // // // // // // //////////////////////////////////////////////////////
		public var showInsideCall : Function;
		public var showEndCall : Function;
		public var worldMapPlayer : WorldMapPlayer = WorldMapPlayer.instance;
		public var isShow : Boolean = false;

		public function show() : void
		{
			if (loaded == false)
			{
				load();
				return;
			}
			isShow = true;
			if (showInsideCall != null) showInsideCall.apply();
			layout();
			updateMapItemVisiable();
			this.alpha = 1;
			container.addChild(this);
			var point : Point = worldMapSWF.getMapPosition(controller.currentMapId);
			worldMapPlayer.x = point.x;
			worldMapPlayer.y = point.y;
			worldMapPlayer.updateAvatar();
			worldMapSWFSprit.addChild(worldMapPlayer);
			stage.addEventListener(Event.RESIZE, onStageResize);
			this.mouseEnabled = true;
			if (showEndCall != null) showEndCall.apply();

			// CC协议监听 -- 0xFFF1 玩家信息改变
			Common.game_server.addCallback(0xFFF1, cc_userDataChange);
		}

		/** CC协议监听 -- 0xFFF1 玩家信息改变 */
		private function cc_userDataChange(msg : CCUserDataChangeUp) : void
		{
			if ((msg.level - msg.oldLevel) != 0)
			{
				updateMapItemVisiable();
			}
		}

		private function onStageResize(event : Event) : void
		{
			layout();
		}

		public function layout() : void
		{
			drawBg();
			if (worldMapSWFSprit != null) UIUtil.alignStageCenter(worldMapSWFSprit);
		}

		// // // // // // // // // //////////////////////////////////////////////////////
		// 隐藏
		// // // // // // // // // //////////////////////////////////////////////////////
		public function hide() : void
		{
			isShow = false;
			this.mouseEnabled = false;
			worldMapPlayer.close();
			// CC协议监听 -- 0xFFF1 玩家信息改变
			Common.game_server.removeCallback(0xFFF1, cc_userDataChange);
//			TweenLite.to(this, 0.5, {alpha:0, onComplete:hideEnd});
			setTimeout(hideEnd, 500);
		}

		public function hideEnd() : void
		{
			stage.removeEventListener(Event.RESIZE, onStageResize);
			if (parent != null) parent.removeChild(this);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 绘制背景 */
		public function drawBg() : void
		{
			var g : Graphics = this.graphics;
			g.beginFill(0x0);
			g.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			g.endFill();
		}

		/** 更新显示地图 */
		public function updateMapItemVisiable() : void
		{
			var level : int = UserData.instance.level;
			var worldMap : Dictionary = WorldMapConfig.worldMap;
			for each (var worldMapStruct:WorldMapStruct in worldMap)
			{
				if (worldMapStruct.openLevel <= level)
				{
					worldMapSWF.mapOn(worldMapStruct.id);
				}
				else
				{
					worldMapSWF.mapOff(worldMapStruct.id);
				}
			}
		}

		/** 去某个地图 */
		public function toMap(mapId : int) : void
		{
			var point : Point = worldMapSWF.getMapPosition(mapId);
			worldMapPlayer.moveTo(point.x, point.y);
		}
	}
}
class Singleton
{
}