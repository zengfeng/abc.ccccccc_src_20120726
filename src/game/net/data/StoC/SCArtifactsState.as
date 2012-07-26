package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xE0
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCArtifactsState extends com.protobuf.Message {
		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@lastGetExp   lastGetExp
		  **/
		public var lastGetExp:uint;

		 /**
		  *@currentExp   currentExp
		  **/
		public var currentExp:uint;

		 /**
		  *@challengeCount   challengeCount
		  **/
		public var challengeCount:uint;

		 /**
		  *@trainCount   trainCount
		  **/
		public var trainCount:uint;

		 /**
		  *@critNum   critNum
		  **/
		public var critNum:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var level$count:uint = 0;
			var lastGetExp$count:uint = 0;
			var currentExp$count:uint = 0;
			var challengeCount$count:uint = 0;
			var trainCount$count:uint = 0;
			var critNum$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCArtifactsState.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (lastGetExp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCArtifactsState.lastGetExp cannot be set twice.');
					}
					++lastGetExp$count;
					lastGetExp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (currentExp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCArtifactsState.currentExp cannot be set twice.');
					}
					++currentExp$count;
					currentExp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (challengeCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCArtifactsState.challengeCount cannot be set twice.');
					}
					++challengeCount$count;
					challengeCount = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (trainCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCArtifactsState.trainCount cannot be set twice.');
					}
					++trainCount$count;
					trainCount = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (critNum$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCArtifactsState.critNum cannot be set twice.');
					}
					++critNum$count;
					critNum = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
