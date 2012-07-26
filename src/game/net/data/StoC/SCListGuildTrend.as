package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2F0
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCListGuildTrend.Player;
	import game.net.data.StoC.SCListGuildTrend.Trend;
	public dynamic final class SCListGuildTrend extends com.protobuf.Message {
		 /**
		  *@trend   trend
		  **/
		public var trend:Vector.<Trend> = new Vector.<Trend>();

		 /**
		  *@player   player
		  **/
		public var player:Vector.<Player> = new Vector.<Player>();

		 /**
		  *@stamp   stamp
		  **/
		public var stamp:uint;

		 /**
		  *@latid   latid
		  **/
		private var latid$field:uint;

		private var hasField$0:uint = 0;

		public function removeLatid():void {
			hasField$0 &= 0xfffffffe;
			latid$field = new uint();
		}

		public function get hasLatid():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set latid(value:uint):void {
			hasField$0 |= 0x1;
			latid$field = value;
		}

		public function get latid():uint {
			return latid$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			trend = new Vector.<Trend>();

			player = new Vector.<Player>();

			var stamp$count:uint = 0;
			var latid$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					trend.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCListGuildTrend.Trend()));
					break;
				case 2:
					player.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCListGuildTrend.Player()));
					break;
				case 3:
					if (stamp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCListGuildTrend.stamp cannot be set twice.');
					}
					++stamp$count;
					stamp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (latid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCListGuildTrend.latid cannot be set twice.');
					}
					++latid$count;
					latid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
