package game.module.soul
{
	import game.core.hero.VoHero;
	import game.core.item.soul.Soul;
	import game.core.item.soul.SoulSlot;

	/**
	 * @author jian
	 */
	public class SoulUtils
	{
		public static function calHeroSoulPower(hero : VoHero) : uint
		{
			var exp : uint = 0;

			for each (var soul:Soul in hero.souls)
			{
				exp += soul.exp;
			}

			return exp / 5;
		}

		public static function getSoulSlotNumByHeroLevel(level : uint) : uint
		{
			if (level < 20)
				return 1;
			else if (level < 40)
				return 2;
			else if (level < 50)
				return 3;
			else if (level < 60)
				return 4;
			else if (level < 70)
				return 5;
			else return 6;
		}
	}
}
