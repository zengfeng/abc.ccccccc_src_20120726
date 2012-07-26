package com.utils
{
    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����5:01:24 
     */
    public class LVUtils
    {
        
        /** 获取级别 */
		public static function getLevel(levelConfig:Array, value:Number):uint
		{
			var level:int = 0;
			var arr:Array;
			//超过最小时
			arr = levelConfig[0];
			if(value <= arr[0])
			{
				level = 0;
				return level;
			}
			//超过最大时
			arr = levelConfig[levelConfig.length - 1];
			if(value >= arr[1])
			{
				level = levelConfig.length - 1;
				return level;
			}
			
			for(var i:int = 0; i < levelConfig.length; i++)
			{
				arr = levelConfig[i];
				if(value >= arr[0] && value <= arr[1])
				{
					level = i;
					break;
				}
			}
			
			return level;
		}
        
		/** 获取值 */
		public static function getValue(levelConfig:Array,valueConfig:Array, vipLevel:uint):uint
		{
			var level:uint = getLevel(levelConfig, vipLevel);
			return valueConfig[level];
		}
    }
}
