package game.net.data.StoC.SCGEResult {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class PlayerDamage extends com.protobuf.Message {
		 /**
		  *@playerid   playerid
		  **/
		public var playerid:uint;

		 /**
		  *@damage   damage
		  **/
		public var damage:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, playerid);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, damage);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var playerid$count:uint = 0;
			var damage$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (playerid$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerDamage.playerid cannot be set twice.');
					}
					++playerid$count;
					playerid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (damage$count != 0) {
						throw new flash.errors.IOError('Bad data format: PlayerDamage.damage cannot be set twice.');
					}
					++damage$count;
					damage = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
