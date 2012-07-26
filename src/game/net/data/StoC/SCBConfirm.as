package game.net.data.StoC {
	/**
	 * Server to Client 协议号0xB1
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.EquipAttribute;
	public dynamic final class SCBConfirm extends com.protobuf.Message {
		 /**
		  *@tradeid   tradeid
		  **/
		public var tradeid:uint;

		 /**
		  *@items   items
		  **/
		public var items:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@equipments   equipments
		  **/
		public var equipments:Vector.<EquipAttribute> = new Vector.<EquipAttribute>();

		 /**
		  *@money   money
		  **/
		private var money$field:uint;

		private var hasField$0:uint = 0;

		public function removeMoney():void {
			hasField$0 &= 0xfffffffe;
			money$field = new uint();
		}

		public function get hasMoney():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set money(value:uint):void {
			hasField$0 |= 0x1;
			money$field = value;
		}

		public function get money():uint {
			return money$field;
		}

		 /**
		  *@remark   remark
		  **/
		private var remark$field:String;

		public function removeRemark():void {
			remark$field = null;
		}

		public function get hasRemark():Boolean {
			return remark$field != null;
		}

		public function set remark(value:String):void {
			remark$field = value;
		}

		public function get remark():String {
			return remark$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var tradeid$count:uint = 0;
			items = new Vector.<uint>();

			equipments = new Vector.<EquipAttribute>();

			var money$count:uint = 0;
			var remark$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (tradeid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBConfirm.tradeid cannot be set twice.');
					}
					++tradeid$count;
					tradeid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, items);
						break;
					}
					items.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 3:
					equipments.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.EquipAttribute()));
					break;
				case 4:
					if (money$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBConfirm.money cannot be set twice.');
					}
					++money$count;
					money = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (remark$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBConfirm.remark cannot be set twice.');
					}
					++remark$count;
					remark = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
