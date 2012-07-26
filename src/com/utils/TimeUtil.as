package com.utils
{
	/**
	 * @author yangyiqiang
	 */
	public class TimeUtil
	{
		/**
		 * 获取一个格式化的日期类似2010-04-01
		 */
		public static function getTime(date : Date, detailed : Boolean = true) : String
		{
			var y : uint = date.getFullYear();

			var m : String = ("0" + (date.getMonth() + 1)).substr(-2);

			var d : String = ("0" + date.getDate()).substr(-2);

			var h : String = ("0" + date.getHours()).substr(-2);

			var mi : String = ("0" + date.getMinutes()).substr(-2);

			if (detailed) return y + "-" + m + "-" + d + " " + h + ":" + mi;
			return y + "-" + m + "-" + d;
		}

		/**
		 * 将秒数换算成 小时：分钟：秒 的时间格式
		 */
		public static function secondsToTime(totalSeconds : int) : String
		{
			 var _loc_2:* = Math.floor(totalSeconds / 3600);
            _loc_2 = isNaN(_loc_2) ? (0) : (_loc_2);
            var _loc_3:* = Math.floor(totalSeconds % 3600 / 60);
            _loc_3 = isNaN(_loc_3) ? (0) : (_loc_3);
            var _loc_4:* = Math.floor(totalSeconds % 3600 % 60);
            _loc_4 = isNaN(_loc_4) ? (0) : (_loc_4);
            return (_loc_2 == 0 ? ("00:") : (_loc_2 < 10 ? ("0" + _loc_2 + ":") : (_loc_2 + ":"))) + (_loc_3 < 10 ? ("0" + _loc_3) : (_loc_3)) + ":" + (_loc_4 < 10 ? ("0" + _loc_4) : (_loc_4));
		}
		
		/**
		 * 将秒数换算成 分钟：秒 的时间格式
		 */
		public static function secondsToMinuteSeconds(totalSeconds : int) : String
		{
            var _loc_3:* = Math.floor(totalSeconds % 3600 / 60);
            _loc_3 = isNaN(_loc_3) ? (0) : (_loc_3);
            var _loc_4:* = Math.floor(totalSeconds % 3600 % 60);
            _loc_4 = isNaN(_loc_4) ? (0) : (_loc_4);
            return (_loc_3 < 10 ? ("0" + _loc_3) : (_loc_3)) + ":" + (_loc_4 < 10 ? ("0" + _loc_4) : (_loc_4));
		}

		/**
		 * 将秒数换算成 小时：分钟：秒 的时间格式 去除00
		 */
		public static function secondsToTimeSimple(totalSeconds : int, needSecond : Boolean = true, needDay : Boolean = false) : String
		{
			if (totalSeconds <= 0) return "0秒";

			var days : uint = uint(totalSeconds / 86400);
			var hours : int = needDay ? int(totalSeconds % 86400 / 3600) : int(totalSeconds / 3600);
			var minuts : int = needDay ? int(totalSeconds % 86400 % 3600 / 60) : int(totalSeconds % 3600 / 60);
			var seconds : int = needDay ? int(totalSeconds % 86400 % 3600 % 60) : int(totalSeconds % 3600 % 60);
			var daystxt : String = days + "天";
			var hourstxt : String = hours + "小时";
			var minutstxt : String = minuts + "分";
			var secondstxt : String = seconds + "秒";
			if (!needDay || days == 0)
				daystxt = "";
			if (!needSecond)
				secondstxt = "";
			if (hours == 0)
			{
				hourstxt = "";
				if (minuts == 0 )
					minutstxt = "";
			}
			return daystxt + hourstxt + minutstxt + secondstxt;
		}

		/**
		 * 系统时间转换为本地时间
		 * @param totalSeconds 系统时间 秒 从19701月1日开始到现在
		 */
		public static function sysTimeToLocal(totalSeconds : int, needYear : Boolean = true, needMonth : Boolean = true, needDay : Boolean = true, needHour : Boolean = false, needMin : Boolean = false, needSecond : Boolean = false, earse : Boolean = false) : String
		{
			var date : Date = new Date();
			date.setTime(totalSeconds * 1000);
			var year : String = date.fullYear.toString() + "年";
			var month : String = (date.month + 1).toString() + "月";
			var day : String = date.date.toString() + "日";
			var hours : String = earse && date.hours == 0 ? "" : ((date.hours>=10?date.hours:("0"+date.hours)) + "时");
			var minutes : String = earse && date.minutes == 0 ? "" : ((date.minutes>=10?date.minutes:("0"+date.minutes)) + "分");
			var seconds : String = earse && date.seconds == 0 ? "" : ((date.seconds>=10?date.seconds:("0"+date.seconds)) + "秒");
			var dateString : String = (needYear ? year : "" ) + (needMonth ? month : "") + (needDay ? day : "") + (needHour ? hours : "") + (needMin ? minutes: "") + (needSecond ? seconds : "");

			return dateString;
		}

		/**
		 * 系统时间转换为本地时间
		 * @param totalSeconds 系统时间 秒 从19701月1日开始到现在  格式为 11年8月23日 省去前两位
		 */
		public static function sysTimeToSimpleLocal(totalSeconds : int) : String
		{
			var date : Date = new Date();
			date.setTime(totalSeconds * 1000);
			var yearLength : uint = date.fullYear.toString().length;
			var year : String = date.fullYear.toString().slice(yearLength - 2,yearLength) + "年";
			var month : String = (date.month + 1).toString() + "月";
			var day : String = date.date.toString() + "日";

			return (year + month + day);
		}
		
//	    public static function sysTimeToWeek(totalSeconds : int) : int
//		{
//			var date : Date = new Date();
//			date.setTime(totalSeconds * 1000);
//			var yearLength : uint = date.fullYear.toString().length;
//			var weekDay:uint=date.day;
//			var hour:uint=date.hours;
//			var minutes:uint=date.minutes;
//
//			return (weekDay + hour + minutes);
//		}
	

		public static function systemTimeToLocal(totalSeconds : int) : String
		{
			var date : Date = new Date();
			date.setTime(totalSeconds * 1000);
			var dateString : String = date.fullYear.toString() + "/" + (date.month + 1).toString() + "/" + date.date.toString();
			return dateString;
		}

		/**
		 * 到下一次正点计时的剩余时间
		 * @param currentSeconds  系统时间 秒 从19701月1日0点0分0秒开始到现在  （秒）
		 * @param modSeconds 		间隔时间 （秒）
		 * @param hourOffset			起始小时修正   默认为从0点开始算起  但是有可能实际需求是(1,3,5……)
		 * @return 						当前时间到下次准点时间剩余的时间（秒）
		 */
		public static function nextTimeRemain(currentSeconds : Number, modSeconds : int, hourOffset : int) : Number
		{
			var result : Number;

			var prvSeconds : Number = currentSeconds - (currentSeconds - (new Date()).getTimezoneOffset() * 60 - hourOffset) % modSeconds;
			// 上一次准点时间  注意有时区的问题(中国时区为-8 )

			var nextSeconds : Number = prvSeconds + modSeconds;
			// 下一次准点时间

			result = nextSeconds - currentSeconds;

			return result;
		}
        
        /** 转换成h:m:s */
        public static function toHMS(time:int):Object
        {
            var obj:Object = new Object();
            var h:int = Math.floor(time / 3600);
            var m:int = Math.floor((time - h * 3600) / 60);
            var s:int = time - h * 3600 - m * 60;
            
            obj["h"] = h;
            obj["m"] = m;
            obj["s"] = s;
            return obj;
        }
        
        /** 转换成hh:mm:ss */
        public static function toHHMMSS(time:int):String
        {
            var obj:Object = toHMS(time);
            return StringUtils.fillStr(obj["h"], 2) + ":" + StringUtils.fillStr(obj["m"], 2) + ":" + StringUtils.fillStr(obj["s"], 2);
        }
        
        /** 转换成m:s */
        public static function toMS(time:int):Object
        {
            var obj:Object = new Object();
            var m:int = Math.floor(time / 60);
            var s:int = time - m * 60;
            
            obj["m"] = m;
            obj["s"] = s;
            return obj;
        }
        
        
        /** 转换成mm:ss */
        public static function toMMSS(time:int):String
        {
            var obj:Object = toHMS(time);
            return StringUtils.fillStr(obj["m"], 2) + ":" + StringUtils.fillStr(obj["s"], 2);
        }
        
	}
}
