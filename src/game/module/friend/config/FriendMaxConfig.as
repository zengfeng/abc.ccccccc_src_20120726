package game.module.friend.config
{
    import com.utils.LVUtils;
    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-9  ����10:41:34 
     */
    public class FriendMaxConfig
    {
        /** 值配置 */
        public static var valueConfig : Array = [
	        										30,	// 非VIP~VIP2 
											        50,	// VIP3~VIP4
											        60, // VIP5~VIP6 
											        70,	// VIP7 
											        80,	// VIP8
											        90,	// VIP9
											        100, // VIP10
											        110, // VIP11
											        120 // VIP12
										        ];
        /** 级别配置 */
        public static var levelConfig : Array = [
	        										[0, 2],	// 非VIP~VIP2 
											        [3, 4],	// VIP3~VIP4 
											        [5, 6],	// VIP5~VIP6
											        [7, 7], // VIP7
											        [8, 8], // VIP8
											        [9, 9], // VIP9
											        [10, 10], // VIP10
											        [11, 11], // VIP11
											        [12, 12] // VIP12
        ];
        
        
        
        /** 获取级别 */
		public static function getLevel(value:Number):uint
		{
            return LVUtils.getLevel(levelConfig, value);
        }
        
		/** 获取值 */
		public static function getValue(vipLevel:uint):uint
		{
            return LVUtils.getValue(levelConfig, valueConfig, vipLevel);
        }
    }
}
