package game.module.compete
{
	import com.utils.FilterUtils;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import game.core.hero.HeroConfigManager;
	import game.core.hero.VoHero;
	import game.core.user.UserData;
	import game.manager.RSSManager;
	import game.net.core.Common;
	import gameui.containers.GPanel;
	import gameui.controls.GLabel;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.data.GToolTipData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;

	/**
	 * @author yangyiqiang
	 */
	public class TestUserInfo extends GPanel
	{
		public function  TestUserInfo()
		{
			_data = new GPanelData();
			_data.width = 500;
			_data.height =130;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
			super(_data);
			initView();
		}
		
	   private var _vo : UserData=UserData.instance;
			
       private var _prop : Dictionary = new Dictionary(true);

		private function initView() : void
		{
			
			addBg();
			var xml : XML = RSSManager.getInstance().getData("competerank");
			if (!xml) return;
			var lable : GLabel;
			var data : GLabelData = new GLabelData();
			//data.textFieldFilters = [];
			for each (var item:XML in xml["userinfo"]["item"])
			{
				data = data.clone();
				data.width=500;
				data.height=130;
				data.x = item.@x;
				data.y = item.@y;
				data.textFieldFilters=[FilterUtils.defaultTextEdgeFilter];
				if (xml.@tips == undefined || item.@tips == "")
				{
					data.toolTipData = null;
				}
				else
				{
					data.toolTipData = new GToolTipData();
				}
				lable = new GLabel(data);
				if (data.toolTipData)
					lable.toolTip.source = item.@tips;
				add(lable);
				_prop[Number(item.@id)] = lable;
			}
		}

		public function refreshUserInfo() : void
		{
			var xml : XML = RSSManager.getInstance().getData("competerank");
			if (!xml) return;
			var lable : GLabel;
			var str : String = "";
			for each (var item:XML in xml["userinfo"]["item"])
			{
				lable = _prop[Number(item.@id)];
				str = item.children();
				switch(Number(item.@id))
				{
					case 81:
						str = str.replace("******",_vo.playerName);   //名字
//						str = str.replace("######",voCompete.myrank);   //名字
						str = str.replace("+++++",VoCompete.bestRank);   //名字
						break;
					case 82:
					    str = str.replace("******",VoCompete.winStreak);   //名字
						break;
					case 83:
					    str = str.replace("#####",_vo.honour);   //名字
						break;
					case 84:
						break;
					case 85:
						break;
					default :
						str = str.replace("*****","XXOO");
						str = str.replace("#####","OOXX");
						break;
				}
				if (!lable) continue;
				lable.htmlText = str;
				
			}
		}
		
		private function addBg() : void {
			
			var bg:Sprite = UIManager.getUI(new AssetData("info_panel"));
			
			bg.width = 500;
			
			bg.height = 130;
						
			_content.addChild(bg);
			
			var bg:Sprite = UIManager.getUI(new AssetData("title"));
			
			bg.x=6;
			
			bg.y=40.7;
			
			bg.width = 364.15;
			
			bg.height = 1;
						
			_content.addChild(bg);
			
		}
		
	}
}
