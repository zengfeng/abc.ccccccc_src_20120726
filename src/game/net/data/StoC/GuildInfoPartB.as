package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GuildMember;
	public dynamic final class GuildInfoPartB extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@intro   intro
		  **/
		public var intro:String;

		 /**
		  *@member   member
		  **/
		public var member:Vector.<GuildMember> = new Vector.<GuildMember>();

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, intro);
			for (var memberIndex:uint = 0; memberIndex < member.length; ++memberIndex) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.protobuf.WriteUtils.write$TYPE_MESSAGE(output, member[memberIndex]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var intro$count:uint = 0;
			member = new Vector.<GuildMember>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfoPartB.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (intro$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfoPartB.intro cannot be set twice.');
					}
					++intro$count;
					intro = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					member.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.GuildMember()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
