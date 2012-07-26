package com.commUI {
	import game.manager.ViewManager;

	import gameui.core.GComponent;

	import com.greensock.TweenLite;
	import com.utils.StringUtils;

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public final class ScrollInfo {
		private static var _instance : ScrollInfo;
		private var _container : GComponent;
		private var _timer : Timer;

		public function ScrollInfo() : void {
			if (_instance) {
				throw Error("---ScrollInfo--is--a--single--model---");
			}
			container = ViewManager.instance.getContainer(ViewManager.ROLL_CONTAINER) as GComponent;
			initSprites();
			_timer = new Timer(700);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}

		public function set container(container : GComponent) : void {
			_container = container;
			_container.mouseEnabled = false;
			_container.mouseChildren = false;
			_container.addChild(_sprite);
		}

		public static function get instance() : ScrollInfo {
			if (_instance == null) {
				_instance = new ScrollInfo();
			}
			return _instance;
		}

		private var _list : Vector.<String>=new Vector.<String>();

		// 添加滚屏信息
		public function add(info : String) : void {
			_list.push(StringUtils.addBold(info));
			if (!_timer.running) {
				execute(_list.shift(), 0.7);
				_timer.start();
			}
		}

		private function timerHandler(event : TimerEvent) : void {
			if (_list.length == 0) {
				_timer.stop();
				return;
			} else {
				// trace("_list.length===>"+_list.length);
				// if (_list.length > max)
				// {
				// _timer.delay=150;
				// reset();
				// }
				// else
				// {
				_timer.delay = 700;
				// }
				execute(_list.shift(), _timer.delay / 1000);
			}
		}

		private var _spriteList : Vector.<ScrollSprite>;
		private var _currentSprite : ScrollSprite;
		private var _sprite : Sprite = new Sprite();

		private function execute(str : String, num : Number) : void {
			_currentSprite = _spriteList[_counter];
			_currentSprite.alpha = 0;
			_currentSprite.x = 0;
			_currentSprite.y = 0;
			_currentSprite.htmlText = str;
			TweenLite.to(_sprite, num, {y:_sprite.y - 30, overwrite:0});
			TweenLite.to(_currentSprite, 3 * num / 7, {delay:4 * num / 7, alpha:1, y:-30, overwrite:0, onComplete:addChild, onCompleteParams:[_currentSprite]});
			TweenLite.to(_currentSprite, num * 5 / 7, {delay:30 * num / 7 + 0.8, alpha:0, overwrite:0, onComplete:removeChild, onCompleteParams:[_currentSprite]});
			if (++_counter >= max) _counter = 0;
		}

		private function addChild(value : ScrollSprite) : void {
			value.y = Math.abs(_sprite.y + 30);
			_sprite.addChild(value);
		}

		private function removeChild(value : ScrollSprite) : void {
			value.alpha = 0;
			_container.addChild(value);
			if (_list.length == 0 && _sprite.numChildren == 0) _container.hide();
		}

		private static const max : uint = 6;
		private var _counter : int;

		private function initSprites() : void {
			_spriteList = new Vector.<ScrollSprite>(6, true);
			for (var i : int = 0;i < max;i++) {
				_spriteList[i] = new ScrollSprite();
				_container.addChild(_spriteList[i]);
			}
			_counter = 0;
		}
		// private function reset():void
		// {
		// for (var i : int = 0;i < max;i++)
		// {
		// TweenLite.killTweensOf(_spriteList[i]);
		// _spriteList[i].alpha=0;
		// _container.addChild(_spriteList[i]);
		// }
		// _counter = 0;
		// }
	}
}
import gameui.manager.UIManager;

import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormatAlign;

class ScrollSprite extends Sprite {
	private var _lable : TextField;
//	private static var _bitMap : Bitmap;

	public function ScrollSprite() {
//		_bitMap = new Bitmap(RESManager.getBitmapData(new AssetData("ScrollInfoBd")));
		// addChild(_bitMap);
		_lable = new TextField();
		_lable.width = 500;
		_lable.defaultTextFormat = UIManager.getTextFormat(16, 0xFFFF33, TextFormatAlign.CENTER);
		_lable.antiAliasType = AntiAliasType.ADVANCED;
		_lable.filters = [new GlowFilter(0x000000, 1, 2, 2, 3, 1, false, false)];
		this.addChild(_lable);
		this.alpha = 0;
	}

	public function set htmlText(str : String) : void {
		_lable.htmlText = str;
	}
}