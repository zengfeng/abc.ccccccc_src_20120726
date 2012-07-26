package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x1A2
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCAthleticsHistory.AthleticsRecord;
	public dynamic final class SCAthleticsHistory extends com.protobuf.Message {
		 /**
		  *@records   records
		  **/
		public var records:Vector.<AthleticsRecord> = new Vector.<AthleticsRecord>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			records = new Vector.<AthleticsRecord>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					records.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCAthleticsHistory.AthleticsRecord()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
