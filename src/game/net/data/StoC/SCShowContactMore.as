package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x4C
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCShowContactMore extends com.protobuf.Message {
		 /**
		  *@blockOnline   blockOnline
		  **/
		public var blockOnline:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@recentOnline   recentOnline
		  **/
		public var recentOnline:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			blockOnline = new Vector.<uint>();

			recentOnline = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, blockOnline);
						break;
					}
					blockOnline.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 2:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, recentOnline);
						break;
					}
					recentOnline.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
