package game.module.mapClanEscort.data {
	import game.module.mapClanEscort.MCEConfig;
	import game.module.mapClanEscort.MCEPlaceStruct;

	import flash.utils.Dictionary;
	/**
	 * @author zhangzheng
	 */
	public class EscortData {
		
		private static var _instance:EscortData ;
		
		/**uint:DrayData*/
		private var _dray:Dictionary;
		private var _drayList:Array;
		/**uint:uint*/
		private var _playerState:Dictionary;
		private var _attackTarget:Dictionary;
		private var _playerList:Array ;
		
		public static function get instance():EscortData{
			if( _instance == null )
				_instance = new EscortData(new Singleton());
			return _instance ;
		}
		
		public function EscortData( s:Singleton ){
			
		}
		/** 低16位 0:normal , 1:battle , 2:dead , 高16位 time */
		public function getPlayerState(id:uint):uint{
			return _playerState[id];
		}
		
		public function setPlayerState(id:uint , state:uint = 0, time:uint = 0):void{
			if( !_playerState.hasOwnProperty(id) )
				_playerList.push(id);
			_playerState[id] = ( time << 16 ) | state ;
		}
		
		public function initDrayData(drayId:uint):DrayData{
			if( !_dray.hasOwnProperty(drayId) ){
				_dray[drayId] = new DrayData(drayId) ;
				_drayList.push(drayId);			
			}
			return _dray[drayId];
		}
		
		public function getDrayData(drayId:uint):DrayData{
			return _dray.hasOwnProperty(drayId)?_dray[drayId]:null;
		}
		
		/**(DrayData):boolean*/
		public function forEachDray( fun:Function ):void{
			for each( var i:uint in _drayList ){
				if( fun.apply(null , [_dray[i] as DrayData]) ){
					break ;
				}
			}
		}
		
		public function forEachPlayer( fun:Function ):void{
			for each( var i:uint in _playerList ){
				if( fun.apply(null, [i,_playerState[i]]) ){
					break ;
				}
			}
		}
		
		public function setAttackTarget( playerId:uint , drayId:uint ):void{
			_attackTarget[playerId] = drayId ;
		}
		
		public function removeAttackTarget( playerId:uint ):uint{
			if( _attackTarget.hasOwnProperty(playerId) ){
				var res:uint = _attackTarget[playerId];
			 	delete _attackTarget[playerId];
			 	return res ;
			}
			return 0xFFFF ;
		}
		
		public function getAttackTarget(playerId:uint):uint{
			if( _attackTarget.hasOwnProperty(playerId) ){
				return _attackTarget[playerId];
			}
			return 0xFFFF ;
		}
		
		public function reset():void{
			_dray = new Dictionary() ;
			_drayList = new Array() ;
			_playerState = new Dictionary() ;
			_attackTarget = new Dictionary() ;
			_playerList = new Array();
		}
		
	}
}

class Singleton{
}