package com.commUI {
	import game.module.quest.animation.ActionDriven;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;
	import net.AssetData;
	import net.LoadModel;
	import net.RESManager;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class ModuleLoader extends GComponent
	{
		protected var _model : LoadModel;

		private function initData() : void
		{
			_base.width = UIManager.stage.stageWidth;
			_base.height = UIManager.stage.stageHeight;
		}

		public function set model(value : LoadModel) : void
		{
			if (_model) removeModelEvents();
			_model = value;
			if (_model) addModelEvents();
		}

		private var _action : MovieClip;

		private var _msg : String = "";

		protected function addAction() : void
		{
			var g : Graphics = this.graphics;
			g.beginFill(0x000000, 0);
			g.drawRect(0, 0, 20, 20);
			g.endFill();
			this.width = UIManager.stage.stageWidth;
			_base.height = UIManager.stage.stageHeight;

			_action = RESManager.getMC(new AssetData("smallLoading", "smallLoader"));
			if (!_action) return;
			_action.x = (UIManager.stage.stageWidth - _action.width) / 2;
			_action.y = (UIManager.stage.stageHeight - _action.height) / 2;
			addChild(_action);
		}

		private  var _modalSkin : Sprite = ASSkin.emptySkin;
		
		public function addQuestMode() : Sprite
		{
			if (!_modalSkin)
				_modalSkin = ASSkin.emptySkin;
			_modalSkin.width = UIManager.stage.stageWidth;
			_modalSkin.height = UIManager.stage.stageHeight;
			if(!_modalSkin.parent)UIManager.root.addChild(_modalSkin);
			return _modalSkin;
		}

		public  function removeQuestMode() : Sprite
		{
			if (_modalSkin && _modalSkin.parent)
			{
				_modalSkin.parent.removeChild(_modalSkin);
			}
			return _modalSkin;
		}

		public function startShow(msg : String) : void
		{
			_msg = msg;
			show();
			this.visible=!ActionDriven.instance().isInQuestAction;
		}

		protected function initView() : void
		{
			addAction();
		}
		
		override public function hide():void
		{
			_action["update"]("", 100);
			super.hide();
		}

		override protected function onShow() : void
		{
			super.onShow();
			GLayout.layout(this);
			width = UIManager.stage.stageWidth;
			height = UIManager.stage.stageWidth;
			addQuestMode();
		}
		
		override protected function onHide() : void{
			super.onHide();
			removeQuestMode();
			resetLoader();
		}

		private function resetLoader() : void
		{
			_action["update"]("", 0);
		}

		private function addModelEvents() : void
		{
			_model.addEventListener(Event.INIT, initHandler);
			_model.addEventListener(Event.CHANGE, changeHandler);
			_model.addEventListener(Event.COMPLETE, completeHandler);
		}

		private function removeModelEvents() : void
		{
			_model.removeEventListener(Event.INIT, initHandler);
			_model.removeEventListener(Event.CHANGE, changeHandler);
			_model.removeEventListener(Event.COMPLETE, completeHandler);
		}

		private function completeHandler(event : Event) : void
		{
			_action["update"]("", 100);
			this.hide();
		}

		private function initHandler(event : Event) : void
		{
			if (!_action) return;
			_action["update"]("", 0);
		}

		override public function stageResizeHandler() : void
		{
			_action.x = (UIManager.stage.stageWidth - _action.width) / 2;
			_action.y = (UIManager.stage.stageHeight - _action.height) / 2;
			width = UIManager.stage.stageWidth;
			height = UIManager.stage.stageWidth;
			_modalSkin.width = UIManager.stage.stageWidth;
			_modalSkin.height = UIManager.stage.stageHeight;
		}

		private function changeHandler(event : Event) : void
		{
			if (_action)
				_action["update"](_msg+" (" + _model.done + "/" + _model.total + ")", _model.progress);
		}

		public function ModuleLoader(parent : Sprite)
		{
			_base = new GComponentData();
			_base.parent = parent;
			initData();
			super(_base);
			initView();
		}
	}
}
