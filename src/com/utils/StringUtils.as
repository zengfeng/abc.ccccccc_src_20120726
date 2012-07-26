/**
 *   The csvlib is free software! Do what you want! No rights or other
 *   bull shit. Use it, or let it! PLEASE do not mail me on, to say "please
 *   change the license model of your software".
 *
 *	 Regards,
 *   Marco
 */
package com.utils
{
	public class StringUtils
	{
		public static var NEWLINE_TOKENS : Array = new Array('\n', '\r');
		public static var WHITESPACE_TOKENS : Array = new Array(' ', '\t');
		public static const LEFT : String = "left";
		public static const RIGHT : String = "right";
		public static const CENTER : String = "center";

		/**
		 * Counts the occurrences of needle in haystack. <br />
		 * {@code //trace (StringUtils.count ('hello world!', 'o')); // 2
		 * }
		 * @param haystack :String
		 * @param needle :String
		 * @param offset :Number (optional)
		 * @param length :Number (optional)
		 * @return The number of times the needle substring occurs in the
		 * haystack string. Please note that needle is case sensitive.
		 */
		public static function count(haystack : String, needle : String, offset : Number = 0, length : Number = 0) : Number
		{
			if ( length === 0 )
				length = haystack.length;
			var result : Number = 0;
			haystack = haystack.slice(offset, length);
			while ( haystack.length > 0 && haystack.indexOf(needle) != -1 )
			{
				haystack = haystack.slice(( haystack.indexOf(needle) + needle.length ));
				result++;
			}
			return result;
		}

		/**
		 * Strip whitespace and newline (or other) from the beginning and end of a string. <br />
		 * {@code //trace (StringUtils.trim ('hello world! ')); // hello world!
		 * }
		 * @param str :String
		 * @param charList :Array (optional)
		 * @return A string with whitespace stripped from the beginning and end
		 * of str. Without the second parameter, trim() will strip characters that
		 * defined in WHITESPACE_TOKENS and NEWLINE_TOKENS array.
		 */
		public static function trim(str : String, charList : Array = null) : String
		{
			var list : Array;
			if ( charList )
			{
				list = charList;
			}
			else
			{
				list = WHITESPACE_TOKENS.concat(NEWLINE_TOKENS);
			}
			str = trimLeft(str, list);
			str = trimRight(str, list);
			return str;
		}

		/**
		 * Does the same how trim method, but only on left-side. <br />
		 * {@code //trace (StringUtils.trimLeft ('hello world!')); // hello world!
		 * }
		 * @param str :String
		 * @param charList :Array (optional)
		 * @return A string with whitespace stripped from the start of str.
		 * Without the second parameter, trimLeft() will strip haracters of
		 * WHITESPACE_TOKENS + NEWLINE_TOKENS.
		 */
		public static function trimLeft(str : String, charList : Array = null) : String
		{
			var list : Array;
			if ( charList )
				list = charList;
			else
				list = WHITESPACE_TOKENS.concat(NEWLINE_TOKENS);

			while ( list.toString().indexOf(str.substr(0, 1)) > -1 && str.length > 0 )
			{
				str = str.substr(1);
			}
			return str;
		}

		/**
		 * Does the same how trim method, but only on right-side. <br />
		 * {@code //trace (StringUtils.trimRight ('hello world!')); // hello world!
		 * }
		 * @param str :String
		 * @param charList :Array (optional)
		 * @return A string with whitespace stripped from the end of str.
		 * Without the second parameter, trimRight() will strip haracters of
		 * WHITESPACE_TOKENS + NEWLINE_TOKENS.
		 */
		public static function trimRight(str : String, charList : Array = null) : String
		{
			var list : Array;
			if ( charList )
				list = charList;
			else
				list = WHITESPACE_TOKENS.concat(NEWLINE_TOKENS);

			while ( list.toString().indexOf(str.substr(str.length - 1)) > -1 && str.length > 0)
			{
				str = str.substr(0, str.length - 1);
			}
			return str;
		}

		/** 为文字加事件 */
		public static function addEvent(content : String, event : String) : String
		{
			return "<a href=\'event:" + event + "\'>" + content + "</a>";
		}

		/** 为文字染色 */
		public static function addColor(content : String, color : String = "#ffcc99") : String
		{
			return "<font color='" + color + "'>" + content + "</font>";
		}

		/** 修改文字大小 */
		public static function addSize(content : String, size : int = 12) : String
		{
			return "<font size='" + size + "'>" + content + "</font>";
		}

		/** 为文字染色  colorId,1为白色，2为绿色，3为蓝色，4为紫色，5为橙色，6为暗金*/
		public static function addColorById(content : String, colorId : uint) : String
		{
			return addColor(content, ColorUtils.TEXTCOLOR[colorId]);
		}

		public static function addGoldColor(content : String) : String
		{
			return addColorById(content, ColorUtils.YELLOW);

			/** 加下划线 */
		}

		public static function addLine(content : String) : String
		{
			return "<u>" + content + "</u>";
		}

//		/** 加下划线 */
//		public static function addLine2(content : String) : String
//		{
//			return "<line>" + content + "</line>";
//			// return "<u>" + content + "</u>";
//		}

		/** 加粗**/
		public static function addBold(content : String) : String
		{
			return  "<b>" + content + "</b>";
		}

		public static function addIndent(content : String, indent : int = 23) : String
		{
			return  "<textformat indent='" + indent + "' >" + content + "</textformat>";
		}

		/** 加对齐方式 */
		public static function addParagraph(content : String, autoSize : String = LEFT) : String
		{
			return  "<p align='" + autoSize + "' >" + content + "</p>";
		}

		/** 
		 * 填充字符串 
		 * @param source 源字符串
		 * @param length 填充到长度
		 * @param fill  填充字符串
		 * @param direction 方向,可选值为start和end
		 */
		public static function fillStr(source : String, length : uint = 2, fill : String = "0", direction : String = "start") : String
		{
			if (source != null && source.length >= length) return source;
			if (fill == null || fill.length == 0) return source;
			while (source.length < length)
			{
				if (direction == "start")
				{
					source = fill + source;
				}
				else
				{
					source += fill;
				}
			}
			return source;
		}

		/** 
		 * 颜色由数据值型转为字符串型 
		 * 0xFFEE00  ===>  #FFEE00
		 */
		public static function colorToString(color : uint) : String
		{
			return "#" + color.toString(16);
		}

		/**
		 * #FFEE00  ===>  0xFFEE00
		 */
		public static function StringToColor(color : String) : uint
		{
			return Number("0x" + color.slice(1));
		}

		/**
		 * 计算UTF字符串长度
		 * */
		public static function UTFLength(value : String) : int
		{
			var length : int = 0;
			if (!value) return 0;
			for (var i : int = 0; i < value.length; i++)
			{
				if (value.charCodeAt(i) > 255)
				{
					length += 2;
				}
				else
				{
					length += 1;
				}
			}
			return length;
		}

		/**
		 * 截取UTF字符串
		 * */
		public static function UTFSubstr(value : String, len : uint, start : int = 0) : String
		{
			if (!value) return value;
			var arr : Array = [];
			var index : uint = 0;
			var i : int = 0;
			for (i = 0; i < value.length; i++)
			{
				if (value.charCodeAt(i) > 255)
				{
					arr[index] = "";
					arr[index + 1] = value.charAt(i);
					index += 2;
				}
				else
				{
					arr[index] = value.charAt(i);
					index += 1;
				}
			}
			if (start < 0) start = arr.length - start;

			var end : uint = start + len;
			end = Math.min(end, arr.length);
			value = "";
			for (i = start; i < end; i++)
			{
				value += arr[i];
			}
			return value;
		}

		/** 将数字按 "万" 进制 */
		public static function numToMillionString(num : Number, million : Number = 10000.0, str : String = "万", threshold : Number = 1000000) : String
		{
			if (num >= threshold)
				return num > million ? int(num / million).toString() + str : int(num).toString();
			else
				return num.toString();
		}
		
		public static function numToString( num:Number , precision:Number = 0.01 ):String{
			if( precision == 0 )
				return num.toString() ;
			var i:int = Math.floor(num/precision) * precision ;
			var x:int = Math.floor( num/precision - i/precision );
			if( x == 0 )
				return i.toString() ;
			else 
				return i.toString() + "." + x.toString() ;
		}

		public static const GREEN : String = addColorById("绿色", ColorUtils.GREEN);
		public static const BLUE : String = addColorById("蓝色", ColorUtils.BLUE);
		public static const VIOLET : String = addColorById("紫色", ColorUtils.VIOLET);
		public static const ORANGE : String = addColorById("橙色", ColorUtils.ORANGE);
	}
}