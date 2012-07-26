package game.core.avatar {
	import bd.BDData;
	import bd.BDUnit;

	import log4a.Logger;

	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import com.utils.UrlUtils;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarBD extends EventDispatcher {
		private var _key : int;
		private var _bd : BDData;
		private var _frameDic : Dictionary = new Dictionary();
		private var _fightData : FightData = null;

		public function AvatarBD(id : int, value : BDData) {
			_key = id;
			_bd = value;
			if (_bd) {
				_bd.addEventListener("dispose", dispose);
				_bd.key = _key;
			}
		}

		public function get id() : int {
			return _key;
		}

		public function get key() : String {
			return _urlKey;
		}

		private function addBDUnit(value : Vector.<BDUnit>, key : int, time : Number = 80) : void {
			if (!_bd) {
				_bd = new BDData(new Vector.<BDUnit>());
				_bd.addEventListener("dispose", dispose);
				_bd.key = _key;
			}
			var start : int = _bd.total;
			var max : int = start + value.length;
			var unit : AvatarUnit = new AvatarUnit();
			for (var i : int = start;i < max;i++) {
				unit.key = key;
				unit.avatars.push(i);
				unit.timer = time;
			}
			_frameDic[key] = unit;
			_bd.addBDUnit(value);
		}

		public function get bds() : BDData {
			return _bd;
		}

		private var _requestDic : Dictionary = new Dictionary();

		public function getAvatarFrame(type : int) : AvatarUnit {
			if (_key == 0) return _frameDic[type];
			if (_frameDic[type] == null && !_requestDic[type] && _key != -1) {
				_requestDic[type] = true;
				RESManager.instance.load(new LibData(UrlUtils.getAvatar(_key), String(_key)), parse, [String(_key)]);
			}
			return _frameDic[type];
		}

		public function hasDieFrame() : Boolean {
			return _frameDic[AvatarManager.DIE] == null ? false : true;
		}

		private var _topX : int = -80;
		private var _topY : int = -115;
		private var _bottomX : int;
		private var _bottomY : int;
		private var _w : int;
		private var _h : int;
		private var _skillPointX : int;
		private var _skillPointY : int;
		private var _type : int = 0;
		private var _urlKey : String;
		private var _isBattle : Boolean = false;
		private var _isParse:Boolean=false;

		public function parse(key : String, isBattle : uint = 0,fun:Function=null,onCompleteParams:Array=null) : void   // 1：战斗avatar 2:技能
		{
			if(_isParse){
				return;
			}
			Logger.info("key===>"+key,"isBattle===>"+isBattle);
			var i : int = 0;
			var j : int = 0;
			var loader : SWFLoader = RESManager.getLoader(key);
			_urlKey = key;
			if (!loader) return;
			if (!loader.getMovieClip("text")) return;
			if (!(loader.getMovieClip("text")).getChildAt(0)) return;
			var text : String = (loader.getMovieClip("text")).getChildAt(0)["text"];
			var _xml : XML = new XML(text);
			_topX = -60;
			_topY = int(_xml.attribute("topY"));
			_type = int(_xml.attribute("type"));
			_bottomX = int(_xml.attribute("bottomX"));
			_bottomY = int(_xml.attribute("bottomY"));
			_skillPointX = int(_xml.attribute("skillPointX"));
			_skillPointY = int(_xml.attribute("skillPointY"));

			_w = int(_xml.attribute("w"));
			_h = int(_xml.attribute("h"));
			var _source : BitmapData;
			if (_type == 0) {
				if (!loader.getClass("source")) return;
				_source = new (loader.getClass("source")) as BitmapData;
				if (!_source) return;
			}
			RESManager.instance.remove(key);
			_isBattle = isBattle > 0 ? true : false;

			for each (var xml:XML in _xml["frame"]) {
				j = 0;
				var frames : Vector.<BDUnit > = new Vector.<BDUnit >;
				for each (var frame:XML in xml["item"]) {
					var unit : BDUnit = new BDUnit();
					if (_type != 0) {
						unit.offset = new Point();
						var cls : Class = loader.getClass(String(xml.@name) + j);
						unit.offset = new Point(-_w + _bottomX, -_h + _bottomY);
						unit.bds = new cls() as BitmapData;
					} else {
						var rect : Rectangle = new Rectangle(frame. @ x, frame. @ y, frame. @ w, frame. @ h);
						var bds : BitmapData = new BitmapData(rect.width, rect.height, true, 0);
						bds.copyPixels(_source, rect, new Point());
						unit.offset = new Point(int(frame.@offsetX) + _bottomX, int(frame.@offsetY) + _bottomY);
						unit.bds = bds;
					}
					frames.push(unit);
					j++;
				}
				var num : int = int(String(xml.@name).split("_")[1]);
				var testTIME:int=xml.@time;
				if(isBattle==1)
				{
//					if(num == 3)
//						testTIME = testTIME * 1.2;
				}
				addBDUnit(frames, num, testTIME);
				// if (isBattle == 1)
				// {
				if (!_fightData && isBattle != 0) _fightData = new FightData();
				if (isBattle == 0 && (xml.@ atkFrame == undefined || !xml.@ atkFrame)) {
					continue;
				} else if (!_fightData) _fightData = new FightData();

				if (i == 1) // 受挫动作
				{
					_fightData.atkTimeTrad = Number((j - 1) * int(testTIME)) / Number(1000);
				} else if (i == 2) {
					_fightData.atkTimePhyatk = Number((j - 1) * int(testTIME)) / Number(1000);
					if (xml.@ atkFrame > 0)
						_fightData.atkTimePhyPoint = Number((int(xml.@ atkFrame)) * int(testTIME)) / Number(1000);
					else
						_fightData.atkTimePhyPoint = Number(int((j + 1) / 2) * int(testTIME)) / Number(1000);
				} else if (i == 3) {
					_fightData.atkTimeSkillatk = Number((j - 1) * int(testTIME)) / Number(1000);
					if (xml.@ atkFrame > 0)
						_fightData.atkTimeSkillPoint = Number((int(xml.@ atkFrame)) * int(testTIME)) / Number(1000);
					else
						_fightData.atkTimeSkillPoint = Number(int((j + 1) / 2) * int(testTIME)) / Number(1000);
				} else if (i == 4) {
					_fightData.atkTimeDie = Number((j - 1) * int(testTIME)) / Number(1000);
				}
				// }
				// else if (isBattle == 2)
				// {
				if (i == 0)  // 攻击技能效果
				{
					_fightData.atkTimeSkillBreak = Number((int(xml.@ atkFrame)) * int(testTIME)) / Number(1000);
					_fightData.atkTimeSkillEfft = Number((j - 1) * int(testTIME)) / Number(1000);
				}
				// }
				i++;
			}
			if (fun != null) fun.apply(null, onCompleteParams);
			_isParse=true;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function cleanUp() : void {
			if (_bd) _bd.dispose();
		}

		private function dispose(event : Event = null) : void {
			Logger.info("dispose","key===>"+key);
			if (_bd) _bd.removeEventListener("dispose", dispose);
			_bd = null;
			RESManager.instance.remove(key);
			_frameDic = new Dictionary();
			_requestDic = new Dictionary();
			AvatarManager.instance.deleteBDDic(_key);
		}

		public function get topX() : int {
			return _topX;
		}

		public function get topY() : int {
			return _topY;
		}

		public function get bottomX() : int {
			return _bottomX;
		}

		public function get bottomY() : int {
			return _bottomY;
		}

		public function get skillPointX() : int {
			return _skillPointX;
		}

		public function get skillPointY() : int {
			return _skillPointY;
		}

		public function get fightData() : FightData {
			if (!_fightData) {
				_fightData = new FightData();
				Logger.error("错误       id= " + id + " 的资源没有设置攻击点");
			}
			return _fightData;
		}
	}
}
class FightData {
	// 物理攻击出手时间点
	public var atkTimePhyPoint : Number = 0;
	// 法术攻击出手时间点
	public var atkTimeSkillPoint : Number = 0;
	// 物理攻击动作时间
	public var atkTimePhyatk : Number = 0;
	// 技能攻击动作时间
	public var atkTimeSkillatk : Number = 0;
	// 受挫动作时间
	public var atkTimeTrad : Number = 0;
	// 死亡动作时间
	public var atkTimeDie : Number = 0;
	// 技能暴破点
	public var atkTimeSkillBreak : Number = 0;
	// 攻击技能效果时间
	public var atkTimeSkillEfft : Number = 0;
}
