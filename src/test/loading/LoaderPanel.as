package test.loading
{
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-14
	 */

	 [ SWF ( frameRate="60" , backgroundColor=0x000000,width="1680" , height="1000" ) ]
	public class LoaderPanel extends Sprite
	{
		private var _loader : Loader = new Loader();

		private var _urlstream : URLStream = new URLStream();

		private var _data : ByteArray = new ByteArray();

		function LoaderPanel() : void
		{
			var loadmenu : ContextMenuItem = new ContextMenuItem("Load image");
			loadmenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onLoadImage, false);
			this.contextMenu = new ContextMenu();
			this.contextMenu.customItems.push(loadmenu);


			_urlstream.addEventListener('progress', processData);
			_urlstream.addEventListener('complete', processData);

			addChild(_loader);

			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(MouseEvent.CLICK, onLoadImage);
		}

		public function onLoadImage(e : Event) : void
		{
			_loader.unload();
			_data.length = 0;


			var url : String = "http://1x020.xd.com:8888/ktpd/0001.jpg";

			_urlstream.load(new URLRequest(url + "?q=" + getTimer()));
		}

		public function processData(e : Event) : void
		{
			var oldlen : int = _data.length;
			_urlstream.readBytes(_data, _data.length);
			if (_data.length > oldlen)
			{
				_loader.loadBytes(_data);
			}
		}
	}
}
