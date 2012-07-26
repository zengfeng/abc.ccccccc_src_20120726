package game.manager {
	import worlds.WorldProto;
	import game.core.hero.HeroManager;
	import game.core.item.ItemService;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.module.battle.BattleInterface;
	import game.module.bossWar.ProxyBossWar;
	import game.module.chatwhisper.ProtoStoCWhisper;
	import game.module.daily.DailyNotice;
	import game.module.formation.FMControlPoxy;
	import game.module.friend.ProtoStoCFriend;
	import game.module.guild.GuildProxy;
	import game.module.heroPanel.OtherHeroProxy;
	import game.module.mapClanEscort.MCEProto;
	import game.module.mapConvoy.ConvoyProto;
	import game.module.mapFeast.FeastProto;
	import game.module.mapGroupBattle.GBProto;
	import game.module.notification.NotificationProxy;
	import game.module.practice.PracticeProxy;
	import game.module.quest.QuestProxy;
	import game.module.quest.guide.GuideMange;
	import game.module.recruitHero.RecruitManager;
	import game.module.rewardPackage.GiftPackageManage;
	import game.module.role.RoleSystem;
	import game.module.searchTreasure.ProxySearchTreasure;
	import game.module.shop.ProxyShop;
	import game.module.tasteTea.ProxyTastTea;
	import game.module.trade.exchange.ExchangeManager;
	import game.module.userPanel.GiftManager;
	import game.module.userPanel.ProposeEqManager;
	import game.net.core.Common;
	import game.net.core.GASignals;
	import game.net.data.StoC.SCSystemMessage;
	import game.net.data.StoC.SCTradeCount;
	import game.net.data.StoC.SCUserLogin;

	import log4a.Logger;

	import com.commUI.alert.Alert;

	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class CommonMessageManage {
		private static var _instance : CommonMessageManage;

		public function CommonMessageManage() {
			if (_instance) {
				throw Error("---CommonMessageManage--is--a--single--model---");
			}
		}

		public static function get instance() : CommonMessageManage {
			if (_instance == null) {
				_instance = new CommonMessageManage();
			}
			return _instance;
		}

		public function init() : void {
			Common.game_server.addCallback(0x02, loginCallBack);
			Common.game_server.addCallback(0x08, systemMessage);
			Common.game_server.addEventListener(Event.CLOSE, socketClose);
		}

		private static var _alert : Alert;

		private function socketClose(event : Event) : void {
			showAlert("你已经断开了连接！");
		}

		public static function showAlert(str : String) : void {
			if (_alert == null)
				_alert = Alert.show(str);
			else
				_alert.text = str;
			_alert.show();
		}

		/**
		 * 登录返回
		 */
		private function loginCallBack(message : SCUserLogin) : void {
			Logger.debug("用户登录数据 message.result===>" + message.result);
			switch(message.result) {
				case 0:
					/** 登录成功 **/
					GASignals.gaLoginContinueRole.dispatch();
					UserData.instance.updateUserData(message);
					initProxy();
					break;
				case 1:
					/** 新用户 **/
					GASignals.gaLoginCreateRole.dispatch();
					RoleSystem.initCreateRole();
					break;
				default:
					/** 账号非法**/
					break;
			}
		}

		private function initProxy() : void {
			DailyInfoManager.instance;
			PracticeProxy.getInstance();
			// 好友
			ProtoStoCFriend.instance;
//			// 地图协议
//			MapProto.instance;
			// BOSS战协议
			ProxyBossWar.instance;
			// 寻宝协议
			ProxySearchTreasure.instance;
			MCEProto.instance;
			ConvoyProto.instance;
			// 阵形协议
			FMControlPoxy.instance;

			// 礼包协议
			GiftPackageManage.instance;

			// 品茶协议
			ProxyTastTea.instance;
			// 物品信息
			ItemService.instance.connect(Common.game_server);
			GuildProxy.stoc() ;
			// ClanManager.instance;
			// ClanManager.instance;
			// 将领管理器
			HeroManager.instance;
			// 其他将领信息管理器
			OtherHeroProxy.instance;

			SCTradeCount;
			// 派对proto
			FeastProto.instance ;
			GuideMange.getInstance();
			new NotificationProxy();

			// 新手新装备弹框
			ProposeEqManager.instance;
			new BattleInterface();
			new RecruitManager();
			new ProxyShop();
			new QuestProxy();
			// 蜀山论剑协议监听
			GBProto.instance;
			DailyNotice.initEvents() ;

			ProtoStoCWhisper.instance;

			ExchangeManager.instance;
			GiftManager.instance;
			PreLoadManager.instance;
			WorldProto.instance;
		}

		private function systemMessage(msg : SCSystemMessage) : void {
			
			var sparam:String="";
			for each(var str:String in msg.sparam){
				sparam+=str;
				sparam+=",";
			}
			sparam+="|";
			for each(var ins:int in msg.iparam){
				sparam+=ins;
				sparam+=",";
			}
//			Logger.info("msg.msgid===>"+msg.msgid,sparam);
			StateManager.instance.checkMsg(msg.msgid, msg.sparam, null, msg.iparam);
		}
	}
}
