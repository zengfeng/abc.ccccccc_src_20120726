package game.module.pack
{
	import com.utils.StringUtils;
	import game.core.hero.VoHero;
	import game.core.item.Item;
	import gameui.cell.LabelSource;
	import gameui.core.GComponent;



	/**
	 * @author yangyiqiang
	 */
	public class PackVariable
	{
		/** false 批量卖出状态
		 *  true  正常使用状态
		 */
		public static var isBattch : Boolean = false;
		public static var mouseDownTarget : GComponent;
		/** 将领面板是否打开 **/
		public static var heroPanelOpen : Boolean = false;
		/** 选中的将领 **/
		public static var selectedHero : VoHero;

	}
}
