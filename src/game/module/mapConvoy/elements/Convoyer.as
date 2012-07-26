package game.module.mapConvoy.elements
{
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.ColorUtils;

	import flash.events.MouseEvent;

	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.user.StateManager;
	import game.manager.MouseManager;
	import game.module.mapConvoy.ConvoyConfig;
	import game.module.mapConvoy.ConvoyControl;
	import game.module.mapConvoy.ConvoyProto;
	import game.module.mapConvoy.ConvoyUtil;
	import game.net.data.StoC.SCConvoyInfoRes;

	import log4a.Logger;

	import worlds.apis.MFactory;
	import worlds.apis.MPlayer;
	import worlds.apis.MSelfPlayer;
	import worlds.auxiliarys.MapMath;
	import worlds.roles.cores.Player;
	import worlds.roles.cores.Role;
	import worlds.roles.structs.PlayerStruct;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-29
	 */
	public class Convoyer
	{
		public var id : int;
		public var struct : PlayerStruct;
		public var player : Player;
		public var turtle : Role;

		function Convoyer() : void
		{
		}
		public function reset(playerId : int, modelId : int) : void
		{
			id = playerId;
			quality = ConvoyUtil.getQuality(modelId);
			player = MPlayer.getPlayer(playerId);
			player.rideUp(1);
			struct = MPlayer.getStruct(playerId);
			var name : String = ConvoyConfig.getTurtleName(quality);
			var colorStr : String = ConvoyConfig.getQualityColorStr(quality);
			var speed : Number = ConvoyUtil.getSpeed(modelId);
			var plusMinusX:int = MapMath.randomPlusMinus(1);
			var plusMinusY:int =  MapMath.randomPlusMinus(1);
			var offsetX:int = MapMath.randomInt(100, 70) * plusMinusX;
			var offsetY:int =  MapMath.randomInt(100, 70) * plusMinusY;
			turtle = MFactory.makeTurtle(quality, struct.id, struct.name, struct.colorStr, name, colorStr);
			turtle.addToLayer();
			turtle.initPosition(player.x + offsetX, player.y +offsetY);
			turtle.follow(player);
			turtle.setNeedMask(true);
			player.changeSpeed(speed);
			player.sUninstall.add(destory);

			player.avatar.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			turtle.avatar.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			player.avatar.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			turtle.avatar.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			player.addClickCall(onClickCall);
			turtle.addClickCall(onClickCall);

			ToolTipManager.instance.registerToolTip(player.avatar, ToolTip, getTipContent);
			ToolTipManager.instance.registerToolTip(turtle.avatar, ToolTip, getTipContent);
		}

		public function destory(modelOut : Boolean = false) : void
		{
			if (!modelOut) ConvoyControl.instance.modelOut(id, true);

			ToolTipManager.instance.destroyToolTip(player.avatar);
			ToolTipManager.instance.destroyToolTip(turtle.avatar);

			player.avatar.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			turtle.avatar.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			player.avatar.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			turtle.avatar.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			player.removeClickCall(onClickCall);
			turtle.removeClickCall(onClickCall);

			player.walkStop();
			player.changeSpeed(struct.speed);
			player.rideUp(0);
			player.sUninstall.remove(destory);
			turtle.destory();
			struct = null;
			player = null;
			turtle = null;
		}

		public function changeModel(modelId : int) : void
		{
			var speed : Number = ConvoyUtil.getSpeed(modelId);
			player.changeSpeed(speed);
		}

		// ===================
		// 鼠标事件
		// ===================
		protected function onClickCall(role : Role) : void
		{
			role;
			Logger.info("onClickCall");
			if (player == null || turtle == null)
			{
				StateManager.instance.checkMsg(258);
				return;
			}

			var distance : Number = MapMath.distance(player.x, player.y, MSelfPlayer.position.x, MSelfPlayer.position.y);
			if (distance > 500)
			{
				StateManager.instance.checkMsg(258);
				return;
			}
			ConvoyProto.instance.cs_attackConvoy(id);
		}

		protected function onMouseOver(event : MouseEvent = null) : void
		{
			ConvoyProto.instance.cs_convoyInfo(id);
			MouseManager.cursor = MouseManager.BATTLE;
		}

		protected function onMouseOut(event : MouseEvent = null) : void
		{
			MouseManager.cursor = MouseManager.ARROW;
		}

		// ===================
		// Tip
		// ===================
		protected var beRobNum : int = 0;
		protected var beRobMaxNum : int = 2;
		protected var sivler : int = 100;
		protected var honour : int = 10;
		protected var robNum : int = 3;
		protected var quality : int;

		public function sc_convoyInfo(msg : SCConvoyInfoRes) : void
		{
			honour = msg.robHonor;
			sivler = msg.robSilver;
			beRobNum = msg.beRobNum;

			ToolTipManager.instance.refreshToolTip(player.avatar);
			ToolTipManager.instance.refreshToolTip(turtle.avatar);
		}

		public function getTipContent() : String
		{
			var item : Item = ItemManager.instance.getPileItem(ConvoyConfig.xiangLuGoodsDic[quality]);
			var str : String = "";
			str += "<font color='__PLAYER_COLOR__' size='14'><b>__PLAYER_NAME__</b></font>   __LEVEL__级\n";
			str += "护送香炉:<font color='__XIANG_LU_COLOR__'>__XIANG_LU_NAME__</font>\n";
			// str += "剩余时间:__TIME__\n";
			str += "被截次数:<font color='" + ColorUtils.HIGHLIGHT_DARK + "'>__BE_ROB_NUM__/__BE_ROB_MAX_NUM__</font>\n";
			str += "打劫获得:<font color='" + ColorUtils.GOOD + "'>__SIVLER__</font>银币，";
			str += "<font color='" + ColorUtils.GOOD + "'>__HONOUR__</font>修为\n";
			if (beRobNum < beRobMaxNum)
			{
				str += "<font color='" + ColorUtils.HIGHLIGHT_DARK + "'>今天还能打劫__GOB_NUM__次</font>";
			}
			else
			{
				str += "<font color='" + ColorUtils.WARN + "'>该玩家已被劫空</font>";
			}

			str = str.replace(/__PLAYER_COLOR__/, struct.colorStr);
			str = str.replace(/__PLAYER_NAME__/, struct.name);
			str = str.replace(/__LEVEL__/, struct.level);
			str = str.replace(/__XIANG_LU_COLOR__/, ColorUtils.TEXTCOLOR[item.color]);
			str = str.replace(/__XIANG_LU_NAME__/, item.name);
			// str = str.replace(/__TIME__/, TimeUtil.toMMSS(time));
			str = str.replace(/__BE_ROB_NUM__/, beRobNum);
			str = str.replace(/__BE_ROB_MAX_NUM__/, beRobMaxNum);
			str = str.replace(/__SIVLER__/, sivler);
			str = str.replace(/__HONOUR__/, honour);
			str = str.replace(/__GOB_NUM__/, ConvoyConfig.attackNum);
			return str;
		}
	}
}
