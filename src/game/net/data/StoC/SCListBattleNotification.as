package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x5E
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCListBattleNotification.BattleItem;
	public dynamic final class SCListBattleNotification extends com.protobuf.Message {
		 /**
		  *@items   items
		  **/
		public var items:Vector.<BattleItem> = new Vector.<BattleItem>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			items = new Vector.<BattleItem>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					items.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCListBattleNotification.BattleItem()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
