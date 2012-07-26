package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2D1
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGuildDrinkTea extends com.protobuf.Message {
		 /**
		  *@sel   sel
		  **/
		public var sel:uint;

		 /**
		  *@reward   reward
		  **/
		public var reward:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var sel$count:uint = 0;
			var reward$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (sel$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildDrinkTea.sel cannot be set twice.');
					}
					++sel$count;
					sel = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (reward$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildDrinkTea.reward cannot be set twice.');
					}
					++reward$count;
					reward = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
