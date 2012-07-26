package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2CF
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGuildTrendMessage extends com.protobuf.Message {
		 /**
		  *@trid   trid
		  **/
		public var trid:uint;

		 /**
		  *@param   param
		  **/
		public var param:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var trid$count:uint = 0;
			param = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (trid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildTrendMessage.trid cannot be set twice.');
					}
					++trid$count;
					trid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, param);
						break;
					}
					param.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
