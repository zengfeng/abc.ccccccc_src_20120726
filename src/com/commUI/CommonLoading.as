package com.commUI {
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.LoadModel;
	import net.RESManager;

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class CommonLoading extends GComponent {
		private var _msg : String = "";
		protected var _model : LoadModel;
		private var _action : MovieClip;

		protected function addAction() : void {
			var g : Graphics = this.graphics;
			g.beginFill(0x000000);
			g.drawRect(0, 0, UIManager.stage.stageWidth, UIManager.stage.stageHeight);
			g.endFill();
			_action = RESManager.getMC(new AssetData("loading", "loading"));
			if (!_action) return;
			_action.x = (UIManager.stage.stageWidth - 456) / 2;
			_action.y = (UIManager.stage.stageHeight - 251) / 2;
			addChild(_action);
		}

		private function changeHandler(event : Event) : void {
			if (isSetupMapProgress || isLoadMapProgress) return;
			_msg = "正在加载资源 (" + RESManager.instance.model.done + "/" + RESManager.instance.model.total + ")  " + RESManager.instance.model.speed + " KB/S";
			updateProgress(_msg,RESManager.instance.model.progress);
		}

		private function initHandler(event : Event) : void {
			if (!_action) return;
			_action["update"]("", 0);
		}

		private function completeHandler(event : Event) : void {
			if (isSetupMapProgress || isLoadMapProgress) return;
			_action["update"]("", 100);
			if (_isCompleteHide)
				this.hide();
		}


		public function set model(value : LoadModel) : void {
			if (_model) removeModelEvents();
			_model = value;
			if (_model) addModelEvents();
		}

		private function addModelEvents() : void {
			_model.addEventListener(Event.INIT, initHandler);
			_model.addEventListener(Event.CHANGE, changeHandler);
			_model.addEventListener(Event.COMPLETE, completeHandler);
		}

		private function removeModelEvents() : void {
			_model.removeEventListener(Event.INIT, initHandler);
			_model.removeEventListener(Event.CHANGE, changeHandler);
			_model.removeEventListener(Event.COMPLETE, completeHandler);
		}

		private var _isCompleteHide : Boolean = true;

		public function startShow(isCompleteHide : Boolean = true) : void {
			UIManager.root.addChild(this);
			_isCompleteHide = isCompleteHide;
			stageResizeHandler1(new Event(""));
		}

		public function CommonLoading() {
			_base = new GComponentData();
			_base.parent = UIManager.root;
			super(_base);
			addAction();
		}

		public function open() : void {
			UIManager.root.addChild(this);
			if (!_action) return;
			stageResizeHandler1(new Event(""));
			_action["update"]("", 0);
		}

		public function updateProgress(text : String = null, progress : int = 100) : void {
			_action["update"](text, progress);
		}

		public var isSetupMapProgress : Boolean = false;

		public function setupMapProgress(progress : int) : void {
			updateProgress("安装地图中....", progress);
		}

		public var isLoadMapProgress : Boolean = false;

		public function loadMapProgress(progress : int) : void {
			updateProgress("加载地图中....", progress);
		}

		private function stageResizeHandler1(event : Event) : void {
			var g : Graphics = this.graphics;
			g.beginFill(0x000000);
			g.drawRect(0, 0, UIManager.stage.stageWidth, UIManager.stage.stageHeight);
			g.endFill();
			if (!_action)
				_action = RESManager.getMC(new AssetData("loading", "loading"));
			_action.x = (UIManager.stage.stageWidth - 456) / 2;
			_action.y = (UIManager.stage.stageHeight - 251) / 2;
			addChild(_action);
		}

		override protected function onShow() : void {
			super.onShow();
			this.stage.addEventListener(Event.RESIZE, stageResizeHandler1);
		}

		override protected function onHide() : void {
			super.onHide();
			this.stage.removeEventListener(Event.RESIZE, stageResizeHandler1);
		}
	}
}
