package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2EA
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCBossDmgUpdate extends com.protobuf.Message {
		 /**
		  *@dmg   dmg
		  **/
		public var dmg:uint;

		 /**
		  *@newRank   newRank
		  **/
		private var newRank$field:uint;

		private var hasField$0:uint = 0;

		public function removeNewRank():void {
			hasField$0 &= 0xfffffffe;
			newRank$field = new uint();
		}

		public function get hasNewRank():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set newRank(value:uint):void {
			hasField$0 |= 0x1;
			newRank$field = value;
		}

		public function get newRank():uint {
			return newRank$field;
		}

		 /**
		  *@oldRank   oldRank
		  **/
		private var oldRank$field:uint;

		public function removeOldRank():void {
			hasField$0 &= 0xfffffffd;
			oldRank$field = new uint();
		}

		public function get hasOldRank():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set oldRank(value:uint):void {
			hasField$0 |= 0x2;
			oldRank$field = value;
		}

		public function get oldRank():uint {
			return oldRank$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var dmg$count:uint = 0;
			var newRank$count:uint = 0;
			var oldRank$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dmg$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBossDmgUpdate.dmg cannot be set twice.');
					}
					++dmg$count;
					dmg = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (newRank$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBossDmgUpdate.newRank cannot be set twice.');
					}
					++newRank$count;
					newRank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (oldRank$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBossDmgUpdate.oldRank cannot be set twice.');
					}
					++oldRank$count;
					oldRank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
