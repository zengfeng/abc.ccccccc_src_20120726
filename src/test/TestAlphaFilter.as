package test
{
	import project.Game;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author jian
	 */
	public class TestAlphaFilter extends Game
	{
		private var _loader:Loader;
		public function TestAlphaFilter()
		{
			super();
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			_loader.load(new URLRequest("http://www.szol.net/vip/edit/UploadFile/20071130162458866.jpg"));
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			addChild(_loader);
//			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
//			var bitmap:Bitmap = _loader as Bitmap;
//			addChild(bitmap);
		}
	}
}
