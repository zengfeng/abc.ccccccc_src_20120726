package worlds.loads {
	import game.config.StaticConfig;
	import game.core.avatar.AvatarType;
	import worlds.players.GlobalPlayers;
	import game.core.avatar.AvatarManager;
	import game.core.user.UserData;
	import game.module.battle.BattleInterface;

	import net.ALoader;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import worlds.apis.MapUtil;
	import worlds.maps.configs.BattleMonstersConfigData;
	import worlds.maps.configs.MapLoadFilesConfigData;
	import worlds.maps.configs.structs.MapStruct;
	import worlds.npcs.NpcData;
	import worlds.roles.structs.NpcStruct;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-11
	 */
	public class RssData
	{
		/** 单例对像 */
		private static var _instance : RssData;

		/** 获取单例对像 */
		static public function get instance() : RssData
		{
			if (_instance == null)
			{
				_instance = new RssData(new Singleton());
			}
			return _instance;
		}

		function RssData(singleton : Singleton) : void
		{
		}

		public var loadbarAppend:Array = new Array();  //ALoader
		public var loadbarData : Array = new Array();		//ALoader
		public var loadpreData : Array = new Array();		//ALoader
		public var loadedNoRepeatLoader:Array= new Array();

		/** 添加url */
		public function append(loader:ALoader) : void
		{
			if(loadbarData.indexOf(loader) == -1) loadbarData.push(loader);
			if(loadbarAppend.indexOf(loader) == -1) loadbarAppend.push(loader);
		}

		/** 生成战斗资源 */
		public function generateBattle() : void
		{
			if (MapUtil.isDuplMap() == false) return;
			var mapStruct : MapStruct = MapUtil.getMapStruct();
			if (mapStruct == null) return;
			var battleMonstersConfigData : BattleMonstersConfigData = BattleMonstersConfigData.instance;
			var monsterList : Array;
			var monsterListLength : int;
			var monsterListA : Array = [];
			var monsterListB : Array = [];
			var monsterId : int;
			var npcStruct : NpcStruct;
			var npcList : Vector.<uint> = NpcData.instance.list;
			npcList.sort(Array.NUMERIC);
			var npcId : int;
			var length : int = npcList.length;
			for (var i : int = 0; i < length; i++)
			{
				npcId = npcList[i];
				monsterList = battleMonstersConfigData.getMonsters(npcId);
				if (monsterList)
				{
					npcStruct = mapStruct.npcDic[npcId];
					if (npcStruct == null)
					{
						continue;
					}

					monsterListLength = monsterList.length;
					var j : int;
					if (npcStruct.moveRadius > 0)
					{
						for (j = 0; j < monsterListLength; j++)
						{
							monsterId = monsterList[j];
							if (monsterListA.indexOf(monsterId) == -1)
							{
								monsterListA.push(monsterId);
							}
						}
					}
					else
					{
						for (j = 0; j < monsterListLength; j++)
						{
							monsterId = monsterList[j];
							if (monsterListB.indexOf(monsterId) == -1 && monsterListA.indexOf(monsterId) == -1)
							{
								monsterListB.push(monsterId);
							}
						}
					}
				}
			}

			if (monsterListA.length > 0)
			{
				var tempArr : Array = loadbarData;
				loadbarData = BattleInterface.preLoadBattleRes(monsterListA, MapUtil.currentMapId, true);
				while (tempArr.length > 0)
				{
					loadbarData.push(tempArr.shift());
				}
			}

			if (monsterListB.length > 0)
			{
				loadpreData = BattleInterface.preLoadBattleRes(monsterListB, MapUtil.currentMapId, true);
			}
		}

		private var isFirstMerge : Boolean = false;

		public function mergeSelfHeroAvatar() : void
		{
			if (isFirstMerge)
			{
				var url : String = StaticConfig.cdnRoot + "assets/avatar/" + AvatarManager.instance.getUUId(GlobalPlayers.instance.self.heroId, AvatarType.PLAYER_RUN, GlobalPlayers.instance.self.clothId)+".swf";
				var libData:LibData = new LibData(url, null, true);
				var swfLoader:SWFLoader = new SWFLoader(libData);
				loadbarData.push(swfLoader);
				isFirstMerge = true;
			}
		}

		public function mergeMapLoadFilesConfig() : void
		{
			var arr : Array = MapLoadFilesConfigData.instance.getFiles(MapUtil.currentMapId);
			if (arr)
			{
				var loader:ALoader;
				for each (loader in arr)
				{
					if(loadedNoRepeatLoader.indexOf(loader) != -1) continue;
					loadbarData.push(loader);
					loadbarAppend.push(loader);
				}
			}
		}

		/** 资源加载管理器 */
		private var res : RESManager = RESManager.instance;
		public function clearup() : void
		{
			while (loadbarData.length > 0)
			{
				loadbarData.shift();
			}

			while (loadpreData.length > 0)
			{
				loadpreData.shift();
			}
			
			var loader:ALoader;
			while(loadbarAppend.length > 0)
			{
				loader = loadbarAppend.shift();
				if(loader.isLoaded && loader.isRepeat)
				{
					loadedNoRepeatLoader.push(loader);
				}
				else
				{
					res.remove(loader.key);
				}
			}
		}
	}
}
class Singleton
{
}