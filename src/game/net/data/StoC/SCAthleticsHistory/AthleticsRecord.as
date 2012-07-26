package game.net.data.StoC.SCAthleticsHistory {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class AthleticsRecord extends com.protobuf.Message {
		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@color   color
		  **/
		public var color:uint;

		 /**
		  *@challengeTime   challengeTime
		  **/
		public var challengeTime:uint;

		 /**
		  *@result   result
		  **/
		public var result:uint;

		 /**
		  *@newRank   newRank
		  **/
		private var newRank$field:uint;

		private var hasField$0:uint = 0;

		public function removeNewRank():void {
			hasField$0 &= 0xfffffffe;
			newRank$field = new uint();
		}

		public function get hasNewRank():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set newRank(value:uint):void {
			hasField$0 |= 0x1;
			newRank$field = value;
		}

		public function get newRank():uint {
			return newRank$field;
		}

		 /**
		  *@battleId   battleId
		  **/
		public var battleId:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, name);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, color);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, challengeTime);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, result);
			if (hasNewRank) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, newRank$field);
			}
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, battleId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var name$count:uint = 0;
			var color$count:uint = 0;
			var challengeTime$count:uint = 0;
			var result$count:uint = 0;
			var newRank$count:uint = 0;
			var battleId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsRecord.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (color$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsRecord.color cannot be set twice.');
					}
					++color$count;
					color = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (challengeTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsRecord.challengeTime cannot be set twice.');
					}
					++challengeTime$count;
					challengeTime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsRecord.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (newRank$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsRecord.newRank cannot be set twice.');
					}
					++newRank$count;
					newRank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (battleId$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsRecord.battleId cannot be set twice.');
					}
					++battleId$count;
					battleId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
