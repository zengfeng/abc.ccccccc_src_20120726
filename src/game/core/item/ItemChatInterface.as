package game.core.item
{
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;

	import com.sociodox.utils.Base64;
	import com.utils.SerializeUtils;

	import flash.utils.ByteArray;

	import game.core.item.equipment.Equipment;
	import game.core.item.gem.Gem;
	import game.core.item.pile.PileItem;
	import game.core.item.soul.Soul;
	import game.core.item.sutra.Sutra;

	/**
	 * @author jian
	 */
	public class ItemChatInterface
	{
		public static function encodeItemToString(item : Item) : String
		{
			var vo : Object = getChatVOFromItem(item);
			return SerializeUtils.encodeObjectToString(vo);
		}

		public static function decodeStringToItem(str : String) : Item
		{
			var vo : Object = SerializeUtils.decodeStringToObject(str);
			var item : Item = getItemFromChatVO(vo);
			return item;
		}

		private static function getChatVOFromItem(item : Item) : Object
		{
			var vo : Object = new Object();

			vo["id"] = item.id;
			vo["binding"] = item.binding;

			if (item is Equipment)
				vo["enhanceLevel"] = (item as Equipment).enhanceLevel;

			if (item is Soul)
				vo["exp"] = (item as Soul).exp;

			if (item is PileItem)
				vo["nums"] = item.nums;

			if (item is Sutra)
			{
				var gems : Vector.<uint> = new Vector.<uint>();
				for each (var gem:Gem in (item as Sutra).gems)
				{
					gems.push(gem.id);
				}
				vo["gems"] = gems;
				vo["step"] = (item as Sutra).step;
				vo["runetotemID"] = (item as Sutra).runetotemID;
				if ((item as Sutra).hero)
				{
					vo["heroName"] = (item as Sutra).hero.name;
					vo["heroPotential"] = (item as Sutra).hero.potential;
				}
			}

			return vo;
		}

		private static function getItemFromChatVO(vo : Object) : Item
		{
			if (vo["id"] == undefined)
				return null;

			var item : Item = ItemManager.instance.newItem(vo["id"], vo["binding"]);

			if (item is Equipment)
			{
				(item as Equipment).enhanceLevel = vo["enhanceLevel"];
				(item as Equipment).suiteNums = vo["suiteNums"];
			}

			if (item is Soul)
				(item as Soul).exp = vo["exp"];

			if (item is Sutra && vo["gems"])
			{
				var gems : Array = [];
				for each (var gemId:uint in vo["gems"])
				{
					var gem : Gem = ItemManager.instance.newItem(gemId);

					if (gem)
						gems.push(gem);
				}
				(item as Sutra).gems = gems;
				(item as Sutra).step = vo["step"];
				(item as Sutra).runetotemID = vo["runetotemID"];

				var hero : VoHero = HeroManager.instance.newHero(item.id - 30000);
				if (vo.hasOwnProperty("heroName"))
					hero.name = vo["heroName"];
				if (vo.hasOwnProperty("heroPotential"))
					hero.potential = vo["heroPotential"];
				(item as Sutra).hero = hero;
			}

			return item;
		}
	}
}
