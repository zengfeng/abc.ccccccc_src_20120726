package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0xB1
	 **/
	import com.protobuf.*;
	public dynamic final class CSBConfirm extends com.protobuf.Message {
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
		public var equipments:Vector.<uint> = new Vector.<uint>();

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

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, tradeid);
			if (items != null && items.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, items);
			}
			if (equipments != null && equipments.length > 0) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.protobuf.WriteUtils.writePackedRepeated(output, com.protobuf.WriteUtils.write$TYPE_UINT32, equipments);
			}
			if (hasMoney) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, money$field);
			}
			if (hasRemark) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, remark$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
