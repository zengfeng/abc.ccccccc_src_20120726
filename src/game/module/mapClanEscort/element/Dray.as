package game.module.mapClanEscort.element {
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarThumb;
	import game.core.avatar.AvatarType;
	import game.manager.RSSManager;
	import game.module.mapClanEscort.MCEPlaceStruct;
	import game.module.mapClanEscort.MCEProto;
	import game.module.mapClanEscort.data.DrayData;
	import game.module.quest.VoNpc;

	import worlds.apis.MFactory;
	import worlds.apis.MapUtil;
	import worlds.roles.animations.SimpleAnimation;
	import worlds.roles.cores.Role;

	import flash.events.Event;
//	import game.module.map.animal.AnimalManager;
//	import game.module.map.animal.DrayAnimal;
	// import game.module.map.animalstruct.DrayStruct;



    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-2-24   ����10:36:09 
     */
    public class Dray
    {
		private var _data:DrayData ;
		private var _monster:Role ;
		private var _npcDray:Role ;
        private var _setup : Boolean = false;
        /** 初始化 */
        public function initDray(data:DrayData) : void
        {
			if (data == null)
				return ;
            if (_setup == true) 
				return;
			
			_setup = true ;
			_data = data ;
			_npcDray = makeRole( _data.drayavatar , _data.currentX, _data.currentY, 1/6 );
			if( _data.drayHp > 0 ){
				_npcDray.addToLayer() ;
				_npcDray.setProgressBarVisible(true);
				_npcDray.setProgressBarValue(_data.drayHp);
			}
			syncDrayStatus();
		}
		
		private function makeRole( id:uint , x:uint ,y:uint , speed:Number = 4 , isMonster:Boolean = false ):Role{

			var avatarId : int ;
			var name : String ;
//			var colorStr : String ;
			
			var voNpc : VoNpc = RSSManager.getInstance().getNpcById(id);
			if (voNpc == null) return null;
			avatarId = voNpc.avatarId;
			name = voNpc.name;
//			colorStr = "0xFF7E00";

			var role : Role = MFactory.makeRole();
			var avatar : AvatarThumb = AvatarManager.instance.getAvatar(id, isMonster?AvatarType.MONSTER_TYPE : AvatarType.DRAY_AVATER );
			avatar.setName(name);
			var animation : SimpleAnimation = MFactory.makeSimpleAnimation();
			animation.resetSimple(avatar);
			role.resetRole(id);
			role.setAnimation(animation);
			if (MapUtil.hasMask) role.setNeedMask(MapUtil.hasMask);
			role.initPosition(x, y, speed);
			return role;
		}
		
		public function monsterDamage():void{
			
			if( !_setup )
				return ;
			if( _monster != null ){
				_monster.setProgressBarValue( _data.monsterHpRate );
			}
		}
		
		//TODO
		private function onDefComplete(evt:Event):void{
			_npcDray.avatar.player.removeEventListener(Event.COMPLETE, onDefComplete);
			_npcDray.setAction(13);
		}
		
		public function syncDrayStatus():void{
			
			switch(_data.status){
				case DrayStatus.MOVE:{
						if( _monster != null ){
							//TODO : fade out effect ;
//							_monster.destory();
							_monster.cancelAttack() ;
							_monster.fadeQuit();
							_monster = null ;
						}
						var place:MCEPlaceStruct = _data.getNextPlace() ;
						_npcDray.walkPathTo(place.x, place.y);
					}
					break ;
				case DrayStatus.BE_ROB:{
						if( _monster == null ){
							_monster = makeRole( _data.monsterId , _npcDray.x - 70, _npcDray.y - 20 , 4 , true);
							_monster.addToLayer();
							_monster.setProgressBarVisible(true);
							_monster.setProgressBarValue(_data.monsterHpRate);
							_monster.attack(_npcDray);
							_monster.addClickCall(function( r:Role ):void{ MCEProto.instance.cs_playerBattle(_data.drayId) ; });
						}
						_npcDray.setProgressBarValue( _data.drayHp );
						//TODO
						if( _npcDray.avatar.getAction() != 12 && _npcDray.avatar.getAction() != 13 ){
							_npcDray.walkStop() ;
							_npcDray.avatar.setAction(12,1);
							_npcDray.avatar.player.addEventListener(Event.COMPLETE, onDefComplete);
						}
					}
					break ;
				case DrayStatus.COMPLETE:{
						if( _data.drayHp > 0 ){
							_npcDray.walkStop();
							_npcDray.setAction(11);
							_npcDray.avatar.player.flipH = false  ;
						}
						else{
							_npcDray.removeFromLayer() ;
							_npcDray.fadeQuit() ;
							if( _monster != null ){
								
//								_monster.destory() ;
								_monster.cancelAttack() ;
								_monster.fadeQuit() ;
								_monster = null ;
							}
						}
					}
					break;
				default :
					;
			}
		}
		

//        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
//        /** 战斗玩家ID */
//        public var battlePlayerList : Vector.<int> = new Vector.<int>();
//
//        /** 添加战斗玩家ID */
//        public function addBattlePlayer(playerId : int) : void
//        {
//            var index : int = battlePlayerList.indexOf(playerId);
//            if (index == -1)
//            {
//                battlePlayerList.push(index);
//            }
//        }
//
//        /** 移除战斗玩家ID */
//        public function reomveBattlePlayer(playerId : int) : void
//        {
//            var index : int = battlePlayerList.indexOf(playerId);
//            if (index != -1)
//            {
//                battlePlayerList.splice(index, 1);
//            }
//        }
//
//        /** 清理战斗玩家 */
//        public function clearBattlePlayer() : void
//        {
//            while (battlePlayerList.length > 0)
//            {
//                battlePlayerList.shift();
//            }
//        }
//		
//		public function set monsterMaxHp(value:Number):void{
//			_monsterMaxHp = value ;
//		}
//		
		public function get attackX():uint{
			return _monster == null ? _npcDray.x : _monster.x ;
		}
		
		public function get attackY():uint{
			return _monster == null ?  _npcDray.y : _monster.y ;
		}
		
		public function quit():void{
			if( _npcDray != null ){
				_npcDray.destory() ;
				_npcDray = null ;
			}
			
			if( _monster != null ){
				_monster.destory() ;
				_monster = null ;
			}
		}

//		
//		public function get attacktarget():Role{
//			return _monster == null ? _npcDray : _monster ;
//		}
    }
}
