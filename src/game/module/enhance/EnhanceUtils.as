package game.module.enhance
{
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.user.UserData;

	import com.utils.ColorUtils;
	import com.utils.StringUtils;

	/**
	 * @author verycd
	 */
	public class EnhanceUtils
	{
//		// 矿工NPC
//		public static var MINER_NPC_ID:int = 3007;
		// 最高强化等级
		public static var maxEnhaceLevel : int = 14;

		public static function getColorIdByEnhanceLevel(level : int) : int
		{
			if (isNaN(level) || level < 0 || level > 14)
			{
				throw("ItemEnhanceLevelError");
				return 0;
			}

			var colorId : int = (level == 0) ? 2 :					// 绿色 
			(level >= 1 && level <= 4) ? 2 :	// 绿色 
			(level >= 5 && level <= 6) ? 3 :	// 蓝色 
			(level >= 7 && level <= 8) ? 4 :	// 紫色 
			5 ;
			// 橙色

			return colorId;
		}

		public static function getColorByEnhanceLevel(level : int) : uint
		{
			return ColorUtils.TEXTCOLOROX[getColorIdByEnhanceLevel(level)];
		}

		public static function getEnhanceLevelHtmlText(level : int) : String
		{
			return StringUtils.addColorById("+" + level.toString(), getColorIdByEnhanceLevel(level));
		}

		public static function getEnhanceLevelHtmlText2(level : int) : String
		{
			return StringUtils.addColorById(level.toString(), getColorIdByEnhanceLevel(level));
		}

		public static function getOwnerFirstCharHtmlText(owner : String) : String
		{
			return StringUtils.addColor(owner.substr(0, 1), "#ffffff");
		}

		public static function getLevelAfterEnhance(levelBefore : int) : int
		{
			if (levelBefore < 14)
			{
				return levelBefore + 1;
			}
			else
			{
				return levelBefore;
			}
		}

		public static function getHeroEquipmetns(heroTabList : EnhanceHeroList, sutra : Boolean) : Array /* of Item */
		{
			var heroId : uint = heroTabList.heroId;
			var items : Array;
			var hero : VoHero;

			if (heroId != 0)
			{
				hero = HeroManager.instance.getTeamHeroById(heroId);
				items = hero.equipments;
			}
			else
			{
				items = [];
				for each (hero in UserData.instance.heroes)
				{
					var match : Boolean = false;
					for each (var tabHeroId:uint in heroTabList.heroes)
					{
						if (hero.id == tabHeroId)
						{
							match = true;
							break;
						}
					}

					if (!match)
					{
						if (sutra) items.push(hero.sutra);
						items = items.concat(hero.equipments);
					}
				}
			}
			return items;
		}
	}
}
