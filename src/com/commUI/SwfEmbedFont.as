package com.commUI
{
    import flash.display.MovieClip;
    import gameui.manager.UIManager;

    import net.AssetData;
    import net.RESManager;

    import flash.display.SimpleButton;
    import flash.display.Sprite;

    /**
     *  @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-4-17
     */
    public class SwfEmbedFont
    {
        public static const themeKey : String = "embedFont";

        public static function getClass(className : String) : Class
        {
            return RESManager.getClass(new AssetData(className, themeKey));
        }

        public static function getSimpleButton(className : String) : SimpleButton
        {
            var cla : Class = getClass(className);
            if (cla)
            {
                return new cla();
            }
            return new SimpleButton();
        }

        public static function getUI(className : String) : Sprite
        {
            return UIManager.getUI(new AssetData(className, themeKey));
        }
		
		 public static function getMC(className : String) : MovieClip
        {
            return RESManager.getMC(new AssetData(className, themeKey));
        }
    }
}
