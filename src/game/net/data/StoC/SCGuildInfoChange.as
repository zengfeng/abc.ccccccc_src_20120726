package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2C9
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGuildInfoChange extends com.protobuf.Message {
		 /**
		  *@exp   exp
		  **/
		private var exp$field:uint;

		private var hasField$0:uint = 0;

		public function removeExp():void {
			hasField$0 &= 0xfffffffe;
			exp$field = new uint();
		}

		public function get hasExp():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set exp(value:uint):void {
			hasField$0 |= 0x1;
			exp$field = value;
		}

		public function get exp():uint {
			return exp$field;
		}

		 /**
		  *@seq   seq
		  **/
		private var seq$field:uint;

		public function removeSeq():void {
			hasField$0 &= 0xfffffffd;
			seq$field = new uint();
		}

		public function get hasSeq():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set seq(value:uint):void {
			hasField$0 |= 0x2;
			seq$field = value;
		}

		public function get seq():uint {
			return seq$field;
		}

		 /**
		  *@announce   announce
		  **/
		private var announce$field:String;

		public function removeAnnounce():void {
			announce$field = null;
		}

		public function get hasAnnounce():Boolean {
			return announce$field != null;
		}

		public function set announce(value:String):void {
			announce$field = value;
		}

		public function get announce():String {
			return announce$field;
		}

		 /**
		  *@intro   intro
		  **/
		private var intro$field:String;

		public function removeIntro():void {
			intro$field = null;
		}

		public function get hasIntro():Boolean {
			return intro$field != null;
		}

		public function set intro(value:String):void {
			intro$field = value;
		}

		public function get intro():String {
			return intro$field;
		}

		 /**
		  *@action   action
		  **/
		private var action$field:uint;

		public function removeAction():void {
			hasField$0 &= 0xfffffffb;
			action$field = new uint();
		}

		public function get hasAction():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set action(value:uint):void {
			hasField$0 |= 0x4;
			action$field = value;
		}

		public function get action():uint {
			return action$field;
		}

		 /**
		  *@actionconfig   actionconfig
		  **/
		private var actionconfig$field:uint;

		public function removeActionconfig():void {
			hasField$0 &= 0xfffffff7;
			actionconfig$field = new uint();
		}

		public function get hasActionconfig():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set actionconfig(value:uint):void {
			hasField$0 |= 0x8;
			actionconfig$field = value;
		}

		public function get actionconfig():uint {
			return actionconfig$field;
		}

		 /**
		  *@actionremain   actionremain
		  **/
		private var actionremain$field:uint;

		public function removeActionremain():void {
			hasField$0 &= 0xffffffef;
			actionremain$field = new uint();
		}

		public function get hasActionremain():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set actionremain(value:uint):void {
			hasField$0 |= 0x10;
			actionremain$field = value;
		}

		public function get actionremain():uint {
			return actionremain$field;
		}

		 /**
		  *@status   status
		  **/
		private var status$field:uint;

		public function removeStatus():void {
			hasField$0 &= 0xffffffdf;
			status$field = new uint();
		}

		public function get hasStatus():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set status(value:uint):void {
			hasField$0 |= 0x20;
			status$field = value;
		}

		public function get status():uint {
			return status$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var exp$count:uint = 0;
			var seq$count:uint = 0;
			var announce$count:uint = 0;
			var intro$count:uint = 0;
			var action$count:uint = 0;
			var actionconfig$count:uint = 0;
			var actionremain$count:uint = 0;
			var status$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildInfoChange.exp cannot be set twice.');
					}
					++exp$count;
					exp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (seq$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildInfoChange.seq cannot be set twice.');
					}
					++seq$count;
					seq = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (announce$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildInfoChange.announce cannot be set twice.');
					}
					++announce$count;
					announce = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (intro$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildInfoChange.intro cannot be set twice.');
					}
					++intro$count;
					intro = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (action$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildInfoChange.action cannot be set twice.');
					}
					++action$count;
					action = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (actionconfig$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildInfoChange.actionconfig cannot be set twice.');
					}
					++actionconfig$count;
					actionconfig = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (actionremain$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildInfoChange.actionremain cannot be set twice.');
					}
					++actionremain$count;
					actionremain = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGuildInfoChange.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
