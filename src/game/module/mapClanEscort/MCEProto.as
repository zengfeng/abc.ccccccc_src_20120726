package game.module.mapClanEscort {
	import game.net.data.StoC.SCGuildEscorFinish;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.module.mapClanEscort.data.DrayData;
	import game.module.mapClanEscort.data.EscortData;
	import game.module.mapClanEscort.element.DrayStatus;
	import game.module.mapClanEscort.ui.ClanEscortResultPanel;
	import game.net.core.Common;
	import game.net.data.CtoS.CSGEEnter;
	import game.net.data.CtoS.CSGELeave;
	import game.net.data.CtoS.CSGEPlayerBattle;
	import game.net.data.CtoS.CSGEPlayerFastRevive;
	import game.net.data.StoC.GEDrayData;
	import game.net.data.StoC.SCGEDrayComplete;
	import game.net.data.StoC.SCGEDraySyn;
	import game.net.data.StoC.SCGEEnterInfo;
	import game.net.data.StoC.SCGEInfo;
	import game.net.data.StoC.SCGELeave;
	import game.net.data.StoC.SCGEPlayerBattle;
	import game.net.data.StoC.SCGEPlayerBattleEnd;
	import game.net.data.StoC.SCGEPlayerRevive;
	import game.net.data.StoC.SCGEResult;



    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-2-23   ����10:39:55 
     */
    public class MCEProto
    {
        public function MCEProto(singleton : Singleton)
        {
            singleton;
            sToC();
        }

        /** 单例对像 */
        private static var _instance : MCEProto;

        /** 获取单例对像 */
        static public function get instance() : MCEProto
        {
            if (_instance == null)
            {
                _instance = new MCEProto(new Singleton());
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 控制器 */
        private var _controller : MCEController;

        /** 控制器 */
        public function get controller() : MCEController
        {
            if (_controller == null)
            {
                _controller = MCEController.instance;
            }
            return _controller;
        }

        /** 自己玩家ID */
        public function get selfPlayerId() : int
        {
            return UserData.instance.playerId;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 协议监听 */
        private function sToC() : void
        {
            // 协议监听 -- 0x2F2 家族运镖信息
            Common.game_server.addCallback(0x2F2, sc_info);
        }

        private function addCallBackList() : void
        {
            // 协议监听 -- 0x2F3 镖车同步消息
            Common.game_server.addCallback(0x2F3, sc_draySynchro);
            // 协议监听 -- 0x2F4 镖车到达完成
            Common.game_server.addCallback(0x2F4, sc_drayComplete);
            // 协议监听 -- 0x2F5 玩家战斗
            Common.game_server.addCallback(0x2F5, sc_playerBattle);
            // 协议监听 -- 0x2F6 玩家复活
            Common.game_server.addCallback(0x2F6, sc_playerRevive);
            // 协议监听 -- 0x2F7 结算
            Common.game_server.addCallback(0x2F7, sc_result);
			// 协议监听 -- 0x2FD 结束
			Common.game_server.addCallback(0x2FD, sc_finish);
            // 协议监听 -- 0x2F8 退出
            Common.game_server.addCallback(0x2F8, sc_quit);
            // 协议监听 -- 0x2F9 玩家死亡
            Common.game_server.addCallback(0x2F9, sc_playerEnter);
            // 协议监听 -- 0x2FA 玩家战斗结束
            Common.game_server.addCallback(0x2FA, sc_playerBattleEnd);
		}

		private function sc_finish( msg:SCGuildEscorFinish ) : void {
			removeCallBackList();
			controller.sc_quit();
		}

        private function removeCallBackList() : void
        {
            // 协议监听 -- 0x2F3 镖车同步消息
            Common.game_server.removeCallback(0x2F3, sc_draySynchro);
            // 协议监听 -- 0x2F4 镖车到达完成
            Common.game_server.removeCallback(0x2F4, sc_drayComplete);
            // 协议监听 -- 0x2F5 玩家战斗
            Common.game_server.removeCallback(0x2F5, sc_playerBattle);
            // 协议监听 -- 0x2F6 玩家复活
            Common.game_server.removeCallback(0x2F6, sc_playerRevive);
            // 协议监听 -- 0x2F7 结算
            Common.game_server.removeCallback(0x2F7, sc_result);
            // 协议监听 -- 0x2F8 退出
            Common.game_server.removeCallback(0x2F8, sc_quit);
            // 协议监听 -- 0x2F9 玩家死亡
            Common.game_server.removeCallback(0x2F9, sc_playerEnter);
			
			Common.game_server.removeCallback(0x2FD, sc_finish);
			
			Common.game_server.removeCallback(0x2FA, sc_playerBattleEnd);
        }

        /** 协议监听 -- 0x2F2 家族运镖信息 */
        private function sc_info(msg : SCGEInfo) : void
        {
            addCallBackList();
			var d:EscortData = EscortData.instance ;
			d.reset() ;
			
			for each ( var dray:GEDrayData in msg.drayList ){
				var ddata:DrayData = d.initDrayData(dray.drayId);
				ddata.placeId = dray.status & 0xFFFF ;
				ddata.status = dray.status >> 29 ;
				ddata.walkedTime = (dray.status & 0x1FFF0000) >> 16 ;
				ddata.drayHp = dray.hP ;
				if( dray.hasMonsterTotalHP )ddata.monsterMaxHp = dray.monsterTotalHP ;
				ddata.monsterHp = dray.hasMonsterHP ? dray.monsterHP : ddata.monsterMaxHp ;
			}
			
			for each( var dpid:uint in msg.diePlayerList ){
				controller.playerDie(dpid, 0);
			}
			for ( var i:uint = 0 ; i < msg.battlePlayerList.length ; ++ i ){
				controller.playerAttack( msg.battlePlayerList[i] ,msg.battlePlayerPath[i]);
			}
			
			
            if (msg.hasRevtime == true)
            {
                // 14-15bit: 1:战斗->胜利, 2:死亡 , 3:战斗->死亡, 没有:打酱油
                var selfstatus:uint = msg.revtime >> 14 ;
				var selftime:uint = msg.revtime & 0x3FFF ;
				var selfPath:uint = msg.hasPath ? msg.path : -1 ;
				
				switch( selfstatus ){
					case 1:
					case 3:
						controller.playerAttack(UserData.instance.playerId, selfPath);
						break ;
					case 2:
						controller.playerDie(UserData.instance.playerId,selftime);
						break ;
					default:
						;
				}
            }

            controller.sc_enter();
        }

        /** 协议监听 -- 0x2F3 镖车同步消息 */
        public function sc_draySynchro(msg : SCGEDraySyn) : void
        {
            var drayData : GEDrayData = msg.dray;
			var d:DrayData = EscortData.instance.getDrayData(drayData.drayId);
			d.placeId = drayData.status & 0xFFFF ;
			d.status = drayData.status >> 29 ;
            if (drayData.hasHP) d.drayHp = drayData.hP;
            if (drayData.hasMonsterTotalHP) d.monsterMaxHp = drayData.monsterTotalHP;
            if (drayData.hasMonsterHP) d.monsterHp = drayData.monsterHP;
			controller.syncDray(drayData.drayId);
			
        }

        /** 协议监听 -- 0x2F4 镖车到达完成  */
        private function sc_drayComplete(msg : SCGEDrayComplete) : void
        {
			var d:DrayData = EscortData.instance.getDrayData(msg.drayId);
			d.status = DrayStatus.COMPLETE ;
			if ( msg.hasSuccess && !msg.success ){
				d.drayHp = 0;
			}
			controller.syncDray(msg.drayId);
        }

        /** 协议监听 -- 0x2F5 玩家战斗  */
        private function sc_playerBattle(msg : SCGEPlayerBattle) : void
        {
			var d:DrayData = EscortData.instance.getDrayData(msg.drayId);
			d.monsterHp = msg.health ;
			controller.playerAttack(msg.playerId, msg.drayId);
			if( controller.getDray( msg.drayId ) != null ){
				controller.getDray( msg.drayId ).monsterDamage();
			}
        }

        /** 协议监听 -- 0x2FA 玩家战斗结束  */
        private function sc_playerBattleEnd(msg : SCGEPlayerBattleEnd) : void
        {
            // 战斗胜利
            if (msg.hasDeadtim == false)
            {
                controller.playerNormal(msg.player);
            }
            // 战斗失败
            else
            {
                controller.playerDie(msg.player, msg.deadtim);
            }
        }

        /** 协议监听 -- 0x2F6 玩家复活  */
        private function sc_playerRevive(msg : SCGEPlayerRevive) : void
        {
            controller.playerNormal(msg.playerId);
        }

        /** 协议监听 -- 0x2F7 结算  */
        private function sc_result(msg : SCGEResult) : void
        {
//            Alert.show("结算");
            if(controller.isEnter == false) return;
            ClanEscortResultPanel.instance.scMsg(msg);
            controller.sc_over();
        }

        /** 协议监听 -- 0x2F8 退出  */
        private function sc_quit(msg : SCGELeave) : void
        {
            removeCallBackList();
//            Alert.show("离开");
            msg;
            controller.sc_quit();
        }

        /** 协议监听 -- 0x2F9 刚进来的人是死亡了的  */
        private function sc_playerEnter(msg : SCGEEnterInfo) : void
        {
			
            // 0正常 1战斗失败 2死亡 3战斗死亡
            if (msg.status == 1 || msg.status == 3)
            {
				controller.playerAttack(msg.player,0);
//                setTimeout(controller.playerBattle, 1000, msg.player, true);
            }
            else if (msg.status == 2)
            {
                controller.playerDie(msg.player, 0);
            }
//            else if (msg.status == 3)
//            {
//                controller.playerBattle(msg.player);
//            }
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 发送协议[0x2F2] -- 进入家族运镖地图 */
        public function cs_enter() : void
        {
            var msg : CSGEEnter = new CSGEEnter();
            Common.game_server.sendMessage(0x2F2, msg);
        }

        /** 发送协议[0x2F3] -- 玩家战斗 */
        public function cs_playerBattle(drayId : int) : void
        {
            if (EscortData.instance.getPlayerState(UserData.instance.playerId) > 2)
            {
                StateManager.instance.checkMsg(223);
                return;
            }

            var msg : CSGEPlayerBattle = new CSGEPlayerBattle();
            msg.drayId = drayId;
            Common.game_server.sendMessage(0x2F3, msg);
        }

        /** 发送协议[0x2F4] -- 玩家快速复活 */
        public function cs_playerFastRevive() : void
        {
            var msg : CSGEPlayerFastRevive = new CSGEPlayerFastRevive();
            Common.game_server.sendMessage(0x2F4, msg);
        }

        /** 发送协议[0x2F5] -- 退出 */
        public function cs_quit() : void
        {
            var msg : CSGELeave = new CSGELeave();
            Common.game_server.sendMessage(0x2F5, msg);
        }
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
    }
}
class Singleton
{
}