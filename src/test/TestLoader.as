package test
{
	import game.config.StaticConfig;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class TestLoader extends Sprite
	{
		private var _res : RESManager = RESManager.instance;

		public function TestLoader()
		{
			loadNumbers();
		}

		private function onComplete(event:Event) : void
		{
			_res.removeEventListener(Event.COMPLETE, onComplete);
			var bitmap:Bitmap = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_b", "Numbers")));
			_res.remove("Numbers");
			loadNumbers();
		}

		private function loadNumbers() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/ui/Numbers.swf", "Numbers")));
			_res.addEventListener(Event.COMPLETE, onComplete);
			_res.startLoad();
		}
	}
}
