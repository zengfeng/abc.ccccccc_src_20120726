package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xE1
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCChallengeArtifactsRes extends com.protobuf.Message {
		 /**
		  *@result   result
		  **/
		public var result:uint;

		 /**
		  *@challengeCount   challengeCount
		  **/
		public var challengeCount:uint;

		 /**
		  *@level   level
		  **/
		private var level$field:uint;

		private var hasField$0:uint = 0;

		public function removeLevel():void {
			hasField$0 &= 0xfffffffe;
			level$field = new uint();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set level(value:uint):void {
			hasField$0 |= 0x1;
			level$field = value;
		}

		public function get level():uint {
			return level$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var result$count:uint = 0;
			var challengeCount$count:uint = 0;
			var level$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCChallengeArtifactsRes.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (challengeCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCChallengeArtifactsRes.challengeCount cannot be set twice.');
					}
					++challengeCount$count;
					challengeCount = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCChallengeArtifactsRes.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
