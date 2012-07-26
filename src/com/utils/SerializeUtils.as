package com.utils
{
	import com.sociodox.utils.Base64;

	import flash.utils.ByteArray;
	/**
	 * @author jian
	 */
	public class SerializeUtils
	{
		public static function encodeObjectToString(vo : Object) : String
		{
			var ba : ByteArray = new ByteArray();
			ba.writeObject(vo);

			try
			{
				var str : String = Base64.encode(ba);
			}
			catch (e : Error)
			{
				//trace("对象序列化编码错误");
				return "";
			}
			return str;
		}

		public static function decodeStringToObject(str : String) : Object
		{
			try
			{
				var ba : ByteArray = Base64.decode(str);
				ba.position = 0;
				var vo : Object = ba.readObject();
			}
			catch (e : Error)
			{
				//trace("序列化解码错误");
				return null;
			}

			return vo;
		}		
	}
}
