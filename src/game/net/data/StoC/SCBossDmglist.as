package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2E1
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.BossDmgInfo;
	public dynamic final class SCBossDmglist extends com.protobuf.Message {
		 /**
		  *@dmglist   dmglist
		  **/
		public var dmglist:Vector.<BossDmgInfo> = new Vector.<BossDmgInfo>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			dmglist = new Vector.<BossDmgInfo>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					dmglist.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.BossDmgInfo()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
