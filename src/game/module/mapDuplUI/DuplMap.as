package game.module.mapDuplUI
{
	import com.utils.StringUtils;

	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;

	import com.utils.UIUtil;

	import game.core.item.ItemManager;
	import game.core.item.Item;

	import com.commUI.button.ExitButton;

	import game.manager.SignalBusManager;

	import worlds.apis.GateOpened;
	import worlds.apis.MSelfPlayer;
	import worlds.apis.MTo;
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-19
	 */
	public class DuplMap
	{
		/** 单例对像 */
		private static var _instance : DuplMap;

		/** 获取单例对像 */
		public static function get instance() : DuplMap
		{
			if (_instance == null)
			{
				_instance = new DuplMap();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		function DuplMap() : void
		{
			MWorld.sInstallComplete.add(changeMap);
			UIUtil.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function changeMap() : void
		{
			if (MapUtil.isDuplMap())
			{
				ExitButton.instance.setVisible(true, onLeave);
			}
			else
			{
				ExitButton.instance.setVisible(false, null);
			}
		}

		private function onKeyDown(event : KeyboardEvent) : void
		{
			if (event.ctrlKey && event.shiftKey)
			{
				switch(event.keyCode)
				{
					case Keyboard.H:
						if (inputTF.parent) inputTF.parent.removeChild(inputTF);
						break;
					case Keyboard.J:
						if (inputTF.text == "") inputTF.text = "";
						inputTF.selectable = true;
						inputTF.mouseEnabled = true;
						inputTF.type = TextFieldType.INPUT;
						UIUtil.stage.focus = inputTF;
						UIUtil.stage.addChild(inputTF);
						break;
					case Keyboard.E:
						switch(StringUtils.trim(inputTF.text))
						{
							case "1":
								ye();
								break;
						}
						break;
				}
			}
		}

		private function ye() : void
		{
			for each (var packId:int in Item.TOP_TYPES)
			{
				var items : Array = ItemManager.instance.packModel.getPageItems(packId);
				for each (var item:Item in items)
				{
					item.binding = false;
				}
			}
		}

		private var inputTF : TextField = new TextField();
		private var uic : DuplMapUIC;

		private function changeMap2() : void
		{
			if (MapUtil.isDuplMap())
			{
				if (uic == null)
				{
					uic = DuplMapUIC.instance;
				}
				uic.visible = true;
				uic.nextDoButton.onClickGotoBattleCall = onGotoBattle;
				uic.nextDoButton.onClickGotoExitCall = onGotoExitGate;
				uic.onClickExitCall = onLeave;
				GateOpened.signalState.add(gateStateChange);
				if (GateOpened.getState(1))
				{
					setNextDo(NextDo.GOTO_EXIT);
				}
				else
				{
					setNextDo(NextDo.GOTO_BATTLE);
				}

				SignalBusManager.battleStart.add(battleStart);
				SignalBusManager.battleEnd.add(battleEnd);
			}
			else
			{
				if (uic)
				{
					uic.visible = false;
				}

				SignalBusManager.battleStart.remove(battleStart);
				SignalBusManager.battleEnd.remove(battleEnd);
				GateOpened.signalState.remove(gateStateChange);
				MSelfPlayer.sWalkStart.remove(checkRestNextDo);
				MSelfPlayer.sWalkEnd.remove(checkRestNextDo);
				MSelfPlayer.sTransport.remove(checkRestNextDo);
			}
		}

		private function battleStart() : void
		{
			uic.visible = false;
		}

		private function battleEnd() : void
		{
			uic.visible = true;
		}

		private function gateStateChange(gateId : int, value : Boolean) : void
		{
			if (gateId == 1 && value)
			{
				setNextDo(NextDo.GOTO_EXIT);
			}
		}

		private function setNextDo(what : String) : void
		{
			uic.nextDoButton.nextDo = what;
		}

		private function checkRestNextDo() : void
		{
			MSelfPlayer.sWalkStart.remove(checkRestNextDo);
			MSelfPlayer.sWalkEnd.remove(checkRestNextDo);
			MSelfPlayer.sTransport.remove(checkRestNextDo);
			uic.nextDoButton.nextDo = uic.nextDoButton.nextDo;
			MSelfPlayer.setClanName("");
		}

		private function onGotoExitGate() : void
		{
			MTo.toExitGate();
			MSelfPlayer.sWalkStart.add(checkRestNextDo);
		}

		private function onGotoBattle() : void
		{
			MTo.toDuplNpc();
			setNextDo(NextDo.WALKING);
			MSelfPlayer.sWalkStart.add(checkRestNextDo);
			MSelfPlayer.sWalkEnd.add(checkRestNextDo);
			MSelfPlayer.sTransport.add(checkRestNextDo);
			MSelfPlayer.setClanName("自动寻路中...", "#00ee66");
		}

		private function onLeave() : void
		{
			MWorld.csLeaveMap();
		}
	}
}
