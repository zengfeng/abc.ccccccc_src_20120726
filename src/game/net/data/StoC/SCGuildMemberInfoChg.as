package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2CA
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGuildMemberInfoChg extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@level   level
		  **/
		private var level$field:uint;

		private var hasField$0:uint = 0;

		public function removeLevel():void {
			hasField$0 &= 0xfffffffe;
			level$field = new uint();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set level(value:uint):void {
			hasField$0 |= 0x1;
			level$field = value;
		}

		public function get level():uint {
			return level$field;
		}

		 /**
		  *@rank   rank
		  **/
		private var rank$field:uint;

		public function removeRank():void {
			hasField$0 &= 0xfffffffd;
			rank$field = new uint();
		}

		public function get hasRank():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set rank(value:uint):void {
			hasField$0 |= 0x2;
			rank$field = value;
		}

		public function get rank():uint {
			return rank$field;
		}

		 /**
		  *@devote   devote
		  **/
		private var devote$field:uint;

		public function removeDevote():void {
			hasField$0 &= 0xfffffffb;
			devote$field = new uint();
		}

		public function get hasDevote():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set devote(value:uint):void {
			hasField$0 |= 0x4;
			devote$field = value;
		}

		public function get devote():uint {
			return devote$field;
		}

		 /**
		  *@latestonl   latestonl
		  **/
		private var latestonl$field:uint;

		public function removeLatestonl():void {
			hasField$0 &= 0xfffffff7;
			latestonl$field = new uint();
		}

		public function get hasLatestonl():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set latestonl(value:uint):void {
			hasField$0 |= 0x8;
			latestonl$field = value;
		}

		public function get latestonl():uint {
			return latestonl$field;
		}

		 /**
		  *@potential   potential
		  **/
		private var potential$field:uint;

		public function removePotential():void {
			hasField$0 &= 0xffffffef;
			potential$field = new uint();
		}

		public function get hasPotential():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set potential(value:uint):void {
			hasField$0 |= 0x10;
			potential$field = value;
		}

		public function get potential():uint {
			return potential$field;
		}

		 /**
		  *@online   online
		  **/
		private var online$field:Boolean;

		public function removeOnline():void {
			hasField$0 &= 0xffffffdf;
			online$field = new Boolean();
		}

		public function get hasOnline():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set online(value:Boolean):void {
			hasField$0 |= 0x20;
			online$field = value;
		}

		public function get online():Boolean {
			return online$field;
		}

		 /**
		  *@vote   vote
		  **/
		private var vote$field:uint;

		public function removeVote():void {
			hasField$0 &= 0xffffffbf;
			vote$field = new uint();
		}

		public function get hasVote():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set vote(value:uint):void {
			hasField$0 |= 0x40;
			vote$field = value;
		}

		public function get vote():uint {
			return vote$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var level$count:uint = 0;
			var rank$count:uint = 0;
			var devote$count:uint = 0;
			var latestonl$count:uint = 0;
			var potential$count:uint = 0;
			var online$count:uint = 0;
			var vote$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildMemberInfoChg.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildMemberInfoChg.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (rank$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildMemberInfoChg.rank cannot be set twice.');
					}
					++rank$count;
					rank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (devote$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildMemberInfoChg.devote cannot be set twice.');
					}
					++devote$count;
					devote = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (latestonl$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildMemberInfoChg.latestonl cannot be set twice.');
					}
					++latestonl$count;
					latestonl = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildMemberInfoChg.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (online$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildMemberInfoChg.online cannot be set twice.');
					}
					++online$count;
					online = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 10:
					if (vote$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildMemberInfoChg.vote cannot be set twice.');
					}
					++vote$count;
					vote = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
