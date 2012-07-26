package game.module.quest.guide
{
	import flash.display.Sprite;

	import game.core.menu.MenuManager;

	/**
	 * @author yangyiqiang
	 */
	public class VoGuide
	{
		public static const CLOSE : int = 1;

		public var id : int;

		public var targetId : int;
		
		public var type:int=0;

		public var steps : Vector.<VoGuideStep>=new Vector.<VoGuideStep>();

		private var _step : int = -1;

		public function parse(xml : XML) : void
		{
			id = xml.@id;
			targetId = xml.@targetId;
			type=xml.@type;
		}

		public function reset() : void
		{
			_step = -1;
		}

		public function checkLastStep() : Boolean
		{
			if (steps.length <= _step || steps.length - 1 != _step) return false;
			if (steps[_step].type != CLOSE) return false;
			GuideProxy.getInstance().guideUpdate(id);
			return true;
		}

		public function checkNextStep(step : int = -1, view : Sprite = null) : void
		{
			if (GuideProxy.getInstance().isFinish(id))
			{
				if (MenuManager.getInstance().getMenuButton(targetId))
 					MenuManager.getInstance().getMenuButton(targetId).removeMenuMc();
				GuideMange.getInstance().hide();
				return;
			}
			if (step != -1)
			{
				_step = step;
			}
			else
				_step++;
			if (steps.length <= _step)
				GuideProxy.getInstance().guideUpdate(id);
			else
				steps[_step].execute(view);
			return ;
		}
	}
}
