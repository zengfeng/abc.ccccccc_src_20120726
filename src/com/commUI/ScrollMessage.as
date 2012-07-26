package com.commUI {
	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.data.GLabelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import worlds.apis.MSelfPlayer;

	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;




	/**
	 * @author yangyiqiang
	 */
	public class ScrollMessage
	{
		private static var _instance : ScrollMessage;

		private static var _alert : sorollAlert;

		public function ScrollMessage()
		{
			if (_instance)
			{
				throw Error("---ScrollMessage--is--a--single--model---");
			}
			_timer = new Timer(600);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_message = new Vector.<String>();

			_timer2 = new Timer(600);
			_timer2.addEventListener(TimerEvent.TIMER, timerHandler2);
			_message2 = new Vector.<String>();
		}

		public static function get instance() : ScrollMessage
		{
			if (_instance == null)
			{
				_instance = new ScrollMessage();
				_alert = new sorollAlert();
			}
			return _instance;
		}

		private var _timer : Timer;

		private var _message : Vector.<String>;

		/** 在主将身上 滚屏 */
		public function sorollOnMyAvatar(str : String) : void
		{
			_message.push(str);
			if (!_timer.running)
			{
				execute();
				_timer.start();
			}
		}

		private function timerHandler(event : TimerEvent) : void
		{
			if (_message.length == 0)
			{
				_timer.stop();
			}else{
				execute();
			}
		}

		private function execute() : void
		{
			if (!MSelfPlayer.avatar) return;
			MSelfPlayer.avatar.sorollMsg(_message.shift());
		}

		/** 在屏幕中央 滚arert */
		public function soroll(msg : String) : void
		{
			var arertY : int = (UIManager.stage.stageHeight - _alert.height) / 2 + 50;
			_alert.setMsg(msg);
			_alert.x = (UIManager.stage.stageWidth - _alert.width) / 2;
			_alert.y = arertY;
			_alert.alpha = 0;
			_alert.show();
			TweenLite.to(_alert, 0.3, {alpha:1, y:arertY - 100, onComplete:hideAlert, onCompleteParams:[arertY],ease:Quint.easeOut});
		}

		private var _textData : GLabelData = new GLabelData();

		private var _timer2 : Timer;

		private var _message2 : Vector.<String>;

		/** 在mouse坐标 滚屏 */
		public function sorollMssage(msg : String,parent:Sprite=null,x:int=-1,y:int=-1) : void
		{
			_message2.push(msg);
			if (!_timer2.running)
			{
				executeOffMouse(parent,x,y);
				_timer2.start();
			}
		}
		
		private function executeOffMouse(parent:Sprite=null,x:int=-1,y:int=-1) : void
		{
			var _x : Number = x==-1?UIManager.stage.mouseX:x;
			var _y : Number = x==-1?(UIManager.stage.mouseY-30):y;
			if(!parent)parent=UIManager.root;
			_textData.width = 200;
			_textData.align = new GAlign(_x, -1, _y);
			_textData.textColor = 0x00ff00;
			_textData.textFormat = UIManager.getTextFormat(14);
			var text : GLabel = new GLabel(_textData);
			parent.addChild(text);
			text.htmlText = _message2.shift();
			GLayout.layout(text);
			TweenLite.to(text, 4, {y:_y - 170, onComplete:sorollEnd, onCompleteParams:[text],overwrite:0,ease:Quint.easeOut});
			TweenLite.to(text, 3, {delay:1,alpha:0, overwrite:0,ease:Quint.easeOut});
		}

		private function timerHandler2(event : TimerEvent) : void
		{
			if (_message2.length == 0)
			{
				_timer2.stop();
			}else{
				executeOffMouse();
			}
		}

		private function sorollEnd(text : GLabel) : void
		{
			if(text&&text.parent)text.parent.removeChild(text);
		}

		private function removeChild_func() : void
		{
			_alert.hide();
		}

		private function hideAlert(_y : Number) : void
		{
			TweenLite.to(_alert, 0.3, {delay:1, alpha:0, y:_y - 200, onComplete:removeChild_func});
		}
	}
}
import game.definition.UI;

import gameui.controls.GTextArea;
import gameui.core.GComponent;
import gameui.core.GComponentData;
import gameui.core.ScaleMode;
import gameui.data.GTextAreaData;
import gameui.manager.UIManager;
import gameui.skin.SkinStyle;

import net.AssetData;
import net.RESManager;

import flash.display.MovieClip;
import flash.text.TextFormatAlign;




class sorollAlert extends GComponent
{
	public function sorollAlert()
	{
		_base = new GComponentData();
		_base.parent = UIManager.root;
		_base.width = 235;
		_base.height = 128;
		_base.scaleMode = ScaleMode.SCALE9GRID;
		super(_base);
		initView();
	}

	private var _back1 : MovieClip;

//	private var _back2 : MovieClip;

	private function initView() : void
	{
		_back1 = RESManager.getMC(new AssetData(UI.ALERT_BG));

		_back1.width = 246;
		_back1.height = 105;
		addChild(_back1);
//		_back2 = RESManager.getMC(new AssetData(UI.ALERT_BODY_BG));
//		_back2.mouseChildren = false;
//		_back2.mouseEnabled = false;
//		_back2.x = 10;
//		_back2.y = 20;
//		_back2.width = 218;
//		_back2.height = 90;
//		addChild(_back2);
		initLable();
		this.mouseChildren = false;
		this.mouseEnabled = false;
	}

//	private var _lable : GLabel;

	private function initLable() : void
	{
//		var data : GLabelData = new GLabelData();
//		data.y = 90;
//		data.width = 130;
//		data.x = 15;
//		data.textColor = 0x000000;
//		data.textFieldFilters = [];
//		data.text = "2秒后系统自动返回...";
//		_lable = new GLabel(data);
//		addChild(_lable);
		var textData : GTextAreaData = new GTextAreaData();
		textData.backgroundAsset = new AssetData(SkinStyle.emptySkin);
		textData.textFormat.align = TextFormatAlign.CENTER;
		_text = new GTextArea(textData);
		_text.x = 15;
		_text.y = 20;
		_text.width = 200;
		_text.height = 80;
		addChild(_text);
	}

	private var _text : GTextArea;

	public function setMsg(str : String) : void
	{
		_text.htmlText = str;
	}
}
