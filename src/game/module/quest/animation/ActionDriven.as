package game.module.quest.animation {
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarThumb;
	import game.core.avatar.PerformerAvatar;
	import game.core.user.StateManager;
	import game.core.user.StateType;
	import game.manager.MouseManager;
	import game.manager.PreLoadManager;
	import game.manager.RSSManager;
	import game.manager.ViewManager;
	import game.module.battle.view.BTSystem;
	import game.net.core.Common;
	import game.net.data.CtoS.CSPlotEnd;

	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.data.GButtonData;
	import gameui.data.GLabelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;

	import log4a.Logger;

	import net.ALoader;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import worlds.apis.MLoading;
	import worlds.apis.MTo;

	import com.greensock.TweenLite;
	import com.utils.FilterUtils;

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	/**
	 * @author yangyiqiang
	 */
	public class ActionDriven {
		<!-- 
			所有标点请用英文半角
			id  对应的任务编号
			name 任务名
			mapid 地图编号
			mapx  中心点X,Y
			player 玩家列表  1,100,100|  用|区分player     用,区分坐标   
			npc    npc列表
			
			action
			target   动作的执行者  数值与上面player或npc对应 0,代表玩家avatar
			direction  1:左边 2：右边
			type       动作分类  1:对话，2:人物原地出现 3：模型转身 4: 模型攻击 5：死亡消失 6:冒金光特效 7：文字或物品从avatar上浮现 
			                     8:星宿归位，任务人物消失化为金光升空的动画 9：从天而降 10：模型释放技能特效 11：后退 12：屏幕抖动
								 14：引入过场动画  15: 模型无痕迹消失 16: 烟雾逃遁 17：星宿归位 18:黑屏之后文字 describe 为要显示的内容  19:模型闪避
								 20：模型无痕迹出现  21：被攻击受创 22：打坐姿势出现 23：白色雾气环绕 24：融入体内  25：压黑底显示文字（有确定）
								 26: 走路  27：切换动作  28:模型skill攻击  29：骑坐骑移动  31:被攻击后闪避（describe里填写相对便宜位置，填的是距离X,Y的正负值） 
								 32:不断缩小至消失   34:NPC发光  36：从消失不断放大  37：模型使用第二套动作
								 35: 2个模型绑定 describe里，若target在上层，则填0,ID 若target在下层，则填1,ID describe里填 0，33【NPCid】，x，y【X,Y为相对坐标】
								
			describe 动作描述
			1:对话，对话内容
			2:移动, 目标点坐标
			3:转身,	当前面向的坐标
			completeType  动作完成类型
			0: 点击完成   其它表示延时
				
				
				
			1:对话
			10:人物原地出现 21：模型转身 22：玩家切换动作  23: 人物移动 
			20: 普通攻击  31:技能攻击  
			30：死亡消失  41:烟雾逃遁
			40: 人物冒光（身上加程序效果） 51:屏幕抖动  52:黑屏之后文字  53: 压黑底显示文字（有确定） 54: 2个模型绑定 describe里，若target在上层，则填0,ID 若target在下层，则填1,ID describe里填 0，33【NPCid】，x，y【X,Y为相对坐标】
			50: NPC切换第2种动作  61: (NPC)被攻击受创  62:被攻击后闪避（describe里填写相对便宜位置，填的是距离X,Y的正负值） 
		 */
		-->;
		public static const DIALOGUE : int = 1;
		public static const MOVE : int = 2;
		public static const AVATAR_TUN : int = 3;
		public static const AVATAR_ATTACK : int = 4;
		public static const AVATAR_DIE : int = 5;
		public static const SCREEN_WIDTH : int = 1280;
		public static const SCREEN_HEIGHT : int = 700;
		private static var _instance : ActionDriven;

		public function ActionDriven() {
			if (_instance) {
				throw Error("单类，不能多次初始化!");
			}
		}

		private var _currentAction : Animation;

		public function getNextAction() : Action {
			return _currentAction.getNextAction();
		}

		public static function instance() : ActionDriven {
			if (_instance == null) {
				_instance = new ActionDriven();
			}
			return _instance;
		}

		private var _dic : Dictionary = new Dictionary(true);

		/** 初始化xml */
		public function initXml(xml : XML) : void {
			if (!xml)
				return;
			var anim : Animation;
			for each (var item:XML in xml.children()) {
				anim = new Animation();
				anim.parse(item);
				_dic[anim.id] = anim;
			}
			RSSManager.getInstance().deleteData("questAnimation");
		}

		private var _panel : DialoguePanel;

		public function playAnimation(id : int) : Animation {
			_currentAction = _dic[id];
			if (_currentAction) {
				StateManager.instance.changeState(StateType.ANIMATION, true, startAnimation, null, waitFor, [id]);
			} else {
				Logger.error("找不到 id= " + id + " 的剧情动画");
			}
			return _currentAction;
		}

		public function getAnimationAssets(id : int) : Array {
			return _dic[id] ? (_dic[id] as Animation).getAssets() : [];
		}

		public function getHalfbodyAssets(id : int) : Array {
			return _dic[id] ? (_dic[id] as Animation).getHalfbody() : [];
		}

		private var _isEnd : Boolean = true;

		private function startAnimation() : void {
			_isEnd = false;
			if (!_currentAction.isLoaded() && _currentAction.getAssets().length > 0) {
				var libData : LibData;

				for each (var item:* in _currentAction.getAssets()) {
					if (item is ALoader) {
						RESManager.instance.add(item);
					} else {
						if (item is LibData)
							libData = item;
						else if (item is String)
							libData = new LibData(item);
						else
							continue;
						if (libData.cls)
							RESManager.instance.add(new libData.cls(libData));
						else
							RESManager.instance.add(new SWFLoader(libData));
					}
				}
				PreLoadManager.instance.moduleLoader.model = RESManager.instance.model;
				
				RESManager.instance.addEventListener(Event.COMPLETE, loadComplete);
				PreLoadManager.instance.moduleLoader.startShow("加载剧情动画资源中...");
				MLoading.pause();
				RESManager.instance.startLoad();
			} else {
				initAnimation();
			}
			MouseManager.cursor = MouseCursor.ARROW;
		}

		private function waitFor(id : int) : void {
			BTSystem.INSTANCE().addClickEndCall({fun:playAnimation, arg:[id]});
		}

		private function loadComplete(event : Event) : void {
			RESManager.instance.removeEventListener(Event.COMPLETE, loadComplete);
			initAnimation();
			PreLoadManager.instance.moduleLoader.hide();
			MLoading.go();
		}

		public function endAnimation() : void {
			_isEnd = true;
			removeMode();
			UIManager.stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
			ViewManager.instance.getContainer(ViewManager.MAP_CONTAINER).mask = null;
			ViewManager.removeStageResizeCallFun(onResize);
			LandLayerManager.instance.exitAnimation();
			_panel.hide();
			ViewManager.instance.uiContainer.visible = true;
			ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).visible = true;
			ViewManager.instance.getContainer(ViewManager.IOC_CONTAINER).visible = true;
			TweenLite.to(ViewManager.instance.uiContainer, 2, {alpha:1});
			TweenLite.to(ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER), 2, {alpha:1});
			PreLoadManager.instance.moduleLoader.visible=true;
			var cmd : CSPlotEnd = new CSPlotEnd();
			cmd.plotId = _currentAction.id;
			Common.game_server.sendMessage(0x39, cmd);
			StateManager.instance.changeState(StateType.ANIMATION, false);
			if (_backSkin && _backSkin.parent) _backSkin.parent.removeChild(_backSkin);
			setTimeout(runEndClickCall, 100);
			MouseManager.cursor = MouseCursor.ARROW;
		}

		private var _clickEndCallList : Vector.<Object>=new Vector.<Object>();

		/*
		 * ActionDriver.instance.addClickEndCall({fun:QuestUtil.questAction, arg:[temp.id]});
		 */
		public function addClickEndCall(obj : Object) : void {
			if (obj == null || !obj["fun"])
				return;
			var index : int = _clickEndCallList.indexOf(obj);
			if (index == -1)
				_clickEndCallList.push(obj);
		}

		public function removeClickEndCall(obj : Object) : void {
			var index : int = _clickEndCallList.indexOf(obj);
			if (index != -1)
				_clickEndCallList.splice(index, 1);
		}

		private function runEndClickCall() : void {
			if (_clickEndCallList.length <= 0)
				return;
			for (var i : int = 0; i < _clickEndCallList.length; i++) {
				var fun : Object = _clickEndCallList[i];
				if (!fun["fun"])
					continue;
				(fun["fun"] as Function).apply(null, fun["arg"]);
			}
			_clickEndCallList = new Vector.<Object>();
		}

		public function initAnimation() : void {
			addMode();
			_currentAction.reset();
			TweenLite.to(ViewManager.instance.uiContainer, 0.5, {alpha:0, onComplete:visible});
			TweenLite.to(ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER), 0.5, {alpha:0, onComplete:visible});
			ViewManager.instance.getContainer(ViewManager.IOC_CONTAINER).visible = false;
			UIManager.stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			PreLoadManager.instance.moduleLoader.visible=false;
			if (!_panel)
				_panel = new DialoguePanel();
			ViewManager.addStageResizeCallFun(onResize);
			initMapElement();
			addBackSkin();
			setTimeout(executeAction, 1000);
		}

		private function visible() : void {
			ViewManager.instance.uiContainer.visible = false;
			ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).visible = false;
		}

		public function get isInQuestAction() : Boolean {
			return !_isEnd;
		}

		private function onResize(... args) : void {
			GLayout.layout(_panel, new GAlign(-1, -1, -1, 0, 0));
			LandLayerManager.instance.setPosition();
			addBackSkin();
			if (_modalSkin) {
				_modalSkin.width = UIManager.stage.stageWidth;
				_modalSkin.height = UIManager.stage.stageHeight;
			}
		}

		public static const GET : int = 7;

		private function onMouseClick(event : MouseEvent) : void {
			if (!_action)
				return;
			if (_action.type == 1) {
				if (_panel.showAll()) {
					executeAction();
					return;
				}
			} else if (_action.type == GET) // 点击获得
			{
				removeSkin();
				executeAction();
			}
		}

		private var _skin : Sprite;
		private var _action : Action;
		/**
		 * 1:对话
		2:人物状态切换
		3:战斗
		4:人物冒光（身上加程序效果）
		5:屏幕抖动
		6:黑屏之后文字
		7:压黑底显示文字（有确定）
		8:2个模型绑定 describe里，若target在上层，则填0,ID 若target在下层，则填1,ID describe里填 0，33【NPCid】，x，y【X,Y为相对坐标】
		9:烟雾逃遁
		10:移动
		 */
		private var avatar : PerformerAvatar;
		private var _temp : Array;

		private function executeAction() : void {
			if (_isEnd)
				return;
			_action = getNextAction();
			if (!_action) {
				endAnimation();
				return;
			}
			_panel.hide();
			switch (_action.type) {
				case 1:
					_panel.data = _action;
					break;
				case 2:
					avatar = LandLayerManager.instance.getPerformer(_action.target);
					if (avatar)
						avatar.setAvatarState(int(_action.describe));
					break;
				case 3:
					var arr : Array = _action.describe.split(",");
					if (arr.length < 4) break;
					var atAvatar : PerformerAvatar = LandLayerManager.instance.getPerformer(_action.target);
					var tgAvatar : PerformerAvatar = LandLayerManager.instance.getPerformer(arr[2]);
					if (arr.length > 4)
						fight(atAvatar, arr[0], arr[1], tgAvatar, arr[3], arr[4], arr[5]);
					else fight(atAvatar, arr[0], arr[1], tgAvatar, arr[3]);
					break;
				case 4:
					avatar = LandLayerManager.instance.getPerformer(_action.target);
					var defaultGlowFilter : GlowFilter = FilterUtils.defaultGlowFilter;
					avatar.filters = [defaultGlowFilter];
					avatar.alpha = 1;
					TweenLite.to(defaultGlowFilter, 1, {alpha:1, blurX:20, blurY:20, overwrite:0});
					break;
				case 5:
					LandLayerManager.instance.shake();
					break;
				case 6:
					addSkin(_action.describe);
					break;
				case 7:
					addSkin(_action.describe, 0);
					break;
				case 8:
					// 0,npcid     1,npcid
					avatar = LandLayerManager.instance.getPerformer(_action.target);
					_temp = _action.describe.split(",");
					var avatar2 : PerformerAvatar = LandLayerManager.instance.getPerformer(_temp[1]);
					avatar2.x = _temp[3];
					avatar2.y = _temp[4];
					if (_temp[0] == 0)
						avatar.addChildAt(avatar2, 0);
					else {
						avatar.addChild(avatar2);
					}
					break;
				case 9:
					break;
				case 10:
					_temp = _action.describe.split(",");
					LandLayerManager.instance.goto(_action.target, _temp[0], _temp[1], _action.completeType);
					break;
				case 11:
					LandLayerManager.instance.getPerformer(0).addSeat(25);
					break;
				case 33:
					_temp = _action.describe.split("|");
					arr = String(_temp[1]).split(",");
					addSkin("", 3);
					endAnimation();
					MTo.toMap(1, arr[0], arr[1], _temp[0], null, null,true);
					break;
			}
			if (_action.completeType > 0)
				setTimeout(executeAction, _action.completeType * 1000);
		}

		private function fight(atAvatar : PerformerAvatar, x : Number, y : Number, tgAvatar : PerformerAvatar, type : int, ix : Number = -30, iy : Number = -30) : void {
			var hurtTimer : int = tgAvatar.avatarBd.fightData ? tgAvatar.avatarBd.fightData.atkTimeSkillatk : 1;
			TweenLite.to(atAvatar, 0.3, {x:x, y:y, onComplete:fightStepA, onCompleteParams:[atAvatar, atAvatar.x, atAvatar.y, AvatarManager.MAGIC_ATTACK], overwrite:0});
			switch(type) {
				case 1:
					BTSystem.INSTANCE().initAssets();
					setTimeout(showEfft, hurtTimer * 1000 + 300, tgAvatar, ix, iy);
					break;
				case 2:
					setTimeout(tgAvatar.hurt, hurtTimer * 1000 + 300);
					break;
				case 3:
					setTimeout(tgAvatar.die, hurtTimer * 1000 + 300);
					break;
			}
		}

		private var _tempArray : Array;

		private function fightStepA(avatar : AvatarThumb, oldX : int, oldY : int, type : int) : void {
			_tempArray = [avatar, oldX, oldY];
			avatar.setAction(type, 1);
			avatar.player.addEventListener(Event.COMPLETE, fightStepB);
		}

		private function fightStepB(event : Event) : void {
			var avatar : AvatarThumb = event.target["parent"] as AvatarThumb;
			if (!avatar)
				return;
			avatar.player.removeEventListener(Event.COMPLETE, fightStepB);
			TweenLite.to(_tempArray[0], 0.3, {x:int(_tempArray[1]), y:int(_tempArray[2]), overwrite:0});
		}

		private function showEfft(tgAvatar : PerformerAvatar, ix : Number, iy : Number) : void {
			tgAvatar.showEfft();
			TweenLite.to(tgAvatar, 0.2, {x:tgAvatar.x + Number(ix), y:tgAvatar.y + Number(iy), overwrite:0});
			TweenLite.to(tgAvatar, 0.2, {delay:0.2, x:tgAvatar.x, y:tgAvatar.y, overwrite:0});
		}

		private var _backSkin : Sprite;

		private function addBackSkin() : void {
			if (!_backSkin)
				_backSkin = new Sprite();
			_backSkin.graphics.clear();
			var fillType : String = GradientType.LINEAR;

			var colors : Array = [0xffff88, 0xffff00];
			var alphas : Array = [1, 1];
			var ratios : Array = [0x00, 0xff];
			var matr : Matrix = new Matrix();
			matr.createGradientBox(20, 20, 0, 0, 0);
			_backSkin.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr);
			_backSkin.graphics.drawRect(0, 0, UIManager.stage.stageWidth, 1);
			with (_backSkin.graphics) {
				beginFill(0x000000, 0.8);
				drawRect(0, 1, UIManager.stage.stageWidth, 140);
				endFill();
			}
			_backSkin.y = UIManager.stage.stageHeight - _backSkin.height;
			if (!UIManager.root.contains(_backSkin))
				UIManager.root.addChild(_backSkin);
		}

		private var _lable : GLabel;
		private var _button : GButton;

		private function addSkin(str : String, type : int = 1) : void {
			if (!_skin) {
				_skin = ASSkin.blackSkin;
				var data : GLabelData = new GLabelData();
				data.textFormat = UIManager.getTextFormat(20);
				data.width = 500;
				_lable = new GLabel(data);
			}
			_skin.x = 0;
			_skin.y = 0;
			_skin.mouseChildren = false;
			_skin.mouseEnabled = false;
			_skin.alpha = 0;
			_lable.htmlText = str;
			_skin.width = UIManager.stage.stageWidth;
			_skin.height = UIManager.stage.stageHeight;
			_lable.x = (_skin.width - _lable.width) / 2;
			_lable.y = (_skin.height - _lable.height) / 2;
			UIManager.root.addChild(_skin);
			UIManager.root.addChild(_lable);
			if (type == 0) {
				_skin.alpha = 1;
				_lable.alpha = 1;
				var gbutton : GButtonData = new GButtonData();
				_button = new GButton(gbutton);
				_button.text = "确定";
				_button.x = (_skin.width - _button.width) / 2;
				_button.y = (_skin.height - _button.height) / 2 + 30;
				UIManager.root.addChild(_button);
			} else if (type == 1) {
				TweenLite.to(_skin, 1, {alpha:1, overwrite:0});
				TweenLite.to(_lable, 1, {alpha:1, overwrite:0});
				TweenLite.to(_skin, 1, {delay:_action ? _action.completeType : 1, alpha:0, onComplete:removeSkin, overwrite:0});
				TweenLite.to(_lable, 1, {delay:_action ? _action.completeType : 1, alpha:0, overwrite:0});
			} else {
				_skin.alpha = 1;
				TweenLite.to(_skin, 1, {delay:1, alpha:0, onComplete:removeSkin, overwrite:0});
			}
		}

		private function removeSkin() : void {
			if (_lable && UIManager.root.contains(_lable))
				UIManager.root.removeChild(_lable);
			if (UIManager.root.contains(_skin))
				UIManager.root.removeChild(_skin);
			if (_button && UIManager.root.contains(_button))
				UIManager.root.removeChild(_button);
		}

		private var _modalSkin : Sprite = ASSkin.emptySkin;

		private function addMode() : Sprite {
			if (!_modalSkin)
				_modalSkin = ASSkin.emptySkin;
			_modalSkin.width = UIManager.stage.stageWidth;
			_modalSkin.height = UIManager.stage.stageHeight;
			if (!_modalSkin.parent)
				UIManager.root.addChild(_modalSkin);
			return _modalSkin;
		}

		private function removeMode() : Sprite {
			if (_modalSkin && _modalSkin.parent) {
				_modalSkin.parent.removeChild(_modalSkin);
			}
			return _modalSkin;
		}

		private function initMapElement() : void {
			LandLayerManager.instance.enterIntoAnimation(_currentAction.mapX, _currentAction.mapY, addPerformer);
			for each (var obj:Performer in _currentAction.performerDic) {
				var avatar : PerformerAvatar = new PerformerAvatar();
				avatar.setId(obj.id);
				avatar.x = obj.x;
				avatar.y = obj.y;
				LandLayerManager.instance.addPerformer(avatar);
				avatar.setAvatarState(obj.state);
				Logger.debug("avatar.id==>" + obj.id, "avatar.scaleX===>" + avatar.scaleX, "avatar.scaleY===>" + avatar.scaleY);
			}
		}

		private function addPerformer() : void {
		}
	}
}
