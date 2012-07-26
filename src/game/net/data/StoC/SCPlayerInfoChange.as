package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x11
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.BuffData;
	public dynamic final class SCPlayerInfoChange extends com.protobuf.Message {
		 /**
		  *@name   name
		  **/
		private var name$field:String;

		public function removeName():void {
			name$field = null;
		}

		public function get hasName():Boolean {
			return name$field != null;
		}

		public function set name(value:String):void {
			name$field = value;
		}

		public function get name():String {
			return name$field;
		}

		 /**
		  *@id   id
		  **/
		private var id$field:uint;

		private var hasField$0:uint = 0;

		public function removeId():void {
			hasField$0 &= 0xfffffffe;
			id$field = new uint();
		}

		public function get hasId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set id(value:uint):void {
			hasField$0 |= 0x1;
			id$field = value;
		}

		public function get id():uint {
			return id$field;
		}

		 /**
		  *@packSizeChange   packSizeChange
		  **/
		private var packSizeChange$field:uint;

		public function removePackSizeChange():void {
			hasField$0 &= 0xfffffffd;
			packSizeChange$field = new uint();
		}

		public function get hasPackSizeChange():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set packSizeChange(value:uint):void {
			hasField$0 |= 0x2;
			packSizeChange$field = value;
		}

		public function get packSizeChange():uint {
			return packSizeChange$field;
		}

		 /**
		  *@status   status
		  **/
		private var status$field:uint;

		public function removeStatus():void {
			hasField$0 &= 0xfffffffb;
			status$field = new uint();
		}

		public function get hasStatus():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set status(value:uint):void {
			hasField$0 |= 0x4;
			status$field = value;
		}

		public function get status():uint {
			return status$field;
		}

		 /**
		  *@opt   opt
		  **/
		private var opt$field:uint;

		public function removeOpt():void {
			hasField$0 &= 0xfffffff7;
			opt$field = new uint();
		}

		public function get hasOpt():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set opt(value:uint):void {
			hasField$0 |= 0x8;
			opt$field = value;
		}

		public function get opt():uint {
			return opt$field;
		}

		 /**
		  *@buff   buff
		  **/
		private var buff$field:game.net.data.StoC.BuffData;

		public function removeBuff():void {
			buff$field = null;
		}

		public function get hasBuff():Boolean {
			return buff$field != null;
		}

		public function set buff(value:game.net.data.StoC.BuffData):void {
			buff$field = value;
		}

		public function get buff():game.net.data.StoC.BuffData {
			return buff$field;
		}

		 /**
		  *@totalTopup   totalTopup
		  **/
		private var totalTopup$field:uint;

		public function removeTotalTopup():void {
			hasField$0 &= 0xffffffef;
			totalTopup$field = new uint();
		}

		public function get hasTotalTopup():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set totalTopup(value:uint):void {
			hasField$0 |= 0x10;
			totalTopup$field = value;
		}

		public function get totalTopup():uint {
			return totalTopup$field;
		}

		 /**
		  *@totalConsume   totalConsume
		  **/
		private var totalConsume$field:uint;

		public function removeTotalConsume():void {
			hasField$0 &= 0xffffffdf;
			totalConsume$field = new uint();
		}

		public function get hasTotalConsume():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set totalConsume(value:uint):void {
			hasField$0 |= 0x20;
			totalConsume$field = value;
		}

		public function get totalConsume():uint {
			return totalConsume$field;
		}

		 /**
		  *@vipLevel   vipLevel
		  **/
		private var vipLevel$field:uint;

		public function removeVipLevel():void {
			hasField$0 &= 0xffffffbf;
			vipLevel$field = new uint();
		}

		public function get hasVipLevel():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set vipLevel(value:uint):void {
			hasField$0 |= 0x40;
			vipLevel$field = value;
		}

		public function get vipLevel():uint {
			return vipLevel$field;
		}

		 /**
		  *@tradecnt   tradecnt
		  **/
		private var tradecnt$field:uint;

		public function removeTradecnt():void {
			hasField$0 &= 0xffffff7f;
			tradecnt$field = new uint();
		}

		public function get hasTradecnt():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set tradecnt(value:uint):void {
			hasField$0 |= 0x80;
			tradecnt$field = value;
		}

		public function get tradecnt():uint {
			return tradecnt$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var name$count:uint = 0;
			var id$count:uint = 0;
			var packSizeChange$count:uint = 0;
			var status$count:uint = 0;
			var opt$count:uint = 0;
			var buff$count:uint = 0;
			var totalTopup$count:uint = 0;
			var totalConsume$count:uint = 0;
			var vipLevel$count:uint = 0;
			var tradecnt$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 14:
					if (packSizeChange$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange.packSizeChange cannot be set twice.');
					}
					++packSizeChange$count;
					packSizeChange = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 15:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 16:
					if (opt$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange.opt cannot be set twice.');
					}
					++opt$count;
					opt = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 17:
					if (buff$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange.buff cannot be set twice.');
					}
					++buff$count;
					buff = new game.net.data.StoC.BuffData();
					com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, buff);
					break;
				case 18:
					if (totalTopup$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange.totalTopup cannot be set twice.');
					}
					++totalTopup$count;
					totalTopup = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 19:
					if (totalConsume$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange.totalConsume cannot be set twice.');
					}
					++totalConsume$count;
					totalConsume = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 20:
					if (vipLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange.vipLevel cannot be set twice.');
					}
					++vipLevel$count;
					vipLevel = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 21:
					if (tradecnt$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange.tradecnt cannot be set twice.');
					}
					++tradecnt$count;
					tradecnt = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
