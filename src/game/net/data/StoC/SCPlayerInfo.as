package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x10
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.FormationInfo;
	import game.net.data.StoC.BuffData;
	import game.net.data.StoC.HeroInfo;
	public dynamic final class SCPlayerInfo extends com.protobuf.Message {
		 /**
		  *@gold   gold
		  **/
		public var gold:uint;

		 /**
		  *@goldB   goldB
		  **/
		public var goldB:uint;

		 /**
		  *@silver   silver
		  **/
		public var silver:uint;

		 /**
		  *@profExp   profExp
		  **/
		public var profExp:uint;

		 /**
		  *@status   status
		  **/
		public var status:uint;

		 /**
		  *@opt   opt
		  **/
		public var opt:uint;

		 /**
		  *@heroes   heroes
		  **/
		public var heroes:Vector.<HeroInfo> = new Vector.<HeroInfo>();

		 /**
		  *@availHeroes   availHeroes
		  **/
		public var availHeroes:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@formations   formations
		  **/
		public var formations:Vector.<FormationInfo> = new Vector.<FormationInfo>();

		 /**
		  *@packSize   packSize
		  **/
		public var packSize:uint;

		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@experience   experience
		  **/
		public var experience:uint;

		 /**
		  *@buffList   buffList
		  **/
		public var buffList:Vector.<BuffData> = new Vector.<BuffData>();

		 /**
		  *@totalTopup   totalTopup
		  **/
		public var totalTopup:uint;

		 /**
		  *@totalConsume   totalConsume
		  **/
		public var totalConsume:uint;

		 /**
		  *@tradecnt   tradecnt
		  **/
		private var tradecnt$field:uint;

		private var hasField$0:uint = 0;

		public function removeTradecnt():void {
			hasField$0 &= 0xfffffffe;
			tradecnt$field = new uint();
		}

		public function get hasTradecnt():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set tradecnt(value:uint):void {
			hasField$0 |= 0x1;
			tradecnt$field = value;
		}

		public function get tradecnt():uint {
			return tradecnt$field;
		}

		 /**
		  *@wallow   wallow
		  **/
		public var wallow:uint;

		 /**
		  *@wallowTime   wallowTime
		  **/
		public var wallowTime:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var gold$count:uint = 0;
			var goldB$count:uint = 0;
			var silver$count:uint = 0;
			var profExp$count:uint = 0;
			var status$count:uint = 0;
			var opt$count:uint = 0;
			heroes = new Vector.<HeroInfo>();

			availHeroes = new Vector.<uint>();

			formations = new Vector.<FormationInfo>();

			var packSize$count:uint = 0;
			var level$count:uint = 0;
			var experience$count:uint = 0;
			buffList = new Vector.<BuffData>();

			var totalTopup$count:uint = 0;
			var totalConsume$count:uint = 0;
			var tradecnt$count:uint = 0;
			var wallow$count:uint = 0;
			var wallowTime$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (gold$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.gold cannot be set twice.');
					}
					++gold$count;
					gold = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (goldB$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.goldB cannot be set twice.');
					}
					++goldB$count;
					goldB = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (silver$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.silver cannot be set twice.');
					}
					++silver$count;
					silver = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (profExp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.profExp cannot be set twice.');
					}
					++profExp$count;
					profExp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (opt$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.opt cannot be set twice.');
					}
					++opt$count;
					opt = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					heroes.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.HeroInfo()));
					break;
				case 13:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, availHeroes);
						break;
					}
					availHeroes.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 9:
					formations.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.FormationInfo()));
					break;
				case 10:
					if (packSize$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.packSize cannot be set twice.');
					}
					++packSize$count;
					packSize = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 11:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 12:
					if (experience$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.experience cannot be set twice.');
					}
					++experience$count;
					experience = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 15:
					buffList.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.BuffData()));
					break;
				case 16:
					if (totalTopup$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.totalTopup cannot be set twice.');
					}
					++totalTopup$count;
					totalTopup = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 17:
					if (totalConsume$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.totalConsume cannot be set twice.');
					}
					++totalConsume$count;
					totalConsume = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 29:
					if (tradecnt$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.tradecnt cannot be set twice.');
					}
					++tradecnt$count;
					tradecnt = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 30:
					if (wallow$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.wallow cannot be set twice.');
					}
					++wallow$count;
					wallow = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 31:
					if (wallowTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfo.wallowTime cannot be set twice.');
					}
					++wallowTime$count;
					wallowTime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
