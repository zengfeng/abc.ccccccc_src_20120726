package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2F7
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCGEResult.PlayerDamage;
	public dynamic final class SCGEResult extends com.protobuf.Message {
		 /**
		  *@player   player
		  **/
		public var player:Vector.<PlayerDamage> = new Vector.<PlayerDamage>();

		 /**
		  *@membercnt   membercnt
		  **/
		public var membercnt:uint;

		 /**
		  *@result1   result1
		  **/
		private var result1$field:Boolean;

		private var hasField$0:uint = 0;

		public function removeResult1():void {
			hasField$0 &= 0xfffffffe;
			result1$field = new Boolean();
		}

		public function get hasResult1():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set result1(value:Boolean):void {
			hasField$0 |= 0x1;
			result1$field = value;
		}

		public function get result1():Boolean {
			return result1$field;
		}

		 /**
		  *@result2   result2
		  **/
		private var result2$field:Boolean;

		public function removeResult2():void {
			hasField$0 &= 0xfffffffd;
			result2$field = new Boolean();
		}

		public function get hasResult2():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set result2(value:Boolean):void {
			hasField$0 |= 0x2;
			result2$field = value;
		}

		public function get result2():Boolean {
			return result2$field;
		}

		 /**
		  *@reward1   reward1
		  **/
		private var reward1$field:uint;

		public function removeReward1():void {
			hasField$0 &= 0xfffffffb;
			reward1$field = new uint();
		}

		public function get hasReward1():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set reward1(value:uint):void {
			hasField$0 |= 0x4;
			reward1$field = value;
		}

		public function get reward1():uint {
			return reward1$field;
		}

		 /**
		  *@reward2   reward2
		  **/
		private var reward2$field:uint;

		public function removeReward2():void {
			hasField$0 &= 0xfffffff7;
			reward2$field = new uint();
		}

		public function get hasReward2():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set reward2(value:uint):void {
			hasField$0 |= 0x8;
			reward2$field = value;
		}

		public function get reward2():uint {
			return reward2$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			player = new Vector.<PlayerDamage>();

			var membercnt$count:uint = 0;
			var result1$count:uint = 0;
			var result2$count:uint = 0;
			var reward1$count:uint = 0;
			var reward2$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					player.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCGEResult.PlayerDamage()));
					break;
				case 2:
					if (membercnt$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEResult.membercnt cannot be set twice.');
					}
					++membercnt$count;
					membercnt = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (result1$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEResult.result1 cannot be set twice.');
					}
					++result1$count;
					result1 = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 4:
					if (result2$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEResult.result2 cannot be set twice.');
					}
					++result2$count;
					result2 = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 5:
					if (reward1$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEResult.reward1 cannot be set twice.');
					}
					++reward1$count;
					reward1 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (reward2$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEResult.reward2 cannot be set twice.');
					}
					++reward2$count;
					reward2 = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
