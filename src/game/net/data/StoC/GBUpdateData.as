package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class GBUpdateData extends com.protobuf.Message {
		 /**
		  *@winPlayerId   winPlayerId
		  **/
		public var winPlayerId:uint;

		 /**
		  *@losePlayerId   losePlayerId
		  **/
		public var losePlayerId:uint;

		 /**
		  *@winPlayerKill   winPlayerKill
		  **/
		public var winPlayerKill:uint;

		 /**
		  *@winGroupScore   winGroupScore
		  **/
		public var winGroupScore:uint;

		 /**
		  *@loseGroupScore   loseGroupScore
		  **/
		public var loseGroupScore:uint;

		 /**
		  *@winSilver   winSilver
		  **/
		public var winSilver:uint;

		 /**
		  *@winDonateCnt   winDonateCnt
		  **/
		public var winDonateCnt:uint;

		 /**
		  *@loseSilver   loseSilver
		  **/
		public var loseSilver:uint;

		 /**
		  *@loseDonateCnt   loseDonateCnt
		  **/
		public var loseDonateCnt:uint;

		 /**
		  *@isFirstBlood   isFirstBlood
		  **/
		private var isFirstBlood$field:Boolean;

		private var hasField$0:uint = 0;

		public function removeIsFirstBlood():void {
			hasField$0 &= 0xfffffffe;
			isFirstBlood$field = new Boolean();
		}

		public function get hasIsFirstBlood():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set isFirstBlood(value:Boolean):void {
			hasField$0 |= 0x1;
			isFirstBlood$field = value;
		}

		public function get isFirstBlood():Boolean {
			return isFirstBlood$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, winPlayerId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, losePlayerId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, winPlayerKill);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, winGroupScore);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, loseGroupScore);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, winSilver);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 7);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, winDonateCnt);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 8);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, loseSilver);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 9);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, loseDonateCnt);
			if (hasIsFirstBlood) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 10);
				com.protobuf.WriteUtils.write$TYPE_BOOL(output, isFirstBlood$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var winPlayerId$count:uint = 0;
			var losePlayerId$count:uint = 0;
			var winPlayerKill$count:uint = 0;
			var winGroupScore$count:uint = 0;
			var loseGroupScore$count:uint = 0;
			var winSilver$count:uint = 0;
			var winDonateCnt$count:uint = 0;
			var loseSilver$count:uint = 0;
			var loseDonateCnt$count:uint = 0;
			var isFirstBlood$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (winPlayerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: GBUpdateData.winPlayerId cannot be set twice.');
					}
					++winPlayerId$count;
					winPlayerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (losePlayerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: GBUpdateData.losePlayerId cannot be set twice.');
					}
					++losePlayerId$count;
					losePlayerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (winPlayerKill$count != 0) {
						throw new flash.errors.IOError('Bad data format: GBUpdateData.winPlayerKill cannot be set twice.');
					}
					++winPlayerKill$count;
					winPlayerKill = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (winGroupScore$count != 0) {
						throw new flash.errors.IOError('Bad data format: GBUpdateData.winGroupScore cannot be set twice.');
					}
					++winGroupScore$count;
					winGroupScore = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (loseGroupScore$count != 0) {
						throw new flash.errors.IOError('Bad data format: GBUpdateData.loseGroupScore cannot be set twice.');
					}
					++loseGroupScore$count;
					loseGroupScore = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (winSilver$count != 0) {
						throw new flash.errors.IOError('Bad data format: GBUpdateData.winSilver cannot be set twice.');
					}
					++winSilver$count;
					winSilver = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (winDonateCnt$count != 0) {
						throw new flash.errors.IOError('Bad data format: GBUpdateData.winDonateCnt cannot be set twice.');
					}
					++winDonateCnt$count;
					winDonateCnt = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (loseSilver$count != 0) {
						throw new flash.errors.IOError('Bad data format: GBUpdateData.loseSilver cannot be set twice.');
					}
					++loseSilver$count;
					loseSilver = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (loseDonateCnt$count != 0) {
						throw new flash.errors.IOError('Bad data format: GBUpdateData.loseDonateCnt cannot be set twice.');
					}
					++loseDonateCnt$count;
					loseDonateCnt = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (isFirstBlood$count != 0) {
						throw new flash.errors.IOError('Bad data format: GBUpdateData.isFirstBlood cannot be set twice.');
					}
					++isFirstBlood$count;
					isFirstBlood = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
