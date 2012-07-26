package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x8A
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCResetDemon extends com.protobuf.Message {
		 /**
		  *@demonId   demonId
		  **/
		public var demonId:uint;

		 /**
		  *@countLeft   countLeft
		  **/
		public var countLeft:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var demonId$count:uint = 0;
			var countLeft$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (demonId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCResetDemon.demonId cannot be set twice.');
					}
					++demonId$count;
					demonId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (countLeft$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCResetDemon.countLeft cannot be set twice.');
					}
					++countLeft$count;
					countLeft = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
