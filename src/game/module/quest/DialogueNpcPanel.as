package game.module.quest {
	import com.utils.StringUtils;
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import game.core.menu.MenuManager;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.manager.ViewManager;
	import game.module.mapFishing.FishingManager;
	import game.module.wordDonate.DonateControl;
	import gameui.controls.GImage;
	import gameui.controls.GTextArea;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.data.GTextAreaData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;
	import gameui.skin.SkinStyle;
	import log4a.Logger;
	import net.AssetData;
	import net.RESManager;






	/**
	 * @author yang
	 */
	public class DialogueNpcPanel extends GComponent {
		private var _dialogBottom : GTextArea;
		private var _nameLable : TextField;
		private var _dialogTimer : Timer;
		private var _bgAsset : Sprite;
		private var _bg : Sprite;
		private var _trigon : MovieClip;

		private function initData() : void {
			_base = new GComponentData();
			_base.width = 500;
			_base.height = 100;
		}

		private var _mask : Bitmap;

		private function initViews() : void {
			_bgAsset = UIManager.getUI(new AssetData("NpcDialoguePanel", "quest"));
			_bgAsset.width = 500;
			_bgAsset.height = 100;
			_bg = new Sprite();
			_bg.x = 104;
			_bg.y = 32;
			_bg.alpha = 0;
			addChild(_bgAsset);
			_mask = new Bitmap(RESManager.getBitmapData(new AssetData("mask", "quest")));
			_mask.y = -50;
			_mask.x = 5;
			// addChild(_mask);
			var data : GImageData = new GImageData();
			data.iocData.align = new GAlign(0);
			_halfImg = new GImage(data);
			// _halfImg.mask=_mask;
			addChild(_halfImg);
			addTextArea();
			_trigon = RESManager.getMC(new AssetData("quest_trigon", "quest"));

			if (_trigon) {
				_trigon.x = this.width - 50;
				_trigon.y = this.height;
				addChild(_trigon);
			}
		}

		private function onComplete(event : Event) : void {
			_halfImg.y = 95 - _halfImg.height;
			_halfImg.x = 5;
		}

		private function initEvents() : void {
			addEventListener(MouseEvent.CLICK, clickHandler);
			_halfImg.addEventListener(Event.COMPLETE, onComplete);
		}

		private function clearEvent() : void {
			removeEventListener(MouseEvent.CLICK, clickHandler);
		}

		private var itemVecto : Vector.<DialogueItem> = new Vector.<DialogueItem>();

		private function addItem(arg : Array) : void {
			var max : int = arg.length;

			var data : GComponentData = new GComponentData();
			for (var i : int = 0;i < max;i++) {
				data.align = new GAlign(130, -1, (100 - max * 20) / 2 + i * 20 + 10);
				var item : DialogueItem = new DialogueItem(data.clone());
				item.setText(arg[i]);
				itemVecto.push(item);
				addChild(item);
				GLayout.layout(item);
			}
		}

		private function removeItems() : void {
			for each (var item:DialogueItem in itemVecto) {
				item.hide();
			}
			itemVecto = new Vector.<DialogueItem>();
		}

		private function addTextArea() : void {
			var data : GTextAreaData = new GTextAreaData();
			data.width = 394;
			data.height = 80;
			data.hideBackgroundAsset = false;
			data.selectable = true;
			data.editable = false;
			data.textFormat = UIManager.getTextFormat(12);
			data.padding = 10;
			data.selectable = false;
			data.align = new GAlign(105, -1, 24);
			data.backgroundAsset = new AssetData(SkinStyle.emptySkin);
			_dialogBottom = new GTextArea(data);
			_dialogBottom.textField.autoSize = TextFieldAutoSize.CENTER;
			_dialogBottom.textField.textColor = 0x000000;
			_dialogBottom.hideEdge();
			addChild(_dialogBottom);
			GLayout.layout(_dialogBottom);
			_nameLable = new TextField();
			_nameLable.x = 120;
			_nameLable.y = 5;
			_nameLable.height = 30;
			_nameLable.width = 500;
			_nameLable.wordWrap = true;
			_nameLable.selectable = false;
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.size = 18;
			textFormat.leading = 2;
			textFormat.color = 0x562503;
			_nameLable.defaultTextFormat = textFormat;
			addChild(_nameLable);
		}

		private var strArray : Array = [];
		private var num : int = 0;

		private function addWords(str : String) : void {
			strArray = [];
			num = 0;
			for (var i : int = 0;i < str.length;i++) {
				strArray.push(str.charAt(i));
			}
			if (strArray.length < 1) return;
			_dialogBottom.text = "";
			resetTimer();
		}

		private function resetTimer() : void {
			if (!_dialogTimer) {
				_dialogTimer = new Timer(30);
				_dialogTimer.addEventListener(TimerEvent.TIMER, enterFrame);
				_dialogTimer.start();
			} else {
				_dialogTimer.addEventListener(TimerEvent.TIMER, enterFrame);
				_dialogTimer.stop();
				_dialogTimer.start();
			}
		}

		private var _currentDialog : VoDialogue;

		private function clickHandler(event : MouseEvent) : void {
			if (!_quest) return ;
			if (_quest.isCompleted) {
				sendTaskOperateReq(_quest.id, 2);
				return;
			}
			if (_dialogTimer && _dialogTimer.running) {
				_dialogTimer.stop();
				_dialogBottom.htmlText = _currentDialog.getDialogue();
				fillMatrix();
				return;
			}
			_currentDialog = _quest.getNextDialogue();
			if (_currentDialog == null) {
				if (_quest.base.type == 3)
					sendTaskOperateReq(_quest.id, 0, _flag);
				else sendTaskOperateReq(_quest.id, 1, _flag);
				return;
			}
			_nameLable.text = _currentDialog.id == -1 ? UserData.instance.playerName : _npc.name;
			_halfImg.url = _currentDialog.id == -1 ? UserData.instance.myHero.halfIocUrl : _npc.helfIocUrl;
			onComplete(new Event(""));
			addWords(_currentDialog.getDialogue());
			fillMatrix();
		}

		private var _h : int = 0;

		private function fillMatrix() : void {
			if (_h == _dialogBottom.textField.numLines * 20 + 5) return;
			_h = _dialogBottom.textField.numLines * 20 + 5;
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(360, _h);
			_bg.graphics.clear();
			_bg.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000, 0x000000, 0x000000], [0, 1, 0.5, 0], [0, 20, 160, 255], matrix);
			_bg.graphics.drawRect(0, 0, 388, _h);
			_bg.graphics.endFill();
		}

		private function linkHandler(event : Event) : void {
			this.removeEventListener(DialogueItem.CLICKITEM, linkHandler);
			var voLink : VoNpcLink = QuestManager.getInstance().voNpcLinkDic[(DialogueItem(event.target).getId())];
			if (!voLink) {
				hideMy();
				Logger.error("id=" + DialogueItem(event.target).getId() + " 的voLink没找到!");
				return;
			}
			switch(voLink.type) {
				case 1:
					MenuManager.getInstance().openMenuView(int(voLink.link));
					break;
				case 2:
					StateManager.instance.startEvent(int(voLink.link));
					break;
				case 3:
					break;
				case 5:
					if (voLink.id == 15 || voLink.id == 16)
					{
						FishingManager.instance.enterFishing(voLink.id);
						break;
					}
					else if (voLink.id == 20)
						DonateControl.instance.setupDonateUI();
					else if (voLink.id == 21)
						DonateControl.instance.setupListUI();
					QuestUtil.sendCSNpcReAction(voLink.id);
					break;
			}
			removeItems();
			hideMy();
		}

		private function enterFrame(event : TimerEvent) : void {
			if (num < strArray.length) {
				_dialogBottom.appendHtmlText(strArray[num] == "^" ? StringUtils.addColor(UserData.instance.playerName, "#ff0000") : strArray[num]);
				fillMatrix();
			} else {
				_dialogTimer.stop();
				_dialogTimer.removeEventListener(TimerEvent.TIMER, enterFrame);
				_h = 0;
			}
			num++;
		}

		// op 操作类型 1:接收  2:提交  3:更新任务步骤;
		private function sendTaskOperateReq(questId : int, op : int, flag : int = 0) : void {
			if (flag > 0)
				QuestUtil.sendQuestComplete(questId, flag);
			else
				QuestUtil.sendTaskOperateReq(questId, op);
			removeItems();
			_bg.alpha = 0;
			_bg.graphics.clear();
			_flag = 0;
			hideMy();
		}

		public function DialogueNpcPanel() {
			_base = new GComponentData();
			_base.parent = ViewManager.dialogueSprite;
			initData();
			super(_base);
			initViews();
			initEvents();
		}

		private var _quest : VoQuest;
		private var _npc : VoBase;
		private var _halfImg : GImage;
		private  var modalSkin : Sprite = ASSkin.emptySkin;
		private var _flag : int = 1;

		public function setData(npc : VoBase, vo : VoQuest, defaultString : String = "", flag : int = 0) : void {
			_npc = npc;
			_halfImg.url = _npc.helfIocUrl;
			_quest = vo;
			_flag = flag;
			onComplete(new Event(""));
			if (defaultString != "") {
				removeEventListener(MouseEvent.CLICK, clickHandler);
				_dialogBottom.htmlText = "";
				removeItems();
				addEventListener(DialogueItem.CLICKITEM, linkHandler);
				addItem(defaultString.split("|"));
				_nameLable.text = _npc.name;
				_halfImg.url = _npc.helfIocUrl;
				onComplete(new Event(""));
				if (_trigon) _trigon.visible = false;
				return;
			}
			clickHandler(new MouseEvent(""));
			addQuestMode().addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
			if (_trigon) _trigon.visible = true;
		}

		private  function hideMy() : void {
			ViewManager.dialogueSprite.hideMySelf();
			removeItems();
			_bg.alpha = 0;
			_bg.graphics.clear();
			clearEvent();
			removeQuestMode().removeEventListener(MouseEvent.CLICK, clickHandler);
			super.hide();
			if (_trigon)
				_trigon.stop();
		}

		public function addQuestMode() : Sprite {
			if (!modalSkin)
				modalSkin = ASSkin.emptySkin;
			modalSkin.width = UIManager.stage.stageWidth;
			modalSkin.height = UIManager.stage.stageHeight;
			if (!ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).contains(modalSkin))
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).addChildAt(modalSkin, 0);
			return modalSkin;
		}

		public  function removeQuestMode() : Sprite {
			if (modalSkin && modalSkin.parent) {
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).removeChild(modalSkin);
			}
			return modalSkin;
		}

		override public function hide() : void {
			Logger.debug("dialogueNpcPanel hide");
			hideMy();
			QuestUtil.checkQuide();
		}

		override public function show() : void {
			_bg.alpha = 0;
			initEvents();
			super.show();
		}

		override protected function onShow() : void {
			super.onShow();
			if (_trigon)
				_trigon.gotoAndPlay(0);
		}
		
		override protected function onHide():void
		{
			super.onHide();
		}
	}
}
