package game.module.mapClanEscort.data {
	import game.module.mapClanEscort.element.DrayStatus;
	import game.module.mapClanEscort.MCEConfig;
	import game.module.mapClanEscort.MCEPlaceStruct;

	import com.commUI.alert.Alert;
	/**
	 * @author zhangzheng
	 */
	public class DrayData {
		
		private var _drayId:uint ;	
			
        private var _pathId : int;
        /** 路线地点ID */
        public var placeId : int;		
        /** 到下一个地点已经走了多少时间 */
        public var walkedTime : Number;
        /** 镖车状态 1.前进中    2.被怪拦截     3.被毁(一般不会用到，除非UI上要显示) */
        public var _status :int;
		
		public var drayHp:uint ;

		public var monsterHp:uint ;
		public var monsterMaxHp:uint ;
		private var _monsterId:uint ;
		
		public function DrayData( drayId:uint ){
			_drayId = drayId ;
			_pathId = drayId >> 4 ;
		}
		public function get drayId():uint{
			return _drayId ;
		}
		public function get pathId():uint{
			return _pathId ;
		}
		public function get monsterId():uint{
			return _monsterId ;
		}
		
		public function monsterAppear():uint{
			var place:MCEPlaceStruct = getPlace() ;
			_monsterId = place == null ? 0 : place.monsterId ;
			return _monsterId ;
		}
		
		public function get drayavatar():uint{
			return MCEConfig.getAvatarId(_drayId);
		}
		
		public function get currentY():uint{
            var placeStruct : MCEPlaceStruct = getPlace();
            if (placeStruct == null) Alert.show("没有配置那么高的地址");
            var nextPlaceStruct : MCEPlaceStruct = getPlace(placeId + 1);			
			return nextPlaceStruct == null ? placeStruct.y : placeStruct.y + (nextPlaceStruct.y - placeStruct.y) * walkedTime / nextPlaceStruct.time ;
		}
		
		public function get currentX():uint{
            var placeStruct : MCEPlaceStruct = getPlace();
            if (placeStruct == null) Alert.show("没有配置那么高的地址");
            var nextPlaceStruct : MCEPlaceStruct = getPlace(placeId + 1);
			return nextPlaceStruct == null ? placeStruct.x : placeStruct.x + (nextPlaceStruct.x - placeStruct.x) * walkedTime / nextPlaceStruct.time ;

		}
		
        public function getPlace(placeId : int = 0) : MCEPlaceStruct
        {
            if (placeId == 0) placeId = this.placeId;
            return MCEConfig.getPlace(placeId);
		}
		
		public function getNextPlace():MCEPlaceStruct{
			return MCEConfig.getPathEndId(pathId) == placeId ? getPlace(placeId) : getPlace(placeId+1);
			
		}
		
		public function get monsterHpRate():Number{
			return Number(monsterHp) / monsterMaxHp * 100 ;
		}
		
		public function get status():uint {
			return _status ;
		}
		
		public function set status(value:uint):void{
			_status = value ;
			if( _status == DrayStatus.MOVE || _status == DrayStatus.COMPLETE ){
				_monsterId = 0 ;
			}
			else if( _status == DrayStatus.BE_ROB ){
				monsterAppear();
			}
		}
	}
}
