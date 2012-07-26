package game.module.recruitHero.highFindHero
{
	import game.core.user.StateManager;
	import game.definition.UI;
	import game.net.core.Common;
	import game.net.data.CtoS.CSHeroBet;

	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;

	import net.AssetData;
	import net.RESManager;

	import com.commUI.alert.Alert;
	import com.commUI.tooltip.ToolTipData;
	import com.utils.StringUtils;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	/**
	 * @author zheng
	 */
	public class FindHeroPanel extends GComponent
	{
		// ===========================================================
		// @属性
		// ===========================================================
		private var _findButton : GButton;
		private var _findButtonGold : GButton;
		private var _mcLight : MovieClip;
		private var _mcCurrent : MovieClip;
		private var _mcWealth : MovieClip ;
		private var _mcBlessing : MovieClip ;
		private var _mcLast : MovieClip ;
		private var _mcGround : MovieClip ;
		private var _mcOpen : MovieClip;
		private var _mcMagicMirror : MovieClip;
		private static const mcX : int = 130;
		private static const mcY : int = 126;

		// ===========================================================
		// @创建
		// ===========================================================
		public function FindHeroPanel()
		{
			_base = new GComponentData();
			_base.width = 266;
			_base.height = 314;
			super(_base);
					
		}

		override protected function create() : void
		{
			super.create();
			addBg();
			addButtons();
			addGodMC();
			addResultMC();
		}

		private function addBg() : void
		{
			_mcMagicMirror = RESManager.getMC(new AssetData("mojing", "highHeroFindFont"));
			if (!_mcMagicMirror) return;

			_mcMagicMirror.x = 133;
			_mcMagicMirror.y = 157;
			this.addChild(_mcMagicMirror);
		}

		private function addButtons() : void
		{
			var buttonData : GButtonData = new GButtonData();
			buttonData.upAsset = new AssetData(UI.HIGH_FINDHERO_BTNGOLD_UP, "hfindhero");
			buttonData.overAsset = new AssetData(UI.HIGH_FINDHERO_BTNGOLD_OVER, "hfindhero");
			buttonData.downAsset = new AssetData(UI.HIGH_FINDHERO_BTNGOLD_DOWN, "hfindhero");
			buttonData.disabledAsset = new AssetData("EnterButtonSkin_Disable");
			buttonData.width = 96;
			buttonData.height = 39;
			buttonData.x = 85;
			buttonData.y = 248;
			buttonData.toolTipData = new ToolTipData();
			var str : String = "消耗"+StringUtils.addGoldColor("50")+"元宝";//"<font size='12',color='#ffffff'>请神需花费50元宝</font>";
			_findButtonGold = new GButton(buttonData);
			this.addChild(_findButtonGold);
			_findButtonGold.toolTip.source = str;
			_findButtonGold.visible = false;
			_findButtonGold.toolTip.visible = false;

			buttonData.upAsset = new AssetData(UI.HIGH_FINDHERO_BTN_UP, "hfindhero");
			buttonData.overAsset = new AssetData(UI.HIGH_FINDHERO_BTN_OVER, "hfindhero");
			buttonData.downAsset = new AssetData(UI.HIGH_FINDHERO_BTN_DOWN, "hfindhero");
			buttonData.disabledAsset = new AssetData("EnterButtonSkin_Disable");
			buttonData.width = 96;
			buttonData.height = 39;
			buttonData.x = 85;
			buttonData.y = 248;
			_findButton = new GButton(buttonData);
			this.addChild(_findButton);
		}

		private function addGodMC() : void
		{
//			_mcLight = RESManager.getMC(new AssetData("light", "embedFont"));
//			_mcLight.x = mcX - 5;
//			_mcLight.y = mcY + 104;
			_mcLast = RESManager.getMC(new AssetData("mcLast", "highHeroFindFont"));
			_mcLast.x = mcX;
			_mcLast.y = mcY;
			_mcGround = RESManager.getMC(new AssetData("mcGround", "highHeroFindFont"));
			_mcGround.x = mcX;
			_mcGround.y = mcY;
			_mcWealth = RESManager.getMC(new AssetData("mcWealth", "highHeroFindFont"));
			_mcWealth.x = mcX;
			_mcWealth.y = mcY;
			_mcBlessing = RESManager.getMC(new AssetData("mcBlessing", "highHeroFindFont"));
			_mcBlessing.x = mcX;
			_mcBlessing.y = mcY;
			_mcOpen = RESManager.getMC(new AssetData("openFhero", "highHeroFindFont"));
			_mcOpen.x = mcX;
			_mcOpen.y = mcY;
			_mcCurrent = _mcOpen;
			addChild(_mcCurrent);
		}

		private function addResultMC() : void
		{
		}

		// ===========================================================
		// @刷新
		// ===========================================================
		public function refreshGodMC(id : int) : void
		{
			var mc : MovieClip = getMcById(id);
			_mcCurrent = swap(_mcCurrent, mc) as MovieClip;
//			if (this.contains(_mcLight) != true)
//			{
//				addChild(_mcLight);
//			}
			resetMovieClip(_mcCurrent);
//			resetMovieClip(_mcLight);
			_mcCurrent.play();
//			_mcLight.play();
		}

		public function refreshBtn(num : int) : void
		{
			if (num == 0)
			{
				_findButton.visible = false;
				_findButton.toolTip.visible = false;
				_findButtonGold.visible = true;
				_findButtonGold.toolTip.visible = true;
			}
			else
			{
				_findButton.visible = true;
				_findButton.toolTip.visible = false;
				_findButtonGold.visible = false;
				_findButtonGold.toolTip.visible = false;
			}
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			_findButton.addEventListener(MouseEvent.CLICK, onFindBtnClick);
			_findButtonGold.addEventListener(MouseEvent.CLICK, onFindGoldBtnClick);
		// ToolTipManager.instance.registerToolTip(_findButtonGold, findHeroTooltip, provideToolTipData);
			_mcMagicMirror.gotoAndPlay(1);
			_mcCurrent.gotoAndPlay(1);
		}

		override protected function onHide() : void
		{
			super.onHide();

			_mcCurrent = swap(_mcCurrent, _mcOpen) as MovieClip;
			_findButton.removeEventListener(MouseEvent.CLICK, onFindBtnClick);
			_findButtonGold.removeEventListener(MouseEvent.CLICK, onFindGoldBtnClick);
			// ToolTipManager.instance.destroyToolTip(this);
		}

		private function onFindBtnClick(event : MouseEvent) : void
		{
			if(getTimer()-_time<500)return;
			_time=getTimer();
			var cmd : CSHeroBet = new CSHeroBet();
			Common.game_server.sendMessage(0x79, cmd);
		}

		private var _time:uint;
		private function onFindGoldBtnClick(event : MouseEvent) : void
		{
			if(getTimer()-_time<500)return;
			_time=getTimer();
			
			StateManager.instance.checkMsg(311,null, okFun,[50]);
		}

		// =====================
		// @交互
		// =====================
		private function okFun(type : String) : Boolean
		{
			switch(type)
			{
				case Alert.OK_EVENT:
				{
					var cmd : CSHeroBet = new CSHeroBet();
					Common.game_server.sendMessage(0x79, cmd);
				}
				default:
				{
					break;
				}
			}
			return true;
		}

		private function getMcById(id : int) : MovieClip
		{
			var mc : MovieClip;
			// type类型 0 - 穷神  1 - 土地公公  2 - 财神  3 - 福神
			switch(id)
			{
				case 0:
					mc = _mcLast;
					break;
				case 1:
					mc = _mcGround;
					break;
				case 2:
					mc = _mcWealth;
					break;
				case 3:
					mc = _mcBlessing;
					break;
			}
			return mc;
		}

		// ===========================================
		public static function resetMovieClip(target:MovieClip):void
		{
			forEachChildIn(target, resetMovieClipFunc, -1);
		}
		
		public static function resetMovieClipFunc (target:DisplayObject, currentDepth:int):Boolean
		{
			if (target is MovieClip)
			{
				(target as MovieClip).gotoAndPlay(1);
			}
			return true;
		}
		
		public static function forEachChildIn(root : DisplayObjectContainer, func : Function, depth : int = 0, currentDepth : int = 0) : void
		{
			if (depth >= 0 && currentDepth > depth)
				return;

			var num : int = root.numChildren;

			for (var i : int = 0; i < num; i++)
			{
				var child : DisplayObject = root.getChildAt(i);
				if (func is Function)
				{
					if (!func(child, currentDepth))
						return;
				}

				if (child is DisplayObjectContainer)
				{
					forEachChildIn(child as DisplayObjectContainer, func, depth, currentDepth + 1);
				}
			}
		}
	}
}
