package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x32
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCQuestStepUpdate extends com.protobuf.Message {
		 /**
		  *@questId   questId
		  **/
		public var questId:uint;

		 /**
		  *@stepType   stepType
		  **/
		public var stepType:uint;

		 /**
		  *@stepNum   stepNum
		  **/
		public var stepNum:uint;

		 /**
		  *@isCompleted   isCompleted
		  **/
		public var isCompleted:Boolean;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var questId$count:uint = 0;
			var stepType$count:uint = 0;
			var stepNum$count:uint = 0;
			var isCompleted$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (questId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCQuestStepUpdate.questId cannot be set twice.');
					}
					++questId$count;
					questId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (stepType$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCQuestStepUpdate.stepType cannot be set twice.');
					}
					++stepType$count;
					stepType = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (stepNum$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCQuestStepUpdate.stepNum cannot be set twice.');
					}
					++stepNum$count;
					stepNum = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (isCompleted$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCQuestStepUpdate.isCompleted cannot be set twice.');
					}
					++isCompleted$count;
					isCompleted = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
