package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x280
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCEnhanceResult extends com.protobuf.Message {
		 /**
		  *@itemID   itemID
		  **/
		public var itemID:uint;

		 /**
		  *@result   result
		  **/
		public var result:Boolean;

		 /**
		  *@reason   reason
		  **/
		public var reason:Boolean;

		 /**
		  *@history   history
		  **/
		public var history:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var itemID$count:uint = 0;
			var result$count:uint = 0;
			var reason$count:uint = 0;
			history = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (itemID$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCEnhanceResult.itemID cannot be set twice.');
					}
					++itemID$count;
					itemID = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCEnhanceResult.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 3:
					if (reason$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCEnhanceResult.reason cannot be set twice.');
					}
					++reason$count;
					reason = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 4:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, history);
						break;
					}
					history.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
