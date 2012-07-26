package game.module.mapClanEscort {
	import game.module.mapClanEscort.ui.ClanEscortResultPanel;
	import com.utils.UrlUtils;
	import game.core.user.StateManager;
	import game.core.user.StateType;
	import game.core.user.UserData;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.mapClanEscort.data.DrayData;
	import game.module.mapClanEscort.data.EscortData;
	import game.module.mapClanEscort.element.Dray;

	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;

	import net.LibData;
	import net.RESManager;

	import worlds.apis.MPlayer;
	import worlds.apis.MTo;
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;
	import worlds.apis.validators.Validator;
	import worlds.roles.cores.Player;

	import com.commUI.UIPlayerStatus;
	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;

	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
//	import game.module.battle.view.BTSystem;
//	import game.module.map.MapController;
//	import game.module.map.MapSystem;
//	import game.module.map.animal.AnimalManager;
//	import game.module.map.animal.AnimalType;
//	import game.module.map.animal.PlayerAnimal;
	// import game.module.map.animal.SelfPlayerAnimal;




    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-2-23   ����10:49:29 
     */
    public class MCEController {

		//
		public static const PLAYER_NORMAL:uint = 0 ;
		public static const PLAYER_BATTLE:uint = 1 ;
		public static const PLAYER_DIE:uint = 2 ;
		
        public function MCEController(singleton : Singleton)
        {
            singleton;
			MWorld.sInstallComplete.add(initEscor);
			var bdata:GButtonData = new KTButtonData(KTButtonData.EXIT_BUTTON);
			bdata.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			_quitbtn = new GButton(bdata);
			_quitbtn.addEventListener(MouseEvent.CLICK, onClickLeave);
        }
		
		private var _data:EscortData = EscortData.instance ;
		
        /** 单例对像 */
        private static var _instance : MCEController;
		private static var _quitbtn : GButton ;
        /** 自己玩家状态UI */
        private var _uiPlayerStatus : UIPlayerStatus;
		private var _setup:Boolean;
		private var _walkEnable:Boolean = true ;

        /** 获取单例对像 */
        static public function get instance() : MCEController
        {
            if (_instance == null)
                _instance = new MCEController(new Singleton());
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        private var proto : MCEProto = MCEProto.instance;
        /** 镖车字典 */
        public var drayDic : Dictionary = new Dictionary();
		public var drayList : Vector.<Dray> ;

        /** 获取镖车 */
        public function getDray(drayId : int) : Dray
        {
            return drayDic[drayId];
        }

        public function get  uiPlayerStatus() : UIPlayerStatus
        {
            if (_uiPlayerStatus == null)
                _uiPlayerStatus = UIPlayerStatus.instance;
            return _uiPlayerStatus;
        }
		
		public function onPlayerLoad(id:uint) : void{
			var s:uint = _data.getPlayerState(id) & 0xFFFF;
			var p:Player = MPlayer.getPlayer(id);
			if( s == 1 ){
				var did:uint = _data.getAttackTarget(id);
				var d:Dray = getDray(did);
				if( d != null ){
					p.actionAttack(d.attackX);
				}
			}
			else if( s == 2 ){
				p.setGhost(true);
			}
		}
		
		public function playerAttack( playerId:uint , drayId:uint ):void{
			
			_data.setPlayerState(playerId,PLAYER_BATTLE);
			_data.setAttackTarget(playerId, drayId);
			
			var p:Player = MPlayer.getPlayer(playerId);
			var d:Dray = getDray(drayId);
			if( _setup && d != null ){
				
				if( p != null ){
					p.walkStop();
					p.actionAttack( d.attackX );
				}
				else 
					MPlayer.addInstallCall(playerId, onPlayerLoad,[playerId]);
					
				if ( playerId == UserData.instance.playerId )
					updSelfStateUI() ;
			}
		}
		
		public function playerNormal(playerId:uint,state:uint = 0xFFFF):void{
			var s:uint = state == 0xFFFF ? _data.getPlayerState(playerId) & 0xFFFF : state ;
			var p:Player = MPlayer.getPlayer(playerId);
			if( _setup ){
				if( p != null ){
					switch(s){
						case PLAYER_BATTLE:
							p.walkStop() ;
							break ;
						case PLAYER_DIE:
							p.setGhost(false);
							break ;
						default:
							;
					}
				}
				else {
					MPlayer.addInstallCall(playerId, onPlayerLoad,[playerId]);
				}
				if ( playerId == UserData.instance.playerId )
					updSelfStateUI(PLAYER_NORMAL) ;
			}
			_data.setPlayerState(playerId,PLAYER_NORMAL);
			_data.removeAttackTarget(playerId);
		}
		
		public function playerDie( playerId:uint , time:uint ):void{
			var s:uint = _data.getPlayerState(playerId) & 0xFFFF ;
			var p:Player = MPlayer.getPlayer(playerId);
			if( _setup ){
				
				if( p != null ){
					if( s == PLAYER_BATTLE )
						p.walkStop() ;
					p.setGhost(true);
				}
				else{
					MPlayer.addInstallCall(playerId, onPlayerLoad,[playerId]);				
				}
				if ( playerId == UserData.instance.playerId )
					updSelfStateUI(PLAYER_DIE | (time << 16 )) ;

			}
			_data.setPlayerState(playerId,PLAYER_DIE,time);
			_data.removeAttackTarget(playerId);
		}

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 进入 */
        public function sc_enter() : void
        {
            isEnter = true;
            isOver = false;
			_quitbtn.show();
			ViewManager.addStageResizeCallFun(onStageResize);
			onStageResize() ;
//			ExitButton.instance.setVisible(true, cs_quit);
//            quitButton.clickCall = cs_quit;
//            quitButton.show();
			StateManager.instance.changeState(StateType.GUILDESCOR);
            // 临时测试
//            testDrawWay();
        }
		
//		private function onClickExit():void{
//			StateManager.instance.checkMsg(225,null,null,null,Alert.OK );
//		}
		
        public var isEnter : Boolean = false;
        private var isOver : Boolean = false;

        public function sc_over() : void
        {
            isOver = true;
			
			_data.forEachPlayer(playerNormal);
			
			if (faseReviveAlert) {
				faseReviveAlert.hide();
				faseReviveAlert = null ;
			}
 			StateManager.instance.changeState(StateType.NO_STATE);
        }

        /** 退出 */
        public function sc_quit() : void
        {
            isEnter = false;
//			UIManager.root.removeChild(_quitbtn);
			_quitbtn.hide() ;
			ViewManager.removeStageResizeCallFun(onStageResize);

            uiPlayerStatus.hide();
			if (faseReviveAlert) {
				faseReviveAlert.hide();
				faseReviveAlert = null ;
			}

            for (var key:String in drayDic)
            {
                var dray : Dray = drayDic[key];
                dray.quit() ;
                delete drayDic[key];
            }
			
			_data.forEachPlayer(playerNormal);
 			StateManager.instance.changeState(StateType.NO_STATE);
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
//        public function testDrawWay() : void
//        {
//            var dic : Dictionary = MCEConfig.placeDic;
//            for each (var placeStruct : MCEPlaceStruct in dic)
//            {
//                var c : Sprite = circle();
//                c.x = placeStruct.x;
//                c.y = placeStruct.y;
//                pList.push(c);
//                MapController.instance.elementLayer.addChild(c);
//            }
//        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 向服务器发送离开 */
        public function cs_quit() : void
        {
            proto.cs_quit();
        }
		
		private function initDray( dray:DrayData ):Boolean{
			var d :Dray = new Dray(); 
			d.initDray(dray);
			drayDic[dray.drayId] = d ;
			
			return false ;
		}
		
		private function initPlayerStatus( playerId:uint , status:uint ):Boolean{
			
			if( MPlayer.getPlayer(playerId) == null )
				MPlayer.addInstallCall(playerId, onPlayerLoad,[playerId]);
			else
				onPlayerLoad(playerId);
			return false ;
		}
		
		public function initEscor():void
		{
			if( MapUtil.isClanEscortMap() ){
				
				_data.forEachDray(initDray);
				_data.forEachPlayer(initPlayerStatus);
				
				_quitbtn.show() ;
				_setup = true ;
				
				updSelfStateUI();
				
				//TODO : temp , 
				if( !ClanEscortResultPanel.instance.hasInit )
					RESManager.instance.load(new LibData(UrlUtils.getLangSWF("mapClanEscort.swf"), "mce"), ClanEscortResultPanel.instance.initViews);
				ViewManager.instance.clearFullViews();
			}
		}

		private function updSelfStateUI( status:uint = 0xFFFF ) : void {
			
			var stat:uint = status == 0xFFFF ? _data.getPlayerState(UserData.instance.playerId) : status ;
			if( ( stat & 0xFFFF ) == 1 ){
				uiPlayerStatus.battleing() ;
				if( _walkEnable ){
					_walkEnable = false ;
					MTo.validWalk.reset().add(checkMove).endChange();
				}
			}
			else if( (stat & 0xFFFF) == 2 ){
                uiPlayerStatus.cdQuickenBtnCall = faseReviveCall;
                uiPlayerStatus.cdCompleteCall = reviveCompleteCall;
                uiPlayerStatus.setCDTime(stat >> 16);
//				MMouse.enableWalk = true ;
				if( !_walkEnable ){
					_walkEnable = true ;
					MTo.validWalk.reset().endChange();
				}
			}
			else {
				uiPlayerStatus.hide() ;
//				MMouse.enableWalk = true ;
				if( !_walkEnable ){
					_walkEnable = true ;
					MTo.validWalk.reset().endChange();
				}
				if( faseReviveAlert != null ){
					faseReviveAlert.hide() ;
					faseReviveAlert = null ;
				}
			}
		}
		
		private function checkMove( val:Validator ):Boolean{
			StateManager.instance.checkMsg(23);
			return false ;
		}

		private function onClickLeave(event : MouseEvent) : void {
			MCEProto.instance.cs_quit();
		}

        /** 快速复活对话框 */
        private var faseReviveAlert : Alert;

        /** 快速复活 */
        private function faseReviveCall() : void
        {
			if( UserData.instance.gold + UserData.instance.goldB >= 10 )
            	faseReviveAlert = StateManager.instance.checkMsg(226, [], faseReviveAlertCall);
			else 
				StateManager.instance.checkMsg(4);
        }

        /** 快速复活对话框回调 */
        private function faseReviveAlertCall(eventType : String) : Boolean
        {
            switch(eventType)
            {
                case Alert.OK_EVENT:
                    if (UserData.instance.gold + UserData.instance.goldB >= 10  )
                    {
                        proto.cs_playerFastRevive();
						if (faseReviveAlert) {
							faseReviveAlert.close();
							faseReviveAlert = null ;
						}
						return false ;
                    }
					else
					{
						StateManager.instance.checkMsg(4);
					}
                    break;
            }
            return true;
        }

        /** 复活时间到 */
        private function reviveCompleteCall() : void
        {
            // playerRevive(selfPlayerId);
        }
		
		private function onStageResize(stage:Stage = null, preStageWidth:Number = 0, preStageHeight:Number = 0):void{
			_quitbtn.x = UIManager.stage.stageWidth - 90;
			_quitbtn.y = 20;
		}
		
		public function syncDray( drayId:uint ):void{
			if( drayDic[drayId]!=null ){
				(drayDic[drayId] as Dray).syncDrayStatus() ;
			}
		}
    }
}
class Singleton
{
}
