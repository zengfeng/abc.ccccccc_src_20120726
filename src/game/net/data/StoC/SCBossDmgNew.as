package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2E9
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCBossDmgNew extends com.protobuf.Message {
		 /**
		  *@playername   playername
		  **/
		public var playername:String;

		 /**
		  *@color   color
		  **/
		public var color:uint;

		 /**
		  *@dmg   dmg
		  **/
		public var dmg:uint;

		 /**
		  *@rank   rank
		  **/
		public var rank:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var playername$count:uint = 0;
			var color$count:uint = 0;
			var dmg$count:uint = 0;
			var rank$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (playername$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBossDmgNew.playername cannot be set twice.');
					}
					++playername$count;
					playername = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (color$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBossDmgNew.color cannot be set twice.');
					}
					++color$count;
					color = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (dmg$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBossDmgNew.dmg cannot be set twice.');
					}
					++dmg$count;
					dmg = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (rank$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBossDmgNew.rank cannot be set twice.');
					}
					++rank$count;
					rank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
