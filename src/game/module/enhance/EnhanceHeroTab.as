package game.module.enhance
{
	import com.commUI.herotab.HeroTab;
	import game.core.hero.VoHero;
	import gameui.data.GTabData;
	import gameui.layout.GLayout;



	/**
	 * @author jian
	 */
	public class EnhanceHeroTab extends HeroTab
	{
		public function EnhanceHeroTab(data : GTabData)
		{
			super(data);
		}

		override public function set source(value : *) : void
		{
			var hero : VoHero = value as VoHero;

			if (hero && hero.id == 0)
			{
				_label.text = "其他名仙";
				_label.visible = true;
				_icon.visible = false;
				super.source = value;
				GLayout.layout(_label);
			}
			else
			{
				_label.visible = false;
				_icon.visible = true;
				super.source = value;
			}
		}
	}
}
