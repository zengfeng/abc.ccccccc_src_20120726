package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2D2
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGuildActEvent extends com.protobuf.Message {
		 /**
		  *@event   event
		  **/
		public var event:uint;

		 /**
		  *@param   param
		  **/
		private var param$field:String;

		public function removeParam():void {
			param$field = null;
		}

		public function get hasParam():Boolean {
			return param$field != null;
		}

		public function set param(value:String):void {
			param$field = value;
		}

		public function get param():String {
			return param$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var event$count:uint = 0;
			var param$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (event$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildActEvent.event cannot be set twice.');
					}
					++event$count;
					event = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (param$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildActEvent.param cannot be set twice.');
					}
					++param$count;
					param = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
