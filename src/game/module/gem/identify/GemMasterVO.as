package game.module.gem.identify
{
	import com.utils.ColorUtils;
	import game.definition.UI;
	import net.AssetData;



	/**
	 * @author jian
	 */
	public class GemMasterVO
	{
		// =====================
		// @配置
		// =====================
		private static var ICON_ASSET : Array = [new AssetData(UI.GEM_MASTER_ICON_0), new AssetData(UI.GEM_MASTER_ICON_1), new AssetData(UI.GEM_MASTER_ICON_2)];
		private static var IMG_ASSET : Array = [new AssetData(UI.GEM_MASTER_IMG_0), new AssetData(UI.GEM_MASTER_IMG_1), new AssetData(UI.GEM_MASTER_IMG_2)];
		private static var COLOR : Array = [ColorUtils.GREEN, ColorUtils.BLUE, ColorUtils.VIOLET];
		// =====================
		// @属性
		// =====================
		public var id : uint;
		public var vipLevel : uint;
		public var money : uint;
		public var price : uint;
		public var color : uint;
		public var name : String;
		public var phrase : String;
		public var iconAsset : AssetData;
		public var imgAsset : AssetData;

		// =====================
		// @方法
		// =====================
		public function parse(arr : Array) : void
		{
			id = arr[0];
			vipLevel = arr[1];
			money = arr[2];
			price = arr[3];
			name = arr[6];
			phrase = arr[7];

			color = COLOR[id];
			iconAsset = ICON_ASSET[id];
			imgAsset = IMG_ASSET[id];
		}
	}
}
