package game.manager {
	import game.core.hero.VoHero;
	import game.core.item.Item;
	import game.core.item.equipable.EquipableItem;

	import com.signalbus.Signal;

	import flash.geom.Point;


	/**
	 * @author jian
	 */
	public class SignalBusManager
	{
		public static var userInitData:Signal = new Signal();
		// ---------------------------------------------------------------
		// 玩家消息
		// ---------------------------------------------------------------
		public static var clickPlayer:Signal = new Signal();
		
		// ---------------------------------------------------------------
		// NPC消息
		// ---------------------------------------------------------------
		public static var clickNPC:Signal = new Signal(int /* npcId */);
		
		// ---------------------------------------------------------------
		// 物品消息
		// ---------------------------------------------------------------
		public static var itemNumsChange:Signal = new Signal(Item);
		public static var itemPropChange:Signal = new Signal(Item);
		
		public static var equipableItemAddToPack:Signal = new Signal(EquipableItem);
		public static var equipableItemAddToHero:Signal = new Signal(EquipableItem, VoHero);
		public static var equipableItemMoveToPack:Signal = new Signal(EquipableItem, VoHero);
		public static var equipableItemMoveToHero:Signal = new Signal(EquipableItem, VoHero);
		public static var equipableItemRemoveFromPack:Signal = new Signal(EquipableItem);
		public static var equipableItemRemoveFromHero:Signal = new Signal(EquipableItem, VoHero);
		
		// ---------------------------------------------------------------
		// 玩家信息
		// ---------------------------------------------------------------
//		public static var playerLevelChange:Signal = new Signal(/* old */ uint, /* new */ uint);
		
		// ---------------------------------------------------------------
		// 将领消息
		// ---------------------------------------------------------------
		public static var heroPropChange:Signal = new Signal(VoHero);
		public static var heroItemPropChange:Signal = new Signal(EquipableItem, VoHero);
		public static var heroSoulPower:Signal = new Signal(VoHero, uint);
		
		// ---------------------------------------------------------------
		// 面板消息
		// ---------------------------------------------------------------
		public static var packPanelChange:Signal = new Signal();
		public static var heroPanelChange:Signal = new Signal();
		public static var heroPanelSelectHero:Signal = new Signal(uint);
		public static var soulPanelSelectHero:Signal = new Signal(uint);
		public static var sutraPanelSelectHero:Signal = new Signal(uint);
		public static var packPanelSelectPage:Signal = new Signal(uint);
		
		// ---------------------------------------------------------------
		// 模式切换消息
		// ---------------------------------------------------------------
		public static var enterSceneModeMap:Signal = new Signal(int);
		public static var enterSceneModePanel:Signal = new Signal(int);
		public static var exitSceneModePanel:Signal = new Signal(int);
		
		// ---------------------------------------------------------------
		// 聊天框消息
		// ---------------------------------------------------------------
		public static var sendToChatItem:Signal = new Signal(Item);
		public static var sendToChatHero:Signal = new Signal(VoHero);
		public static var sendToChatObject:Signal = new Signal(Object);
		/** args=[playerName:String,playerId:uint,colorPropertyValue:uint,isOnline:Boolean] */
		public static var sendToChatFriendIsOnline:Signal = new Signal(String,uint,uint,Boolean);
		
		// ---------------------------------------------------------------
		// 战斗
		// ---------------------------------------------------------------
		public static var battleReady:Signal = new Signal();
		public static var battleStart:Signal = new Signal();
		public static var battleStartNoDelay:Signal = new Signal();
		public static var battleEnd:Signal = new Signal();
		public static var battleOver:Signal = new Signal();
        public static var battleMapPosition:Signal = new Signal();
		// ---------------------------------------------------------------
		// 副本
		// ---------------------------------------------------------------
		public static var duplOpened:Signal = new Signal(uint);
		public static var setIsQuitParentMap:Signal = new Signal(Boolean);
		// ---------------------------------------------------------------
		// 地图
		// ---------------------------------------------------------------
		public static var setupMap:Signal = new Signal(uint, Point);
		public static var setupMapComplete:Signal = new Signal();
		public static var setGateVisible:Signal = new Signal(uint, Boolean);
		public static var setGateListVisible:Signal = new Signal(Boolean);
        public static var selfStartWalk:Signal = new Signal();
        public static var selfEndWalk:Signal = new Signal();
        
        public static var mapWorldOpen:Signal = new Signal();
        public static var mapWorldClose:Signal = new Signal();
		// ---------------------------------------------------------------
		// 地图--剧情
		// ---------------------------------------------------------------
		public static var mapStoryIsEnter:Signal = new Signal(Boolean);

		// ---------------------------------------------------------------
		// 日常面板
		// ---------------------------------------------------------------
		public static var updateDaily:Signal = new Signal(int /*id*/, int /*state*/, int /*var1*/, int /*var2*/);
		public static var onUpdateDaily:Signal = new Signal();
		// ---------------------------------------------------------------
		// 任务
		// ---------------------------------------------------------------
		public static var questCollectProgressPlayComplete:Signal = new Signal();
		// ---------------------------------------------------------------
		// 阵形
		// ---------------------------------------------------------------
		public static var formationChange:Signal = new Signal();
		public static var heroWaringChange:Signal = new Signal(int/*改变将领id*/,Boolean/*true:出战  false：不出战*/);
		// ---------------------------------------------------------------
		// 交易
		// ---------------------------------------------------------------
		public static var changeNewExchangeCount:Signal = new Signal();
		// ---------------------------------------------------------------
		// 调试
		// ---------------------------------------------------------------
		public static var debugCachaAsBitmapData:Signal = new Signal(Boolean);
		// ---------------------------------------------------------------
		// 合成面板
		// ---------------------------------------------------------------
		public static var mergeViewSelectSource:Signal = new Signal(int);
		//----------------------------------------------------------------
		//悬赏
		//----------------------------------------------------------------
		public static var questPanelAcceptMissionUpdate:Signal = new Signal(uint,uint);
		public static var questPanelEndMissionUpdate:Signal = new Signal(uint);
		public static var questPanelSubmitMissionUpdate:Signal = new Signal(uint);
		
		

	}
}
