package game.module.enhance
{
	import game.core.user.StateManager;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.equipment.Equipment;
	import game.core.item.sutra.Sutra;
	import game.core.user.UserData;
	import game.definition.ID;
	import game.net.core.Common;
	import game.net.data.CtoS.CSEnhance;
	import game.net.data.StoC.SCEnhanceResult;

	import log4a.Logger;

	import net.AssetData;
	import net.RESManager;

	import com.commUI.quickshop.MultiQuickShop;
	import com.commUI.quickshop.SingleQuickShop;
	import com.commUI.quickshop.VoOrder;

	import flash.display.MovieClip;

	/**
	 * @author jian
	 */
	public class EnhanceManager
	{
		// =====================
		// @单例
		// =====================
		private static var __instance : EnhanceManager;

		public static function get instance() : EnhanceManager
		{
			if (!__instance)
				__instance = new EnhanceManager();

			return __instance;
		}

		public function EnhanceManager()
		{
			if (__instance)
				throw(Error("单例错误！"));
		}

		// =====================
		// @属性
		// =====================
		private var _model : EnhanceModel;
		private var _panel : EnhanceView;
		private var _mcSuccess : MovieClip;
		private var _mcFailed : MovieClip;

		// =====================
		// @方法
		// =====================
		public function set model(value : EnhanceModel) : void
		{
			_model = value;
		}

		public function set panel(value : EnhanceView) : void
		{
			_panel = value;
		}

		// 服务器返回强化结果
		public function onEnhanceResult(msg : SCEnhanceResult) : void
		{
			if (msg.itemID != _model.item.uuid)
				return;

			if (msg.result == true)
			{
				trace("强化成功");
				showSuccessEffect();
				_panel.showEffect();
				StateManager.instance.checkMsg(406, null, null, [_model.item.id, _model.item.enhanceLevel]);
				StateManager.instance.checkMsg(403, [_model.item.enhancePropName], null, [_model.item.enhanceValue]);
			}
			else
			{
				trace("强化失败");
				showFailedEffect();
			}

			if (_model.item is Sutra)
				_model.item = ItemManager.instance.getSutra(msg.itemID);
			else
				_model.item = ItemManager.instance.getEquipableItem(msg.itemID) as Equipment;

			_panel.updateView();
		}

		// 成功特效
		private function showSuccessEffect() : void
		{
			if (_panel && _panel.parent)
			{
				if (!_mcSuccess)
				{
					_mcSuccess = RESManager.getMC(new AssetData("enhanceSuccess", "commonAction"));
				}
				if (_mcSuccess.parent)
					_mcSuccess.stop();

				_panel.addChild(_mcSuccess);

				_mcSuccess.x = 95;
				_mcSuccess.y = 114;
				_mcSuccess.gotoAndPlay(0);
			}
		}

		// 失败特效
		private function showFailedEffect() : void
		{
			if (_panel && _panel.parent)
			{
				if (!_mcFailed)
				{
					_mcFailed = RESManager.getMC(new AssetData("enhanceFail", "commonAction"));
				}
				if (_mcFailed.parent)
					_mcFailed.stop();
				_panel.addChild(_mcFailed);
				_mcFailed.x = 95;
				_mcFailed.y = 114;
				_mcFailed.gotoAndPlay(0);
			}
		}

		private function sendEnhanceRequest() : void
		{
			var msg : CSEnhance = new CSEnhance();

			msg.itemID = _model.item.equipId;

			var settings : uint = 0;
			Logger.info("强化装备 " + _model.targetLevel);

			settings |= _model.targetLevel;

			if (_model.isEquiped) settings |= 0x00040000;

			msg.settings = settings;

			Common.game_server.sendMessage(0x280, msg);
		}

		public function askForShopping() : void
		{
			if (!_model.hasEnoughStone())
			{
				StateManager.instance.checkMsg(80);
				return;
			}

			if (!_model.hasEnoughSilver())
			{
				SingleQuickShop.show(ID.SILVER, ID.GOLD, Math.ceil(Number(_model.costSilver - UserData.instance.silver)), null, null, _panel, onShoppingResult);
				return;
			}

			sendEnhanceRequest();
		}

		private function onShoppingResult(success : Boolean) : void
		{
			if (success && _model.meetCost())
			{
				sendEnhanceRequest();
				Common.game_server.removeCallback(0xFFF2, onShoppingResult);
			}
		}
	}
}
