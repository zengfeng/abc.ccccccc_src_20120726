package game.module.quest.animation {
	import game.config.StaticConfig;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarType;
	import game.core.hero.VoHero;
	import game.core.user.UserData;
	import game.manager.RSSManager;
	import game.manager.VersionManager;
	import game.module.quest.VoNpc;

	import net.ALoader;
	import net.BDSWFLoader;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	/**
	 * @author yangyiqiang
	 */
	public class Animation {
		/**
		所有标点请用英文半角
		id  对应的任务编号
		name 任务名
		mapid 地图编号
		mapx  中心点X,Y
		player 玩家列表  1,100,100|  用|区分player     用,区分坐标   
		npc    npc列表
		
		action
		target   动作的执行者  数值与上面player或npc对应
		id       动作分类  1:对话，2:人物移动
		describe 动作描述
		1:对话，对话内容
		2:移动, 目标点坐标
		 */
		public var id : int;
		public var name : String;
		public var mapId : int;
		public var mapX : int;
		public var mapY : int;
		private var _assets : Array = null;
		public var performerDic : Vector.<Performer> = new Vector.<Performer>();
		public var list : Vector.<Action>=new Vector.<Action>();

		/*
		 * <animation id="10100106" name="一句话引起的血案" mapid="1" mapx="100" mapy="100" player="1,100,100|2,200,200" npc="4001,500,100|4002,450,100">
		<action target="1" id="1" describe="轮到我说话" />
		<action target="2" id="1" describe="你快说，我还有好多话要说！" />
		<action target="4001" id="1" describe="话多的人类" />
		<action target="1" id="2" describe="500,90" />
		<action target="1" id="2" describe="敢打扰我们说话，找死!" />
		</animation>
		 */
		public function parse(xml : XML) : void {
			id = xml.@id;
			name = xml.@name;
			mapId = xml.@mapid;
			mapX = xml.@mapx;
			mapY = xml.@mapy;

			var tempArr : Array = String(xml.@player).split("|");
			var obj : Performer;
			for each (var msg:String in tempArr) {
				if (msg == "") continue;
				obj = new Performer(msg.split(","));
				performerDic.push(obj);
			}

			tempArr = String(xml.@npc).split("|");
			for each (msg in tempArr) {
				if (msg == "") continue;
				obj = new Performer(msg.split(","));
				performerDic.push(obj);
			}
			var xmlList : XMLList = xml.descendants("action");
			var action : Action;
			for each (var str:XML in xmlList) {
				action = new Action();
				action.parse(str);
				list.push(action);
			}
		}

		public function getAssets() : Array {
			if (_assets) return _assets;
			_assets = [];
			for each (var obj:Performer in performerDic) {
				if (obj.id == 0) {
				} else {
					var _npcVo : VoNpc = RSSManager.getInstance().getNpcById(obj.id);
					if (!_npcVo) continue;
					var uuid : int = id < 4000 ? AvatarManager.instance.getUUId(_npcVo.avatarId, AvatarType.NPC_TYPE) : AvatarManager.instance.getUUId(_npcVo.avatarId, AvatarType.MONSTER_TYPE);
					_assets.push(new SWFLoader(new LibData(_npcVo.avatarUrl, _npcVo.avatarUrl, true, false), AvatarManager.instance.getAvatarBD(uuid).parse, [_npcVo.avatarUrl]));
				}
			}
			checkMyBattleAvatar();
			return _assets;
		}

		private var _isLoaded : Boolean = false;

		public function isLoaded() : Boolean {
			if (_isLoaded) return _isLoaded;
			_assets = getAssets();
			for each (var loader:ALoader in _assets) {
				if (!RESManager.isLoade(loader.key)) return _isLoaded;
			}
			_isLoaded = true;
			return _isLoaded;
		}

		public function checkMyBattleAvatar() : void {
			var uuid : int;
			var url : String;
			for each (var action:Action in list) {
				if (action.type == 3) {
					var arr : Array = action.describe.split(",");
					if ( arr[3] == 1) {
						_assets.push(new SWFLoader(new LibData(VersionManager.instance.getUrl("assets/ui/Numbers.swf"), "Numbers")));
					}
					if ( arr[3] == 3) {
						_assets.push(new BDSWFLoader(new LibData(VersionManager.instance.getUrl("assets/avatar/battle/die.swf"), "diessss")));
					}
				}
				if (action.type == 11) {
					uuid = AvatarManager.instance.getUUId(25, AvatarType.SEAT_TYPE);
					url = VersionManager.instance.getUrl("assets/avatar/" + uuid + ".swf");
					_assets.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(uuid).parse, [url]));
				}
				if ((action.target == 0 && action.type == 2)) {
					var vo : VoHero = UserData.instance.myHero;
					switch(int(action.describe)) {
						case 11:
						case 13:
							url = vo.getAvatarUrl(1);
							_assets.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(uuid).parse, [url]));
							break;
						case 12:
						case 14:
							url = vo.getAvatarUrl(2);
							_assets.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(uuid).parse, [url]));
							break;
					}
				}
			}
		}

		public function getHalfbody() : Array {
			var arr : Array = [];
			for each (var obj:Performer in performerDic) {
				if (obj.id == 0) {
					if(UserData.instance.myHero.id==0)continue;
					arr.push(StaticConfig.cdnRoot + "assets/avatar/halfBody/" + UserData.instance.myHero.id + ".png");
				} else {
					var _npcVo : VoNpc = RSSManager.getInstance().getNpcById(obj.id);
					if (!_npcVo) continue;
					var url : String = StaticConfig.cdnRoot + "assets/avatar/halfBody/" + _npcVo.halfId + ".png";
					if(_npcVo.halfId==0)continue;
					arr.push(url);
				}
			}
			return arr;
		}

		private var _index : int = 0;

		public function getNextAction() : Action {
			if ((list.length - 1) < _index) return null;
			return list[_index++];
		}

		public function reset() : void {
			_index = 0;
		}
	}
}
