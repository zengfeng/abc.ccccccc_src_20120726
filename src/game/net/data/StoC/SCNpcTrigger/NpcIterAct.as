package game.net.data.StoC.SCNpcTrigger {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class NpcIterAct extends com.protobuf.Message {
		 /**
		  *@actionTyp   actionTyp
		  **/
		public var actionTyp:uint;

		 /**
		  *@actionId   actionId
		  **/
		public var actionId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, actionTyp);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, actionId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var actionTyp$count:uint = 0;
			var actionId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (actionTyp$count != 0) {
						throw new flash.errors.IOError('Bad data format: NpcIterAct.actionTyp cannot be set twice.');
					}
					++actionTyp$count;
					actionTyp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (actionId$count != 0) {
						throw new flash.errors.IOError('Bad data format: NpcIterAct.actionId cannot be set twice.');
					}
					++actionId$count;
					actionId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
