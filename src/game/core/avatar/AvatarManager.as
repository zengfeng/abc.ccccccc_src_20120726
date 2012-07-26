package game.core.avatar {
	import bd.BDData;
	import bd.BDUnit;

	import framerate.SecondsTimer;

	import game.module.battle.view.BTAvatar;

	import gameui.controls.BDPlayer;
	import gameui.core.GComponentData;

	import net.RESManager;

	import worlds.apis.MapUtil;
	import worlds.loads.LoadMediator;

	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarManager {
		private static var _instance : AvatarManager;
		// private static var _checkMemory : uint = 507200000;
		/** 战斗站立 */
		public static const BT_STAND : int = 1;
		/** 被攻击*/
		public static const HURT : int = 2;
		/** 物理攻击 */
		public static const ATTACK : int = 3;
		/** 魔法攻击 */
		public static const MAGIC_ATTACK : int = 4;
		/** 死亡 */
		public static const DIE : int = 5;
		/** 打坐 */
		public static const PRACTICE : int = 20;
		/** 通用 转圈特效 */
		public static const COMM_CIRCLEEFFECT : int = 184549379;
		/** 通用 钓鱼水纹特效 */
		public static const WATER_WAVE : int = 184549382;
		/** avatar的存储源 */
		private var _avatarBDDic : Dictionary = new Dictionary(true);
		public static var hitTest : BitmapData = new BitmapData(5, 5, false);
		private var _factory : AvatarFactory;
		private var _lock : Boolean = false;

		public function AvatarManager() {
			if (_instance) {
				throw Error("---AvatarManager--is--a--single--model---");
			}
			_factory = new AvatarFactory();
			SecondsTimer.addFunction(gcAvatar);
			// getDie();
			LoadMediator.sReady.add(changeMap);
		}

		public static function get instance() : AvatarManager {
			if (_instance == null) {
				_instance = new AvatarManager();
			}
			return _instance;
		}

		private function changeMap() : void {
			if (MapUtil.isDuplMap()) {
				_lock = true;
			} else {
				_lock = false;
				if (MapUtil.isDuplMap(MapUtil.preMapId))
					clearBattleAvatars();
			}
		}

		public function getShodow(type : int = 0) : BitmapData {
			return _factory.getShodow(type);
		}

		public function getCommonAvatar() : BitmapData {
			return _factory.getCommonAvatar();
		}

		public function getDie() : BDData {
			return _factory.getDie();
		}

		/** 获取avatar实例 */
		public  function getAvatar(id : int, type : uint, cloth : uint = 0) : AvatarThumb {
			return _factory.getAvatar(id, type, cloth);
		}

		/** 获取UUID */
		public function getUUId(id : int, type : uint, cloth : uint = 0) : uint {
			return (type << 24) + (cloth << 20) + id;
		}

		/**  移除avatar实例 */
		public function removeAvatar(avatar : AbstractAvatar) : void {
			if (!avatar) return;
			if (_lock)
				_battleList.push(avatar);
			else {
				avatar.callback();
			}
		}

		/**获得avatar的bitMapData源  */
		public function getAvatarBD(id : int) : AvatarBD {
			if (!_avatarBDDic[id]) {
				_avatarBDDic[id] = new AvatarBD(id, new BDData(new Vector.<BDUnit>()));
			}
			return _avatarBDDic[id];
		}

		/**获得avatar的 某一动作的帧系列  */
		public function getAvatarFrame(id : int, type : int) : AvatarUnit {
			if (!_avatarBDDic[id]) {
				_avatarBDDic[id] = new AvatarBD(id, new BDData(new Vector.<BDUnit>()));
			}
			return (_avatarBDDic[id] as AvatarBD).getAvatarFrame(type);
		}

		public function deleteBDDic(id : int) : void {
			delete _avatarBDDic[id];
		}

		private var _battleList : Array = [];

		public function getBattleAvatar(type : int = 0, data : *=null) : * {
			var avatar : *;
			switch(type) {
				case 0:
					avatar = new BTAvatar(data);
					break;
				case 1:
					avatar = new AvatarSkill();
					break;
			}
			_battleList.push(avatar);
			return avatar;
		}

		public function clearBattleAvatars() : void {
			if (_lock) return;
			for each (var avatar:AbstractAvatar in _battleList) {
				avatar.dispose();
			}
			_battleList = [];
			RESManager.instance.remove("Numbers");
			_factory.clearDie();
			for each (var map:* in _backArray) {
				if (map is String)
					RESManager.instance.remove(map);
				else if (map is BitmapData)
					(map as BitmapData).dispose();
			}
		}

		private var _backArray : Array = [];

		public function removeBattleBack(str : String, data : BitmapData) : void {
			if (_lock) {
				_backArray.push(str);
				if (data)
					_backArray.push(data);
				return;
			}
			RESManager.instance.remove(str);
			if (data)
				data.dispose();
		}

		public function getCommBDPlayer(key : int, data : GComponentData) : BDPlayer {
			return _factory.getCommBDPlayer(key, data);
		}

		private function gcAvatar() : void {
		}
	}
}
