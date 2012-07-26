package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2C
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCItemTrain extends com.protobuf.Message {
		 /**
		  *@type   type
		  **/
		public var type:uint;

		 /**
		  *@count   count
		  **/
		public var count:uint;

		 /**
		  *@exp   exp
		  **/
		public var exp:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var type$count:uint = 0;
			var count$count:uint = 0;
			var exp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCItemTrain.type cannot be set twice.');
					}
					++type$count;
					type = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (count$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCItemTrain.count cannot be set twice.');
					}
					++count$count;
					count = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCItemTrain.exp cannot be set twice.');
					}
					++exp$count;
					exp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
