package game.net.data.StoC.SCQuestList {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class CurrQuestList extends com.protobuf.Message {
		 /**
		  *@questId   questId
		  **/
		public var questId:uint;

		 /**
		  *@isCompleted   isCompleted
		  **/
		public var isCompleted:Boolean;

		 /**
		  *@stepNum   stepNum
		  **/
		public var stepNum:Vector.<uint> = new Vector.<uint>();

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, questId);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, isCompleted);
			if (stepNum != null && stepNum.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, stepNum);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var questId$count:uint = 0;
			var isCompleted$count:uint = 0;
			stepNum = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (questId$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrQuestList.questId cannot be set twice.');
					}
					++questId$count;
					questId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (isCompleted$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrQuestList.isCompleted cannot be set twice.');
					}
					++isCompleted$count;
					isCompleted = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 3:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, stepNum);
						break;
					}
					stepNum.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
