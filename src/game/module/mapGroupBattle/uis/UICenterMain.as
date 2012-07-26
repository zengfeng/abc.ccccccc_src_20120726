package game.module.mapGroupBattle.uis
{
	import game.module.mapGroupBattle.GBConfig;
	import com.commUI.SwfEmbedFont;
	import com.utils.UrlUtils;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import gameui.controls.GImage;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.manager.UIManager;

	import net.AssetData;

	/**
	 *  @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-4-9
	 */
	public class UICenterMain extends GComponent
	{
		public  const TEXT_SCORE : String = "积分：__NUM__";
		public  const TEXT_FIRST_PLAYER : String = "<font color='__COLOR__'>__PLAYER_NAME__</font> <font color='#FFFF00'>__MAX_KILL_COUNT__连杀</font>";
		// 背景
		private var bridgeBg : Sprite;
		//战文字
		private var battle:Sprite;
		/** 游戏结束时间 */
		public var overTimer : UiOverTimer;
		/** 组A积分Label */
		private var scoreTFA : TextField;
		/** 组B积分Label */
		private var scoreTFB : TextField;
		/** 组A图标 */
		private var iconA : GImage;
		/** 组B图标 */
		private var iconB : GImage;
		/** 第一名玩家名称 */
		private var firstPalyerTF : TextField;

		public function UICenterMain(width : Number = 665)
		{
			_base = new GComponentData();
			_base.width = width;
			_base.height = 96;
			super(_base);
			initViews();
			initLayout();
			// 临时
			// test();
		}

		public function test() : void
		{
			overTimer.time = 755;
			setScore(454, 0);
			setScore(946, 1);
			setIconA(0);
			setIconB(1);
			setFirstPlayer("大海明月", GBConfig.GROUP_COLOR_STR_B, 86);
		}

		private var paddingH:int = 0;

		public function updateLayout() : void
		{
			_base.width = width;
			bridgeBg.width = width - paddingH * 2;
			bridgeBg.x = (width -bridgeBg.width) / 2 ;
			
			battle.x =  (width -battle.width) / 2 + 6 ;

			overTimer.x = (width - overTimer.width) / 2;

			scoreTFA.x = width / 2 - 140 - scoreTFA.width;
			scoreTFB.x = width / 2 + 140;
			firstPalyerTF.x = ( width - firstPalyerTF.width)/ 2;
			
			iconALayout();
			iconBLayout();
		}

		public function initLayout() : void
		{
			bridgeBg.width = width - paddingH * 2;
			bridgeBg.x = (width -bridgeBg.width) / 2 ;
			bridgeBg.y = 0;
			
			battle.x =  (width -battle.width) / 2 + 6 ;
			battle.y =  -3 ;

			overTimer.x = (width - overTimer.width) / 2;
			overTimer.y =71;

			scoreTFA.x = width / 2 - 140 - scoreTFA.width;
			scoreTFA.y = (height - scoreTFA.height) / 2 - 2;

			scoreTFB.x = width / 2 + 140;
			scoreTFB.y = scoreTFA.y ;

			firstPalyerTF.x = ( width - firstPalyerTF.width)/ 2;
			firstPalyerTF.y = height ;
		}

		public function initViews() : void
		{
			// 背景
			bridgeBg = UIManager.getUI(new AssetData("swfClass.Sword"));
			addChild(bridgeBg);

			// 游戏结束时间
			overTimer = new UiOverTimer();
			overTimer.x = (_base.width - overTimer.width) / 2;
			overTimer.y = 26;
			addChild(overTimer);
			
			//战
			battle = GBLangUI.getUI("BattleText");
			addChild(battle);

			// 组A积分Label
			var textFormat : TextFormat;
			var tempTF : TextField;
			textFormat = new TextFormat();
			textFormat.size = 12;
			textFormat.bold = true;
			textFormat.align = TextFormatAlign.RIGHT;
			textFormat.color =GBConfig.GROUP_COLOR_A;
			textFormat.font = UIManager.defaultFont;
			tempTF = new TextField();
			tempTF.selectable = false;
			tempTF.defaultTextFormat = textFormat;
			tempTF.filters =UIManager.getEdgeFilters();
			tempTF.width = 150;
			tempTF.height = 20;
			tempTF.x = 90;
			tempTF.y = 34;
			tempTF.text = "积分：0";
			addChild(tempTF);
			scoreTFA = tempTF;
			// 组B积分Label
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.color =GBConfig.GROUP_COLOR_B;
			tempTF = new TextField();
			tempTF.selectable = false;
			tempTF.defaultTextFormat = textFormat;
			tempTF.filters = UIManager.getEdgeFilters();
			tempTF.width = 150;
			tempTF.height = 20;
			tempTF.x = 297;
			tempTF.y = 34;
			tempTF.text = "积分：0";
			addChild(tempTF);
			scoreTFB = tempTF;

			// 组A图标
			var imageData : GImageData;
			var image : GImage;
			imageData = new GImageData();
			imageData.x = 0;
			imageData.y = -4;
			imageData.width = 236;
			imageData.height = 160;
			image = new GImage(imageData);
			addChild(image);
			iconA = image;
			// 组B图标
			imageData = new GImageData();
			// imageData.x = 428;
			// imageData.y = -4;
			// imageData.width = 109;
			// imageData.height = 91;
			image = new GImage(imageData);
			addChild(image);
			iconB = image;

			// 第一名玩家名称
			textFormat = new TextFormat();
			textFormat.size = 16;
			textFormat.font = UIManager.defaultFont;
			// textFormat.bold = true;
			textFormat.align = TextFormatAlign.CENTER;
			firstPalyerTF = new TextField();
			firstPalyerTF.selectable = false;
			firstPalyerTF.defaultTextFormat = textFormat;
			firstPalyerTF.filters = UIManager.getEdgeFilters();
			firstPalyerTF.width = 326;
			firstPalyerTF.height = 30;
			firstPalyerTF.x = (_base.width - firstPalyerTF.width ) >> 1;
			firstPalyerTF.y = 68;
			addChild(firstPalyerTF);
			firstPalyerTF.visible = false;
		}

		// =================
		// 第一名玩家
		// =================
		public function setFirstPlayer(name : String, colorStr : String, maxKillCount : int) : void
		{
			// var colorStr:String = groupId % 2 == 0 ? GBConfig.GROUP_COLOR_STR_A : GBConfig.GROUP_COLOR_STR_B;
			var str : String = TEXT_FIRST_PLAYER.replace(/__COLOR__/, colorStr);
			str = str.replace(/__PLAYER_NAME__/, name);
			str = str.replace(/__MAX_KILL_COUNT__/, maxKillCount);
			firstPalyerTF.htmlText = str;
			firstPalyerTF.visible = name != null && name != "";
		}

		// =================
		// 积分
		// =================
		public function setScore(value : int, groupId : int) : void
		{
			var str : String = TEXT_SCORE.replace(/__NUM__/, value);
			if (groupId % 2 == 0)
			{
				scoreTFA.text = str;
			}
			else
			{
				scoreTFB.text = str;
			}
		}

		// =================
		// 组图标
		// =================
		private var iconAGroupId : int = 0;
		private var iconBGroupId : int = 1;

		public function setIconA(groupId : int) : void
		{
			iconAGroupId = groupId;
			var url : String = UrlUtils.getGroupBattleGroupIcon(groupId);
			iconA.url = url;
			iconALayout();
		}

		public function setIconB(groupId : int) : void
		{
			iconBGroupId = groupId;
			var url : String = UrlUtils.getGroupBattleGroupIcon(groupId);
			iconB.url = url;
			iconBLayout();
		}

		private function iconALayout() : void
		{
			if (iconAGroupId == 0)
			{
				iconA.x = -120;
				iconA.y = -26;
			}
			else
			{
				iconA.x = -82;
				iconA.y = -27;
			}
		}

		private function iconBLayout() : void
		{
			if (iconBGroupId == 1)
			{
				iconB.x = width -30;
				iconB.y = -30;
			}
			else
			{
				iconB.x = width -30;
				iconB.y = -18;
			}
		}
	}
}
