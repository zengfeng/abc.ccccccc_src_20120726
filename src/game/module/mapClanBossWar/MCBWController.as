package game.module.mapClanBossWar {
	import worlds.apis.BarrierOpened;
	import game.core.user.StateManager;
	import game.core.user.StateType;
	import game.core.user.UserData;

//	import worlds.apis.BarrierOpened;
	import worlds.apis.MMouse;
	import worlds.apis.MNpc;
	import worlds.apis.MPlayer;
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;
	import worlds.roles.cores.Npc;
	import worlds.roles.cores.Player;
	import worlds.roles.cores.SelfPlayer;

	import flash.utils.Dictionary;


	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-13 ����2:28:53
	 */
	public class MCBWController
	{
		function MCBWController(singleton : Singleton) : void
		{
			singleton;
		}

		/** 单例对像 */
		private static var _instance : MCBWController;
		
		private var _playerState:Dictionary = new Dictionary();
		private var _playerList:Vector.<uint> = new Vector.<uint>();
		private var _isSetup:Boolean = false ;
		private var _bossAlive:Boolean = false ;
		private var _selfdead:Boolean = false ;
		private var _active:Boolean = false ;

		/** 获取单例对像 */
		public static function get instance() : MCBWController
		{
			if (_instance == null)
			{
				_instance = new MCBWController(new Singleton());
			}
			return _instance;
		}


		public function get selfPlayer() : SelfPlayer
		{
			return SelfPlayer.instance ;
		}

		public function initialize():void{
			if( MapUtil.isClanBossMap() ){
				initPathPass() ;
				_isSetup = true ;
//				MNpc.add(5009);
//				MNpc.add(3021);
				for each( var i:int in _playerList ){
					switch(_playerState[i]){
					case 0x12:
						die(i);
						_playerState[i] = 2 ;
						break ;
					case 0x11:
						battle(i);
						_playerState[i] = 1 ;
						break ;
					case 0x10:
						revive(i);
						_playerState[i] = 0 ;
						break ;
					default:
						;
					}
				}
				
				var n:Npc ;
				n = MNpc.getNpc(5009);
				if( n != null ){
					if( _bossAlive )
						n.addToLayer();
					else
						n.removeFromLayer();
				}
				else{
					MNpc.addInstallCall(5009, onBossInstall);
				}
				n = MNpc.getNpc(3021);
				if( n != null ){
					if( _selfdead )
						n.addToLayer();
					else
						n.removeFromLayer();					
				}
				else{
					MNpc.addInstallCall(3021, onFireWallInstall);
				}
				
			}
		}

		private function onFireWallInstall() : void {
			if( _selfdead )
				MNpc.getNpc(3021).addToLayer();
			else
				MNpc.getNpc(3021).removeFromLayer();					
		}

		private function onBossInstall() : void {
			if( _bossAlive )
				MNpc.getNpc(5009).addToLayer();
			else
				MNpc.getNpc(5009).removeFromLayer();

		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 进入 */
		public function enter() : void
		{
			StateManager.instance.changeState(StateType.GUILDCAVERN);
			if( MWorld.isInstallComplete )
				initialize();
			else
				MWorld.sInstallComplete.add(initialize);
				
			_active = true ;
		}


		/** 退出 */
		public function quit() : void
		{

			// 复活
			revive();
			// 复活所有死亡玩家
			reviveAllDiePlayer();
			_playerList = new Vector.<uint>();
			_playerState = new Dictionary() ;
			// 清理死亡玩家
			//clearDiePlayer();
			StateManager.instance.changeState(StateType.NO_STATE);
		}
		
		public function finish() : void{
			_active = false ;
		}

		/** 进入地图时初始化关卡 */
		public function initPathPass(  ) : void
		{
			if (isSelfDie == false)
			{
				openDiePassPath();
			}
			else
			{
				die(UserData.instance.playerId);
			}
		}

		/** 开放复活路口 */
		private function openDiePassPath() : void
		{
			BarrierOpened.setState(MCBWConfig.diePassColor, true);
		}

		/** 关闭复活路口 */
		private function closeDiePassPath() : void
		{
			BarrierOpened.setState(MCBWConfig.diePassColor, false);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 自己是否死亡 */
		private function get isSelfDie() : Boolean {
			return _playerState[UserData.instance.playerId] == 1;
		}


		/** 死亡 */
		public function die(playerId : int = 0) : void
		{
			if( !_active )
				return ;
			
			if (playerId == UserData.instance.playerId || playerId == 0)
			{
				selfPlayer.walkStop() ;
				setPlayerDie(playerId) ;
			}
			else
			{
				var p:Player ;
				if( ( p = MPlayer.getPlayer(playerId) ) == null ){
					MPlayer.addInstallCall(playerId, onPlayerLoad,[playerId]);
				}
				else{
					setPlayerDie(playerId);
				}
			}
		}
		
		public function battle(playerId:int = 0):void{
			
			if( playerId == UserData.instance.playerId ){
				setPlayerBattle(playerId);
			}
			else{
				var p:Player ;
				if( ( p = MPlayer.getPlayer(playerId) ) == null )
					MPlayer.addInstallCall(playerId, onPlayerLoad,[playerId]);
				else 
					setPlayerBattle(playerId);
			}
		}
		
		private function onPlayerLoad( arr:Array ):void{
			var id:uint = arr[0];
			var pl:Player = MPlayer.getPlayer(id);
			var stat:uint = _playerState[id];
			switch(stat){
				case 1:
					pl.attack(MNpc.getNpc(5009));
					break ;
				case 2:
					pl.setGhost(true);
					break;
				default:
					;
			}
		}

		/** 设置玩家战斗状态 */
		public function setPlayerBattle(playerId : int) : void
		{
			if( !_active )
				return ;
			var player : Player;
			if (playerId == UserData.instance.playerId || playerId == 0)
			{
				var wall:Npc = MNpc.getNpc(3021);
				if( wall != null ){
					wall.removeFromLayer() ;
				}
				_selfdead = false ;
				MMouse.enableWalk = false ;
				player = selfPlayer ;
			}
			else
			{
				player = MPlayer.getPlayer(playerId);
			}

			if (player)
			{
				var n:Npc = MNpc.getNpc(5009);
				player.walkStop();
				player.attack(n);
			}
		}

		/** 设置玩家死亡状态 */
		public function setPlayerDie(playerId : int) : void
		{
			if( !_active )
				return ;
			
			var player : Player;
			if (playerId == UserData.instance.playerId || playerId == 0)
			{
				var n:Npc = MNpc.getNpc(3021);
				if( n != null )
				{
					n.addToLayer();
					n.avatar.mouseEnabled = false ;
					n.avatar.mouseChildren = false ;
				}
				_selfdead = true ;
				closeDiePassPath();
				player = selfPlayer ;
				MMouse.enableWalk = true ;
			}
			else
			{
				player = MPlayer.getPlayer(playerId);
//				addDiePlayer(playerId);
			}
			if (player)
			{
				player.cancelAttack();
				player.setGhost(true);
			}
		}

		/** 复活所有死亡玩家 */
		public function reviveAllDiePlayer() : void
		{
			for each( var i:uint in _playerList ){
				var player : Player = MPlayer.getPlayer(i);
				if( player == null )
					continue ;
				if( _playerState[i] == 1 ){
					player.cancelAttack();
					_playerState[i] = 0 ;
				}
				else if( _playerState[i] == 2 ){
					player.setGhost(false) ;
					_playerState[i] = 0 ;
				}
			}
			MMouse.enableWalk = true  ;
		}

		/** 复活 */  //TODO :stop revive time;
		public function revive(playerId : int = 0) : void
		{
			var player : Player;
			if (playerId == UserData.instance.playerId || playerId == 0)
			{
				openDiePassPath();
				player = selfPlayer;
				var n:Npc ;
				if( ( n = MNpc.getNpc(3021) ) != null ){
					n.removeFromLayer() ;
				}
				_selfdead = false ; 
			}
			else
			{
				player = MPlayer.getPlayer(playerId);
			}

			if (player) {
				player.cancelAttack() ;
				player.setGhost(false);
			}
		}
		
		public function setPlayerState( id:int , state:int ):void{
			if( !_playerState.hasOwnProperty(id) ){
				_playerList.push(id);
			}
			if( _isSetup ){
				if( state == 1 ){
					battle(id);
				}
				else if( state == 2 ){
					die(id);
				}else if( state == 0 ){
					revive(id);
				}
				_playerState[id] = state ;
				return ;
			}
			_playerState[id] = 0x10 | state ;
		}
		
		public function removePlayer(id:int):void{
			delete _playerState[id];
			var index:int = _playerList.indexOf(id);
			if( index > 0 )
				_playerList.splice(index, 1);
		}


		public function clear() : void {
			
			_playerList = new Vector.<uint>() ;
			_playerState = new Dictionary() ;
			_isSetup = false ;
		}

		public function showBoss(isShow:Boolean) : void {
			
			var n:Npc = MNpc.getNpc(5009);
			if( n != null ){
				if( isShow )
					n.addToLayer();
				else
					n.removeFromLayer();
			}
			_bossAlive = isShow ;
		}
	}
}
class Singleton
{
}