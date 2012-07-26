package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2E3
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCBossPlayerDmg extends com.protobuf.Message {
		 /**
		  *@totaldmg   totaldmg
		  **/
		public var totaldmg:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var totaldmg$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (totaldmg$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBossPlayerDmg.totaldmg cannot be set twice.');
					}
					++totaldmg$count;
					totaldmg = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
