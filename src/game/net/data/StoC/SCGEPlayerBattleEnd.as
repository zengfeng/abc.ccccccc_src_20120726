package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2FA
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGEPlayerBattleEnd extends com.protobuf.Message {
		 /**
		  *@player   player
		  **/
		public var player:uint;

		 /**
		  *@deadtim   deadtim
		  **/
		private var deadtim$field:uint;

		private var hasField$0:uint = 0;

		public function removeDeadtim():void {
			hasField$0 &= 0xfffffffe;
			deadtim$field = new uint();
		}

		public function get hasDeadtim():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set deadtim(value:uint):void {
			hasField$0 |= 0x1;
			deadtim$field = value;
		}

		public function get deadtim():uint {
			return deadtim$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player$count:uint = 0;
			var deadtim$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEPlayerBattleEnd.player cannot be set twice.');
					}
					++player$count;
					player = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (deadtim$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEPlayerBattleEnd.deadtim cannot be set twice.');
					}
					++deadtim$count;
					deadtim = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
