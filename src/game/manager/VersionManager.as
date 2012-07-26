package game.manager {
	import net.SWFLoader;
	import net.ALoader;

	import game.config.StaticConfig;

	import gameui.manager.UIManager;

	import net.LibData;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class VersionManager {
		private static var _instance : VersionManager;
		private var _versionDic : Dictionary = new Dictionary(true);

		public function VersionManager() {
			if (_instance) {
				throw Error("---VersionManager--is--a--single--model---");
			}
		}

		public static function get instance() : VersionManager {
			if (_instance == null) {
				_instance = new VersionManager();
			}
			return _instance;
		}

		public function initVersion(bytes : ByteArray) : void {
			if(!bytes)
			{
				UIManager.version="60";
				return;
			}
			var url : String = bytes.readUTFBytes(bytes.length);
			var arr : Array = url.split("\r\n");
			UIManager.version = arr.shift();
			var temp : Array = [];
			for each (var obj:String in arr) {
				temp = obj.split("|");
				_versionDic[temp[0]] = temp[1];
			}
		}

		public function getVersion(url : String) : String {
			return _versionDic[url] == null ? "-1" : _versionDic[url];
		}

		public function getLib(url : String, key : String, cache : Boolean = true, isRepeat : Boolean = true, cls : Class = null) : LibData {
			return new LibData(StaticConfig.cdnRoot+url, key, cache, isRepeat, getVersion(url), cls);
		}

		public function getLoader(url : String, key : String=null, cls : Class = null) : ALoader {
			if (cls == null) cls = SWFLoader;
			return new cls(getLib(url, key));
		}

		/**
		 * 根据版本来取文件路径
		 */
		public function getUrl(url : String) : String {
			return  StaticConfig.cdnRoot + url;
		}
	}
}
