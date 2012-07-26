package test
{
	import bd.BDData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import game.config.StaticConfig;
	import gameui.controls.BDPlayer;
	import gameui.core.GComponentData;
	import net.AssetData;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;
	import project.Game;
	import utils.BDUtil;
	import utils.SystemUtil;

	/**
	 * @author yangyiqiang
	 */
	public class BDPlayerTest extends Game
	{
		private var _player : BDPlayer;
		
		private var _player2 : BDPlayer;

		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/test.swf","test")));
			_res.addEventListener(Event.COMPLETE,completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event : Event) : void
		{
			var base : GComponentData = new GComponentData();
			base.x = 0;
			base.y = 0;
			_player = new BDPlayer(base);
			base=base.clone();
			base.x=0;
			base.y=200;
			_player2=new BDPlayer(base);
			play();
		}

		private function play() : void
		{
			var data : BDData;
			data=BDUtil.toBDS(RESManager.getLoader("test").getContent() as MovieClip );
//			BDUtil.getBDData(new AssetData("test","test"));
			_player.setBDData(data);
			_player.play(80,null,0);
			_player.addEventListener(Event.COMPLETE,onPlayComplete);
//			_player2.setBDData(data);
//			_player2.flipH = true;
//			_player2.play(30,null,0);
//			addChild(_player2);
			addChild(_player);
		}

		private function onPlayComplete(event : Event) : void
		{
			_player.dispose();
			_player.removeEventListener(Event.COMPLETE, onPlayComplete);
			SystemUtil.gc();
			play();
		}

		public function BDPlayerTest()
		{
			super();
		}
	}
}
