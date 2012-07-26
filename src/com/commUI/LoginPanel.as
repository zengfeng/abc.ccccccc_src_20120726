package com.commUI {
	import game.config.StaticConfig;
	import game.net.core.Common;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.controls.GPoster;
	import gameui.controls.GTextInput;
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.data.GTextInputData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import utils.GStringUtil;

	import com.utils.SHA1;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.ByteArray;





	/**
	 * @author yangyiqiang
	 */
	public class LoginPanel extends  GPanel
	{
		private var _poster : GPoster;
		private var _username_ti : GTextInput;

		private var _server_ti : GTextInput;

		private var _login_btn : GButton;

		private var _username : String;

		private var _server : String;

		private var _info_lb : GLabel;

		private function initData() : void
		{
			_data.bgAsset = new AssetData(SkinStyle.panel_backgroundSkin, AssetData.AS_LIB);
			_data.filters = [new DropShadowFilter(3, 45, 0, 0.5, 3, 3)];
			_data.align = new GAlign(-1, -1, -1, -1, 10, 0);
			_data.width = 300;
			_data.height = 288;
		}

		private function addLabels() : void
		{
			var data : GLabelData = new GLabelData();
			data.x = 20;
			data.y = 157;
			data.text = "欢迎来到开天辟地";
			data.textColor = 0xFFFF00;
			_info_lb = new GLabel(data);
			add(_info_lb);
			data = new GLabelData();
			data.x = 20;
			data.y = 185;
			data.text = "帐户ID:";
			var username_lb : GLabel = new GLabel(data);
			add(username_lb);
			data = data.clone();
			data.x = 20;
			data.y = 215;
			data.text = "服务器:";
			var pwd_lb : GLabel = new GLabel(data);
			add(pwd_lb);
		}

		private function addButtons() : void
		{
			var data : GButtonData = new GButtonData();
			data.upAsset = new AssetData(SkinStyle.button_upSkin, AssetData.AS_LIB);
			data.overAsset = new AssetData(SkinStyle.button_overSkin, AssetData.AS_LIB);
			data.downAsset = new AssetData(SkinStyle.button_downSkin, AssetData.AS_LIB);
			data.disabledAsset = new AssetData(SkinStyle.button_disabledSkin, AssetData.AS_LIB);
			data.labelData.textColor = 0x330000;
			data.rollOverColor = 0x660000;
			data.disabledColor = 0x000011;
			data.labelData.textFieldFilters = UIManager.getEdgeFilters(0xFFFFFF, 0.2);
			data.x = 70;
			data.y = 245;
			data.width = 70;
			data.height = 28;
			data.labelData.text = "<b>登录游戏</b>";
			_login_btn = new GButton(data);
			add(_login_btn);
		}

		private function addTextInputs() : void
		{
			var data : GTextInputData = new GTextInputData();
			data.x = 60;
			data.y = 183;
			data.width = 150;
			data.maxChars = 16;
			data.restrict = "a-zA-Z0-9.:^";
			data.allowIME = false;
			data.text = Common.los.getAt("username") == null ? "" : String(Common.los.getAt("username"));
			_username_ti = new GTextInput(data);
			data = data.clone();
			data.y = 214;
			data.maxChars = 30;
			data.text = Common.los.getAt("serverNumber") == null ? "" : String(Common.los.getAt("serverNumber"));
			_server_ti = new GTextInput(data);
			addChild(_username_ti);
			addChild(_server_ti);
		}

		private function initView() : void
		{
			addLabels();
			addButtons();
			addTextInputs();
			addPoster();
		}
		
		private function addPoster() : void {
			var data : GComponentData = new GComponentData();
			data.x = 10;
			data.y = 10;
			data.width = 280;
			data.height = 135;
			_poster = new GPoster(data);
			add(_poster);
		}

		private function initEvents() : void
		{
			_server_ti.addEventListener(GTextInput.ENTER, pwd_enterHandler);
			_login_btn.addEventListener(MouseEvent.CLICK, login_clickHandler);
		}

		private function clearEvents() : void
		{
			_server_ti.removeEventListener(GTextInput.ENTER, pwd_enterHandler);
			_login_btn.removeEventListener(MouseEvent.CLICK, login_clickHandler);
		}

		private function pwd_enterHandler(event : Event) : void
		{
			onLogin();
		}

		private function login_clickHandler(event : MouseEvent) : void
		{
			onLogin();
		}
		
		private function toHexPadding(num: uint): String
		{
			var r: String = num.toString(16).toLowerCase();
			if (r.length > 8)
				return r.substr(0, 8);
			for (var i: int = 0; i < 8 - r.length; i ++)
			{
				r = '0' + r;
			}
			return r;
		}

		private function onLogin() : void
		{
			_username = GStringUtil.trim(_username_ti.text);
			_server = GStringUtil.trim(_server_ti.text);
			if (_username.length == 0)
			{
				_info_lb.text = "请输入帐号ID!";
				_username_ti.setFocus();
				return;
			}
			Common.los.setAt("username", _username);
			Common.los.setAt("serverNumber", _server);
			enabled = false;
			this.hide();
			clearEvents();
			_callFun();
			StaticConfig.userId=_username;
			StaticConfig.serversString = _server;
			
			/* 生成验证Key */
			var static_key: String = "v5948y8E";
			var now: uint = (new Date).time / 1000;
			var rnd: uint = Math.random() * 2000000000;
			var shift: uint = rnd ^ now;
			var data: String = _username + toHexPadding(shift) + static_key;
			var sha1: SHA1 = new SHA1;
			var ba: ByteArray = new ByteArray;
			ba.writeUTFBytes(data);
			ba = sha1.hash(ba);
			var result: String = '';
			for (var i: uint = 0; i < ba.length; i ++)
			{
				if (ba[i] < 16)
					result = result + '0' + ba[i].toString(16);
				else
					result += ba[i].toString(16);
			}
			StaticConfig.key = result + toHexPadding(rnd) + toHexPadding(shift);
		}

		public function resetFocus() : void
		{
			if (_username_ti.text.length > 0)
				_server_ti.setFocus();
			else
				_username_ti.setFocus();
		}

		override protected function onShow() : void
		{
			super.onShow();
			GLayout.layout(this);
			resetFocus();
		}

		private var _callFun : Function;

		public function LoginPanel(parent : Sprite, callFun : Function)
		{
			_data = new GPanelData();
			_data.parent = parent;
			_callFun = callFun;
			initData();
			super(_data);
			initView();
			initEvents();
		}
	}
}
