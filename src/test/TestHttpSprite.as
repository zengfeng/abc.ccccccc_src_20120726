package test {
	import model.LocalSO;

	import net.LibData;
	import net.RESLoader;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.utils.ByteArray;

	/**
	 * @author yangyiqiang
	 */
	public class TestHttpSprite extends Sprite
	{
		private var _resLoader : RESLoader;

		private var _content : ByteArray;

		private var _loader : Loader;

		private var _los : LocalSO = new LocalSO("ktadf");

		public function TestHttpSprite()
		{
			flash.system.Security.allowDomain("*");
			_resLoader = new RESLoader(new LibData("http://127.0.0.1:8080"));
			// _resLoader=new SWFLoader(new LibData("http://127.0.0.1:8080"));
			_resLoader.load();
		}

		private function onComplete(loader : RESLoader) : void
		{
			_content = loader.getByteArray();
			_los.setAt("key00000", _content);
			_los.flush();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderByteArray);
			_loader.loadBytes(_los.getAt("key00000") as ByteArray);
		}

		private function onLoaderByteArray(event : Event) : void
		{
			// _loader.content;
			// addChild(_loader.content);
			var _domain : ApplicationDomain = LoaderInfo(event.currentTarget).applicationDomain;
			var gameClass : Class = _domain.getDefinition("Client") as Class;
			var game:* = new gameClass();
			addChild(game);
			game["init"]();
		}
	}
}
