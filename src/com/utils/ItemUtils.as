package com.utils
{
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.equipable.HeroSlot;
	import game.core.item.equipable.IEquipable;
	import game.core.item.equipment.Equipment;
	import game.core.item.equipment.EquipmentType;
	import game.core.item.gem.Gem;
	import game.core.item.pile.IPileGroup;
	import game.core.item.pile.PileItem;
	import game.core.item.soul.Soul;
	import game.core.item.sutra.Sutra;
	import game.definition.ID;
	import game.definition.UI;
	import game.module.enhance.EnhanceRule;
	import game.module.enhance.EnhanceRuleManager;

	import gameui.cell.LabelSource;

	import utils.DictionaryUtil;

	import com.commUI.tooltip.EqPairTip;
	import com.commUI.tooltip.EquipmentTip;
	import com.commUI.tooltip.GemTip;
	import com.commUI.tooltip.ItemTip;
	import com.commUI.tooltip.MoneyTip;
	import com.commUI.tooltip.SoulTip;
	import com.commUI.tooltip.SutraTip;

	import flash.utils.Dictionary;

	/**
	 * @author jian
	 */
	public class ItemUtils
	{
		// =====================
		// @排序
		// =====================
		// 所有物品
		public static function sortItemFunc(a : Item, b : Item) : int
		{
			if (a.topType != b.topType)
				return b.topType - a.topType;

			// 法宝是装备，沿用装备的排序方法
			// if (a is Sutra && b is Sutra)
			// return sortWeaponFunc(Sutra(a), Sutra(b));

			if (a is Gem && b.type == 65)
				return -1;

			if (b is Gem && a.type == 65)
				return 1;

			if (a is Equipment && b is Equipment)
				return sortEquipmentFunc(Equipment(a), Equipment(b));

			if (a is Gem && b is Gem)
				return sortGemFunc(Gem(a), Gem(b));

			if (a is Soul && b is Soul)
				return sortSoulFunc(Soul(a), Soul(b));

			if (a.color != b.color)
				return b.color - a.color;

			if (a.id != b.id)
				return b.id - a.id;

			return (b.binding ? 1 : 0) - (a.binding ? 1 : 0);
		}

		// 装备
		public static function sortEquipmentFunc(a : Equipment, b : Equipment) : int
		{
			if (a.heroId != b.heroId)
				return b.heroId - a.heroId;
			// if (a.level != b.level)
			// return a.level - b.level;
			// 装备ID 已经按照 装备等级＞品质＞锐套装＞固套装＞部位 排序过了
			if (a.id != b.id)
				return b.id - a.id;
			if (a.enhanceLevel != b.enhanceLevel)
				return b.enhanceLevel - a.enhanceLevel;
			return (b.binding ? 1 : 0) - (a.binding ? 1 : 0);
		}

		//		//  武器
		// public static function sortWeaponFunc(a : Sutra, b : Sutra) : int
		// {
		// if (a.heroId != b.heroId)
		// return b.heroId - a.heroId;
		// if (a.level != b.level) return b.level - a.level;
		// if (a.color != b.color) return b.color - a.color;
		// if (a.type != b.type) return b.type - a.type;
		// return -1;
		// }
		// 灵珠
		public static function sortGemFunc(a : Gem, b : Gem) : int
		{
			if (a.color != b.color)
				return b.color - a.color;
			if (a.level != b.level)
				return b.level - a.level;
			if (a.id != b.id)
				return b.id - a.id;
			return (b.binding ? 1 : 0) - (a.binding ? 1 : 0);
		}

		// 元神排序
		public static function sortSoulFunc(a : Soul, b : Soul) : int
		{
			if (a.color != b.color)
				return b.color - a.color;
			if (a.level != b.level)
				return b.level - a.level;
			if (a.id != b.id)
				return b.id - a.id;
			return (b.binding ? 1 : 0) - (a.binding ? 1 : 0);
		}

		// =====================
		// 强化
		// =====================
		public static function getEnhancePropKey(type : uint) : String
		{
			switch(type)
			{
				case EquipmentType.SUTRA:
					return "act_add";
				case EquipmentType.HELM:
					return "magic_act";
				case EquipmentType.ARMOR:
					return "hp_add";
				case EquipmentType.BELT:
					return "def";
				case EquipmentType.BOOT:
					return "hp_add";
				case EquipmentType.RING:
					return "act_add";
				case EquipmentType.AMULET:
					return "magic_act";
				default:
					throw(Error("类型错误" + type));
			}
		}

		public static function getEnhancePropValue(type : uint, enhanceLevel : uint) : Number
		{
			var rule : EnhanceRule = EnhanceRuleManager.getInstance().getRule(enhanceLevel);

			switch(getEnhancePropKey(type))
			{
				case "act_add":
					return rule.incrAttack;
				case "hp_add":
					return rule.incrHealth;
				case "def":
					return rule.incrDefence;
				case "magic_act":
					return rule.incrSpell;
				default:
					throw(Error("类型错误" + type));
			}
		}

		public static function getEquipmentTypeName(type : uint) : String
		{
			switch (type)
			{
				case EquipmentType.HELM:
					return "头饰";
				case EquipmentType.ARMOR:
					return "盔甲";
				case EquipmentType.BELT:
					return "腰带";
				case EquipmentType.BOOT:
					return "靴子";
				case EquipmentType.RING:
					return "戒指";
				case EquipmentType.AMULET:
					return "挂件";
				case EquipmentType.SUTRA:
					return "法宝";
			}
			return "未知";
		}

		// =====================
		// @堆叠
		// =====================
		public static function splitPileArray(array : Array) : Array
		{
			var splitted : Array = [];

			for each (var item:* in array)
			{
				if (item is IPileGroup)
					splitted = splitted.concat(IPileGroup(item).elements);
				else
					splitted.push(item);
			}

			return splitted;
		}

		public static function mergePileArray(array : Array) : Array
		{
			var merged : Array = [];
			var groups : Array = [];
			var group : IPileGroup;

			for each (var item:* in array)
			{
				if (item is PileItem)
				{
					if (PileItem(item).selected)
						continue;
					else
					{
						group = PileItem(item).group ? PileItem(item).group : item;
						group.selected = true;
						groups.push(group);
						merged.push(group);
					}
				}
				else
					merged.push(item);
			}

			for each (group in groups)
			{
				group.selected = false;
			}

			return merged;
		}

		public static function addToPileArray(array : Array, item : Item) : void
		{
			if (!(item is PileItem) || item.config.stackLimit == 1)
			{
				array.push(item);
				return;
			}

			for each (var oldItem:Item in array)
			{
				if (oldItem.id == item.id && oldItem.binding == item.binding)
				{
					oldItem.nums += item.nums;
					return;
				}
			}

			array.push(item);
		}

		// =====================
		// @筛选框
		// =====================
		public static function listElementPropertyValue(array : Array, property : String) : Array
		{
			var propList : Array = [];
			var propDict : Dictionary = new Dictionary();

			for each (var element:Object in array)
			{
				if (element.hasOwnProperty(property))
				{
					propDict[element[property]] = true;
				}
			}

			for (var propValue:* in propDict)
			{
				propList.push(propValue);
			}

			return propList;
		}

		private static var comboLabelsByColor : Array = [StringUtils.addColorById("白色", 1), StringUtils.addColorById("绿色", 2), StringUtils.addColorById("蓝色", 3), StringUtils.addColorById("紫色", 4), StringUtils.addColorById("橙色", 5),, StringUtils.addColorById("暗金 ", 6)];

		public static function changeComboBoxByColor(items : Array/* of Item */) : Array
		{
			var comboBoxSource : Array = [new LabelSource("全部", 0)];
			var vc : Vector.<LabelSource>=new Vector.<LabelSource>(comboLabelsByColor.length);
			for each (var vo:Item in items)
			{
				if (vo.color < 1 || vo.color > vc.length) continue;
				if (vc[vo.color] == null)
				{
					vc[vo.color] = new LabelSource(comboLabelsByColor[vo.color - 1], vo.color);
					comboBoxSource.push(vc[vo.color]);
				}
			}
			return comboBoxSource;
		}

		public static function changeComboBoxByItemId(items : Array/* of Item */) : Array
		{
			var itemIdDict : Dictionary = new Dictionary();
			var item : Item;
			for each (item in items)
			{
				itemIdDict[item.id] = item;
			}

			var comboBoxSource : Array = [new LabelSource("全部", 0)];
			for each (item in DictionaryUtil.getValues(itemIdDict).sortOn("id"))
			{
				comboBoxSource.push(new LabelSource(item.htmlName, item.id));
			}
			return comboBoxSource;
		}

		public static function filterItemsByColor(items : Array/* of Item */, color : uint) : Array
		{
			if (!items)
				return null;
			if (color == 0)
				return items;

			var arr : Array = [];
			for each (var item:Item in items)
			{
				if (item.color == color)
					arr.push(item);
			}

			return arr;
		}

		// =====================
		// ToolTip
		// =====================
		public static function getItemToolTipClass(item : Item, showPair : Boolean = false) : Class
		{
			if (item is Sutra)
				return SutraTip;
			else if (item is Equipment)
			{
				if (showPair)
					return EqPairTip;
				else
					return EquipmentTip;
			}
			else if (item is Soul)
				return SoulTip;
			else if (item is Gem)
				return GemTip;
			else if (item.id == ID.GOLD || item.id == ID.BIND_GOLD || item.id == ID.SILVER || item.id == ID.HONOR)
				return MoneyTip;
			else return ItemTip;

//			var className:String;
//			
//			if (item is Sutra)
//				className = "com.commUI.tooltip.SutraTip";
//			else if (item is Equipment)
//			{
//				if (showPair)
//					className = "com.commUI.tooltip.EqPairTip";
//				else
//					className =  "com.commUI.tooltip.EquipmentTip";
//			}
//			else if (item is Soul)
//				className = "com.commUI.tooltip.SoulTip";
//			else if (item is Gem)
//				className = "com.commUI.tooltip.GemTip";
//			else if (item.id == ID.GOLD || item.id == ID.BIND_GOLD || item.id == ID.SILVER || item.id == ID.HONOR)
//				className = "com.commUI.tooltip.MoneyTip";
//			else
//				className = "com.commUI.tooltip.ItemTip";
//			
//			return ApplicationDomain.currentDomain.getDefinition(className) as Class;

		}

		// =====================
		// 图标边框
		// =====================
		public static function getBorderByColor(color : uint) : String
		{
			switch(color)
			{
				case 1:
					return UI.ROUND_ICON_BACKGROUND_WHITE;
				case 2:
					return UI.ROUND_ICON_BACKGROUND_GREEN;
				case 3:
					return UI.ROUND_ICON_BACKGROUND_BLUE;
				case 4:
					return UI.ROUND_ICON_BACKGROUND_VIOLET;
				case 5:
					return UI.ROUND_ICON_BACKGROUND_ORANGE;
				case 6:
					return UI.ROUND_ICON_BACKGROUND_GOLD;
				default:
					return UI.ROUND_ICON_BACKGROUND_WHITE;
			}
		}

		// =====================
		// @其它
		// =====================
		public static function getHeroId(item : Item) : uint
		{
			if (item is IEquipable)
			{
				return ((item as IEquipable).slot as HeroSlot).hero.id;
			}

			return 0;
		}

		// private static var _stepString : Array = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"];
		//
		// public static function getSutraStepString(step : uint) : String
		// {
		// return _stepString[step] + "阶";
		// }
		// =====================
		// 元神
		// =====================
		// =====================
		// 转移
		// =====================
		/**
		 * 替换的规则是：（优先级高到低）1. 同部位装备 2. 使用等级满足 4. 物品ID高的 5. 替换强化等级高的 或 强化转移强化等级高的 6. 优先绑定的
		 */
		public static function calculateTransferWeight(source : Equipment, target : Equipment, job : uint) : uint
		{
			var weight : uint = 0;
			// var jobWeight:uint;
			// if (source.qualityType == EquipmentQualityType.NORMAL)
			// {
			// if (target.qualityType == EquipmentQualityType.NORMAL)
			// jobWeight = 1;
			// else if (job == JobType.JIN_GANG && target.qualityType == EquipmentQualityType.FIRM || job != JobType.JIN_GANG && target.qualityType != EquipmentQualityType.FIRM)
			// jobWeight = 2;
			// else
			// jobWeight = 0;
			// }
			// else
			// {
			// if (source.qualityType == target.qualityType)
			// jobWeight = 3;
			// else
			// jobWeight = 0;
			// }

			var isTrans : Boolean = (source != target && source.enhanceLevel >= target.enhanceLevel);

			// weight = jobWeight << 27;
			weight |= target.id << 11;

			if (!isTrans)
				weight |= (target.enhanceLevel + 1) << 6;
			else
				weight |= (31 - target.enhanceLevel) << 1;
			weight |= target.binding ? 1 : 0;

			return weight;
		}

		public static function getTransferTarget(useLevel : uint, source : Equipment, job : uint) : Equipment
		{
			var chosen : Equipment = source;
			var chosenWeight : uint = calculateTransferWeight(source, source, job);
			var targetWeight : uint;

			for each (var target:Equipment in ItemManager.instance.packModel.getPageItems(Item.EQ))
			{
				if (target.type != source.type)
					continue;

				if (target.useLevel > useLevel)
					continue;

				targetWeight = calculateTransferWeight(source, target, job);

				if (targetWeight > chosenWeight)
				{
					chosen = target;
					chosenWeight = targetWeight;
				}
			}

			if (chosen == source)
				return null;
			return chosen;
		}

		public static function proposeNewbieEquipment(useLevel : uint, type : uint, sourceId : uint) : Equipment
		{
			var eqChosen : Equipment;

			for each (var target:Equipment in ItemManager.instance.packModel.getPageItems(Item.EQ))
			{
				if (target.type != type)
					continue;

				if (target.useLevel > useLevel)
					continue;

				if (!eqChosen)
				{
					if (target.id > sourceId)
						eqChosen = target;
				}
				else
				{
					if (target.id > eqChosen.id)
						eqChosen = target;
				}
			}
			return eqChosen;
		}
	}
}


