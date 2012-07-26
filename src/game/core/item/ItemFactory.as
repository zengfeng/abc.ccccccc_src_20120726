package game.core.item
{
	import game.core.item.config.ItemConfig;
	import game.core.item.config.ItemConfigManager;
	import game.core.item.config.SutraConfig;
	import game.core.item.equipment.Equipment;
	import game.core.item.gem.Gem;
	import game.core.item.pile.PileItem;
	import game.core.item.prop.ItemPropManager;
	import game.core.item.soul.Soul;
	import game.core.item.soul.SoulConfigManager;
	import game.core.item.sutra.Sutra;

	import log4a.Logger;

	/**
	 * @author jian
	 */
	public class ItemFactory
	{
		private var _itemConfigManager : ItemConfigManager = ItemConfigManager.instance;
		private var _itemPropManger : ItemPropManager = ItemPropManager.instance;
		private var _soulConfigManager : SoulConfigManager = SoulConfigManager.instance;

		public function newItem(id : uint, binding : Boolean) : *
		{
			var config : ItemConfig = _itemConfigManager.getConfig(id);
			if (!config) {
				Logger.error("装备配置类型错误：" + id);
				return null;
			}

			var type : uint = config.type;
			var item : Item;

			if (type >= 81 && type <= 86)
			{
				item = Equipment.create(config, binding, _itemPropManger.getProp(id));
			}
			else if (type == 87)
			{
//				var hero : VoHero = HeroConfigManager.instance.getHeroById(id - 30000);
				item = Sutra.create(SutraConfig(config), _itemPropManger.getProp(id));
			}
			else if (type >= 14 && type <= 50)
			{
				item = Soul.create(config, binding, _itemPropManger.getProp(id), _soulConfigManager.getConfig(id));
			}
			else if (type <= 13)
			{
				item = Gem.create(config, binding, _itemPropManger.getProp(id));
			}
			else
			{
				item = PileItem.create(config, binding);
			}

			return item;
		}
	}
}
