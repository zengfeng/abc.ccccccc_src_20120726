package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xE2
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCTrainArtifactsRes extends com.protobuf.Message {
		 /**
		  *@result   result
		  **/
		public var result:uint;

		 /**
		  *@critNum   critNum
		  **/
		private var critNum$field:uint;

		private var hasField$0:uint = 0;

		public function removeCritNum():void {
			hasField$0 &= 0xfffffffe;
			critNum$field = new uint();
		}

		public function get hasCritNum():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set critNum(value:uint):void {
			hasField$0 |= 0x1;
			critNum$field = value;
		}

		public function get critNum():uint {
			return critNum$field;
		}

		 /**
		  *@trainCount   trainCount
		  **/
		public var trainCount:uint;

		 /**
		  *@lastGetExp   lastGetExp
		  **/
		public var lastGetExp:uint;

		 /**
		  *@currentExp   currentExp
		  **/
		public var currentExp:uint;

		 /**
		  *@level   level
		  **/
		public var level:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var result$count:uint = 0;
			var critNum$count:uint = 0;
			var trainCount$count:uint = 0;
			var lastGetExp$count:uint = 0;
			var currentExp$count:uint = 0;
			var level$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTrainArtifactsRes.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (critNum$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTrainArtifactsRes.critNum cannot be set twice.');
					}
					++critNum$count;
					critNum = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (trainCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTrainArtifactsRes.trainCount cannot be set twice.');
					}
					++trainCount$count;
					trainCount = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (lastGetExp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTrainArtifactsRes.lastGetExp cannot be set twice.');
					}
					++lastGetExp$count;
					lastGetExp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (currentExp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTrainArtifactsRes.currentExp cannot be set twice.');
					}
					++currentExp$count;
					currentExp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCTrainArtifactsRes.level cannot be set twice.');
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
