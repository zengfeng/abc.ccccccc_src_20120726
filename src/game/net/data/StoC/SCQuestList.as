package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x30
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCQuestList.CurrQuestList;
	public dynamic final class SCQuestList extends com.protobuf.Message {
		 /**
		  *@currQuestList   currQuestList
		  **/
		public var currQuestList:Vector.<CurrQuestList> = new Vector.<CurrQuestList>();

		 /**
		  *@submitQuestId   submitQuestId
		  **/
		public var submitQuestId:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			currQuestList = new Vector.<CurrQuestList>();

			submitQuestId = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					currQuestList.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCQuestList.CurrQuestList()));
					break;
				case 2:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, submitQuestId);
						break;
					}
					submitQuestId.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
