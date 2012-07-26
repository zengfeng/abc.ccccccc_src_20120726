package test
{
	import gameui.controls.GButton;
	import gameui.data.GButtonData;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	/**
	 * @author jian
	 */
	public class TestLoadSwfVsPng extends Sprite
	{
		private const SWF_URL : String = "../assets/test/0_11.swf";
		private const PNG_URL : String = "../assets/test/0_11.png";
		private const LOAD_TIMES : uint = 100;
		private var _swfCnt : uint;
		private var _pngCnt : uint;
		private var _swfStart: uint;
		private var _pngStart: uint;
		private var _swfLoader : Loader;
		private var _pngLoader : Loader;
		private var _swfCache : Array;
		private var _pngCache : Array;
		private var _button1:GButton;
		private var _button2:GButton;

		public function TestLoadSwfVsPng()
		{
			_button1 = new GButton(new GButtonData());
			_button1.x = 100;
			_button1.y = 40;
			_button1.text = "Load SWF";
			_button2 = new GButton(new GButtonData());
			_button2.x = 200;
			_button2.y = 40;
			_button2.text = "Load PNG";
			
			addChild(_button1);
			addChild(_button2);
			
			_button1.addEventListener(MouseEvent.CLICK, button1_onClick);
			_button2.addEventListener(MouseEvent.CLICK, button2_onClick);
		}
		
		private function button1_onClick (event:MouseEvent):void
		{
			startLoadSwf();
		}
		
		private function button2_onClick (event:MouseEvent):void
		{
			startLoadPng();
		}

		private function startLoadSwf() : void
		{
			_button1.removeEventListener(MouseEvent.CLICK, button1_onClick);
			_swfCnt = 0;
			_swfCache = [];
			_swfStart = getTimer();

			if (!_swfLoader)
				_swfLoader = new Loader();

			_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfLoadComplete);

			//trace("Start Load SWF: " + getTimer());
			loadSwfOnce();
		}

		private function startLoadPng() : void
		{
			_button2.removeEventListener(MouseEvent.CLICK, button1_onClick);
			_pngCnt = 0;
			_pngCache = [];
			_pngStart = getTimer();

			if (!_pngLoader)
				_pngLoader = new Loader();

			_pngLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPngLoadComplete);
			loadPngOnce();
		}

		private function loadSwfOnce() : void
		{
			_swfLoader.load(new URLRequest(SWF_URL));
		}

		private function loadPngOnce() : void
		{
			_pngLoader.load(new URLRequest(PNG_URL));
		}

		private function onSwfLoadComplete(event : Event) : void
		{
			_swfCnt++;
			_swfCache.push(_swfLoader.content);
			//trace("  onLoad " + _swfCnt + " time " + (getTimer() - _swfStart));

			if (_swfCnt == LOAD_TIMES)
			{
				_swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSwfLoadComplete);
				_button1.addEventListener(MouseEvent.CLICK, button1_onClick);
			}
			else
			{
				loadSwfOnce();
			}
		}

		private function onPngLoadComplete(event : Event) : void
		{
			_pngCnt++;
			_pngCache.push(_pngLoader.content);
			//trace("  onLoad " + _pngCnt + " time " + (getTimer() - _pngStart));

			if (_pngCnt == LOAD_TIMES)
			{
				_pngLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onPngLoadComplete);
				_button2.addEventListener(MouseEvent.CLICK, button1_onClick);
			}
			else
			{
				loadPngOnce();
			}
		}
	}
}
