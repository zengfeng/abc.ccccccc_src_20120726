package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xF4
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGDBattleResult extends com.protobuf.Message {
		 /**
		  *@player   player
		  **/
		public var player:uint;

		 /**
		  *@dmg   dmg
		  **/
		public var dmg:uint;

		 /**
		  *@lefthp   lefthp
		  **/
		public var lefthp:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player$count:uint = 0;
			var dmg$count:uint = 0;
			var lefthp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDBattleResult.player cannot be set twice.');
					}
					++player$count;
					player = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (dmg$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDBattleResult.dmg cannot be set twice.');
					}
					++dmg$count;
					dmg = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (lefthp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDBattleResult.lefthp cannot be set twice.');
					}
					++lefthp$count;
					lefthp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
