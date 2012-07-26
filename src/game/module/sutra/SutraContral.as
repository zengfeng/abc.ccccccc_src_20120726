package game.module.sutra {
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.item.sutra.Sutra;
	/**
	 * @author Lv
	 */
	public class SutraContral {
		private static var _instance:SutraContral;
		public function SutraContral(contral:Contral):void{}
		public static function get instance():SutraContral{
			if(_instance == null)
				_instance = new SutraContral(new Contral());
			return _instance;
		}
		private var _sutraImg:SutraImg;
		private var _sutraSubmit:SutraSubmitPanel;
		public function sutraImg():SutraImg{
			if(_sutraImg == null)
				_sutraImg = new SutraImg();
			return _sutraImg;
		}
		public function sutraSubmit():SutraSubmitPanel{
			if(_sutraSubmit == null)
				_sutraSubmit = new SutraSubmitPanel();
			return _sutraSubmit;
		}
		
		public function refreshSubmit(heroID:int):void{
			var voHero:VoHero ;
			voHero = HeroManager.instance.getTeamHeroById(heroID);
			if(_sutraSubmit == null||_sutraImg == null)return;
			sutraSubmit().refreshData(voHero.sutra);
			sutraImg().refreshData(voHero.sutra);
		}
		public function weapLevelUp(sutr:Sutra):void{
			_sutraImg.upLevelSutra(sutr);
			_sutraSubmit.weapUpLevel(sutr);
		}
		//符文改变
		public function runtesChange():void{
			_sutraSubmit.runtesSubmitChange();
		}
	}
}
class Contral{}
