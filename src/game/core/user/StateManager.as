package game.core.user {
	import framerate.SecondsTimer;

	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.manager.ViewManager;
	import game.module.practice.PracticeProxy;

	import log4a.Logger;

	import worlds.apis.MSelfPlayer;
	import worlds.apis.MWorld;

	import com.commUI.alert.Alert;

	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 * 状态管理器
	 */
	public class StateManager {
		// 通过将领等级 获取法宝阶数上线
		public static var sutraStepOnLineDic : Dictionary = new Dictionary();
		// 通过法宝阶数 获取将领分界等级
		public static var levelStepOnLineDic : Dictionary = new Dictionary();
		private  var sysMsgDic : Dictionary = new Dictionary(true);
		private static var _instance : StateManager;
		/*
		 *  人物状态 value < 0xffff
		 */
		private var _heroState : uint;
		/*
		 *  场景状态 value > 0xffff
		 */
		private var _stageState : uint;

		public function StateManager() : void {
			if (_instance) {
				throw Error("---StateManager--is--a--single--model---");
			}
			MSelfPlayer.sWalkStart.add(startMove);
			MSelfPlayer.sWalkEnd.add(endMove);
			MSelfPlayer.sTransport.add(transMove);
			MWorld.sInstallReady.add(transMove);
			checkState();
		}

		public static function get instance() : StateManager {
			if (_instance == null) {
				_instance = new StateManager();
			}
			return _instance;
		}

		private function startMove() : void {
			changeState(StateType.MOVE_STATE, true);
		}

		private function endMove() : void {
			changeState(StateType.MOVE_STATE, false);
		}

		private function transMove() : void {
			Logger.debug("transMove");
			ViewManager.otherPlayerPanel.hide();
			if (ViewManager.dialogueSprite.parent) ViewManager.dialogueSprite.hide();
		}

		private var _value : uint;
		private var _yesFun : Function;
		private var _yesFunArgs : Array;

		/*
		 *  人物状态 value < 0xffff
		 *  场景状态 value > 0xffff
		 */
		public function changeState(value : uint, open : Boolean = true, yesFun : Function = null, yesFunArgs : Array = null, noFun : Function = null, noFunArgs : Array = null) : void {
			_value = value;
			_yesFun = yesFun;
			_yesFunArgs = yesFunArgs;
			if (value > 0xffff) {
				switch(value) {
					case StateType.ANIMATION:
						if (_heroState == StateType.BATTLE) {
							if (noFun != null)
								noFun.apply(null, noFunArgs);
							return;
						}
						break;
				}
				_stageState = open ? value : 0;
			} else {
				switch(value) {
					case StateType.MOVE_STATE:
						if (open) {
							if (ViewManager.dialogueSprite.parent) ViewManager.dialogueSprite.hide();
							if (_stageState == StateType.PRACTICE) {
								PracticeProxy.getInstance().sendCmd(0);
							}
							if (_heroState == StateType.PRACTICE_STATE) {
								PracticeProxy.getInstance().sendCmd(0);
							}
							ViewManager.otherPlayerPanel.hide();
						} else break;
						break;
					case StateType.AUTO_RUN:
						break;
				}
				_heroState = open ? value : 0;
			}
			if (yesFun != null)
				yesFun.apply(null, _yesFunArgs);
			checkState();
		}

		private function checkState() : void {
			SecondsTimer.removeFunction(onTimer);
			if (!MenuManager.getInstance().checkOpen(MenuType.PRACTICE)) return;
			if (_stageState == StateType.GROUP_BATTLE) return;
			if (_stageState == StateType.ANIMATION) return;

			if (_stageState == StateType.BATTLE) return;
			if (_stageState == StateType.MOVE_STATE) return;
			if (_stageState == StateType.FEASTING ) return ;
			if (_stageState == StateType.GUILDCAVERN ) return ;
			if (_stageState == StateType.GUILDESCOR) return ;
			if (_stageState == StateType.MINING) return ;
			if (_stageState == StateType.FISHING) return ;

			resetTimer();
		}

		/**
		 * type==0   PRACTICE||PRACTICE_STATE	 打坐
		 * type==1   PRACTICE                    主城打坐
		 * type==2	 PRACTICE_STATE 			 原地打坐
		 */
		public function isPractice(type : int = 0) : Boolean {
			switch(type) {
				case 0:
					return _stageState == StateType.PRACTICE || _heroState == StateType.PRACTICE_STATE;
					break;
				case 1:
					return _stageState == StateType.PRACTICE;
					break;
				case 2:
					return _stageState == StateType.PRACTICE_STATE;
					break;
			}
			return false;
		}

		/** 
		 * arg 是vector 或者 array
		 * 
		 * type = 0 则用sysmsg 里面的type运行
		 * 其它用传过来的类型滚
		 */
		public function checkMsg(msgId : int, arg : * = null, yesFun : Function = null, arg2 : *=null, type : int = 0) : Alert {
			var msgVo : SysMsgVo = sysMsgDic[msgId];
			if (msgVo != null) return msgVo.runMsg(arg, yesFun, arg2, type);
			return null;
		}

		// npc 对话面板点击后触发的事件
		public function startEvent(id : int) : void {
			switch(id) {
				case 1:
				case 2:
					break;
				case 3:
					break;
				default :
					break;
			}
		}

		public function initMsg(vo : SysMsgVo) : void {
			if (vo)
				sysMsgDic[vo.id] = vo;
		}

		private var indexLeve : int = 0;

		/**  
		 *从配置文件中读入上线数据 
		 */
		public function initFunctionVo(value : VoFunction) : void {
			if (!value) return;
			sutraStepOnLineDic[value.heroLevel] = value.sutraStepOnLine;

			if (value.sutraStepOnLine != indexLeve) {
				levelStepOnLineDic[value.sutraStepOnLine] = value.heroLevel;
				indexLeve = value.sutraStepOnLine;
			}
		}

		// private function okFun(type : String) : Boolean
		// {
		// switch(type)
		// {
		// case Alert.OK_EVENT:
		// case Alert.YES_EVENT:
		// if (_yesFun != null) _yesFun.apply(null, _yesFunArgs);
		// PracticeProxy.getInstance().sendCmd(0);
		// break;
		// }
		// return true;
		// }
		/** 5分钟无操作，进入打坐 */
		private var _timer : int = 0;

		private function onTimer() : void {
			_timer++;
			if (_timer > (5 * 60)) {
				PracticeProxy.getInstance().sendCmd();
				_timer == 0;
				SecondsTimer.removeFunction(onTimer);
			}
		}

		private function resetTimer() : void {
			_timer = 0;
			SecondsTimer.addFunction(onTimer);
		}
		
		public function getMsgVo(msgId:int):SysMsgVo
		{
			 return sysMsgDic[msgId];
		}
	}
}
