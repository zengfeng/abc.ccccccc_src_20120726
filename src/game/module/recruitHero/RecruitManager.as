package game.module.recruitHero
{
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.UserData;
	import game.module.sutra.SutraContral;
	import game.net.core.Common;
	import game.net.data.CtoS.CSHeroSummon;

	/**
	 * @author Lv
	 */
	public class RecruitManager
	{
		// =====================
		// 单例
		// =====================
		private static var __instance : RecruitManager;

		public static function get instance() : RecruitManager
		{
			if (!__instance)
				__instance = new RecruitManager();

			return __instance;
		}

		public function RecruitManager()
		{
			if (__instance)
				throw(Error("单例错误"));

			initiate();
		}

		// =====================
		// 属性
		// =====================
		private var _recruitPanel : RecruitView;

		private var _castPanel : CastPanel;

		private var _questPanel : QuestRecruitPanel;

		// =====================
		// Getter/Setter
		// =====================
		public function get recruitPanel() : RecruitView
		{
			if (!_recruitPanel)
				_recruitPanel = new RecruitView();

			return _recruitPanel;
		}

		public function get castPanel() : CastPanel
		{
			if (!_castPanel)
				_castPanel = new CastPanel();

			return _castPanel;
		}

		public function get questPanel() : QuestRecruitPanel
		{
			if (!_questPanel)
				_questPanel = new QuestRecruitPanel();

			return _questPanel;
		}

		// =====================
		// 方法
		// =====================
		private function initiate() : void
		{
			// Common.game_server.addCallback(0x10, onPlayerInfoChange);
			// Common.game_server.addCallback(0x19, onHeroNewList);
			// Common.game_server.addCallback(0x18, onHeroSummonStatusChange);
			Common.game_server.addCallback(0xFFF1, cCUserDataChangeUp);
		}

		// 将领等级提升
		private function cCUserDataChangeUp(...arg) : void
		{
			//SutraContral.instance.refreshSubmit(UserData.instance.myHero.id);
			updateMenuIcon();
		}

		/**isSummon true表示招募，false表示解雇**/
		public function sendHeroSummonMessage(heroId : int, isSummon : Boolean = true) : void
		{
			var cmd : CSHeroSummon = new CSHeroSummon();
			cmd.id = heroId;
			cmd.summon = isSummon;
			Common.game_server.sendMessage(0x18, cmd);
		}

		// 当有新的名仙显示在寻仙列表的时候，导航栏上出新“新”字样ICON
		private function updateMenuIcon() : void
		{
			var heroes : Array = [];
			var myHero : VoHero = HeroManager.instance.myHero;

			for each (var hero:VoHero in HeroManager.instance.allHeroes)
			{
				if (hero == myHero)
					continue;
				if (hero.preRecruitLevel > myHero.level)
					continue;
				heroes.push(hero);
			}

			for each (var _hero : VoHero in heroes)
			{
				if (myHero.level == _hero.preRecruitLevel)
				{
					MenuManager.getInstance().getMenuButton(MenuType.RECRUITHERO).addMenuMc(2, "新");
					break;
				}
			}
		}
	}
}
