package game.module.soul.soulBD {
	import bd.BDData;
	import bd.BDUnit;

	import log4a.Logger;

	import net.RESManager;
	import net.SWFLoader;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * @author jian
	 */
	public class SoulFlameManager
	{
		// =====================
		// Singleton
		// =====================
		private static var __instance : SoulFlameManager;

		public static function get instance() : SoulFlameManager
		{
			if (!__instance)
				__instance = new SoulFlameManager();
			return __instance;
		}

		public function SoulFlameManager()
		{
			if (__instance)
				throw (Error("Singleton Error"));
		}

		// =====================
		// Attribute
		// =====================
		private var _flameBDs : Dictionary;
		private var _flameTimes : Dictionary;

		// =====================
		// Method
		// =====================
		public function initiate() : void
		{
			Logger.debug("解析元神");
			_flameBDs = new Dictionary();
			_flameTimes = new Dictionary();
			parseFlameBD();
		}

		private function parseFlameBD() : void
		{
			var i : int = 0;
			var j : int = 0;
			var loader : SWFLoader = RESManager.getLoader("soul_flame");
			if (!loader) return;

			var _source : BitmapData = new(loader.getClass("source")) as BitmapData;
			if (!_source) return;
			var text : String = (loader.getMovieClip("text")).getChildAt(0)["text"];
			var _xml : XML = new XML(text);

			var bottomX : Number = Number(_xml.attribute("bottomX"));
			var bottomY : Number = Number(_xml.attribute("bottomY"));
			for each (var xml:XML in _xml["frame"])
			{
				j = 0;
				var frames : Vector.<BDUnit > = new Vector.<BDUnit >;
				for each (var frame:XML in xml["item"])
				{
					var unit : BDUnit = new BDUnit();
					var rect : Rectangle = new Rectangle(frame. @ x, frame. @ y, frame. @ w, frame. @ h);
					var bds : BitmapData = new BitmapData(rect.width, rect.height, true, 0);
					bds.copyPixels(_source, rect, new Point());
					unit.offset = new Point(int(frame.@offsetX) + bottomX, int(frame.@offsetY) + bottomY);
					unit.bds = bds;
					frames.push(unit);
					j++;
				}

				var flameID : String = String(int(String(xml.@name).split("_")[1]));
				addFlameBD(frames, flameID, xml.@time);

				i++;
			}
		}

		private function addFlameBD(frames : Vector.<BDUnit>, flameID : String, time : int = 80) : void
		{
			Logger.debug("添加元神"+flameID);
			_flameBDs[flameID] = new BDData(frames);
			_flameTimes[flameID] = time;
		}

		public function getFlameBD(flameID : String) : BDData
		{
			Logger.debug("请求元神" + flameID);
			var bddata:BDData = _flameBDs[String(int(flameID))];
			
			if (!bddata)
				throw(Error("Missing Soul BD" + flameID));
			
			return bddata;
		}

		public function getFlameTime(flameID : String) : int
		{
			return _flameTimes[String(int(flameID))];
		}
	}
}
