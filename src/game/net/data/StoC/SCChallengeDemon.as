package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x89
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCChallengeDemon extends com.protobuf.Message {
		 /**
		  *@demonId   demonId
		  **/
		public var demonId:uint;

		 /**
		  *@result   result
		  **/
		public var result:Boolean;

		 /**
		  *@items   items
		  **/
		public var items:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var demonId$count:uint = 0;
			var result$count:uint = 0;
			items = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (demonId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCChallengeDemon.demonId cannot be set twice.');
					}
					++demonId$count;
					demonId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCChallengeDemon.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 3:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, items);
						break;
					}
					items.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
