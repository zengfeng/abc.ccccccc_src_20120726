package game.core.item.soul
{
	import game.core.hero.VoHero;
	import game.core.item.ItemService;
	import game.core.item.equipable.HeroSlot;
	import game.core.item.equipable.IEquipable;
	import game.core.user.StateManager;
	import game.manager.ViewManager;
	import game.module.soul.SoulDragManager;
	import gameui.drag.DragManage;


	/**
	 * @author jian
	 */
	public class SoulSlot extends HeroSlot
	{
		public function SoulSlot(hero : VoHero, pos : uint)
		{
			super(hero, HeroSlot.SOUL, pos);
		}

		override public function equip(source : IEquipable) : void
		{
			var soul : Soul = source as Soul;

			if (soul.isExpSoul())
			{
				StateManager.instance.checkMsg(230);

				if (SoulDragManager.state == SoulDragManager.DRAGGING)
				{
					SoulDragManager.state = SoulDragManager.IDLE;
				}
				return;
			}

			for each (var equippedSoul:Soul in hero.souls)
			{
				if (equippedSoul.otherKey == soul.otherKey && equippedSoul.uuid != soul.uuid)
				{
					StateManager.instance.checkMsg(114);
					if (SoulDragManager.state == SoulDragManager.DRAGGING)
					{
						SoulDragManager.state = SoulDragManager.IDLE;
					}
					return;
				}
			}

			SoulDragManager.state = SoulDragManager.WAITING_REPLY;
			super.equip(source);
		}

		public function releaseTo(index : int) : void
		{
			ItemService.instance.sendEquipChangeMessage(this.equipPosition, 0, index);
		}
		
		override public function onEquipped(source : IEquipable) : void
		{
			var waiting:Boolean = _waitingEquip;
			
			super.onEquipped(source);
			
			if (waiting && source is Soul)
			{
				ViewManager.instance.rollMessage((source as Soul).rollDescription);
			}
		}
	}
}
