package worlds.apis
{
	import flash.utils.Dictionary;
	import worlds.players.PlayerControl;
	import worlds.players.PlayerData;
	import game.module.battle.battleData.mapData;
	import worlds.players.GlobalPlayers;
	import game.manager.ViewManager;

	import worlds.auxiliarys.mediators.MSignal;
	import worlds.mediators.PlayerMediator;
	import worlds.roles.cores.Player;
	import worlds.roles.structs.PlayerStruct;

	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	*/
	public class MPlayer
	{
		/** 安装完成 */
		public static const sInstallComplete : MSignal = PlayerMediator.playerInstalled;
		/** 卸载开始 */
		public static const sDestory : MSignal = PlayerMediator.playerDestory;

		/** 获取玩家 */
		public static function getPlayer(playerId : int) : Player
		{
			return PlayerMediator.getPlayer.call(playerId);
		}

		/** 获取数据结构 */
		public static function getStruct(playerId : int) : PlayerStruct
		{
			return PlayerMediator.getStruct.call(playerId);
		}
		
		/** 获取数据结构列表 */
		public static function getStructList() : Vector.<PlayerStruct>
		{
			var list:Vector.<PlayerStruct> = new Vector.<PlayerStruct>();
			var dic:Dictionary = PlayerData.instance.dic;
			var palyerStruct:PlayerStruct;
			for each (palyerStruct in dic)
			{
				list.push(palyerStruct);
			}
			return list;
		}
		
		
		/** 获取数据结构全局的 */
		public static function getStructOfGlobal(playerId:int):PlayerStruct
		{
			return GlobalPlayers.instance.getPlayer(playerId);
		}
		// =================
		// 添加&移除
		// =================
		public static function addSelf():void
		{
			PlayerData.instance.self = GlobalPlayers.instance.self;
		}
		
		public static function addStruct(playerStruct:PlayerStruct):void
		{
			PlayerData.instance.addWaitInstall(playerStruct);
		}
		
		public static function addStructToGlobal(playerStruct:PlayerStruct):void
		{
			GlobalPlayers.instance.addPlayer(playerStruct);
		}
		
		public static function removePlayer(playerId:int):void
		{
			PlayerData.instance.playerLeave(playerId);
		}
		// =================
		// 监听
		// =================
		/** 添加安装回调 */
		public static function addInstallCall(playerId : int, callFun : Function, callFunArgs : Array = null) : void
		{
			PlayerMediator.cAddInstallListener.call(playerId, callFun, callFunArgs);
		}

		/** 移除安装回调 */
		public static function removeInstallCall(playerId : int, callFun : Function) : void
		{
			PlayerMediator.cRemoveInstallListener.call(playerId, callFun);
		}

		/** 添加卸载回调 */
		public static function addDestoryCall(playerId : int, callFun : Function, callFunArgs : Array = null) : void
		{
			PlayerMediator.cAddDestoryistener.call(playerId, callFun, callFunArgs);
		}

		/** 移除卸载回调 */
		public static function removeDestoryCall(playerId : int, callFun : Function) : void
		{
			PlayerMediator.cRemoveDestoryistener.call(playerId, callFun);
		}

		// =================
		// 模式
		// =================
		/** 龟仙拜佛进入 args=[playerId, quality] */
		public static const MODEL_CONVOY_IN : MSignal = PlayerMediator.MODEL_CONVOY_IN;
		/** 龟仙拜佛退出 args=[playerId] */
		public static const MODEL_CONVOY_OUT : MSignal = PlayerMediator.MODEL_CONVOY_OUT;
		/** 龟仙拜佛速度改变 args=[playerId, speedModel] */
		public static const MODEL_CONVOY_CHANGE : MSignal = PlayerMediator.MODEL_CONVOY_CHANGE;
		// -----------------------------
		/** 钓鱼进入 args=[playerId, modelId] */
		public static const MODEL_FISHING_IN : MSignal = PlayerMediator.MODEL_FISHING_IN;
		/** 钓鱼退出 args=[playerId] */
		public static const MODEL_FISHING_OUT : MSignal = PlayerMediator.MODEL_FISHING_OUT;
		// -----------------------------
		/** 采矿进入 args=[playerId, modelId]  */
		public static const MODEL_MINGING_IN : MSignal = PlayerMediator.MODEL_MINGING_IN;
		/** 采矿退出 args=[playerId]  */
		public static const MODEL_MINGING_OUT : MSignal = PlayerMediator.MODEL_MINGING_OUT;
		// -----------------------------
		/** 派对进入 args=[playerId, status] */
		public static const MODEL_FEAST_IN : MSignal = PlayerMediator.MODEL_FEAST_IN;
		/** 派对退出 args=[playerId] */
		public static const MODEL_FEAST_OUT : MSignal = PlayerMediator.MODEL_FEAST_OUT;
		/** 派对状态改变 args=[playerId, modelId] */
		public static const MODEL_FEAST_CHANGE : MSignal = PlayerMediator.MODEL_FEAST_CHANGE;

		public static function onClickShowInfo(playerId : int) : void
		{
			var playerStruct : PlayerStruct = getStruct(playerId);
			if (!ViewManager.otherPlayerPanel || !playerStruct) return;
			var obj : Object = new Object();
			obj["id"] = playerStruct.id;
			obj["name"] = playerStruct.name;
			obj["heroId"] = playerStruct.heroId;
			obj["level"] = playerStruct.level;
			ViewManager.otherPlayerPanel.source = obj;
			ViewManager.otherPlayerPanel.show();
		}
	}
}
