package test {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import game.config.StaticConfig;
	import net.LibData;
	import net.RESLoader;
	import net.RESManager;



	/**
	 * @author yangyiqiang
	 */
	public class TestLib extends Sprite {
		private var _res : RESManager = RESManager.instance;

		public function TestLib() {
			_res.add(new RESLoader(new LibData(StaticConfig.cdnRoot + "version", "version")));
			_res.addEventListener(Event.COMPLETE, loadComplete);
			_res.startLoad();
		}


		private function loadComplete(evt : Event) : void {
			_res.removeEventListener(Event.COMPLETE, loadComplete);
			var arr:ByteArray=RESManager.getByteArray("version");
			var str:String=arr.readUTFBytes(arr.length);
			var strArray:Array=str.split("\r\n");
			for each (var item:String in strArray){
				//trace(item);
			}
		}
	}
}
