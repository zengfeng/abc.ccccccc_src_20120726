package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x31
	 **/
	import com.protobuf.*;
	public dynamic final class CSQuestOperateReq extends com.protobuf.Message {
		 /**
		  *@op   op
		  **/
		public var op:uint;

		 /**
		  *@questId   questId
		  **/
		public var questId:uint;

		 /**
		  *@questQualityId   questQualityId
		  **/
		private var questQualityId$field:uint;

		private var hasField$0:uint = 0;

		public function removeQuestQualityId():void {
			hasField$0 &= 0xfffffffe;
			questQualityId$field = new uint();
		}

		public function get hasQuestQualityId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set questQualityId(value:uint):void {
			hasField$0 |= 0x1;
			questQualityId$field = value;
		}

		public function get questQualityId():uint {
			return questQualityId$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, op);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, questId);
			if (hasQuestQualityId) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, questQualityId$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
