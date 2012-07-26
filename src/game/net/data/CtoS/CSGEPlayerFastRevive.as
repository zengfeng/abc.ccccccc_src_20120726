package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2F4
	 **/
	import com.protobuf.*;
	public dynamic final class CSGEPlayerFastRevive extends com.protobuf.Message {
		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
