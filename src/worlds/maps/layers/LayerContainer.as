package worlds.maps.layers
{
	import worlds.apis.MWorld;
	import worlds.apis.MStory;
	import worlds.auxiliarys.MapStage;
	import worlds.auxiliarys.MapPoint;
	import worlds.apis.MSelfPlayer;
	import worlds.apis.MValidator;

	import flash.display.DisplayObjectContainer;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.system.Capabilities;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;

	import game.manager.MouseManager;

	import worlds.WorldStartup;
	import worlds.apis.MapUtil;
	import worlds.maps.layers.lands.LandInstall;
	import worlds.maps.layers.lands.LandLayer;
	import worlds.mediators.MapMediator;
	import worlds.mediators.SelfMediator;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class LayerContainer
	{
		/** 单例对像 */
		private static var _instance : LayerContainer;

		/** 获取单例对像 */
		static public function get instance() : LayerContainer
		{
			if (_instance == null)
			{
				_instance = new LayerContainer(new Singleton());
			}
			return _instance;
		}

		function LayerContainer(singleton : Singleton) : void
		{
			singleton;
		}

		private var containerParent : DisplayObjectContainer;
		private var containerChildIndex : int;
		/** 容器 */
		public var container : Sprite;
		// ================
		// 层级
		// ================
		/** 陆地层 */
		public var landLayer : LandLayer;
		/** 传送门层 */
		public var gateLayer : GateLayer;
		/** 角色层 */
		public var roleLayer : RoleLayer;
		/** UI层 */
		public var uiLayer : UILayer;
		private var landInstall : LandInstall;
		private var bindScorll : Boolean = true;

		public function init() : void
		{
			container = WorldStartup.mapContainer;
			// var c:Sprite = WorldStartup.mapContainer;
			// c.x= 800;
			// c.y = 500;
			// c.scaleX = c.scaleY = 0.3;
			// container = new Sprite();
			// c.addChild(container);
			containerParent = container.parent;
			containerChildIndex = containerParent.getChildIndex(container);

			landInstall = LandInstall.instance;
			container.name = "mapContainer";
			landLayer = LandLayer.instance;
			landLayer.name = "landLayer";
			landLayer.init();
			gateLayer = new GateLayer(container);
			roleLayer = RoleLayer.instance;
			roleLayer.name = "roleLayer";
			uiLayer = new UILayer(container);

			container.addChild(landLayer);
			container.addChild(roleLayer);

			MapMediator.cBindScorll.register(setBindScroll);
			MapMediator.cbBindScorll.register(getBindScroll);
			MapMediator.cMouseEnabled.register(setMouseEnabled);
			MapMediator.cbMouseEnabled.register(getMouseEnabled);
			MapMediator.cMouseClick.register(mouseWalk);
			MapMediator.cbPrintScreen.register(printScreen);
			MapMediator.sMouseWalk.add(showMouseClickEffect);
			MapMediator.cShow.register(show);
			MapMediator.cHide.register(hide);

			roleLayer.addEventListener(MouseEvent.CLICK, onClick);
			landLayer.addEventListener(MouseEvent.CLICK, onClick);
			landLayer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			landLayer.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			container.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			MapStage.addStageResize(onStageResize);
		}

		public function onStageResize(...args : *) : void
		{
			args;
			if (MStory.storying) return;
			centerAlign();
		}

		public function resetMapSize(mapWidth : int, mapHeight : int) : void
		{
			roleLayer.resetMapSize(mapWidth, mapHeight);
			uiLayer.resetMapSize(mapWidth, mapHeight);
		}

		private function getBindScroll() : Boolean
		{
			return bindScorll;
		}

		private function setBindScroll(value : Boolean) : void
		{
			bindScorll = value;
			if (value)
			{
				// SelfMediator.sWalkTurn.add(move);
				SelfMediator.sPosition.add(updatePosition);
			}
			else
			{
				// SelfMediator.sWalkTurn.remove(move);
				SelfMediator.sPosition.remove(updatePosition);
			}
		}

		private function getMouseEnabled() : Boolean
		{
			return landLayer.mouseEnabled;
		}

		private function setMouseEnabled(value : Boolean) : void
		{
			landLayer.mouseEnabled = value;
		}

		// =========================
		// 鼠标事件
		// =========================
		private var mouseDownTimer : uint;
		private var preClickTime : Number = 0;

		private function onClick(event : MouseEvent) : void
		{
			if (getTimer() - preClickTime < 300)
			{
				return;
			}
			mouseWalk();
			preClickTime = getTimer();
		}

		private function onMouseDown(event : MouseEvent) : void
		{
			clearInterval(mouseDownTimer);
			mouseDownTimer = setInterval(mouseWalk, 300);
			landLayer.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function onMouseUp(event : MouseEvent) : void
		{
			landLayer.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			clearInterval(mouseDownTimer);
		}

		private var mouseX : int;
		private var mouseY : int;

		private function mouseWalk() : void
		{
			if (!landLayer.mouseEnabled) return;
			mouseX = landLayer.mouseX;
			mouseY = landLayer.mouseY;

			var result : Boolean = MValidator.walk.doValidation(MapMediator.sMouseWalk.dispatch, [mouseX, mouseY]);
			if (result)
			{
				MapMediator.sMouseWalk.dispatch(mouseX, mouseY);
			}
		}

		// =========================
		// 鼠标点击陆地特效
		// =========================
		private var clickEffect : MovieClip;

		private function showMouseClickEffect(toX : int, toY : int) : void
		{
			if (clickEffect == null)
			{
				var myClass : Class = MouseManager.MapMouseDownEffect;
				if (myClass)
				{
					clickEffect = new myClass();
					clickEffect.name = "clickEffect";
				}
				else
				{
					return;
				}
			}
			clickEffect.x = toX;
			clickEffect.y = toY;
			clickEffect.gotoAndPlay(1);
			if (clickEffect.parent == null) container.addChildAt(clickEffect, 1);
		}

		/** 频幕截图 */
		public function printScreen(centerX : int, centerY : int, width : uint = 0, height : uint = 0) : BitmapData
		{
			if (width == 0)
			{
				width = flash.system.Capabilities.screenResolutionX;
			}

			if (height == 0)
			{
				height = flash.system.Capabilities.screenResolutionY;
			}
			var halfScreenWidth : int = width / 2;
			var halfScreenHeight : int = height / 2;
			var mapWidth : int = MapUtil.mapWidth;
			var mapHeight : int = MapUtil.mapHeight;
			if (centerX < halfScreenWidth)
			{
				width = centerX * 2;
			}

			if (centerX + halfScreenWidth > mapWidth)
			{
				width = Math.min((mapWidth - centerX) * 2, width);
			}

			if (centerY < halfScreenHeight)
			{
				height = centerY * 2;
			}

			if (centerY + halfScreenHeight > mapHeight)
			{
				height = Math.min((mapHeight - centerY) * 2, height);
			}

			var matrix : Matrix = new Matrix();
			matrix.tx -= centerX - width / 2;
			matrix.ty -= centerY - height / 2;

			var bitmapData : BitmapData = new BitmapData(width, height, false, 0xFF0000);
			bitmapData.draw(LandLayer.instance, matrix);
			return bitmapData;
		}

		// ========================
		// 显示/隐藏
		// ========================
		private function show() : void
		{
			if (container.parent) return;
			containerParent.addChildAt(container, containerChildIndex);
		}

		private function hide() : void
		{
			if (!container.parent) return;
			if (container.parent) container.parent.removeChild(container);
		}

		// ========================
		// 位置
		// ========================
		private var num : int = 0;

		private function setPosition(mapX : int, mapY : int, forceLoad : Boolean = false) : void
		{
			num++;
			container.x = mapX ;
			container.y = mapY;
			if (forceLoad == false && num < 20)
			{
				num = 0;
				landInstall.loadMapPosition(-mapX, -mapY);
			}
		}

		public function initPosition(mapX : int, mapY : int) : void
		{
			this.mapX = mapX;
			this.mapY = mapY;
			container.x = mapX;
			container.y = mapY;
		}

		public var mapX : int;
		public var mapY : int;

		public function updatePosition(selfX : int, selfY : int) : void
		{
			mapX = MapUtil.selfToMapX(selfX);
			mapY = MapUtil.selfToMapY(selfY);
			if (mapX == container.x && mapY == container.y) return;
			setPosition(mapX, mapY);
		}

		public function centerAlign() : void
		{
			var point : MapPoint ;
			if (MWorld.isInstallComplete)
			{
				point = MSelfPlayer.position;
				if (point == null)
				{
					point = new MapPoint();
					point.x = MSelfPlayer.struct.x;
					point.y = MSelfPlayer.struct.y;
				}
			}
			else
			{
				if(!MSelfPlayer.struct) return;
				point = new MapPoint();
				point.x = MSelfPlayer.struct.x;
				point.y = MSelfPlayer.struct.y;
			}
			updatePosition(point.x, point.y);
		}
	}
}
class Singleton
{
}