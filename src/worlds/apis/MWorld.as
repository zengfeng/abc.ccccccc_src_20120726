package worlds.apis
{
	import game.net.data.StoC.SCCityPlayers;

	import worlds.WorldProto;
	import worlds.maps.configs.MapId;
	import worlds.maps.resets.MapReset;
	import worlds.mediators.MapMediator;
	import worlds.auxiliarys.mediators.MSignal;

	import game.module.mapWorld.WorldMapController;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	 */
	public class MWorld
	{
		/** 地图安装前初始化数据 */
		public static const sInstallReady : MSignal = MapMediator.sInstallReady;
		/** 地图安装完成 */
		public static var sInstallComplete : MSignal = MapMediator.sInstallComplete;
		/** 地图卸载完成 */
		public static var sUninstallComplete : MSignal = MapMediator.sUnstallComplete;
		/** 进入副本 */
		public static var sEnterDupl : MSignal = MapMediator.sEnterDupl;
		public static var sChangeMapStart : MSignal = MapMediator.sChangeMapStart;
		public static var sChangeMapEnd : MSignal = MapMediator.sChangeMapEnd;
		/** 是否需要发送走路消息到服务器 */
		public static var needSendWalk : Boolean = true;

		/** 地图是否安装 */
		public static function get isInstallComplete() : Boolean
		{
			return MapReset.isInstallCompleted;
		}

		public static var isChangeMaping : Boolean;

		/* -----------------------------  发送协议  ----------------------------- */
		/** 离开地图 */
		public static function csLeaveMap() : void
		{
			MapMediator.csLeaveMap.call();
		}

		/** 返回上一个地图 */
		public static function csBackMap() : void
		{
			csChangeMap(MapId.BACK);
		}

		/** 切换地图 */
		public static function csChangeMap(mapId : int) : void
		{
			var result : Boolean = MValidator.changeMap.doValidation(csChangeMap, [mapId]);
			if (result == false) return;
			MapMediator.csChangeMap.call(mapId);
		}

		/** 传送 */
		public static function csTransport(toX : int, toY : int, toMapId : int) : void
		{
			var result : Boolean = MValidator.changeMap.doValidation(csTransport, [toX, toY, toMapId]);
			if (result == false) return;
			MapMediator.csTransport.call(toX, toY, toMapId);
		}

		/** 使用传送阵切换地图 */
		public static function csUseGateChangeMap(gateId : int) : void
		{
			var result : Boolean = MValidator.changeMap.doValidation(csUseGateChangeMap, [gateId]);
			if (result == false) return;
			MapMediator.csUseGateChangeMap.call(gateId);
		}

		/** 模拟服务器协议 0x22 自己玩家进入新地图 */
		public static function scChangeMap(msg : SCCityPlayers, hasSelf : Boolean = true) : void
		{
			WorldProto.instance.sc_changeMap(msg, hasSelf, false);
		}

		/** 打开世界地图并前住某个地图 */
		public static function worldMapTo(toMapId : int) : void
		{
			WorldMapController.instance.toMap(toMapId, true);
		}

		public static function show() : void
		{
			// MapMediator.cShow.call();
		}

		public static function hide() : void
		{
			// MapMediator.cHide.call();
		}
	}
}
