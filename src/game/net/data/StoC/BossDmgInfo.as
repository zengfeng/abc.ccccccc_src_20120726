package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class BossDmgInfo extends com.protobuf.Message {
		 /**
		  *@playername   playername
		  **/
		public var playername:String;

		 /**
		  *@color   color
		  **/
		public var color:uint;

		 /**
		  *@dmg   dmg
		  **/
		public var dmg:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, playername);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, color);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, dmg);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var playername$count:uint = 0;
			var color$count:uint = 0;
			var dmg$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (playername$count != 0) {
						throw new flash.errors.IOError('Bad data format: BossDmgInfo.playername cannot be set twice.');
					}
					++playername$count;
					playername = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (color$count != 0) {
						throw new flash.errors.IOError('Bad data format: BossDmgInfo.color cannot be set twice.');
					}
					++color$count;
					color = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (dmg$count != 0) {
						throw new flash.errors.IOError('Bad data format: BossDmgInfo.dmg cannot be set twice.');
					}
					++dmg$count;
					dmg = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
