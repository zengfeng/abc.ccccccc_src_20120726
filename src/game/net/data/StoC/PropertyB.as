package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class PropertyB extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@ftype   ftype
		  **/
		public var ftype:uint;

		 /**
		  *@fname   fname
		  **/
		private var fname$field:String;

		public function removeFname():void {
			fname$field = null;
		}

		public function get hasFname():Boolean {
			return fname$field != null;
		}

		public function set fname(value:String):void {
			fname$field = value;
		}

		public function get fname():String {
			return fname$field;
		}

		 /**
		  *@job   job
		  **/
		public var job:uint;

		 /**
		  *@side   side
		  **/
		public var side:uint;

		 /**
		  *@pos   pos
		  **/
		public var pos:uint;

		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@color   color
		  **/
		public var color:uint;

		 /**
		  *@weaponid   weaponid
		  **/
		public var weaponid:uint;

		 /**
		  *@skillid   skillid
		  **/
		public var skillid:uint;

		 /**
		  *@hp   hp
		  **/
		public var hp:uint;

		 /**
		  *@hpnow   hpnow
		  **/
		private var hpnow$field:uint;

		private var hasField$0:uint = 0;

		public function removeHpnow():void {
			hasField$0 &= 0xfffffffe;
			hpnow$field = new uint();
		}

		public function get hasHpnow():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set hpnow(value:uint):void {
			hasField$0 |= 0x1;
			hpnow$field = value;
		}

		public function get hpnow():uint {
			return hpnow$field;
		}

		 /**
		  *@attack   attack
		  **/
		public var attack:uint;

		 /**
		  *@spelldmg   spelldmg
		  **/
		public var spelldmg:int;

		 /**
		  *@defend   defend
		  **/
		public var defend:int;

		 /**
		  *@hitrate   hitrate
		  **/
		public var hitrate:Number;

		 /**
		  *@dodge   dodge
		  **/
		public var dodge:Number;

		 /**
		  *@speed   speed
		  **/
		public var speed:uint;

		 /**
		  *@crit   crit
		  **/
		public var crit:Number;

		 /**
		  *@pierce   pierce
		  **/
		public var pierce:Number;

		 /**
		  *@counter   counter
		  **/
		public var counter:Number;

		 /**
		  *@countermul   countermul
		  **/
		public var countermul:Number;

		 /**
		  *@critmul   critmul
		  **/
		public var critmul:Number;

		 /**
		  *@piercedef   piercedef
		  **/
		public var piercedef:Number;

		 /**
		  *@spellmul   spellmul
		  **/
		public var spellmul:Number;

		 /**
		  *@gaugemax   gaugemax
		  **/
		public var gaugemax:uint;

		 /**
		  *@gaugeinit   gaugeinit
		  **/
		public var gaugeinit:uint;

		 /**
		  *@gaugeuse   gaugeuse
		  **/
		public var gaugeuse:uint;

		 /**
		  *@damageAmp   damageAmp
		  **/
		public var damageAmp:Number;

		 /**
		  *@damagedef   damagedef
		  **/
		public var damagedef:Number;

		 /**
		  *@formationid   formationid
		  **/
		private var formationid$field:uint;

		public function removeFormationid():void {
			hasField$0 &= 0xfffffffd;
			formationid$field = new uint();
		}

		public function get hasFormationid():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set formationid(value:uint):void {
			hasField$0 |= 0x2;
			formationid$field = value;
		}

		public function get formationid():uint {
			return formationid$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, ftype);
			if (hasFname) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, fname$field);
			}
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, job);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, side);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, pos);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 7);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, level);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 8);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, color);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 9);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, weaponid);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 10);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, skillid);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 11);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, hp);
			if (hasHpnow) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 12);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, hpnow$field);
			}
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 13);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, attack);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 14);
			com.protobuf.WriteUtils.write$TYPE_SINT32(output, spelldmg);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 15);
			com.protobuf.WriteUtils.write$TYPE_SINT32(output, defend);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.FIXED_64_BIT, 16);
			com.protobuf.WriteUtils.write$TYPE_DOUBLE(output, hitrate);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.FIXED_64_BIT, 17);
			com.protobuf.WriteUtils.write$TYPE_DOUBLE(output, dodge);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 18);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, speed);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.FIXED_64_BIT, 19);
			com.protobuf.WriteUtils.write$TYPE_DOUBLE(output, crit);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.FIXED_64_BIT, 20);
			com.protobuf.WriteUtils.write$TYPE_DOUBLE(output, pierce);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.FIXED_64_BIT, 21);
			com.protobuf.WriteUtils.write$TYPE_DOUBLE(output, counter);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.FIXED_64_BIT, 22);
			com.protobuf.WriteUtils.write$TYPE_DOUBLE(output, countermul);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.FIXED_64_BIT, 23);
			com.protobuf.WriteUtils.write$TYPE_DOUBLE(output, critmul);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.FIXED_64_BIT, 24);
			com.protobuf.WriteUtils.write$TYPE_DOUBLE(output, piercedef);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.FIXED_64_BIT, 25);
			com.protobuf.WriteUtils.write$TYPE_DOUBLE(output, spellmul);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 26);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, gaugemax);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 27);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, gaugeinit);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 28);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, gaugeuse);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.FIXED_64_BIT, 29);
			com.protobuf.WriteUtils.write$TYPE_DOUBLE(output, damageAmp);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.FIXED_64_BIT, 30);
			com.protobuf.WriteUtils.write$TYPE_DOUBLE(output, damagedef);
			if (hasFormationid) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 31);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, formationid$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var ftype$count:uint = 0;
			var fname$count:uint = 0;
			var job$count:uint = 0;
			var side$count:uint = 0;
			var pos$count:uint = 0;
			var level$count:uint = 0;
			var color$count:uint = 0;
			var weaponid$count:uint = 0;
			var skillid$count:uint = 0;
			var hp$count:uint = 0;
			var hpnow$count:uint = 0;
			var attack$count:uint = 0;
			var spelldmg$count:uint = 0;
			var defend$count:uint = 0;
			var hitrate$count:uint = 0;
			var dodge$count:uint = 0;
			var speed$count:uint = 0;
			var crit$count:uint = 0;
			var pierce$count:uint = 0;
			var counter$count:uint = 0;
			var countermul$count:uint = 0;
			var critmul$count:uint = 0;
			var piercedef$count:uint = 0;
			var spellmul$count:uint = 0;
			var gaugemax$count:uint = 0;
			var gaugeinit$count:uint = 0;
			var gaugeuse$count:uint = 0;
			var damageAmp$count:uint = 0;
			var damagedef$count:uint = 0;
			var formationid$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (ftype$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.ftype cannot be set twice.');
					}
					++ftype$count;
					ftype = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (fname$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.fname cannot be set twice.');
					}
					++fname$count;
					fname = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (job$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.job cannot be set twice.');
					}
					++job$count;
					job = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (side$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.side cannot be set twice.');
					}
					++side$count;
					side = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.pos cannot be set twice.');
					}
					++pos$count;
					pos = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (color$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.color cannot be set twice.');
					}
					++color$count;
					color = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (weaponid$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.weaponid cannot be set twice.');
					}
					++weaponid$count;
					weaponid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (skillid$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.skillid cannot be set twice.');
					}
					++skillid$count;
					skillid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 11:
					if (hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.hp cannot be set twice.');
					}
					++hp$count;
					hp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 12:
					if (hpnow$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.hpnow cannot be set twice.');
					}
					++hpnow$count;
					hpnow = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 13:
					if (attack$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.attack cannot be set twice.');
					}
					++attack$count;
					attack = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 14:
					if (spelldmg$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.spelldmg cannot be set twice.');
					}
					++spelldmg$count;
					spelldmg = com.protobuf.ReadUtils.read$TYPE_SINT32(input);
					break;
				case 15:
					if (defend$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.defend cannot be set twice.');
					}
					++defend$count;
					defend = com.protobuf.ReadUtils.read$TYPE_SINT32(input);
					break;
				case 16:
					if (hitrate$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.hitrate cannot be set twice.');
					}
					++hitrate$count;
					hitrate = com.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 17:
					if (dodge$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.dodge cannot be set twice.');
					}
					++dodge$count;
					dodge = com.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 18:
					if (speed$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.speed cannot be set twice.');
					}
					++speed$count;
					speed = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 19:
					if (crit$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.crit cannot be set twice.');
					}
					++crit$count;
					crit = com.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 20:
					if (pierce$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.pierce cannot be set twice.');
					}
					++pierce$count;
					pierce = com.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 21:
					if (counter$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.counter cannot be set twice.');
					}
					++counter$count;
					counter = com.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 22:
					if (countermul$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.countermul cannot be set twice.');
					}
					++countermul$count;
					countermul = com.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 23:
					if (critmul$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.critmul cannot be set twice.');
					}
					++critmul$count;
					critmul = com.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 24:
					if (piercedef$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.piercedef cannot be set twice.');
					}
					++piercedef$count;
					piercedef = com.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 25:
					if (spellmul$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.spellmul cannot be set twice.');
					}
					++spellmul$count;
					spellmul = com.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 26:
					if (gaugemax$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.gaugemax cannot be set twice.');
					}
					++gaugemax$count;
					gaugemax = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 27:
					if (gaugeinit$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.gaugeinit cannot be set twice.');
					}
					++gaugeinit$count;
					gaugeinit = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 28:
					if (gaugeuse$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.gaugeuse cannot be set twice.');
					}
					++gaugeuse$count;
					gaugeuse = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 29:
					if (damageAmp$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.damageAmp cannot be set twice.');
					}
					++damageAmp$count;
					damageAmp = com.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 30:
					if (damagedef$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.damagedef cannot be set twice.');
					}
					++damagedef$count;
					damagedef = com.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 31:
					if (formationid$count != 0) {
						throw new flash.errors.IOError('Bad data format: PropertyB.formationid cannot be set twice.');
					}
					++formationid$count;
					formationid = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
