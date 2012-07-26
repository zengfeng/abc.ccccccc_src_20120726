package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x20
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCPlayerWalk extends com.protobuf.Message {
		 /**
		  *@player_id   player_id
		  **/
		public var playerId:uint;

		 /**
		  *@xy   xy
		  **/
		public var xy:uint;

		 /**
		  *@fromXY   fromXY
		  **/
		private var fromXY$field:uint;

		private var hasField$0:uint = 0;

		public function removeFromXY():void {
			hasField$0 &= 0xfffffffe;
			fromXY$field = new uint();
		}

		public function get hasFromXY():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set fromXY(value:uint):void {
			hasField$0 |= 0x1;
			fromXY$field = value;
		}

		public function get fromXY():uint {
			return fromXY$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player_id$count:uint = 0;
			var xy$count:uint = 0;
			var fromXY$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerWalk.playerId cannot be set twice.');
					}
					++player_id$count;
					playerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (xy$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerWalk.xy cannot be set twice.');
					}
					++xy$count;
					xy = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (fromXY$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerWalk.fromXY cannot be set twice.');
					}
					++fromXY$count;
					fromXY = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
