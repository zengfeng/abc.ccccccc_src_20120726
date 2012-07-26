package game.module.quest.guide
{
	import flash.display.Sprite;
	import game.core.menu.MenuManager;


	/**
	 * @author yangyiqiang
	 */
	public class VoGuideStep
	{
		public var id : int;

		// *  arrowType   1:气泡荷花   2:气泡有文字   3:气泡感叹号         4:新手引导箭头
		public var arrowType : int;

		public var message : String;

		public var x : Number;

		public var y : Number;

		public var targetId : int;

		public var type : int = 0;

		public function VoGuideStep(value : int)
		{
			targetId = value;
		}

		public function prase(xml : XML) : void
		{
			id = xml.@id;
			arrowType = xml.@arrowType;
			message = xml.@message;
			x = xml.@x;
			y = xml.@y;
			type = xml.@type;
			if (Number(xml.@targetId) > 0)
				targetId = Number(xml.@targetId);
		}

		public function execute(view : Sprite = null) : void
		{
			switch(arrowType)
			{
				case 1:
				case 2:
				case 3:
					if (MenuManager.getInstance().getMenuButton(targetId))
						MenuManager.getInstance().getMenuButton(targetId).addMenuMc(arrowType, message, x, y);
					break;
				case 4:
					if (view){
						GuideMange.getInstance().moveTo(x, y, message, view);
						break;
					}
					if (MenuManager.getInstance().getMenuButton(targetId))
						GuideMange.getInstance().moveTo(x, y, message, MenuManager.getInstance().getMenuButton(targetId).target);
					break;
			}
		}
	}
}
