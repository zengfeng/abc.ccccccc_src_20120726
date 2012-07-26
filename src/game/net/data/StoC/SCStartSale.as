package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xB5
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCStartSale extends com.protobuf.Message {
		 /**
		  *@saleid   saleid
		  **/
		public var saleid:uint;

		 /**
		  *@itemid   itemid
		  **/
		public var itemid:uint;

		 /**
		  *@param   param
		  **/
		public var param:uint;

		 /**
		  *@price   price
		  **/
		public var price:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var saleid$count:uint = 0;
			var itemid$count:uint = 0;
			var param$count:uint = 0;
			var price$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (saleid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCStartSale.saleid cannot be set twice.');
					}
					++saleid$count;
					saleid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (itemid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCStartSale.itemid cannot be set twice.');
					}
					++itemid$count;
					itemid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (param$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCStartSale.param cannot be set twice.');
					}
					++param$count;
					param = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (price$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCStartSale.price cannot be set twice.');
					}
					++price$count;
					price = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
