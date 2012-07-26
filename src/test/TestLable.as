package test {
	import game.core.hero.HeroConfig;
	import game.core.hero.VoHero;

	import gameui.controls.GLabel;
	import gameui.controls.GToolTip;
	import gameui.manager.UIManager;

	import project.Game;

	import com.commUI.alert.Alert;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.text.TextField;





	/**
	 * @author yangyiqiang
	 */
	[ SWF ( frameRate="60" , backgroundColor=0x333333 ) ]
	public class TestLable extends Game
	{
		public function TestLable()
		{
			super();
			UIManager.setRoot(this);
			addView();
		}

		private var textFile : TextField;
		private var lable:GLabel;
		private var _text:String= "You can vary the <font size='20'>font size</font>,<br><font color='#0000FF'>color</font>,<br><font face='CourierNew, Courier, Typewriter'>face</font>, or<br><font size='18' color='#FF00FF' face='Times, Times New Roman, _serif'>any combination of the three.</font>";
		private var _tip:GToolTip;

		private function addView() : void
		{
			Alert.show(_text);
			textFile=UICreateUtils.createTextField("asfdasf");
			textFile.multiline=true;
			textFile.width=500;
			textFile.height=500;
			textFile.wordWrap=true;
			addChild(textFile);
			textFile.htmlText=_text;
//			var data:GLabelData=new GLabelData();
//			data.y=60;
//			lable=new GLabel(data);
//			lable.htmlText=getToolTipText();
//			addChild(lable);
//			var tipD:GToolTipData=new GToolTipData();
//			tipD.x=300;
//			_tip=new GToolTip(tipD);
//			_tip.source=getToolTipText();
//			addChild(_tip);
		}
		
		protected function getToolTipText():String
		{
			var text : String = "";
			var hero : VoHero = new VoHero();
			var heroConfig:HeroConfig=new HeroConfig();
			hero.config=heroConfig;
			text += "<b>" + hero.htmlName + " " + hero.level + "级" + "</b>" + "\n";
			text += "职业：" + hero.jobName + "\n";
			// TODO
			text += "战斗力：" + hero.bt + "\n\n";
			text += StringUtils.addColor("CTRL+左键发送到聊天频道", "#999999");
			
			return text;
		}
	}
}
