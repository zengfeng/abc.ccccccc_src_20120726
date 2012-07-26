package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x204
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCDecomposeResult extends com.protobuf.Message {
		 /**
		  *@getitem1   getitem1
		  **/
		public var getitem1:uint;

		 /**
		  *@getitem2   getitem2
		  **/
		public var getitem2:uint;

		 /**
		  *@getitem3   getitem3
		  **/
		public var getitem3:uint;

		 /**
		  *@getitem4   getitem4
		  **/
		public var getitem4:uint;

		 /**
		  *@getitemb1   getitemb1
		  **/
		public var getitemb1:uint;

		 /**
		  *@getitemb2   getitemb2
		  **/
		public var getitemb2:uint;

		 /**
		  *@getitemb3   getitemb3
		  **/
		public var getitemb3:uint;

		 /**
		  *@getitemb4   getitemb4
		  **/
		public var getitemb4:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var getitem1$count:uint = 0;
			var getitem2$count:uint = 0;
			var getitem3$count:uint = 0;
			var getitem4$count:uint = 0;
			var getitemb1$count:uint = 0;
			var getitemb2$count:uint = 0;
			var getitemb3$count:uint = 0;
			var getitemb4$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (getitem1$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDecomposeResult.getitem1 cannot be set twice.');
					}
					++getitem1$count;
					getitem1 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (getitem2$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDecomposeResult.getitem2 cannot be set twice.');
					}
					++getitem2$count;
					getitem2 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (getitem3$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDecomposeResult.getitem3 cannot be set twice.');
					}
					++getitem3$count;
					getitem3 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (getitem4$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDecomposeResult.getitem4 cannot be set twice.');
					}
					++getitem4$count;
					getitem4 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (getitemb1$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDecomposeResult.getitemb1 cannot be set twice.');
					}
					++getitemb1$count;
					getitemb1 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (getitemb2$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDecomposeResult.getitemb2 cannot be set twice.');
					}
					++getitemb2$count;
					getitemb2 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (getitemb3$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDecomposeResult.getitemb3 cannot be set twice.');
					}
					++getitemb3$count;
					getitemb3 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (getitemb4$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDecomposeResult.getitemb4 cannot be set twice.');
					}
					++getitemb4$count;
					getitemb4 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
