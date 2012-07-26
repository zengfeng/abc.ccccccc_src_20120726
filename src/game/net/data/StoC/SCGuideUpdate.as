package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x12
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGuideUpdate extends com.protobuf.Message {
		 /**
		  *@new_step   new_step
		  **/
		public var newStep:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var new_step$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (new_step$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuideUpdate.newStep cannot be set twice.');
					}
					++new_step$count;
					newStep = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
