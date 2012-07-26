package game.module.artifact {
	import game.manager.VersionManager;
	import game.module.battle.view.BattleNumber;

	import gameui.controls.GImage;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.AssetData;
	import net.RESManager;

	import com.commUI.tooltip.ToolTipManager;
	import com.commUI.tooltip.WordWrapToolTip;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class ArtifactMainPanel extends GComponent {
		public function ArtifactMainPanel() {
			_base = new GComponentData();
			_base.width = 1680;
			_base.height = 1050;
			super(base);
		}

		private var _back : Bitmap;
		private var _currentVo : VoArtifact;
		private var _buttonDic : Dictionary = new Dictionary();
		private var _selectVo : VoArtifact;
		private var _countText : TextField;
		private var _critText : TextField;

		private function initButton() : void {
			for (var i : int = 1;i < 5;i++) {
				_buttonDic[i - 1] = RESManager.getObj(new AssetData("button" + i, "artifact"));
				_buttonDic[i - 1]["x"] = 730;
				_buttonDic[i - 1]["y"] = 662;
				(_buttonDic[i - 1] as DisplayObject).addEventListener(MouseEvent.CLICK, onClick);
				if (i == 3) ToolTipManager.instance.registerToolTip(_buttonDic[i - 1], WordWrapToolTip, "花费" + StringUtils.addColor("200", ColorUtils.HIGHLIGHT_DARK) + "元宝铸魂神器，暴击率" + StringUtils.addColor("75%", ColorUtils.HIGHLIGHT_DARK) + "，获得的经验比免费更多");
				if (i == 2) ToolTipManager.instance.registerToolTip(_buttonDic[i - 1], WordWrapToolTip, "免费铸魂神器，暴击率" + StringUtils.addColor("50%", ColorUtils.HIGHLIGHT_DARK));
			}
		}

		private function clearButton() : void {
			for (var i : int = 0;i < 4;i++) {
				if (!_buttonDic[i] || !(_buttonDic[i]  as DisplayObject).parent) continue;
				(_buttonDic[i]  as DisplayObject).parent.removeChild(_buttonDic[i]);
			}
		}

		private var _corona : MovieClip;
		private var _frame : int = 1;

		public function playerCorona(frame : int, init : Boolean = false) : void {
			initCorona();
			if (init) {
				_frame = frame <= 0 ? 1 : frame;
				_frame = _frame > 90 ? 90 : _frame;
				_corona.gotoAndStop(_frame);
				return;
			}
			_corona.stop();
			_corona.addFrameScript(_frame - 1, null);
			ArtifactManage.instance().isBusy = true;
			playSmallAction();
			_frame = frame <= 0 ? 1 : frame;
			_frame = _frame > 90 ? 90 : _frame;
			Logger.debug("_frame===>" + _frame, "frame===>" + frame);
			_corona.addFrameScript(_frame - 1, frameScript);
			_corona.play();
		}

		private var _smallAction : MovieClip;

		private function playSmallAction() : void {
			if (!_smallAction) {
				_smallAction = RESManager.getMC(new AssetData("smallAction", "artifact"));
				_smallAction.x = 830;
				_smallAction.y = 662;
				_smallAction.mouseChildren = false;
				_smallAction.mouseEnabled = false;
			}
			addChild(_smallAction);
			_smallAction.gotoAndPlay(1);
		}

		private function initCorona() : void {
			if (!_corona) {
				_corona = RESManager.getMC(new AssetData("corona", "artifact"));
				_corona.x = 142;
				_corona.y = 223;
				_corona.mouseChildren = false;
				_corona.mouseEnabled = false;
				ToolTipManager.instance.registerToolTip(_tipsMode, WordWrapToolTip, getExpTips);
			}
			addChildAt(_corona, 1);
		}

		private function getExpTips() : String {
			if (!_selectVo) return "";
			return _selectVo.getExpTips();
		}

		private function frameScript() : void {
			_corona.stop();
			ArtifactManage.instance().isBusy = false;
		}

		private var _crit : MovieClip;
		private var _critMore : MovieClip;

		public function playerCrit(num : int = 1) : void {
			if (num <= 1) {
				if (!_crit) {
					_crit = RESManager.getMC(new AssetData("crit", "artifact"));
					_crit.x = 142 + 658;
					_crit.y = 223 + 350;
				}
				_crit.gotoAndPlay(1);
				addChild(_crit);
			} else {
				if (!_critMore) {
					_critMore = RESManager.getMC(new AssetData("critMore", "artifact"));
					_critMore.x = 142 + 550;
					_critMore.y = 223 + 350;
				}
				_critMore.gotoAndStop(1);
				_critMore["setText"] = (String(num));
				_critMore.gotoAndPlay(1);
				addChild(_critMore);
			}
		}

		private var numBitmap : BattleNumber ;

		public function playExp(exp : int) : void {
			var expBit : Bitmap = new Bitmap(createExpBit(exp));
			expBit.x = 142 + 600;
			expBit.y = 223 + 350;
			addChild(expBit);
			TweenLite.to(expBit, 1.5, {y:273, onComplete:function(obj : Bitmap) : void {
				obj.bitmapData.dispose();
				obj.parent.removeChild(obj);
			}, onCompleteParams:[expBit], ease:Quint.easeOut, overwrite:0});
			TweenLite.to(expBit, 1, {alpha:0, delay:1, ease:Quint.easeOut, overwrite:0});
		}

		private var _levelUp : MovieClip;

		public function playLevelUp(nextExp : int) : void {
			if (!_levelUp) {
				_levelUp = RESManager.getMC(new AssetData("orderUpSuccess", "commonAction"));
			}
			_levelUp.x = 762;
			_levelUp.y = 400;
			_levelUp.gotoAndPlay(1);
			addChild(_levelUp);
			playExp(nextExp);
			playSmallAction();
			ArtifactManage.instance().isBusy = true;
			_corona.addFrameScript(_frame - 1, null);
			_corona.addEventListener("runEnd", runEnd);
			_corona.gotoAndPlay(_frame);
		}

		private function runEnd(event : Event) : void {
			_corona.removeEventListener("runEnd", runEnd);
			var frame : int = _currentVo.getPre();
			_corona.gotoAndStop(1);
			_frame = frame <= 0 ? 1 : frame;
			_frame = _frame > 90 ? 90 : _frame;
			_corona.addFrameScript(_frame - 1, frameScript);
			_corona.gotoAndPlay(1);
		}

		private function createExpBit(exp : int) : BitmapData {
			if (!numBitmap)
				numBitmap = new BattleNumber();
			numBitmap.initNumbers(ArtifactManage.instance().numVec, exp, 2);
			numBitmap.toNumber();
			var bitMapData : BitmapData = new BitmapData(numBitmap.width + 90, 52, true, 0);
			var expData : BitmapData = RESManager.getBitmapData(new AssetData("exp", "artifact"));
			bitMapData.copyPixels(numBitmap.bitmapData, new Rectangle(0, 0, numBitmap.width, numBitmap.height), new Point(94, 5));
			bitMapData.copyPixels(expData, new Rectangle(0, 0, expData.width, expData.height), new Point());
			return bitMapData;
		}

		private var _img : GImage;
		private var _tipsMode : Sprite;

		override protected function create() : void {
			_back = new Bitmap(RESManager.getBitmapData(new AssetData("back", "artifact")));
			addChild(_back);
			initButton();
			_countText = UICreateUtils.createTextField("", "", 224, 25, 728, 800, UIManager.getTextFormat(12, 0xffffff, TextFormatAlign.CENTER));
			addChild(_countText);
			_critText = UICreateUtils.createTextField("", "", 224, 25, 728, 780, UIManager.getTextFormat(12, 0xffffff, TextFormatAlign.CENTER));
			addChild(_critText);
			var data : GImageData = new GImageData();
			data.iocData.align = new GAlign(-1, -1, -1, 0);
			data.isBDPlay = false;
			data.ringAlign=new GAlign(100);
			data.showRing=true;
			data.force=true;
			_img = new GImage(data);
			_img.x = 725;
			_img.y = 560;
			addChild(_img);
			_tipsMode = new Sprite();
			_tipsMode.x = 690;
			_tipsMode.y = 560;
			with(_tipsMode.graphics) {
				beginFill(0xff00ff, 0);
				drawRect(0, 0, 300, 110);
				endFill();
			}
			addChild(_tipsMode);
		}

		public function refresh(vo : VoArtifact, flag : Boolean = true) : void {
			if (vo) {
				if (flag)
					_currentVo = vo;
				_selectVo = vo;
			}
			changButton();
		}

		public function get currentVo() : VoArtifact {
			return 	_currentVo;
		}

		private function onClick(event : MouseEvent) : void {
			if (_selectVo)
				_selectVo.execute();
		}

		/**
		 * 1: 免费铸魂（state==0） 2：元宝铸魂（state==0） 3：激活（state==0）  5：铸魂次数全用完（state==0）
		 * 0: 免费挑战（state==1） 4：挑战次数全用完（state==1）   
		 * 6：展示状态
		 */
		private function changButton() : void {
			clearButton();
			ToolTipManager.instance.destroyToolTip(_img);
			addChild(_countText);
			if (_critText && _critText.parent) _critText.parent.removeChild(_critText);
			if (_corona)
				addChildAt(_corona, 1);
			if (_tipsMode)
				addChild(_tipsMode);
			_img.visible=true;
			switch(_selectVo.type) {
				case 0:
//					_img.url = _selectVo.getUrl();
					_img.libData = VersionManager.instance.getLib(_selectVo.getUrl(),null);
					_img.mcText("setName", _selectVo.npcName);
					_countText.htmlText = "今日挑战剩余次数：" + (ArtifactManage.FREE_BATTLE - ArtifactManage.instance().battleCount);
					addChildAt(_buttonDic[0],1);
					if (_corona && _corona.parent) _corona.parent.removeChild(_corona);
					if (_tipsMode && _tipsMode.parent) _tipsMode.parent.removeChild(_tipsMode);
					return;
				case 4:
					_img.mcText("setName", _selectVo.npcName);
//					_img.url = _selectVo.getUrl();
					_img.libData = VersionManager.instance.getLib(_selectVo.getUrl(),null);
					_countText.htmlText = "今日挑战次数已用完";
					addChildAt(_buttonDic[0],1);
					if (_corona && _corona.parent) _corona.parent.removeChild(_corona);
					if (_tipsMode && _tipsMode.parent) _tipsMode.parent.removeChild(_tipsMode);
					return;
				case 1:
					_countText.htmlText = "今日免费铸魂次数：" + (ArtifactManage.FREE_CAST - ArtifactManage.instance().caseCount);
					addChildAt(_buttonDic[1],1);
					_critText.htmlText = ArtifactManage.instance().getCritNumString();
					addChild(_critText);
					break;
				case 2:
					_countText.htmlText = "今日购买铸魂次数：" + (ArtifactManage.instance().caseMax - ArtifactManage.instance().caseCount);
					addChildAt(_buttonDic[2],1);
					_critText.htmlText = ArtifactManage.instance().getCritNumString();
					addChild(_critText);
					break;
				case 3:
					_countText.htmlText = "";
					addChildAt(_buttonDic[3],1);
					initCorona();
					if (_corona.currentFrame < 100)
						_corona.gotoAndPlay(100);
					break;
				case 5:
					_countText.htmlText = "今日次数已用完";
					if (ArtifactManage.instance().caseCount > ArtifactManage.FREE_CAST)
						addChildAt(_buttonDic[2],1);
					else addChildAt(_buttonDic[1],1);
					_critText.htmlText = ArtifactManage.instance().getCritNumString();
					addChild(_critText);
					break;
				case 6:
					initCorona();
					_corona.gotoAndStop(110);
					if (_countText && _countText.parent) _countText.parent.removeChild(_countText);
					break;
				case 7:
					_img.visible=false;
					break;
				default :
					if (_countText && _countText.parent) _countText.parent.removeChild(_countText);
					if (_corona && _corona.parent) _corona.parent.removeChild(_corona);
					if (_tipsMode && _tipsMode.parent) _tipsMode.parent.removeChild(_tipsMode);
					break;
			}
//			_img.url = _selectVo.getUrl(false);
			_img.libData = VersionManager.instance.getLib(_selectVo.getUrl(false),null);
			var str : String = (_selectVo.level != 0 && _selectVo.level != 10) ? (" " + _selectVo.level + "级") : "";
			_img.mcText("setName", _selectVo.name + str);
			ToolTipManager.instance.registerToolTip(_img, WordWrapToolTip, _selectVo.getTips());
		}
	}
}
