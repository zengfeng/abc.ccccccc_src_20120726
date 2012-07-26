package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xC1
	 **/
	import com.protobuf.*;
	public dynamic final class CSGroupBattleQuit extends com.protobuf.Message {
		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
