package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x66
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.PropertyB;
	public dynamic final class SCBattleInfo extends com.protobuf.Message {
		 /**
		  *@randomseed   randomseed
		  **/
		public var randomseed:uint;

		 /**
		  *@myside   myside
		  **/
		public var myside:uint;

		 /**
		  *@overtype   overtype
		  **/
		public var overtype:uint;

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
		  *@itemlist   itemlist
		  **/
		public var itemlist:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@playeraid   playeraid
		  **/
		private var playeraid$field:uint;

		public function removePlayeraid():void {
			hasField$0 &= 0xfffffffd;
			playeraid$field = new uint();
		}

		public function get hasPlayeraid():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set playeraid(value:uint):void {
			hasField$0 |= 0x2;
			playeraid$field = value;
		}

		public function get playeraid():uint {
			return playeraid$field;
		}

		 /**
		  *@playerbid   playerbid
		  **/
		private var playerbid$field:uint;

		public function removePlayerbid():void {
			hasField$0 &= 0xfffffffb;
			playerbid$field = new uint();
		}

		public function get hasPlayerbid():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set playerbid(value:uint):void {
			hasField$0 |= 0x4;
			playerbid$field = value;
		}

		public function get playerbid():uint {
			return playerbid$field;
		}

		 /**
		  *@vecpropertyb   vecpropertyb
		  **/
		public var vecpropertyb:Vector.<PropertyB> = new Vector.<PropertyB>();

		 /**
		  *@artifactslvl   artifactslvl
		  **/
		private var artifactslvl$field:uint;

		public function removeArtifactslvl():void {
			hasField$0 &= 0xfffffff7;
			artifactslvl$field = new uint();
		}

		public function get hasArtifactslvl():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set artifactslvl(value:uint):void {
			hasField$0 |= 0x8;
			artifactslvl$field = value;
		}

		public function get artifactslvl():uint {
			return artifactslvl$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var randomseed$count:uint = 0;
			var myside$count:uint = 0;
			var overtype$count:uint = 0;
			var exp$count:uint = 0;
			itemlist = new Vector.<uint>();

			var playeraid$count:uint = 0;
			var playerbid$count:uint = 0;
			vecpropertyb = new Vector.<PropertyB>();

			var artifactslvl$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (randomseed$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBattleInfo.randomseed cannot be set twice.');
					}
					++randomseed$count;
					randomseed = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (myside$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBattleInfo.myside cannot be set twice.');
					}
					++myside$count;
					myside = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (overtype$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBattleInfo.overtype cannot be set twice.');
					}
					++overtype$count;
					overtype = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBattleInfo.exp cannot be set twice.');
					}
					++exp$count;
					exp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, itemlist);
						break;
					}
					itemlist.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 6:
					if (playeraid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBattleInfo.playeraid cannot be set twice.');
					}
					++playeraid$count;
					playeraid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (playerbid$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBattleInfo.playerbid cannot be set twice.');
					}
					++playerbid$count;
					playerbid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					vecpropertyb.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.PropertyB()));
					break;
				case 9:
					if (artifactslvl$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCBattleInfo.artifactslvl cannot be set twice.');
					}
					++artifactslvl$count;
					artifactslvl = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
