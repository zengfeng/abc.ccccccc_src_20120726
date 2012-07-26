package game.module.searchTreasure {
	import framerate.SecondsTimer;

	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.manager.ViewManager;
	import game.module.bossWar.BossWarSystem;
	import game.module.guild.GuildManager;
	import game.module.mapClanBossWar.MCBWController;
	import game.net.data.StoC.SCGDBossInfo;

	import com.commUI.BossWarUI;
	import com.commUI.UIPlayerStatus;
	import com.commUI.alert.Alert;
	/**
	 * @author Lv
	 */
	public class SearchTreasureControl {
		private static var _instance : SearchTreasureControl;
//		private var _setup : Boolean = false ;
		
		//伤害列表  k:玩家id
//		public static var playerHarmToBossList:Dictionary = new Dictionary();
//		public static var playerharmListVec:Vector.<Object> = new Vector.<Object>();
		
//		public var _join:Boolean = false ;
//		public var _setup:Boolean = false ;
		
		public var _join:Boolean = false ;
		public var _setup:Boolean = false ;
		
		public function SearchTreasureControl(control:Control):void{
		}
		public static function get instance():SearchTreasureControl{
			if(_instance == null){
				_instance = new SearchTreasureControl(new Control());
			}
			return _instance;
		}
		 // 点击按钮复活
//        public function fun() : void
//        {
//			StateManager.instance.checkMsg(43,[ProxySearchTreasure.playerReliveGold],alertCallFFH);
//        }
//        private function alertCallFFH(type : String) : Boolean
//        {
//            switch(type)
//            {
//                case Alert.OK_EVENT:
//                    ProxySearchTreasure.instance.goldPlayerRelive();
//                    break;
//                case Alert.CANCEL_EVENT:
//                    break;
//            }
//            return true;
//        }

        // 复活时间倒计时    为0时
        public function funTimer() : void
        {
            ProxySearchTreasure.instance.myPlayerReLive();
        }
		
		public function get controller():MCBWController
        {
            return MCBWController.instance;
        }
		//申请进入家族寻宝
//		public function applyJoin(): void{
//			
//		}
//		private var uic : SearhTreasureUI;
		private var uic : BossWarUI = BossWarUI.instance;
		
		private var _uiPlayerStatus:UIPlayerStatus = UIPlayerStatus.instance;
		private var _fastReviveAlert:Alert ;
		
		private var _damageList:Vector.<Object>  = new Vector.<Object>();
		private var _bossTotalHp:int ;
		private var _bossCurrentHp:int ;
		private var _bossLevel:int ;
		private var _bossId:int ;
		private var _timeLeft:int ;
		private var _selfDamage:int ;
		private var _reviveTime:int ;
		private var _reviveGold:int ;
		
		//进入家族寻宝
//		public function join():void{
//			
//			_join = true ;
//			if( _setup ){
//				BossWarSystem.isJoin = true;
//				controller.enter();
//				setupUI();
//			}
//		}
		
//		public function mapLoad():void{
//			_setup = true ;
//			join();
//		}
		private function onSecondTimer():void{
			if( _timeLeft > 0 )
				-- _timeLeft ;
			uic.timeLeft = _timeLeft ;
		}
		//加载UI
		public function setupUI():void{
			
			_setup = true ;
			uic.setup() ;
			uic.exitCall = function():void{ ProxySearchTreasure.instance.outToCrypt(); } ;
			if( _bossId != 0 )
				refreshBossInfo();
			uic.damageList = _damageList ;
			BossWarSystem.isJoin = true ;
			SecondsTimer.addFunction(onSecondTimer);
			
			//TODO : temp , 
			ViewManager.instance.clearFullViews();
//			uic = SearhTreasureUI.instance;
//			uic.show();
//			uic.setup() ;
//			var id:int = ProxySearchTreasure.bossID;
//			var level:int = ProxySearchTreasure.bossLevel;
			
//			uic.setboss(_bossId, level);
			//setHarmToBossList();
			//setBossTimer();
//			uic.bloodBox.getBossName(id,level);
//			ExitButton.instance.setVisible(true, ProxySearchTreasure.instance.outToCrypt );
		}
		//卸载UI
		public function uninstallUI():void{
			BossWarSystem.isJoin = false;
			_bossId = 0;
			_damageList = new Vector.<Object>();
			_bossTotalHp = 0;
		  	_bossCurrentHp = 0;
		  	_bossLevel = 0;
		  	_bossId = 0;
		  	_timeLeft = 0 ;
		  	_selfDamage = 0;
		  	_reviveTime = 0;
//			_join = false ;
			controller.quit();
			uic.unsetup();
			if( _uiPlayerStatus )
				_uiPlayerStatus.clear();
			if( _fastReviveAlert != null ){
				_fastReviveAlert.hide() ;
				_fastReviveAlert = null ;
			}
			SecondsTimer.removeFunction(onSecondTimer);
//			uic.clear();
//			ExitButton.instance.setVisible(false,null);
		}
		//玩家为族长在地穴未开启时点击
		public function setupSelectDateUI():void{
			
		}
		//关闭族长打开的日期选择面板
		public function uninstallSelectDateUI():void{
			
		}
		//TODO
		public function setReviveTime(playerReliveTimer : uint ,gold:uint = 0 ) : void {
			
			_uiPlayerStatus.setCDTime(playerReliveTimer);
			_uiPlayerStatus.cdQuickenBtnCall = onQuickButton ;
			_uiPlayerStatus.cdCompleteCall = funTimer ;
			if( gold != 0 ){
				_reviveGold = gold ;
				_uiPlayerStatus.cdTimer.setTimersTip(gold);
			}
		}
		private function onQuickButton() : void {
			
			if( _uiPlayerStatus.cdTimer.time >= 20 )
				return ;
			
			if( UserData.instance.gold + UserData.instance.goldB < _reviveGold ){
				StateManager.instance.checkMsg(4);
				return ;
			}
			
			_fastReviveAlert = StateManager.instance.checkMsg(339, [], 
			function( evt:String ):Boolean{
				if( evt == Alert.YES_EVENT || evt == Alert.OK_EVENT ){
					if( UserData.instance.gold + UserData.instance.goldB >= _reviveGold ){
						ProxySearchTreasure.instance.goldPlayerRelive() ;
						_fastReviveAlert = null ;
					}
					else{
						StateManager.instance.checkMsg(4);
					}
				}
				return true ;
			} , 
			[_reviveGold]
			);
			
			if( _fastReviveAlert != null )
				_fastReviveAlert.show() ;
		}
		
		//TODO
		public function stopReviveTime() : void {
			_uiPlayerStatus.stopCDTime();
			if( _fastReviveAlert != null ){
				_fastReviveAlert.hide() ;
				_fastReviveAlert = null ;
			}
		}

		public function setBossInfo(e : SCGDBossInfo) : void {
	
			if(e.hasBossmaxhp)
				_bossTotalHp = e.bossmaxhp;
			if(e.hasBossnowhp)
				_bossCurrentHp = e.bossnowhp;
			if(e.hasDeadtime)
				_timeLeft = e.deadtime;
			if(e.hasBossid)
				_bossId = e.bossid;
			if(e.hasBosslevel){
				_bossLevel = e.bosslevel;
			}
			
			if( _setup )
				refreshBossInfo() ;
		}

		private function refreshBossInfo() : void {
			
			uic.setboss(_bossId, _bossLevel);
			uic.bosshp(_bossCurrentHp, _bossTotalHp);
			uic.timeLeft = _timeLeft ;
		}

		public function playerDamage(player : uint, dmg : uint) : void {
			for ( var i:int = 0 ; i < _damageList.length ; ++ i ){
				if( _damageList[i].id == player ){
					_damageList[i].damage += dmg;
					_damageList[i].rate = _bossTotalHp == 0 ? 100 : Number(_damageList[i].damage)* 100 / _bossTotalHp ;
					return ;
				}
			}
			var obj:Object = new Object() ;
			if( GuildManager.instance.selfguild == null || GuildManager.instance.selfguild.memberDict[player] == null )
				return ;
			obj.id = player ;
			obj.name = GuildManager.instance.selfguild.memberDict[player].colorname();
			obj.damage = dmg ;
			obj.rate = _bossTotalHp == 0 ? 100 : Number( obj.damage * 100 ) / _bossTotalHp ;
			_damageList.push(obj);
		}
		public function resort():void{
			_damageList.sort( function( obj1:Object,obj2:Object ):int{ return obj2.damage - obj1.damage ; } );
			if( _setup )
				uic.damageList = _damageList ;
		}

		public function bossDamage(dmg : uint) : void {
			if( _setup ){
				
				uic.damage(dmg);
				_bossCurrentHp = _bossCurrentHp > dmg ? _bossCurrentHp - dmg : 0 ;
				uic.bosshp(_bossCurrentHp, _bossTotalHp);
			}
				
		}
		
		public function join() : void {
			setupUI();
		}

		public function refreshPlayerDamage() : void {
			for each ( var obj:Object in _damageList ){
				if( obj.id == UserData.instance.playerId ){
					uic.setSelfdamage(obj.damage, _bossTotalHp);
					return ;
				}
			}
			uic.setSelfdamage(0, _bossTotalHp);
		}
	}
}
class Control{}