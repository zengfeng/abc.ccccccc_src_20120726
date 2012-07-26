package com.commUI.tooltip {
	import com.utils.StringUtils;
	import game.core.item.gem.Gem;
	import game.core.item.prop.ItemProp;
	import game.core.item.sutra.Sutra;
	import game.core.prop.PropManager;
	import game.core.prop.PropUtils;


	/**
	 * @author jian
	 */
	public class SutraTip extends EquipmentTip {
		public function SutraTip(data : ToolTipData) {
			data.width = 180;
			super(data);

			_tradeLabel.visible = false;
		}

		override protected function getToolTipText() : String {
			var text : String = "";
			var sutra : Sutra = _source;

			// text += "攻击距离：" + sutra.range + "\r";
			text += "技能：" + StringUtils.addColorById(sutra.skill, sutra.hero.color) + "\r";
			text += sutra.ruentAdd + sutra.skillHurt + "\r";
			
			text += getPropertyText() + "\r";

			if (sutra.gems.length > 0)
				text += getGemText() + "\r\r";
			text += getSendChatText();

			return text;
		}

		private function getGemText() : String {
			var text : String = "";
			var sutra : Sutra = _source;

			text += "灵珠：" + "\r";

			for each (var gem:Gem in sutra.gems) {
				text += StringUtils.addColorById(gem.level + "级" + gem.name + " " + PropManager.instance.getPropByKey(gem.otherKey).name + "+" + gem.prop[gem.otherKey], gem.color) + "\r";
			}

			return text;
		}

		override protected function getNameLabelText() : String {
			var sutra : Sutra = _source;
			var text : String = "";

			if (sutra) {
				if (sutra.step == 0)
					text += '<font size="14"><b>' + StringUtils.addColorById(sutra.name, sutra.color) + '</b></font>' + "\r";
				else
					text += '<font size="14"><b>' + StringUtils.addColorById(sutra.name + " " + sutra.step + "阶", sutra.color) + '</b></font>' + "\r";
				text += "所属名仙：" + sutra.hero.htmlName + "\r";
			}

			return text;
		}
	}
}
