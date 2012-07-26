package game.module.quest.guide {
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.quest.QuestDisplayManager;
	import game.module.quest.QuestUtil;

	import gameui.manager.UIManager;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import worlds.apis.MLoading;
	import worlds.apis.MapUtil;
	import worlds.maps.configs.structs.MapStruct;

	import com.greensock.TweenLite;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class GuideMange
	{
		private static var _instance : GuideMange;
		private var _guideLogo : MovieClip;
		private var _guideLogoTop : MovieClip;
		/** 新手引导的 */
		public static const GUIDE_MAX : int = 20;

		public function GuideMange()
		{
			if (_instance)
			{
				throw Error("GuideMange 是单类，不能多次初始化!");
			}
			MLoading.sAllComplete.add(changeMapId);
		}

		public static function getInstance() : GuideMange
		{
			if (_instance == null)
			{
				_instance = new GuideMange();
			}
			return _instance;
		}

		/**
		 * 加载新手引导资源
		 */
		public function addToLoad(res : RESManager) : void
		{
			if (GuideProxy.getInstance().isFinish(1))
				res.add(new SWFLoader(new LibData(VersionManager.instance.getUrl("assets/quest/map1.swf"), "map1")));
		}

		private var _mc : MovieClip;
		
//		private function toMap():void
//		{
//			setTimeout(changeMapId, 2000);
//		}
		// 地图引导
		private function changeMapId() : void
		{
			var mapStruct : MapStruct = MapUtil.currentMapStruct;
			if (mapStruct.id >= 20) return;
			if (GuideProxy.getInstance().isFinish(mapStruct.id))
			{
				if (mapStruct.id == 1) checkFirstQuest();
				return;
			}
			_mc = RESManager.getMC(new AssetData("map", "map" + mapStruct.id));
			if (!_mc)
			{
				RESManager.instance.add(new SWFLoader(new LibData(VersionManager.instance.getUrl("assets/quest/map" + mapStruct.id + ".swf"), "map" + mapStruct.id), playMap, [mapStruct.id]));
				return;
			}
			playMap(mapStruct.id);
		}

		private function playMap(mapId : int, mc : MovieClip = null) : void
		{
			if (!mc)
				_mc = RESManager.getMC(new AssetData("map", "map" + mapId));
			if (!_mc) return;
			_mc.x = (UIManager.stage.stageWidth - 308) / 2;
			_mc.y = 100;
			_mc.addEventListener("hide", listener);
			UIManager.root.addChild(_mc);
			_mc.gotoAndPlay(0);
			GuideProxy.getInstance().guideUpdate(mapId);
			ViewManager.instance.uiContainer.alpha = 0;
			ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).alpha = 0;
			QuestUtil.addQuestMode();
		}

		private function listener(event : Event) : void
		{
			if (!_mc) return;
			TweenLite.to(_mc, 1, {delay:2, alpha:0, onComplete:removeMc});
			_mc.removeEventListener("hide", listener);
			removeMap();
		}

		private function removeMap() : void
		{
			ViewManager.instance.uiContainer.alpha = 1;
			ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).alpha = 1;
			QuestUtil.removeQuestMode();
			checkFirstQuest();
		}

		private function removeMc() : void
		{
			if (_mc && UIManager.root.contains(_mc)) UIManager.root.removeChild(_mc);
		}

		private function checkFirstQuest() : void
		{
			QuestDisplayManager.getInstance().questView.traceTasks(true);
		}

		private var _guideDic : Dictionary = new Dictionary();

		public function initVo(value : VoGuide) : void
		{
			_guideDic[value.id] = value;
		}

		public function getVo(id : int) : VoGuide
		{
			return _guideDic[id];
		}

		public function checkAllGuide() : void
		{
			for each (var vo:VoGuide in _guideDic){
				if(vo.type==1)continue;
				vo.checkNextStep();
			}
		}

		public function checkGuideByMenuid(id : int, step : int = -1, view : Sprite = null) : void
		{
			for each (var vo:VoGuide in _guideDic)
			{
				if (vo.targetId == id)
				{
					vo.checkNextStep(step, view);
					return;
				}
			}
		}

		public function checkGuide(id : int, step : int = -1, view : Sprite = null) : void
		{
			var vo : VoGuide = _guideDic[id];
			if (!vo) return;
			vo.checkNextStep(step, view);
		}

		public function resetAndCheckGuide(id : int) : void
		{
			for each (var vo:VoGuide in _guideDic)
			{
				if (vo.targetId == id)
				{
					if (vo.checkLastStep()) return;
					vo.reset();
					vo.checkNextStep();
					return;
				}
			}
		}

		public function moveTo(x : Number, y : Number, str : String = "点击继续任务", superContainer : DisplayObjectContainer = null, type : int = 0) : void
		{
			if (!superContainer) superContainer = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			if (type == 0)
			{
				if (!_guideLogo) _guideLogo = RESManager.getMC(new AssetData("guideArrows", "quest"));
				_guideLogo.name = "guideArrows";
				superContainer.addChild(_guideLogo);
				_guideLogo["string"] = str;
				TweenLite.killTweensOf(_guideLogo);
				TweenLite.to(_guideLogo, 0.3, {x:x, y:y, onComplete:complete, onCompleteParams:[superContainer], overwrite:0});
				// trace(superContainer.toString(),x,y);
			}
			else
			{
				if (!_guideLogoTop) _guideLogoTop = RESManager.getMC(new AssetData("guideArrows2", "quest"));
				_guideLogo.name = "guideArrows";
				superContainer.addChild(_guideLogo);
				_guideLogo["string"] = str;
				TweenLite.to(_guideLogoTop, 0.3, {x:x, y:y, overwrite:1});
			}
		}

		private function complete(sprite : Sprite) : void
		{
			sprite.addChild(_guideLogo);
			// trace("complete====>"+sprite.toString());
		}

		public function hide(type : int = 0) : void
		{
			if (type == 0)
			{
				if (_guideLogo && _guideLogo.parent) _guideLogo.parent.removeChild(_guideLogo);
			}
			else
			{
				if (_guideLogoTop && _guideLogoTop.parent) _guideLogoTop.parent.removeChild(_guideLogoTop);
			}
		}
	}
}
