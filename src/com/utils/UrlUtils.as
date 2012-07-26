package com.utils {
	import game.config.StaticConfig;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.manager.VersionManager;

	import gameui.manager.UIManager;
	/**
	 * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-11-23 ����3:31:52
	 */
	public class UrlUtils
	{
		/** 更目录 */
		public static function get ROOT() : String
		{
			return "";
		}

		/** Avatar目录 */
		private static var DIR_AVATAR : String = ROOT + "assets/avatar/";
		/** 地图文件夹路径 */
		private static var DIR_MAP : String = ROOT + "assets/scene/";
		/** 地图远景文件夹路径 */
		private static var DIR_MAP_DISTANT : String = ROOT + "assets/sceneDistant/";
		/** 玩家头像文件夹路径 */
		private static var DIR_HERO_HEAD_PHOTO : String = ROOT + "assets/ico/heroPicture/";
		/** BUFF图标文件夹路径 */
		private static var DIR_BUFF_STATUS_ICON : String = ROOT + "assets/ico/buffStatus/";
		/** 国战组图标文件夹路径*/
		private static var DIR_GROUP_Battle_Group_ICON : String = ROOT + "assets/ico/groupBattle/";
		/** 副本Boss图标文件夹路径*/
		private static var DIR_DUNGEON_ICON : String = ROOT + "assets/ico/halfBody/";
		/** 副本面板副本封面图片文件夹路径 */
		private static var DIR_DUNGEON_Cover : String = ROOT + "assets/dungeonCover/";
		/** 物品文件夹路径 */
		private static var DIR_GOODS : String = ROOT + "assets/goods/";
		/** 怪物图片件夹路径 */
		private static var DIR_MONSTER : String = ROOT + "assets/img/monster/";
		/** 普通SWF*/
		private static var DIR_SWF : String = ROOT + "assets/swf/";
		/** 语言包*/
		private static var DIR_LANG : String = ROOT + "assets/swf/lang/";

		/** 国战组图标文件*/
		public static function getGroupBattleGroupIcon(groupId : int) : String
		{
			var url : String = DIR_GROUP_Battle_Group_ICON + "group_" + groupId + ".png" ;
			return VersionManager.instance.getUrl(url);
		}

		/** 世界地图SWF文件 */
		public static function get FILE_WORLD_MAP() : String
		{
			var url : String = "assets/swf/worldMap.swf";
			return VersionManager.instance.getUrl(url);
		}

		/** 八卦阵(出口入口)SWF文件 */
		public static function get FILE_GATE() : String
		{
			var url : String = "assets/swf/gate.swf";
			return VersionManager.instance.getUrl(url);
		}

		public static function getGate(type : int) : String
		{
			var url : String = "assets/swf/gate_" + type + ".swf";
			return VersionManager.instance.getUrl(url);
		}

		/** STAUTS图标 */
		public static function getStatusIcon(statusFile : String) : String
		{
			return VersionManager.instance.getUrl(DIR_BUFF_STATUS_ICON + statusFile);
		}

		/** BUFF图标 */
		public static function getBuffIcon(buffFile : String) : String
		{
			return VersionManager.instance.getUrl(DIR_BUFF_STATUS_ICON + buffFile);
		}

		/** 获取NPC的Avatar的文件路径 */
		public static function getNpcAvatar(npcId : uint) : String
		{
			return VersionManager.instance.getUrl(DIR_AVATAR + "body/" + npcId + ".swf");
		}

		/** 获取Avatar的路径 */
		public static function getAvatar(uuid : int) : String
		{
			return VersionManager.instance.getUrl(UrlUtils.DIR_AVATAR + uuid + ".swf");
		}

		/** 获取地图路径 */
		public static function geMapDir(mapId : uint) : String
		{
			return DIR_MAP + mapId + "/";
		}

		/** 获取地图缩略图路径 */
		public static function getMapMask(mapId : uint) : String
		{
			return VersionManager.instance.getUrl(geMapDir(mapId) + "mask.png?v="+ UIManager.version);
		}

		/** 获取地图缩略图路径 */
		public static function getMapThumbnail(mapId : uint) : String
		{
			return VersionManager.instance.getUrl(geMapDir(mapId) + "thumbnail.jpg?v="+ UIManager.version);
		}

		/** 获取地图寻路数据SWF路径 */
		public static function getMapPathDataSwf(mapId : uint) : String
		{
			return VersionManager.instance.getUrl(geMapDir(mapId) + "sceneRes.swf");
		}

		/** 获取地图寻路数据SWF路径 */
		public static function getMapPathData(mapId : uint) : String
		{
			return VersionManager.instance.getUrl(geMapDir(mapId) + "path?v="+ UIManager.version);
		}

		/** 获取地图远景图片路径 */
		public static function getMapDistant(fileName : String) : String
		{
			return VersionManager.instance.getUrl(DIR_MAP_DISTANT + fileName);
		}

		/** 获取地图远景缩略图片路径 */
		public static function getMapDistantThumbnail(fileName : String) : String
		{
			fileName = fileName.replace(".jpg", "_thum.jpg");
			return VersionManager.instance.getUrl(DIR_MAP_DISTANT + fileName);
		}

		/** 获取地图块路径 */
		public static function getMapPiece(mapId : uint, pieceName : String) : String
		{
			return VersionManager.instance.getUrl(geMapDir(mapId) + pieceName + ".swf?v="+ UIManager.version);
		}

		/** 获取地图块路径 */
		public static function getMapPiece2(mapId : uint, x : int, y : int) : String
		{
			return VersionManager.instance.getUrl(geMapDir(mapId) + y + "_" + x + ".swf");
		}

		/** 副本层图片 */
		public static function getBossHeadIcon(duplId : int) : String
		{
			return VersionManager.instance.getUrl(DIR_DUNGEON_ICON + duplId + ".png");
		}

		/** 怪物图片件夹路径 */
		public static function getMonster(monsterId : uint) : String
		{
			return VersionManager.instance.getUrl(DIR_MONSTER + monsterId + ".png");
		}

		/** 获取物品图片路径 */
		public static function getGoods(goodsId : uint, large : Boolean = false) : String
		{
			var imgID : String = "0000";
			var voItem : Item = ItemManager.instance.getEquipableItem(goodsId);
			if (!voItem) return "";
			imgID = voItem.imgUrl;
			var url : String;

			if (large)
			{
				url = DIR_GOODS + imgID + "_large.png";
			}
			else
			{
				url = DIR_GOODS + imgID + ".jpg";
			}
			return VersionManager.instance.getUrl(url);
		}

		/** 获取副本面板副本封面图片路径 */
		public static function getDungeonCover(dungeonId : uint) : String
		{
			return VersionManager.instance.getUrl(DIR_DUNGEON_Cover + dungeonId + ".jpg");
		}

		/** [小图]获取将领头像路径,根据将领ID */
		public static function getHeroHeadPhoto(heroId : uint) : String
		{
			return VersionManager.instance.getUrl(DIR_HERO_HEAD_PHOTO + heroId + ".png");
		}

		/** [小图]获取将领头像路径,根据职业,性别 */
		public static function getHeroHeadPhotoByJobAndSex(job : uint, isMale : Boolean) : String
		{
			return VersionManager.instance.getUrl(DIR_HERO_HEAD_PHOTO + job + ".png");
		}

		/** 获取元神FlameBD路径,根据Flame类型 */
		public static function getSoulFlameBD() : String
		{
			return VersionManager.instance.getUrl(DIR_SWF + "soul_flame.swf");
		}

		/** 获取钓鱼资源 */
		public static function getFishoingSWF() : String
		{
			return VersionManager.instance.getUrl(DIR_SWF + "fishing.swf");
		}
		
		/** 获取语言包资源 */
		public static function getLangSWF (filename:String) : String
		{
			return VersionManager.instance.getUrl(DIR_LANG + StaticConfig.langString + "/" + filename);	
		}
		
		public static function getLangSWF2 (filename:String) : String
		{
			return DIR_LANG + StaticConfig.langString + "/" + filename;	
		}
	}
}
