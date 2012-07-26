package game.module.mapGroupBattle.uis
{
	import game.module.mapGroupBattle.elements.Battler;
	import com.utils.FilterUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;
	import net.AssetData;






	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-1-18 ����12:25:13
	 */
	public class UiSelfInfoBox extends GComponent
	{
		public const TEXT_MAX_KILL_COUNT : String = "最高  <font color='#FFFF66'>__NUM__连杀</font>";
		public const TEXT_KILL_COUNT : String = "当前  <font color='#FFFF66'>__NUM__连杀</font>";
		public const TEXT_WIN_COUNT : String = "赢  <font color='#FFFF66'>__NUM__场</font>";
		public const TEXT_LOSE_COUNT : String = "输  <font color='#FFFF66'>__NUM__场</font>";
		public const TEXT_SILVER_COUNT : String = "银币  <font color='#FFFF66'>__NUM__</font>";
		public const TEXT_DARKSTEEL_COUNT : String = "玄铁  <font color='#FFFF66'>__NUM__</font>";
		/** 背景 */
		private var bg : Sprite;
		/** 最高连杀数 */
		private var maxKillCountTF : TextField;
		/** 连杀数 */
		private var killCountTF : TextField;
		/** 胜利场数 */
		private var winTF : TextField;
		/** 失败场数 */
		private var loseTF : TextField;
		/** 银币数 */
		private var silverTF : TextField;
		/** 玄铁数 */
		private var darksteelTF : TextField;
		/** 玩家名称 */
		private var playerNameTF : TextField;

		public function UiSelfInfoBox()
		{
			_base = new GComponentData();
			_base.width = 225;
			_base.height = 46;
			super(_base);

			initViews();

//			test();
		}

		public function test() : void
		{
			maxKillCount = Math.ceil(Math.random() * 99);
			killCount = Math.ceil(Math.random() * 99);
			winCount = Math.ceil(Math.random() * 99);
			loseCount = Math.ceil(Math.random() * 99);
			silver = Math.ceil(Math.random() * 99);
			darksteel = Math.ceil(Math.random() * 99);
		}

		/** 初始化视图 */
		protected function initViews() : void
		{
			// 背景
			bg = UIManager.getUI(new AssetData("GroupBattle_SelfInfoBg"));
			bg.width = _base.width;
			bg.height = _base.height;
			addChild(bg);

			// 玩家名称
			var textFormat : TextFormat = new TextFormat();
			textFormat.size = 14;
			textFormat.color = 0xFFFFFF;
			textFormat.bold = true;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.font = UIManager.defaultFont;
			var tempTF : TextField = new TextField();
			tempTF.selectable = false;
			tempTF.defaultTextFormat = textFormat;
			tempTF.width = 100;
			tempTF.height = 26;
			tempTF.x = 15;
			tempTF.y = 15;
			tempTF.text = "大海明月";
			tempTF.filters = [FilterUtils.defaultTextEdgeFilter];
			// addChild(tempTF);
			playerNameTF = tempTF;

			var rankX_1 : int = 7;
			var rankX_2 : int = 88;
			var rankX_3 : int = 150;

			var rankWidth_1 : int = 70;
			var rankWidth_2 : int = 66;
			var rankWidth_3 : int = 66;

			var rowY_1 : int = 3;
			var rowY_2 : int = 22;

			textFormat = new TextFormat();
			textFormat.size = 12;
			textFormat.color = 0xFFFFFF;
			textFormat.align = TextFormatAlign.LEFT;
			// 最高连杀数
			tempTF = new TextField();
			tempTF.selectable = false;
			tempTF.defaultTextFormat = textFormat;
			tempTF.width = rankWidth_1;
			tempTF.height = 20;
			tempTF.x = rankX_1;
			tempTF.y = rowY_1;
			tempTF.htmlText = "最高  0连杀";
			addChild(tempTF);
			maxKillCountTF = tempTF;

			// 连杀数
			tempTF = new TextField();
			tempTF.selectable = false;
			tempTF.defaultTextFormat = textFormat;
			tempTF.width = rankWidth_1;
			tempTF.height = 20;
			tempTF.x = rankX_1;
			tempTF.y = rowY_2;
			tempTF.htmlText = "当前  0连杀";
			addChild(tempTF);
			killCountTF = tempTF;

			// 胜利场数
			tempTF = new TextField();
			tempTF.selectable = false;
			tempTF.defaultTextFormat = textFormat;
			tempTF.width = rankWidth_2;
			tempTF.height = 20;
			tempTF.x = rankX_2;
			tempTF.y = rowY_1;
			tempTF.htmlText = "赢  0场";
			addChild(tempTF);
			winTF = tempTF;
			// 失败场数
			tempTF = new TextField();
			tempTF.selectable = false;
			tempTF.defaultTextFormat = textFormat;
			tempTF.width = rankWidth_2;
			tempTF.height = 20;
			tempTF.x = rankX_2;
			tempTF.y = rowY_2;
			tempTF.htmlText = "输  0场";
			addChild(tempTF);
			loseTF = tempTF;
			// 银币
			tempTF = new TextField();
			tempTF.selectable = false;
			tempTF.defaultTextFormat = textFormat;
			tempTF.width = rankWidth_3;
			tempTF.height = 20;
			tempTF.x = rankX_3;
			tempTF.y = rowY_1;
			tempTF.htmlText = "银币  0";
			addChild(tempTF);
			silverTF = tempTF;
			// 银币
			tempTF = new TextField();
			tempTF.selectable = false;
			tempTF.defaultTextFormat = textFormat;
			tempTF.width = rankWidth_3;
			tempTF.height = 20;
			tempTF.x = rankX_3;
			tempTF.y = rowY_2;
			tempTF.htmlText = "玄铁  0";
			addChild(tempTF);
			darksteelTF = tempTF;
		}

		public function setPlayer(battler : Battler) : void
		{
			if (battler == null) return;
			maxKillCount = battler.maxKillCount;
			killCount = battler.killCount;
			winCount = battler.winCount;
			loseCount = battler.loseCount;
			silver = battler.silver;
			darksteel = battler.darksteel;
		}

		// ================
		// 设置值
		// ================
		public function set maxKillCount(value : int) : void
		{
			maxKillCountTF.htmlText = TEXT_MAX_KILL_COUNT.replace(/__NUM__/, value);
		}

		public function set killCount(value : int) : void
		{
			killCountTF.htmlText = TEXT_KILL_COUNT.replace(/__NUM__/, value);
		}

		public function set winCount(value : int) : void
		{
			winTF.htmlText = TEXT_WIN_COUNT.replace(/__NUM__/, value);
		}

		public function set loseCount(value : int) : void
		{
			loseTF.htmlText = TEXT_LOSE_COUNT.replace(/__NUM__/, value);
		}

		public function set silver(value : int) : void
		{
			silverTF.htmlText = TEXT_SILVER_COUNT.replace(/__NUM__/, value);
		}

		public function set darksteel(value : int) : void
		{
			darksteelTF.htmlText = TEXT_DARKSTEEL_COUNT.replace(/__NUM__/, value);
		}
	}
}
