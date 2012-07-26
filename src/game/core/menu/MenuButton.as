package game.core.menu {
	import game.manager.PreLoadManager;
	import worlds.players.PlayerControl;
	import worlds.apis.MValidator;
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.module.mapWorld.WorldMapController;
	import game.module.quest.QuestUtil;
	import game.module.quest.guide.GuideMange;
	import game.net.core.Common;

	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.data.GButtonData;
	import gameui.data.GToolTipData;
	import gameui.manager.UIManager;

	import net.ALoader;
	import net.AssetData;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class MenuButton extends GButton implements IMenuButton {
		protected var _vo : VoMenuButton;
		protected var _type : int = 0;
		public var isShowIng : Boolean = false;

		public function MenuButton(data : GButtonData, vo : VoMenuButton, type : int = 0) {
			data.width = 45;
			data.height = 60;
			data.toolTipData = new GToolTipData();
			_type = type;
			_vo = vo;
			super(data);
			this.vo = vo;
		}

		private var timer : int = getTimer();

		protected function onClick(event : MouseEvent) : void {
			if(vo.id==25)
			{
				PlayerControl.instance.isHideOther = !PlayerControl.instance.isHideOther;
				return;
			}
			if (getTimer() - timer < 500) return;
			timer = getTimer();
			if (vo.id == 21) {
				var result :Boolean = MValidator.changeMap.doValidation(WorldMapController.instance.open);
				if(result == false) return;
				WorldMapController.instance.open();
				return;
			} else if (vo.id == MenuType.PRACTICE) {
				showTargetView();
			}
			MenuManager.getInstance().changMenu(_vo.id);
			event.stopPropagation();
		}

		private var _class : Class;

		private function resetClass() : void {
			try {
				_class = UIManager.appDomain.getDefinition(_vo.classString) as Class;
			} catch(e : Error) {
				_class = null;
			}
		}

		public function setClass(cl : Class) : void {
			_class = cl;
		}

		private var _isBusy : Boolean = false;

		private function initClass() : void {
			if (_target || _isBusy) return;
			if (_class) {
				if (_class["instance"]) {
					_target = _class["instance"];
				} else {
					_target = new _class as GComponent;
				}
				_target.source = vo;
				RESManager.instance.remove(_vo.url);
				var resList:Array = (_target is IAssets)?(_target as IAssets).getResList():null;
				if (_target is IAssets && resList && resList.length > 0) {
					_isBusy = true;
					var libData : LibData;

					for each (var item:* in resList) {
						if (item is ALoader) {
							RESManager.instance.add(item);
						} else {
							if (item is LibData)
								libData = item;
							else if (item is String)
								libData = new LibData(item);
							else
								continue;
							if (libData.cls)
								RESManager.instance.add(new libData.cls(libData));
							else
								RESManager.instance.add(new SWFLoader(libData));
						}
					}
					RESManager.instance.addEventListener(Event.COMPLETE, loadAssComplete);
					PreLoadManager.instance.moduleLoader.startShow("");
					RESManager.instance.startLoad();
				} else if (_target is IModuleInferfaces)
					(_target as IModuleInferfaces).initModule();
			} else {
				_isBusy = true;
				var rslloader : SWFLoader = new SWFLoader(new LibData(_vo.url));
				rslloader.funArray.push({fun:initLoadClass, params:[rslloader]});
				RESManager.instance.add(rslloader);
				PreLoadManager.instance.moduleLoader.startShow("");
				RESManager.instance.startLoad();
			}
		}

		private function loadAssComplete(event : Event) : void {
			_isBusy = false;
			RESManager.instance.removeEventListener(Event.COMPLETE, loadAssComplete);
			if (_target is IModuleInferfaces)
				(_target as IModuleInferfaces).initModule();
			MenuManager.getInstance().openMenuView(vo.id);
		}

		private function initLoadClass(loader : SWFLoader) : void {
			_isBusy = false;
			if (_target) return;
			PreLoadManager.instance.moduleLoader.hide();
			_class = loader.getClass(_vo.classString);
			initClass();
			if (!_isBusy)
				MenuManager.getInstance().openMenuView(vo.id);
		}

		private function closeTarget() : void {
			_target.hide();
			GuideMange.getInstance().resetAndCheckGuide(_vo.id);
			QuestUtil.checkQuide();
			_isBusy = false;
		}

		private function openTarget() : Boolean {
			if (!_target) return false;
			GuideMange.getInstance().checkGuideByMenuid(_vo.id);
			_target.show();
			removeMenuMc();
			_isBusy = false;
			return true;
		}

		private var _mc : MovieClip;

		// 1:荷花   2:有文字   3:感叹号
		public function addMenuMc(type : int = 1, text : String = "", x : int = 10, y : int = -26) : void {
			if (!_mc)
				_mc = RESManager.getMC(new AssetData("bubble" + type, "quest"));
			if (!_mc) return;
			else removeMenuMc();
			_mc.x = x;
			_mc.y = y;
			if (type == 2)
				_mc["actionMC"]["text"]["text"] = text;
			addChild(_mc);
		}

		public function removeMenuMc() : void {
			if (_mc && _mc.parent) _mc.parent.removeChild(_mc);
		}

		public function set vo(value : VoMenuButton) : void {
			if (!value) return;
			_vo = value;
			resetClass();
			this.toolTip.source = _vo.tips;
		}

		public function get vo() : VoMenuButton {
			return _vo;
		}

		private var _target : GComponent;

		public function set target(value : GComponent) : void {
			_target = value;
		}

		public function get target() : GComponent {
			return _target;
		}

		public function showTargetView() : Boolean {
			initClass();

			if (_isBusy) return  false;
			return openTarget();
		}

		public function hideTargetView() : void {
			if (_target && _target.parent)
				closeTarget();
		}

		override protected function create() : void {
			if (_type == 0) {
				super.create();
			} else {
				var obj : DisplayObject = vo.disObj;
				if (!obj) return;
				obj["tabEnabled"] = false;
				addChild(obj);
			}
		}

		override protected function layout() : void {
			if (_type == 0) super.layout();
		}

		override protected function onShow() : void {
			if (_type == 0) super.onShow();
			addEventListener(MouseEvent.CLICK, onClick);
		}

		override protected function onHide() : void {
			if (_type == 0) super.onHide();
			removeEventListener(MouseEvent.CLICK, onClick);
		}
	}
}
