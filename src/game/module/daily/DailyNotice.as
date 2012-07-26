package game.module.daily {
	import worlds.apis.MapUtil;
	import framerate.SecondsTimer;

	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.guild.GuildManager;
	import game.module.guild.vo.VoGuildAction;
	import game.net.core.Common;
	import game.net.data.StoC.SCBossFightBegin;
	import game.net.data.StoC.SCBossFightEnd;
	import game.net.data.StoC.SCFeastFinish;
	import game.net.data.StoC.SCFeastPrepare;
	import game.net.data.StoC.SCFeastStart;
	import game.net.data.StoC.SCGDFinish;
	import game.net.data.StoC.SCGDPrepare;
	import game.net.data.StoC.SCGDStart;
	import game.net.data.StoC.SCGroupBattleTime;
	import game.net.data.StoC.SCGuildEscorFinish;
	import game.net.data.StoC.SCGuildEscorPrepare;
	import game.net.data.StoC.SCGuildEscorStart;

	import gameui.manager.UIManager;

	import worlds.apis.MTo;

	import flash.display.Stage;






	/**
	 * @author zhangzheng
	 */
	public class DailyNotice {
		
		private static var _instance : DailyNotice ;
		
//		private var _button:NoticeButton ;
		
		private var _window:NoticeWindow ;
		
		private var _stage:Stage ;
		
		private var _timeLeft:int ;
		
		private var _state : int ;
		
		private var _isShown : Boolean ;
		private var _visible : Boolean;		
		private var _isActive : Boolean ;
		
		private function set shown(value:Boolean):void{
			if( value != _isShown ){
				_isShown = value ;
				if( _isShown ){
					_window.show() ;
				}
				else {
					_window.hide() ;
				}
			}
		}
		public function set visible(value:Boolean):void
		{
			_visible = value ;
			shown = _visible && _isActive ;
//			_window.visible = _visible && _isActive;
		}
		
		public function get visible():Boolean
		{
			return _visible ;
		}
		
		public function DailyNotice( single:Singleton )
		{
			single ;
			_stage = UIManager.stage ;
//			initButton() ;
			initWindow() ;
			layout() ;
		}
		
		public static function initEvents():void
		{
			Common.game_server.addCallback(0xFA, GuildCavernFinishNotice);
			Common.game_server.addCallback(0xFB, GuildCavernPrepareNotice);
			Common.game_server.addCallback(0xFC, GuildCavernStartNotice);
			Common.game_server.addCallback(0x2FB, GuildEscorPrepareNotice);
			Common.game_server.addCallback(0x2FC, GuildEscorStartNotice);   
			Common.game_server.addCallback(0x2FD, GuildEscorFinishNotice);  
			Common.game_server.addCallback(0x304, FeastPrepareNotice);   
			Common.game_server.addCallback(0x302, FeastStartNotice);    
			Common.game_server.addCallback(0x303, FeastFinishNotice); 
			Common.game_server.addCallback(0xC4, GroupBattleNotice);
			Common.game_server.addCallback(0x2E0, BossFightBegin);
			Common.game_server.addCallback(0x2E8, BossFightEnd);
		}

/*		<item id="1" name="BOSS战" icon="/assets/ico/daily/action4.png" />
		<item id="2" name="蓬莱仙会" icon="/assets/ico/daily/action5.png" />
		<item id="3" name="家族寻宝" icon="/assets/ico/guildaction/1.png" />
		<item id="4" name="家族运镖" icon="/assets/ico/guildaction/3.png" />
		<item id="5" name="守卫唐僧" icon="/assets/ico/daily/action2.png"/>
		<item id="6" name="蜀山论剑" icon="/assets/ico/daily/action3/png"/>
*/

		private static function BossFightBegin( msg:SCBossFightBegin ) : void {
			if( MenuManager.getInstance().checkOpen(MenuType.DAILY) && !MapUtil.isBossWarMap() )
			{
				if( msg.flag == 2 || msg.flag == 3 ){
					instance.showNotice(1, 1,0 , function():void{actionShortCut(DailyManage.BOSS_WAR);} );
					SignalBusManager.updateDaily.dispatch(DailyManage.BOSS_WAR,DailyManage.STATE_OPENED,0,0);
				}
				else if( msg.flag >= 4 ){
					instance.showNotice(1, 0, msg.flag-4 ,  function():void{actionShortCut(DailyManage.BOSS_WAR);} ) ;
				}
			}
		}
		
		private static function BossFightEnd( msg:SCBossFightEnd ):void{
			msg ;
			instance.closeNotice() ;
			SignalBusManager.updateDaily.dispatch(DailyManage.BOSS_WAR,DailyManage.STATE_ENDED,0,0);
		}

		private static function GroupBattleNotice(msg:SCGroupBattleTime) : void {
			if( MenuManager.getInstance().checkOpen(MenuType.DAILY) )
			{
				if( msg.status == 1 ){
					instance.showNotice(6, 1 , 0 , function():void{actionShortCut(DailyManage.ID_GROUP_BATTLE);});
					SignalBusManager.updateDaily.dispatch(DailyManage.ID_GROUP_BATTLE,DailyManage.STATE_OPENED,0,0);
				}
				else if( msg.status == 2 ){
					instance.closeNotice();
					SignalBusManager.updateDaily.dispatch(DailyManage.ID_GROUP_BATTLE,DailyManage.STATE_ENDED,0,0);
				}
				else if( msg.status >= 3 && msg.status <= 303 )
				{
					instance.showNotice(6, 0, msg.status-3 );
					SignalBusManager.updateDaily.dispatch(DailyManage.ID_GROUP_BATTLE,DailyManage.STATE_ENDED,0,0);
				}
			}
		}

		public static function get instance():DailyNotice
		{
			if( _instance == null )
				_instance = new DailyNotice(new Singleton());
			return _instance ;
		}
				
		public function initWindow():void
		{
			_window = new NoticeWindow();
			_isShown = false ;
//			_window.visible = false ;
//			ViewManager.instance.addToStage(_window);
			ViewManager.addStageResizeCallFun(layout);
		}
		
		public function showNotice(  id:int , state:int , timer:int = 0 , fun:Function = null  ):void
		{
			var vos:Vector.<VoNotice> = DailyManage.getInstance().getVos(2) as Vector.<VoNotice>;
			var vo:VoNotice = null ;
			for each( var tmp:VoNotice in vos )
			{
				if( tmp.id == id )
				{
					vo = tmp ;
					break ;
				}
			}
			
			if( vo == null )
				return ;
			
//			_button.update( vo , timer, state ) ;
			_window.update( vo, state , fun , timer);
			_isActive = true ;
			shown = _visible ;

			_state = state ;
			_timeLeft = timer ;
			if( _timeLeft != 0 )
				SecondsTimer.addFunction(onSecondTimer);
		}
		
		public function closeNotice():void
		{
//			_button.visible = false ;
//			_button.stopAnimation() ;
			_isActive = false ;
			shown = false ;
			_window.stopAnimation() ;
		}
		
//		public function onClickButton( evt:MouseEvent ):void
//		{
////			_button.visible = false ;
//			_window.fadeIn() ;
//		}
		
		public function layout(...arg):void
		{
//			_button.x = _stage.stageWidth - 67.4 ;
//			_button.y = _stage.stageHeight - 247 ;
			
			_window.x = _stage.stageWidth - 240 ;
			_window.y = _stage.stageHeight - 252 ;

		}
		
		private function onSecondTimer():void
		{
//			SecondsTimer.removeFunction(onSecondTimer);
			if( _timeLeft > 0 )
			{
				-- _timeLeft ;
//				_button.timeLeft = _timeLeft ;
				_window.timeLeft = _timeLeft ;
//				SecondsTimer.addFunction(onSecondTimer);
			}
			else 
			{
				SecondsTimer.removeFunction(onSecondTimer);
			}
			
		}
		private static function actionShortCut( id:uint ):void
		{
			if( id < 100 )
			{
				var vo:VoDaily = DailyManage.getInstance().getDailyVo(id);
				vo.execute();
			}
			else 
			{
				var data:VoGuildAction = GuildManager.instance.actiondata[id - 100];
				MTo.transportTo( 1,data.shortcutx,data.shortcuty,data.shortcutmap);
			}
		}
		
		private function guildCavernExecute():void{
			actionShortCut(102);
		}
		private function guildEscorExecute():void{
			actionShortCut(103);
		}
		private function feastExecute():void{
			actionShortCut(DailyManage.ID_FEAST);
		}

		private static function GuildCavernFinishNotice(msg : SCGDFinish) : void {
			msg ;
			instance.closeNotice();
		}

		private static function GuildCavernPrepareNotice(msg : SCGDPrepare) : void {
			if( UserData.instance.status & 0xC != 0 )
				instance.showNotice(3, 0, msg.timeLeft);
			StateManager.instance.checkMsg(330);
		}

		private static function GuildCavernStartNotice(msg : SCGDStart) : void {
			msg ;
			if( UserData.instance.status & 0xC != 0 )
				instance.showNotice(3, 1, 0, instance.guildCavernExecute);
			StateManager.instance.checkMsg(331);
		}

		private static function GuildEscorPrepareNotice(msg : SCGuildEscorPrepare) : void {
			
			if( UserData.instance.status & 0xC0 != 0 )
				instance.showNotice(4, 0, msg.timeLeft);
			if ( msg.timeLeft == 300 )
				StateManager.instance.checkMsg(212,["贡品押运使"],null,[5]);
		}

		private static function GuildEscorStartNotice(msg : SCGuildEscorStart) : void {
			msg ;
			if( UserData.instance.status & 0xC0 != 0 )
				instance.showNotice(4, 1, 0, instance.guildEscorExecute);
			StateManager.instance.checkMsg(213);
			trace( "guild escor begin :" + (new Date()).time );
		}

		private static function GuildEscorFinishNotice(msg : SCGuildEscorFinish) : void {
			msg;
			instance.closeNotice();
			StateManager.instance.checkMsg(222);
		}

		private static function FeastPrepareNotice(msg : SCFeastPrepare) : void {
			if( MenuManager.getInstance().checkOpen(MenuType.DAILY) )
			{
				instance.showNotice(2, 0, msg.timeLeft, instance.feastExecute);
				if ( msg.timeLeft == 300 )
					StateManager.instance.checkMsg(186);
			}
		}

		private static function FeastStartNotice(msg : SCFeastStart) : void {
			if( MenuManager.getInstance().checkOpen(MenuType.DAILY) )
			{
				msg;
				instance.showNotice(2, 1, 0, instance.feastExecute);
				SignalBusManager.updateDaily.dispatch(DailyManage.ID_FEAST,DailyManage.STATE_OPENED,0,0);
				StateManager.instance.checkMsg(211);
			}
		}

		private static function FeastFinishNotice(msg : SCFeastFinish) : void {
			if( MenuManager.getInstance().checkOpen(MenuType.DAILY) )
			{
				msg;
				instance.closeNotice();
				SignalBusManager.updateDaily.dispatch(DailyManage.ID_FEAST,DailyManage.STATE_ENDED,0,0);
				StateManager.instance.checkMsg(185);
			}
		}

	}
}

class Singleton{
	
}