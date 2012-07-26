package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xC9
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GroupBattleSortData;
	public dynamic final class SCGroupBattleSortUpdate extends com.protobuf.Message {
		 /**
		  *@sortList   sortList
		  **/
		public var sortList:game.net.data.StoC.GroupBattleSortData;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var sortList$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (sortList$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGroupBattleSortUpdate.sortList cannot be set twice.');
					}
					++sortList$count;
					sortList = new game.net.data.StoC.GroupBattleSortData();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, sortList);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
