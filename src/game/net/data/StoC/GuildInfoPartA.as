package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GuildMember;
	public dynamic final class GuildInfoPartA extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@rank   rank
		  **/
		public var rank:uint;

		 /**
		  *@exp   exp
		  **/
		public var exp:uint;

		 /**
		  *@membercnt   membercnt
		  **/
		public var membercnt:uint;

		 /**
		  *@isApply   isApply
		  **/
		public var isApply:Boolean;

		 /**
		  *@leader   leader
		  **/
		private var leader$field:game.net.data.StoC.GuildMember;

		public function removeLeader():void {
			leader$field = null;
		}

		public function get hasLeader():Boolean {
			return leader$field != null;
		}

		public function set leader(value:game.net.data.StoC.GuildMember):void {
			leader$field = value;
		}

		public function get leader():game.net.data.StoC.GuildMember {
			return leader$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, name);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, rank);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, exp);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, membercnt);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, isApply);
			if (hasLeader) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.protobuf.WriteUtils.write$TYPE_MESSAGE(output, leader$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var name$count:uint = 0;
			var rank$count:uint = 0;
			var exp$count:uint = 0;
			var membercnt$count:uint = 0;
			var isApply$count:uint = 0;
			var leader$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfoPartA.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfoPartA.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (rank$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfoPartA.rank cannot be set twice.');
					}
					++rank$count;
					rank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfoPartA.exp cannot be set twice.');
					}
					++exp$count;
					exp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (membercnt$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfoPartA.membercnt cannot be set twice.');
					}
					++membercnt$count;
					membercnt = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (isApply$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfoPartA.isApply cannot be set twice.');
					}
					++isApply$count;
					isApply = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 7:
					if (leader$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfoPartA.leader cannot be set twice.');
					}
					++leader$count;
					leader = new game.net.data.StoC.GuildMember();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, leader);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
