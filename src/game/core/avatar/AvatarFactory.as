package game.core.avatar {
	import bd.BDData;

	import game.config.StaticConfig;
	import game.manager.VersionManager;

	import gameui.controls.BDPlayer;
	import gameui.core.GComponentData;

	import net.AssetData;
	import net.BDSWFLoader;
	import net.LibData;
	import net.RESManager;

	import utils.ObjectPool;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	internal final class AvatarFactory {
		/** 获取avatar实例 */
		public function getAvatar(id : int, type : uint, cloth : uint = 0) : AvatarThumb {
			var _avatar : AvatarThumb;
			switch(type) {
				case AvatarType.PLAYER_RUN:
				case AvatarType.CHANGE_AVATAR:
					type = AvatarType.PLAYER_RUN;
					_avatar = ObjectPool.getObject(AvatarPlayer);
					break;
				case AvatarType.FLLOW_TYPE:
					type = cloth == 0 ? AvatarType.NPC_TYPE : AvatarType.PLAYER_RUN;
					_avatar = ObjectPool.getObject(AvatarThumb);
					break;
				case AvatarType.NPC_TYPE:
					_avatar = ObjectPool.getObject(AvatarNpc);
					(_avatar as AvatarNpc).setId(id);
					_avatar.setAction(1);
					return _avatar;
				case AvatarType.PERFORMER_TYPE:
					_avatar = new PerformerAvatar();
					(_avatar as PerformerAvatar).setId(id);
					return _avatar;
				case AvatarType.MONSTER_TYPE:
					_avatar = new AvatarMonster();
					break;
				case AvatarType.TURTLE_AVATAR:
					type = AvatarType.MONSTER_TYPE;
					_avatar = ObjectPool.getObject(AvatarTurtle);
					break;
				case AvatarType.PET_TYPE:
					_avatar = ObjectPool.getObject(AvatarMonster);
					break;
				case AvatarType.COUPLE_TYPE:
					type = AvatarType.CHANGE_AVATAR ;
					cloth = 0 ;
					_avatar = ObjectPool.getObject(AvatarCouple);
					break ;
				case AvatarType.SEAT_TYPE:
					_avatar = ObjectPool.getObject(AvatarSeat);
					break;
				case AvatarType.MY_AVATAR:
					type = AvatarType.PLAYER_RUN;
					_avatar = AvatarMySelf.instance;
					break;
				case AvatarType.DRAY_AVATER:
					type = AvatarType.NPC_TYPE;
					_avatar = ObjectPool.getObject(AvatarThumb);
					break ;
				default :
					_avatar = ObjectPool.getObject(AvatarPlayer);
					break;
			}
			_avatar.initAvatar(id, type, cloth);
			_avatar.setAction(1);
			return _avatar;
		}

		private  var _dieData : BDData;

		public function getDie() : BDData {
			if (!_dieData) {
				RESManager.instance.load(new LibData(StaticConfig.cdnRoot + "assets/avatar/battle/die.swf", "diessss"), initDieFrame, null, BDSWFLoader);
			}
			return _dieData;
		}

		public function clearDie() : void {
			if (_dieData) {
				_dieData.dispose();
				RESManager.instance.remove("diessss");
				_dieData = null;
			}
		}

		private function initDieFrame() : void {
			_dieData = RESManager.getBDData(new AssetData("1", "diessss"));
		}

		private var _commonAvatar : BitmapData;

		/** 没加载前通用avatar */
		public function getCommonAvatar() : BitmapData {
			if (!_commonAvatar)
				_commonAvatar = RESManager.getBitmapData(new AssetData("player", "quest"));
			return _commonAvatar;
		}

		private  var _shodow : BitmapData;
		private  var _shodow1 : BitmapData;

		public function getShodow(type : int = 0) : BitmapData {
			if (type == 0) {
				if (!_shodow) {
					if (!RESManager.getLoader("shadowPng" + type)) return null;
					_shodow = (RESManager.getLoader("shadowPng" + type).getContent() as Bitmap).bitmapData;
				}
			} else {
				if (!_shodow1) {
					if (!RESManager.getLoader("shadowPng" + type)) return null;
					_shodow1 = (RESManager.getLoader("shadowPng" + type).getContent() as Bitmap).bitmapData;
				}
				return _shodow1;
			}
			return _shodow;
		}

		private var _commBDPlayer : Dictionary = new Dictionary();
		private var _commBD : Dictionary = new Dictionary();

		public function getCommBDPlayer(key : int, data : GComponentData) : BDPlayer {
			var player : BDPlayer = new BDPlayer(data);
			if (_commBD[key]) {
				player.setBDData(_commBD[key]);
			} else {
				var url : String = VersionManager.instance.getUrl("assets/avatar/" + key + ".swf");
				var bdData : BDData = RESManager.getBDData(new AssetData("1", url));
				if (bdData) {
					player.setBDData(bdData);
				} else {
					RESManager.instance.load(new LibData(url, url, true, false), updateCommBDPlayer, [key], BDSWFLoader);
				}
			}
			if (!_commBDPlayer[key]) _commBDPlayer[key] = [];
			(_commBDPlayer[key] as Array).push(player);
			player.play();
			return player;
		}

		private function updateCommBDPlayer(key : int) : void {
			var arr : Array = _commBDPlayer[key];
			var url : String = VersionManager.instance.getUrl("assets/avatar/" + key + ".swf");
			var bdData : BDData = RESManager.getBDData(new AssetData("1", url));
			_commBD[key] = bdData;
			for each (var player:BDPlayer in arr) {
				player.setBDData(bdData);
				player.play(80, null, 0);
			}
		}
	}
}
