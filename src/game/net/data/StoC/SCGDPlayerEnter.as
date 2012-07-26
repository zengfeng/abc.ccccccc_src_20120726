package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xF3
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGDPlayerEnter extends com.protobuf.Message {
		 /**
		  *@player   player
		  **/
		public var player:uint;

		 /**
		  *@state   state
		  **/
		public var state:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player$count:uint = 0;
			var state$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDPlayerEnter.player cannot be set twice.');
					}
					++player$count;
					player = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (state$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDPlayerEnter.state cannot be set twice.');
					}
					++state$count;
					state = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
