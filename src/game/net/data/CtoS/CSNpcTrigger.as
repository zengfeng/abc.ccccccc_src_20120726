package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x33
	 **/
	import com.protobuf.*;
	public dynamic final class CSNpcTrigger extends com.protobuf.Message {
		 /**
		  *@npcId   npcId
		  **/
		public var npcId:uint;

		 /**
		  *@conveyId   conveyId
		  **/
		private var conveyId$field:uint;

		private var hasField$0:uint = 0;

		public function removeConveyId():void {
			hasField$0 &= 0xfffffffe;
			conveyId$field = new uint();
		}

		public function get hasConveyId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set conveyId(value:uint):void {
			hasField$0 |= 0x1;
			conveyId$field = value;
		}

		public function get conveyId():uint {
			return conveyId$field;
		}

		 /**
		  *@questId   questId
		  **/
		private var questId$field:uint;

		public function removeQuestId():void {
			hasField$0 &= 0xfffffffd;
			questId$field = new uint();
		}

		public function get hasQuestId():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set questId(value:uint):void {
			hasField$0 |= 0x2;
			questId$field = value;
		}

		public function get questId():uint {
			return questId$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, npcId);
			if (hasConveyId) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, conveyId$field);
			}
			if (hasQuestId) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, questId$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
