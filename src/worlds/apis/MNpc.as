package worlds.apis
{
	import game.module.quest.VoNpc;
	import game.module.quest.QuestManager;
	import worlds.roles.structs.NpcStruct;
	import game.core.avatar.AvatarNpc;
	import game.module.quest.QuestUtil;

	import worlds.auxiliarys.mediators.MSignal;
	import worlds.mediators.NpcMediator;
	import worlds.roles.cores.Npc;

	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	*/
	public class MNpc
	{
		/** 安装完成 */
		public static const sInstallComplete : MSignal = NpcMediator.installCompleted;
		public static const clickNpcCall : Function = QuestUtil.npcClick;
		
		public static function getStruct(npcId : int):NpcStruct
		{
			return  MapUtil.getNpcStruct(npcId);
		}

		public static function getAvatar(npcId : int) : AvatarNpc
		{
			var npc : Npc = getNpc(npcId);
			if (npc == null) return null;
			return npc.avatar as AvatarNpc; 
		}
		
		public static function getNpc(npcId : int) : Npc
		{
			return NpcMediator.getNpc.call(npcId);
		}


		public static function add(npcId : int) : void
		{
			NpcMediator.addData.call(npcId);
		}

		public static function remove(npcId : int) : void
		{
			NpcMediator.removeData.call(npcId);
		}
		
		public static function getNpcList():Vector.<Npc>
		{
			return NpcMediator.getNpcList.call();
		}
		
		
		// =================
		// 监听
		// =================
		/** 添加安装回调 */
		public static function addInstallCall(npcId : int, callFun : Function, callFunArgs : Array = null) : void
		{
			NpcMediator.cAddInstallListener.call(npcId, callFun, callFunArgs);
		}

		/** 移除安装回调 */
		public static function removeInstallCall(npcId : int, callFun : Function) : void
		{
			NpcMediator.cRemoveInstallListener.call(npcId, callFun);
		}

		/** 添加卸载回调 */
		public static function addDestoryCall(npcId : int, callFun : Function, callFunArgs : Array = null) : void
		{
			NpcMediator.cAddDestoryistener.call(npcId, callFun, callFunArgs);
		}

		/** 移除卸载回调 */
		public static function removeDestoryCall(npcId : int, callFun : Function) : void
		{
			NpcMediator.cRemoveDestoryistener.call(npcId, callFun);
		}
		
		/** 安装前初始化数据 */
		public static function initData():void
		{
			var mapId:int = MapUtil.currentMapId;
			var arr:Array=QuestManager.getInstance().mapNpcDic[mapId];
			if(arr){
				for each(var vo:VoNpc in arr){
					if(vo.mapId== mapId&&vo.visable)
					{
						 add(vo.id);
					}
				}
			}
		}
	}
}