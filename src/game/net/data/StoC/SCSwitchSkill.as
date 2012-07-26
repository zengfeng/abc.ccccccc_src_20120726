package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x1B
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCSwitchSkill extends com.protobuf.Message {
		 /**
		  *@heroID   heroID
		  **/
		public var heroID:uint;

		 /**
		  *@skillID   skillID
		  **/
		public var skillID:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var heroID$count:uint = 0;
			var skillID$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (heroID$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCSwitchSkill.heroID cannot be set twice.');
					}
					++heroID$count;
					heroID = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (skillID$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCSwitchSkill.skillID cannot be set twice.');
					}
					++skillID$count;
					skillID = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
