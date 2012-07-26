package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x31
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCQuestOperateReply extends com.protobuf.Message {
		 /**
		  *@op   op
		  **/
		public var op:uint;

		 /**
		  *@questId   questId
		  **/
		public var questId:uint;

		 /**
		  *@result   result
		  **/
		public var result:uint;

		 /**
		  *@quality   quality
		  **/
		private var quality$field:uint;

		private var hasField$0:uint = 0;

		public function removeQuality():void {
			hasField$0 &= 0xfffffffe;
			quality$field = new uint();
		}

		public function get hasQuality():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set quality(value:uint):void {
			hasField$0 |= 0x1;
			quality$field = value;
		}

		public function get quality():uint {
			return quality$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var op$count:uint = 0;
			var questId$count:uint = 0;
			var result$count:uint = 0;
			var quality$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (op$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCQuestOperateReply.op cannot be set twice.');
					}
					++op$count;
					op = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (questId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCQuestOperateReply.questId cannot be set twice.');
					}
					++questId$count;
					questId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCQuestOperateReply.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (quality$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCQuestOperateReply.quality cannot be set twice.');
					}
					++quality$count;
					quality = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
