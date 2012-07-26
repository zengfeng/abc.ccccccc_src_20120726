package com.commUI
{
	import net.AssetData;
	import net.RESManager;

	import com.utils.StringUtils;

	import flash.display.Sprite;
    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-3-8   ����4:40:20 
     */
    public class SwfEffectText
    {
        /** 战斗冷却中 */
        public static const ID_BATTLEING:int = 1;
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        public static const themeKey:String = "embedFont";
        private static function getClassName(id:int):String
        {
            //如 EffectText_001
            return "EffectText_"+StringUtils.fillStr(id.toString(), 3);
        }
        
        public static function getMC(id:int):Sprite
        {
            var className:String = getClassName(id);
            var displayObject:Sprite = RESManager.getMC(new AssetData(className,themeKey));
            return displayObject;
        }
    }
}
