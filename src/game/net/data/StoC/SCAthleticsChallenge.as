package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x1A1
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCAthleticsChallenge extends com.protobuf.Message {
		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@color   color
		  **/
		public var color:uint;

		 /**
		  *@challengeTime   challengeTime
		  **/
		public var challengeTime:uint;

		 /**
		  *@result   result
		  **/
		public var result:uint;

		 /**
		  *@newRank   newRank
		  **/
		private var newRank$field:uint;

		private var hasField$0:uint = 0;

		public function removeNewRank():void {
			hasField$0 &= 0xfffffffe;
			newRank$field = new uint();
		}

		public function get hasNewRank():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set newRank(value:uint):void {
			hasField$0 |= 0x1;
			newRank$field = value;
		}

		public function get newRank():uint {
			return newRank$field;
		}

		 /**
		  *@winStreak   winStreak
		  **/
		private var winStreak$field:uint;

		public function removeWinStreak():void {
			hasField$0 &= 0xfffffffd;
			winStreak$field = new uint();
		}

		public function get hasWinStreak():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set winStreak(value:uint):void {
			hasField$0 |= 0x2;
			winStreak$field = value;
		}

		public function get winStreak():uint {
			return winStreak$field;
		}

		 /**
		  *@honorGot   honorGot
		  **/
		private var honorGot$field:uint;

		public function removeHonorGot():void {
			hasField$0 &= 0xfffffffb;
			honorGot$field = new uint();
		}

		public function get hasHonorGot():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set honorGot(value:uint):void {
			hasField$0 |= 0x4;
			honorGot$field = value;
		}

		public function get honorGot():uint {
			return honorGot$field;
		}

		 /**
		  *@silverGot   silverGot
		  **/
		private var silverGot$field:uint;

		public function removeSilverGot():void {
			hasField$0 &= 0xfffffff7;
			silverGot$field = new uint();
		}

		public function get hasSilverGot():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set silverGot(value:uint):void {
			hasField$0 |= 0x8;
			silverGot$field = value;
		}

		public function get silverGot():uint {
			return silverGot$field;
		}

		 /**
		  *@bestRank   bestRank
		  **/
		private var bestRank$field:uint;

		public function removeBestRank():void {
			hasField$0 &= 0xffffffef;
			bestRank$field = new uint();
		}

		public function get hasBestRank():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set bestRank(value:uint):void {
			hasField$0 |= 0x10;
			bestRank$field = value;
		}

		public function get bestRank():uint {
			return bestRank$field;
		}

		 /**
		  *@battleId   battleId
		  **/
		public var battleId:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var name$count:uint = 0;
			var color$count:uint = 0;
			var challengeTime$count:uint = 0;
			var result$count:uint = 0;
			var newRank$count:uint = 0;
			var winStreak$count:uint = 0;
			var honorGot$count:uint = 0;
			var silverGot$count:uint = 0;
			var bestRank$count:uint = 0;
			var battleId$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsChallenge.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (color$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsChallenge.color cannot be set twice.');
					}
					++color$count;
					color = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (challengeTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsChallenge.challengeTime cannot be set twice.');
					}
					++challengeTime$count;
					challengeTime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsChallenge.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (newRank$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsChallenge.newRank cannot be set twice.');
					}
					++newRank$count;
					newRank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (winStreak$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsChallenge.winStreak cannot be set twice.');
					}
					++winStreak$count;
					winStreak = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (honorGot$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsChallenge.honorGot cannot be set twice.');
					}
					++honorGot$count;
					honorGot = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (silverGot$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsChallenge.silverGot cannot be set twice.');
					}
					++silverGot$count;
					silverGot = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (bestRank$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsChallenge.bestRank cannot be set twice.');
					}
					++bestRank$count;
					bestRank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (battleId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsChallenge.battleId cannot be set twice.');
					}
					++battleId$count;
					battleId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
