package test
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import game.config.StaticConfig;
	import net.LibData;
	import net.RESLoader;
	import net.RESManager;
	import project.Game;



//	import com.unitzeroone.WebPLib;


	/**
	 * @author yangyiqiang
	 */
	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1680" , height="1000" ) ]
	public class TestWebPLib extends Game
	{
		override protected function initGame() : void
		{
			_res.add(new RESLoader(new LibData(StaticConfig.cdnRoot + "assets/bb", "aa")));
//			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/aaaa.swf", "aa")));
			_res.addEventListener(Event.COMPLETE, loadComplete);
			_res.startLoad();
		}

		private var _sprite : Sprite = new Sprite();
		private var _timer:int;
		private function loadComplete(event : Event) : void
		{
//			WebPLib.init();
			// Only needs to be called once.
			_timer=getTimer();
//			var bitmapData : BitmapData=RESManager.getBitmapData(new AssetData("aa","aa"));
//			var bitmapData : BitmapData = WebPLib.decode(RESManager.getByteArray("aa"));
//			_sprite.addChild(new Bitmap(bitmapData));
			//trace("getTimer-timer===>"+(getTimer()-_timer));
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addChild(_sprite);
		}

		private function onUp(event : MouseEvent) : void
		{
			_sprite.stopDrag();
		}

		private function onDown(event : MouseEvent) : void
		{
			_sprite.startDrag();
		}
	}
}
