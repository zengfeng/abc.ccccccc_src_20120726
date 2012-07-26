package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xF6
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCGDBossInfo extends com.protobuf.Message {
		 /**
		  *@bossid   bossid
		  **/
		private var bossid$field:uint;

		private var hasField$0:uint = 0;

		public function removeBossid():void {
			hasField$0 &= 0xfffffffe;
			bossid$field = new uint();
		}

		public function get hasBossid():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set bossid(value:uint):void {
			hasField$0 |= 0x1;
			bossid$field = value;
		}

		public function get bossid():uint {
			return bossid$field;
		}

		 /**
		  *@bossmaxhp   bossmaxhp
		  **/
		private var bossmaxhp$field:uint;

		public function removeBossmaxhp():void {
			hasField$0 &= 0xfffffffd;
			bossmaxhp$field = new uint();
		}

		public function get hasBossmaxhp():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set bossmaxhp(value:uint):void {
			hasField$0 |= 0x2;
			bossmaxhp$field = value;
		}

		public function get bossmaxhp():uint {
			return bossmaxhp$field;
		}

		 /**
		  *@bossnowhp   bossnowhp
		  **/
		private var bossnowhp$field:uint;

		public function removeBossnowhp():void {
			hasField$0 &= 0xfffffffb;
			bossnowhp$field = new uint();
		}

		public function get hasBossnowhp():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set bossnowhp(value:uint):void {
			hasField$0 |= 0x4;
			bossnowhp$field = value;
		}

		public function get bossnowhp():uint {
			return bossnowhp$field;
		}

		 /**
		  *@bosslevel   bosslevel
		  **/
		private var bosslevel$field:uint;

		public function removeBosslevel():void {
			hasField$0 &= 0xfffffff7;
			bosslevel$field = new uint();
		}

		public function get hasBosslevel():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set bosslevel(value:uint):void {
			hasField$0 |= 0x8;
			bosslevel$field = value;
		}

		public function get bosslevel():uint {
			return bosslevel$field;
		}

		 /**
		  *@bossdmg   bossdmg
		  **/
		private var bossdmg$field:uint;

		public function removeBossdmg():void {
			hasField$0 &= 0xffffffef;
			bossdmg$field = new uint();
		}

		public function get hasBossdmg():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set bossdmg(value:uint):void {
			hasField$0 |= 0x10;
			bossdmg$field = value;
		}

		public function get bossdmg():uint {
			return bossdmg$field;
		}

		 /**
		  *@deadtime   deadtime
		  **/
		private var deadtime$field:uint;

		public function removeDeadtime():void {
			hasField$0 &= 0xffffffdf;
			deadtime$field = new uint();
		}

		public function get hasDeadtime():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set deadtime(value:uint):void {
			hasField$0 |= 0x20;
			deadtime$field = value;
		}

		public function get deadtime():uint {
			return deadtime$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var bossid$count:uint = 0;
			var bossmaxhp$count:uint = 0;
			var bossnowhp$count:uint = 0;
			var bosslevel$count:uint = 0;
			var bossdmg$count:uint = 0;
			var deadtime$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (bossid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDBossInfo.bossid cannot be set twice.');
					}
					++bossid$count;
					bossid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (bossmaxhp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDBossInfo.bossmaxhp cannot be set twice.');
					}
					++bossmaxhp$count;
					bossmaxhp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (bossnowhp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDBossInfo.bossnowhp cannot be set twice.');
					}
					++bossnowhp$count;
					bossnowhp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (bosslevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDBossInfo.bosslevel cannot be set twice.');
					}
					++bosslevel$count;
					bosslevel = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (bossdmg$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDBossInfo.bossdmg cannot be set twice.');
					}
					++bossdmg$count;
					bossdmg = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (deadtime$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGDBossInfo.deadtime cannot be set twice.');
					}
					++deadtime$count;
					deadtime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
