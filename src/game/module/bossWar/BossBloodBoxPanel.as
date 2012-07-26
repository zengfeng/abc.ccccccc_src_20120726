package game.module.bossWar {
	import framerate.SecondsTimer;

	import game.manager.RSSManager;
	import game.module.battle.view.BattleNumber;
	import game.module.bossWar.bossHead.BossHeadItem;
	import game.module.quest.VoNpc;

	import gameui.containers.GPanel;
	import gameui.controls.GLabel;
	import gameui.controls.GProgressBar;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.data.GProgressBarData;
	import gameui.data.GToolTipData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.greensock.TweenLite;
	import com.greensock.layout.AlignMode;
	import com.utils.TimeUtil;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Lv
	 */
	public class BossBloodBoxPanel extends GPanel {
		private var bossName : GLabel;
		private var bossLeve : GLabel;
		private var bossBloodNow : TextField;
		private var bossBloodPro : GProgressBar;
		private var bossBloodTotalNum : Number = 999999999999;
		private var bossHeadImg : BossHeadItem;
		private var ChallengeLastTimer : GLabel;

		public function BossBloodBoxPanel() {
			_data = new GPanelData();
			initData();
			super(_data);
			initView();
			initEvent();
		}

		private function initData() : void {
			_data.width = 665;
			_data.height = 80;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
			// 取消背景
		}

		private function initEvent() : void {
		}

		private function initView() : void {
			addBG();
			addPanel();
		}

		private function addPanel() : void {
			var level : int = 1;
			bossBloodTotalNum = 10000000000000;
			var data : GLabelData = new GLabelData();
			data.textFormat.size = 18;
			data.textFormat.bold = true;
			data.textColor = 0xFFFFFF;
			// data.text = RSSManager.getInstance().getStructById(id).name;
			data.width = 150;
			data.x = 80;
			data.y = 5;
			data.textColor = 0xFF7E00;
			bossName = new GLabel(data);
			_content.addChild(bossName);
			data.clone();
			data.textFormat.size = 14;
			data.textFormat.bold = false;
			data.x = bossName.x + bossName.width + 5;
			data.y = 9;
			data.text = level + "转";
			bossLeve = new GLabel(data);
			_content.addChild(bossLeve);

			var datapro : GProgressBarData = new GProgressBarData();
			datapro.trackAsset = new AssetData("BossBloodPro_bg");
			datapro.barAsset = new AssetData("BossBloodPro_HP");
			datapro.toolTipData = new GToolTipData();
			datapro.height = 19.85;
			datapro.width = 463.1;
			datapro.x = 65;
			datapro.y = 33.3;
			datapro.paddingX = 2;
			datapro.paddingY = 1;
			datapro.padding = 17;
			bossBloodPro = new GProgressBar(datapro);
			_content.addChild(bossBloodPro);
			bossBloodPro.value = 100 / 100 * 100;

			bossBloodNow = new TextField();
			bossBloodNow.width = 150;
			bossBloodNow.x = 225 - 40;
			bossBloodNow.y = 32;
			bossBloodNow.text = "剩余血量：" + String(10);
			bossBloodNow.setTextFormat(new TextFormat("13", null, 0xffffff, 1, null, null, null, null, AlignMode.CENTER));
			_content.addChild(bossBloodNow);

			data.clone();
			data.text = "剩余时间  00:00:00";
			data.x = 235 - 40;
			data.y = 53;
			data.textColor = 0xFFFFFF;
			data.textFormat.size = 12;
			ChallengeLastTimer = new GLabel(data);
			_content.addChild(ChallengeLastTimer);
		}

		private function addBG() : void {
			var bg : Sprite = UIManager.getUI(new AssetData("RecruitPullItemPanel"));
			bg.width = 533;
			bg.height = 80;
			_content.addChild(bg);

			bossHeadImg = new BossHeadItem();
			bossHeadImg.x = bossHeadImg.width / 2 - 23;
			bossHeadImg.y = bossHeadImg.height / 2 - 10;
			addChild(bossHeadImg);
		}

		/**
		 * 《更新Boss血量》
		 * upBlood:需要跳的血量
		 * harm:boss当前血量
		 * total：boss总血量
		 * img:跳血资源（Vector）
		 */
		public function refreshBossBlood(upBlood : uint, harm : uint, total : uint, img : Vector.<Bitmap>) : void {
			bossBloodTotalNum = total;
			if (bossBloodTotalNum == 0) return;
			bossBloodNow.text = "剩余血量：" + String(harm);
			bossBloodNow.setTextFormat(new TextFormat("12", null, 0xffffff, 1, null, null, null, null, AlignMode.CENTER));
			bossBloodPro.value = int(harm) / bossBloodTotalNum * 100;

			var harmNow : int = upBlood;
			if (harmNow == 0) return;
			if (img == null) return;
			var bx : int = 0;
			var by : int = 0;
			var numBitmap : BattleNumber = new BattleNumber();
			numBitmap.initNumbers(img, Math.abs(harmNow), 0, 4);
			numBitmap.toNumber();
			numBitmap.visible = true;
			numBitmap.scaleX = 0.5;
			numBitmap.scaleY = 0.5;
			numBitmap.alpha = 0.3;
			_content.addChild(numBitmap);
			numBitmap.x = 435;
			numBitmap.y = 40;

			bx = numBitmap.x;
			by = numBitmap.y;
			TweenLite.to(numBitmap, 1, {delay:0, scaleX:1, scaleY:1, y:by - 38, alpha:1, overwrite:0});
			TweenLite.to(numBitmap, 0.5, {delay:0.5, scaleX:1.1, scaleY:1.1, alpha:0, y:by - 45, onComplete:ShowHarmComplete_func, onCompleteParams:[numBitmap], overwrite:0});
		}

		private function ShowHarmComplete_func(tf : BattleNumber) : void {
			_content.removeChild(tf);
		}

		/**
		 * 《获取boss名称》
		 * id:bossID
		 * level:boss等级
		 */
		public function getBossName(id : int, level : int) : void {
			// var id:int = ProxyBossWar.bossID;
			bossLeve.visible = true;
			if (id == 0) return;
			if (level == 0) {
				bossLeve.visible = false;
			} else {
				bossLeve.text = level + "转";
			}
			var voNpv : VoNpc = RSSManager.getInstance().getNpcById(id);
			bossName.text = voNpv.name;
			bossLeve.x = bossName.x + bossName.width + 5;
			bossHeadImg.refreshBossIMG(id);
		}

		// ========================================================================
		//
		// 挑战BOSS的剩余时间控制
		//
		// ========================================================================
		private var timer : int = 180;

		/**
		 * 设置挑战BOSS的剩余时间  ---秒
		 */
		public function setChallageLastTimer(s : int) : void {
			timer = s;
			SecondsTimer.addFunction(refershTimer);
			// 倒计时控制
		}

		private function refershTimer() : void {
			ChallengeLastTimer.text = "剩余时间  " + TimeUtil.secondsToTime(timer);
			// 获取显示时间 格式：00:00:00
			if (timer == 0) {
				SecondsTimer.removeFunction(refershTimer);
				return;
			}
			timer--;
		}
	}
}
