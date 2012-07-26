package com.commUI.tooltip
{
	import game.core.hero.VoHero;
	import game.core.item.equipment.Equipment;
	import game.module.pack.PackVariable;

	/**
	 * @author jian
	 */
	public class EqPairTip extends ToolTip
	{
		private var _firstTip : EquipmentTip;
		private var _secondTip : EquipmentTip;

		public function EqPairTip(data : ToolTipData)
		{
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			_backgroundSkin.visible = false;
			_firstTip = new EquipmentTip(new ToolTipData());
			_secondTip = new EquipmentTip(new ToolTipData());

			addChild(_firstTip);
		}

		override public function set source(value : *) : void
		{
			if (value)
			{
				var wearedEq : Equipment;
				if (PackVariable.heroPanelOpen && PackVariable.selectedHero)
					wearedEq = PackVariable.selectedHero.getEquipment(value["type"]);
				if (wearedEq)
				{
					_secondTip.source = wearedEq;
					addChild(_secondTip);
				}
				else if (contains(_secondTip))
				{
					removeChild(_secondTip);
				}

				_firstTip.source = value;
				layout();
			}
			else
			{
				_firstTip.source = null;
				_secondTip.source = null;
			}
		}

		override protected function layout() : void
		{
			_secondTip.x = _firstTip.width + 4;
		}
	}
}
