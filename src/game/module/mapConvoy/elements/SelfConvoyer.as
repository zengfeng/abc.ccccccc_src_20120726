package game.module.mapConvoy.elements
{
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.mapConvoy.ConvoyConfig;
	import game.module.mapConvoy.ConvoyProto;
	import game.module.mapConvoy.ui.ConvoyInfoBox;
	import game.module.quest.QuestUtil;
	import game.module.userBuffStatus.BuffStatusConfig;
	import game.module.userBuffStatus.BuffStatusManager;
	import game.net.data.StoC.SCConvoyInfoRes;

	import log4a.Logger;

	import worlds.apis.MMouse;
	import worlds.apis.MTo;
	import worlds.apis.MValidator;
	import worlds.apis.MWorld;
	import worlds.apis.validators.Validator;

	import com.commUI.tooltip.ToolTipManager;
	import com.utils.ColorUtils;

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-29
	 */
	public class SelfConvoyer extends Convoyer
	{
		public function SelfConvoyer()
		{
			super();
		}

		override public function reset(playerId : int, modelId : int) : void
		{
			super.reset(playerId, modelId);
			wayPointIndex = 0;

			player.removeClickCall(onClickCall);
			turtle.removeClickCall(onClickCall);
			MMouse.enableWalk = false;
			player.avatar.mouseEnabled = true;
			MWorld.sChangeMapStart.add(ConvoyProto.instance.cs_stopConvoy);
			MValidator.walk.add(validatorCall);
			MValidator.transport.add(validatorCall);
			MValidator.changeMap.add(validatorCall);
			MValidator.joinOtherActivity.add(validatorCall);

			BuffStatusManager.instance.updateBuffTime(BuffStatusConfig.BUFF_ID_CONVOY_START + quality, 999999);
			toNextWayPoint();
		}

		override public function destory(modelOut : Boolean = false) : void
		{
			BuffStatusManager.instance.updateBuffTime(BuffStatusConfig.BUFF_ID_CONVOY_START + quality, 0);
			MValidator.walk.remove(validatorCall);
			MValidator.transport.remove(validatorCall);
			MValidator.changeMap.remove(validatorCall);
			MValidator.joinOtherActivity.remove(validatorCall);

			clearTimeout(toNextWayPointTimer);
			clearTimeout(csCheckArriveWayPointTimer);
			clearTimeout(progressPlayCompleteTimer);
			QuestUtil.progressLoadingClose();
			MWorld.sChangeMapStart.remove(ConvoyProto.instance.cs_stopConvoy);
			MTo.clear();
			player.avatar.mouseEnabled = false;
			super.destory(modelOut);
			MMouse.enableWalk = true;
			if (validatorUse && validator) validator.go();
			validator = null;
			validatorUse = false;
		}

		public var validatorUse : Boolean;
		public var validator : Validator;

		private function validatorCall(v : Validator) : Boolean
		{
			validator = v;
			validatorUse = false;
			ConvoyInfoBox.instance.quitButtonOnClick();
			return false;
		}

		// ===================
		// 鼠标事件
		// ===================
		override protected function onMouseOver(event : MouseEvent = null) : void
		{
			ConvoyProto.instance.cs_convoyInfo(id);
		}

		// ===================
		// Tip
		// ===================
		override public function sc_convoyInfo(msg : SCConvoyInfoRes) : void
		{
			honour = msg.robHonor;
			sivler = msg.robSilver;
			beRobNum = msg.beRobNum;

			ToolTipManager.instance.refreshToolTip(player.avatar);
			ToolTipManager.instance.refreshToolTip(turtle.avatar);
		}

		override public function getTipContent() : String
		{
			var item : Item = ItemManager.instance.getPileItem(ConvoyConfig.xiangLuGoodsDic[quality]);
			var str : String = "";

			// str += "<font color='__PLAYER_COLOR__' size='14'><b>__PLAYER_NAME__</b></font>   __LEVEL__级\n";
			str += "护送香炉:<font color='__XIANG_LU_COLOR__'>__XIANG_LU_NAME__</font>\n";
			// str += "剩余时间:__TIME__\n";
			str += "被截次数:<font color='" + ColorUtils.HIGHLIGHT_DARK + "'>__BE_ROB_NUM__/__BE_ROB_MAX_NUM__</font>\n";
			str += "参拜进程:<font color='" + ColorUtils.HIGHLIGHT_DARK + "'>__WAY__INDEX__/__MAX_WAY_INDEX__</font>\n";
			str += "上香获得:<font color='" + ColorUtils.GOOD + "'>__SIVLER__</font>银币，";
			str += "<font color='" + ColorUtils.GOOD + "'>__HONOUR__</font>修为\n";

			// str = str.replace(/__PLAYER_COLOR__/, playerStruct.colorStr);
			// str = str.replace(/__PLAYER_NAME__/, playerStruct.name);
			// str = str.replace(/__LEVEL__/, playerStruct.level);
			str = str.replace(/__XIANG_LU_COLOR__/, ColorUtils.TEXTCOLOR[item.color]);
			str = str.replace(/__XIANG_LU_NAME__/, item.name);
			// str = str.replace(/__TIME__/, TimeUtil.toMMSS(time));
			str = str.replace(/__BE_ROB_NUM__/, beRobNum);
			str = str.replace(/__BE_ROB_MAX_NUM__/, beRobMaxNum);
			str = str.replace(/__WAY__INDEX__/, wayPointIndex);
			str = str.replace(/__MAX_WAY_INDEX__/, ConvoyConfig.WAY_POINT_COUNT);
			str = str.replace(/__SIVLER__/, sivler);
			str = str.replace(/__HONOUR__/, honour);
			return str;
		}

		// ===================
		// 控制走路
		// ===================
		public var wayPointIndex : int = 0;
		private var toNextWayPointTimer : uint;
		private var csCheckArriveWayPointTimer : uint;
		private var progressPlayCompleteTimer : uint;

		/** 去下一个路点 */
		public function toNextWayPoint() : void
		{
			if (wayPointIndex < ConvoyConfig.WAY_POINT_COUNT)
			{
				var nextWayPointIndex : int = wayPointIndex + 1;
			}
			else
			{
				Logger.info("出错 没有下一个路点");
				return;
			}
			var nextWayPoint : Point = ConvoyConfig.getWayPoint(nextWayPointIndex);
			MTo.toPoint(0, nextWayPoint.x, nextWayPoint.y, 0, 0, arriveNextWayPoint, [nextWayPointIndex]);
		}

		/** 去完成路点 */
		public function toCompleteWayPoint() : void
		{
			clearTimeout(toNextWayPointTimer);
			clearTimeout(csCheckArriveWayPointTimer);
			clearTimeout(progressPlayCompleteTimer);
			var nextWayPoint : Point = ConvoyConfig.getWayPoint(ConvoyConfig.WAY_POINT_COUNT);
			MTo.transportTo(0, nextWayPoint.x, nextWayPoint.y, 0, arriveNextWayPoint, [ConvoyConfig.WAY_POINT_COUNT]);
		}

		/** 到达下一个点 */
		public function arriveNextWayPoint(wayPointIndex : int) : void
		{
			Logger.info("到达地点" + wayPointIndex);
			csCheckArriveWayPoint();
		}

		/** 完成 */
		public function scComplete() : void
		{
			ViewManager.instance.playAnimation();
			// Alert.show("服务器发来完成");
		}

		public function csCheckArriveWayPoint() : void
		{
			clearTimeout(toNextWayPointTimer);
			clearTimeout(csCheckArriveWayPointTimer);
			clearTimeout(progressPlayCompleteTimer);
			ConvoyInfoBox.instance.buttonEnabled = false;
			SignalBusManager.questCollectProgressPlayComplete.add(progressPlayComplete);
			var wayName : String = ConvoyConfig.getWayPointNameDic(wayPointIndex + 1);
			QuestUtil.progressLoading("参拜<font color='" + ColorUtils.GOOD + "'>" + wayName + "</font>中...");
			progressPlayCompleteTimer = setTimeout(progressPlayComplete, 4200);
			// Alert.show("csCheckArriveWayPoint");
		}

		/** 进度完成 */
		private function progressPlayComplete() : void
		{
			clearTimeout(progressPlayCompleteTimer);
			ConvoyInfoBox.instance.buttonEnabled = true;
			QuestUtil.progressLoadingClose();
			SignalBusManager.questCollectProgressPlayComplete.remove(progressPlayComplete);
			ConvoyProto.instance.cs_arrivePoint();
		}

		public function scCheckArriveWayPoint(wayPointIndex : int, time : int) : void
		{
			clearTimeout(toNextWayPointTimer);
			clearTimeout(csCheckArriveWayPointTimer);
			Logger.info("服务器发来验证 wayPointIndex =" + wayPointIndex + "   time" + time);
			if (wayPointIndex <= this.wayPointIndex + 1 && time > 0)
			{
				time = time <= 0 ? 1 : time;
				csCheckArriveWayPointTimer = setTimeout(csCheckArriveWayPoint, time * 1000);
				return;
			}
			else if (wayPointIndex == ConvoyConfig.WAY_POINT_COUNT && time == 0)
			{
				scComplete();
				return;
			}
			// scArriveWayPoint();
			this.wayPointIndex = wayPointIndex;
			if (wayPointIndex < ConvoyConfig.WAY_POINT_COUNT)
			{
				toNextWayPointTimer = setTimeout(toNextWayPoint, 2000);
			}
			else
			{
				toNextWayPoint();
			}
		}
	}
}
