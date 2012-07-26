package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class GuildMember extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@position   position
		  **/
		public var position:uint;

		 /**
		  *@rank   rank
		  **/
		public var rank:uint;

		 /**
		  *@devote   devote
		  **/
		public var devote:uint;

		 /**
		  *@latestonl   latestonl
		  **/
		public var latestonl:uint;

		 /**
		  *@potential   potential
		  **/
		public var potential:uint;

		 /**
		  *@online   online
		  **/
		private var online$field:Boolean;

		private var hasField$0:uint = 0;

		public function removeOnline():void {
			hasField$0 &= 0xfffffffe;
			online$field = new Boolean();
		}

		public function get hasOnline():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set online(value:Boolean):void {
			hasField$0 |= 0x1;
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
			hasField$0 &= 0xfffffffd;
			vote$field = new uint();
		}

		public function get hasVote():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set vote(value:uint):void {
			hasField$0 |= 0x2;
			vote$field = value;
		}

		public function get vote():uint {
			return vote$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, name);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, level);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, position);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, rank);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, devote);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 7);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, latestonl);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 8);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, potential);
			if (hasOnline) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 9);
				com.protobuf.WriteUtils.write$TYPE_BOOL(output, online$field);
			}
			if (hasVote) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 10);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, vote$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var name$count:uint = 0;
			var level$count:uint = 0;
			var position$count:uint = 0;
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
						throw new flash.errors.IOError('Bad data format: GuildMember.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildMember.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildMember.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (position$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildMember.position cannot be set twice.');
					}
					++position$count;
					position = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (rank$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildMember.rank cannot be set twice.');
					}
					++rank$count;
					rank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (devote$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildMember.devote cannot be set twice.');
					}
					++devote$count;
					devote = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (latestonl$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildMember.latestonl cannot be set twice.');
					}
					++latestonl$count;
					latestonl = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildMember.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (online$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildMember.online cannot be set twice.');
					}
					++online$count;
					online = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 10:
					if (vote$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildMember.vote cannot be set twice.');
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
