package game.module.mapGroupBattle.uis
{
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.RESManager;

	import flash.display.Sprite;
	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-17
	 */
	public class GBLangUI
	{
        public static const themeKey : String = "groupBattle";
		
        public static function getClass(className : String) : Class
        {
            return RESManager.getClass(new AssetData(className, themeKey));
        }
		
        public static function getUI(className : String) : Sprite
        {
            return UIManager.getUI(new AssetData(className, themeKey));
        }
	}
}
