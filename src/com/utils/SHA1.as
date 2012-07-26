package com.utils
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SHA1
	{
		
		public static const HASH_SIZE:int = 20;
		
		public function getInputSize():uint
		{
			return 64;
		}
		
		public function hash(src:ByteArray):ByteArray
		{
			var savedLength:uint = src.length;
			var savedEndian:String = src.endian;
			
			src.endian = Endian.BIG_ENDIAN;
			var len:uint = savedLength * 8;
			// pad to nearest int.
			while (src.length % 4 != 0)
			{
				src[src.length] = 0;
			}
			// convert ByteArray to an array of uint
			src.position = 0;
			var a:Array = [];
			for (var i:uint = 0; i < src.length; i += 4)
			{
				a.push(src.readUnsignedInt());
			}
			var h:Array = core(a, len);
			var out:ByteArray = new ByteArray;
			var words:uint = getHashSize() / 4;
			for (i = 0; i < words; i++)
			{
				out.writeUnsignedInt(h[i]);
			}
			// unpad, to leave the source untouched.
			src.length = savedLength;
			src.endian = savedEndian;
			return out;
		}
		
		public function getHashSize():uint
		{
			return HASH_SIZE;
		}
		
		protected function core(x:Array, len:uint):Array
		{
			/* append padding */
			x[len >> 5] |= 0x80 << (24 - len % 32);
			x[((len + 64 >> 9) << 4) + 15] = len;
			
			var w:Array = [];
			var a:uint = 0x67452301; //1732584193;
			var b:uint = 0xEFCDAB89; //-271733879;
			var c:uint = 0x98BADCFE; //-1732584194;
			var d:uint = 0x10325476; //271733878;
			var e:uint = 0xC3D2E1F0; //-1009589776;
			
			for (var i:uint = 0; i < x.length; i += 16)
			{
				
				var olda:uint = a;
				var oldb:uint = b;
				var oldc:uint = c;
				var oldd:uint = d;
				var olde:uint = e;
				
				for (var j:uint = 0; j < 80; j++)
				{
					if (j < 16)
					{
						w[j] = x[i + j] || 0;
					}
					else
					{
						w[j] = rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1);
					}
					var t:uint = rol(a, 5) + ft(j, b, c, d) + e + w[j] + kt(j);
					e = d;
					d = c;
					c = rol(b, 30);
					b = a;
					a = t;
				}
				a += olda;
				b += oldb;
				c += oldc;
				d += oldd;
				e += olde;
			}
			return [a, b, c, d, e];
		
		}
		
		/*
		 * Bitwise rotate a 32-bit number to the left.
		 */
		private function rol(num:uint, cnt:uint):uint
		{
			return (num << cnt) | (num >>> (32 - cnt));
		}
		
		/*
		 * Perform the appropriate triplet combination function for the current
		 * iteration
		 */
		private function ft(t:uint, b:uint, c:uint, d:uint):uint
		{
			if (t < 20)
				return (b & c) | ((~b) & d);
			if (t < 40)
				return b ^ c ^ d;
			if (t < 60)
				return (b & c) | (b & d) | (c & d);
			return b ^ c ^ d;
		}
		
		/*
		 * Determine the appropriate additive constant for the current iteration
		 */
		private function kt(t:uint):uint
		{
			return (t < 20) ? 0x5A827999 : (t < 40) ? 0x6ED9EBA1 : (t < 60) ? 0x8F1BBCDC : 0xCA62C1D6;
		}
		
		public function toString():String
		{
			return "sha1";
		}
	
	}

}