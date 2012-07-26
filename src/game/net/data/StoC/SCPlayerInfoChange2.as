package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x1F
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCPlayerInfoChange2 extends com.protobuf.Message {
		 /**
		  *@tipsType   tipsType
		  **/
		public var tipsType:uint;

		 /**
		  *@gold   gold
		  **/
		private var gold$field:uint;

		private var hasField$0:uint = 0;

		public function removeGold():void {
			hasField$0 &= 0xfffffffe;
			gold$field = new uint();
		}

		public function get hasGold():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set gold(value:uint):void {
			hasField$0 |= 0x1;
			gold$field = value;
		}

		public function get gold():uint {
			return gold$field;
		}

		 /**
		  *@goldChange   goldChange
		  **/
		private var goldChange$field:int;

		public function removeGoldChange():void {
			hasField$0 &= 0xfffffffd;
			goldChange$field = new int();
		}

		public function get hasGoldChange():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set goldChange(value:int):void {
			hasField$0 |= 0x2;
			goldChange$field = value;
		}

		public function get goldChange():int {
			return goldChange$field;
		}

		 /**
		  *@goldB   goldB
		  **/
		private var goldB$field:uint;

		public function removeGoldB():void {
			hasField$0 &= 0xfffffffb;
			goldB$field = new uint();
		}

		public function get hasGoldB():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set goldB(value:uint):void {
			hasField$0 |= 0x4;
			goldB$field = value;
		}

		public function get goldB():uint {
			return goldB$field;
		}

		 /**
		  *@goldBChange   goldBChange
		  **/
		private var goldBChange$field:int;

		public function removeGoldBChange():void {
			hasField$0 &= 0xfffffff7;
			goldBChange$field = new int();
		}

		public function get hasGoldBChange():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set goldBChange(value:int):void {
			hasField$0 |= 0x8;
			goldBChange$field = value;
		}

		public function get goldBChange():int {
			return goldBChange$field;
		}

		 /**
		  *@silver   silver
		  **/
		private var silver$field:uint;

		public function removeSilver():void {
			hasField$0 &= 0xffffffef;
			silver$field = new uint();
		}

		public function get hasSilver():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set silver(value:uint):void {
			hasField$0 |= 0x10;
			silver$field = value;
		}

		public function get silver():uint {
			return silver$field;
		}

		 /**
		  *@silverChange   silverChange
		  **/
		private var silverChange$field:int;

		public function removeSilverChange():void {
			hasField$0 &= 0xffffffdf;
			silverChange$field = new int();
		}

		public function get hasSilverChange():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set silverChange(value:int):void {
			hasField$0 |= 0x20;
			silverChange$field = value;
		}

		public function get silverChange():int {
			return silverChange$field;
		}

		 /**
		  *@profExp   profExp
		  **/
		private var profExp$field:uint;

		public function removeProfExp():void {
			hasField$0 &= 0xffffffbf;
			profExp$field = new uint();
		}

		public function get hasProfExp():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set profExp(value:uint):void {
			hasField$0 |= 0x40;
			profExp$field = value;
		}

		public function get profExp():uint {
			return profExp$field;
		}

		 /**
		  *@profExpChange   profExpChange
		  **/
		private var profExpChange$field:int;

		public function removeProfExpChange():void {
			hasField$0 &= 0xffffff7f;
			profExpChange$field = new int();
		}

		public function get hasProfExpChange():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set profExpChange(value:int):void {
			hasField$0 |= 0x80;
			profExpChange$field = value;
		}

		public function get profExpChange():int {
			return profExpChange$field;
		}

		 /**
		  *@expGot   expGot
		  **/
		private var expGot$field:uint;

		public function removeExpGot():void {
			hasField$0 &= 0xfffffeff;
			expGot$field = new uint();
		}

		public function get hasExpGot():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set expGot(value:uint):void {
			hasField$0 |= 0x100;
			expGot$field = value;
		}

		public function get expGot():uint {
			return expGot$field;
		}

		 /**
		  *@level   level
		  **/
		private var level$field:uint;

		public function removeLevel():void {
			hasField$0 &= 0xfffffdff;
			level$field = new uint();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x200) != 0;
		}

		public function set level(value:uint):void {
			hasField$0 |= 0x200;
			level$field = value;
		}

		public function get level():uint {
			return level$field;
		}

		 /**
		  *@exp   exp
		  **/
		private var exp$field:uint;

		public function removeExp():void {
			hasField$0 &= 0xfffffbff;
			exp$field = new uint();
		}

		public function get hasExp():Boolean {
			return (hasField$0 & 0x400) != 0;
		}

		public function set exp(value:uint):void {
			hasField$0 |= 0x400;
			exp$field = value;
		}

		public function get exp():uint {
			return exp$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var tipsType$count:uint = 0;
			var gold$count:uint = 0;
			var goldChange$count:uint = 0;
			var goldB$count:uint = 0;
			var goldBChange$count:uint = 0;
			var silver$count:uint = 0;
			var silverChange$count:uint = 0;
			var profExp$count:uint = 0;
			var profExpChange$count:uint = 0;
			var expGot$count:uint = 0;
			var level$count:uint = 0;
			var exp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (tipsType$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.tipsType cannot be set twice.');
					}
					++tipsType$count;
					tipsType = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (gold$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.gold cannot be set twice.');
					}
					++gold$count;
					gold = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (goldChange$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.goldChange cannot be set twice.');
					}
					++goldChange$count;
					goldChange = com.protobuf.ReadUtils.read$TYPE_SINT32(input);
					break;
				case 5:
					if (goldB$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.goldB cannot be set twice.');
					}
					++goldB$count;
					goldB = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (goldBChange$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.goldBChange cannot be set twice.');
					}
					++goldBChange$count;
					goldBChange = com.protobuf.ReadUtils.read$TYPE_SINT32(input);
					break;
				case 7:
					if (silver$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.silver cannot be set twice.');
					}
					++silver$count;
					silver = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (silverChange$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.silverChange cannot be set twice.');
					}
					++silverChange$count;
					silverChange = com.protobuf.ReadUtils.read$TYPE_SINT32(input);
					break;
				case 9:
					if (profExp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.profExp cannot be set twice.');
					}
					++profExp$count;
					profExp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (profExpChange$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.profExpChange cannot be set twice.');
					}
					++profExpChange$count;
					profExpChange = com.protobuf.ReadUtils.read$TYPE_SINT32(input);
					break;
				case 12:
					if (expGot$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.expGot cannot be set twice.');
					}
					++expGot$count;
					expGot = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 13:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 14:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCPlayerInfoChange2.exp cannot be set twice.');
					}
					++exp$count;
					exp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
