package game.core.item.soul
{
	import com.commUI.alert.Alert;
	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	import game.core.item.ItemService;
	import game.core.item.config.ItemConfig;
	import game.core.item.equipable.EquipableItem;
	import game.core.item.prop.ItemProp;
	import game.core.prop.Prop;
	import game.core.prop.PropManager;
	import game.core.user.StateManager;
	import game.manager.VersionManager;
	import game.module.soul.SoulDragManager;
	import gameui.drag.DragManage;





	/**
	 * @author jian
	 */
	public class Soul extends EquipableItem
	{
		// =====================
		// @属性
		// =====================
		public var exp : uint = 0;
		public var soulConfig : SoulConfig;
		// private var _position : int;
		private var _mergeTarget : Soul;
		private var _mergeTargetPosition : int = -1;
		private var _description : String;
		private var _rollDescription : String;

		// =====================
		// @创建
		// =====================
		public static function create(config : ItemConfig, binding : Boolean, prop : ItemProp, soulConfig : SoulConfig) : Soul
		{
			var soul : Soul = new Soul();
			soul.config = config;
			soul.binding = binding;
			soul.prop = prop;
			soul.soulConfig = soulConfig;
			soul.exp = soul.initialExp;
			// soul.position = -1;

			return soul;
		}

		override protected function parse(source : *) : void
		{
			super.parse(source);

			var soul : Soul = source as Soul;
			soul.prop = prop;
			soul.exp = exp;
		}

		// =====================
		// @方法
		// =====================
		public function get soulType() : uint
		{
			return uint((id - 1) / 10);
		}
		
		public function get minLevelId () : uint
		{
			return soulType * 10 + 1;
		}
		
		public function get maxLevelId () : uint
		{
			return soulType * 10 + 10;
		}

		// 获取元神等级
		public function get level() : uint
		{
			return soulConfig.level;
		}

		override public function get searchName() : String
		{
			return (name + " Lv" + level);
		}

		public function get totemUrl() : String
		{
			if (soulConfig.totemName)
				return VersionManager.instance.getUrl("assets/totem/" + soulConfig.totemName + ".png");
			else
				return "";
		}

		public function get flameId() : String
		{
			return soulConfig.flameId;
		}

		// 获取升级经验值
		public function get upgradeExp() : uint
		{
			if (level == 10)
				return soulConfig.exp;
			else
				return SoulConfig(SoulConfigManager.instance.getConfig(id + 1)).exp;
		}

		// 获取初始经验值（当前等级）
		public function get initialExp() : uint
		{
			return soulConfig.exp;
		}

		public function isExpSoul() : Boolean
		{
			return id >= 9251 && id <= 9260;
		}

		override public function get description() : String
		{
			if (isExpSoul())
				return super.description;
			else
				return _description;
		}

		public function get rollDescription() : String
		{
			if (isExpSoul())
				return super.description;
			else
				return _rollDescription;
		}

		override public function set prop(value : ItemProp) : void
		{
			super.prop = value;

			if (!isExpSoul())
			{
				var property : Prop = PropManager.instance.getPropByKey(otherKey);
				_description = property.name + StringUtils.addColor(" +" + this.prop[otherKey] + (property.per == 1 ? "%" : ""), ColorUtils.GOOD);
				_rollDescription = property.name + StringUtils.addColor(" 提升 " + this.prop[otherKey] + (property.per == 1 ? "%" : ""), ColorUtils.GOOD);
			}
		}

		// =====================
		// @吞噬
		// =====================
		// 元神吞噬协议
		public function merge(target : Soul) : void
		{
			if (uuid == target.uuid) return;

			_mergeTarget = target;
			popupMergeAlert();
		}

		public function mergeTo(target : Soul, position : int) : void
		{
			_mergeTargetPosition = position;
			merge(target);
		}

		// 弹框
		private function popupMergeAlert() : void
		{
			var strong : Soul;
			var weak : Soul;

			if (this.isExpSoul() && !_mergeTarget.isExpSoul())
			{
				strong = _mergeTarget;
				weak = this;
			}
			else if (!this.isExpSoul() && _mergeTarget.isExpSoul())
			{
				strong = this;
				weak = _mergeTarget;
			}
			else if (this.color > _mergeTarget.color)
			{
				strong = this;
				weak = _mergeTarget;
			}
			else
			{
				strong = _mergeTarget;
				weak = this;
			}

			if (strong.level == 10)
			{
				SoulDragManager.state = SoulDragManager.IDLE;
				StateManager.instance.checkMsg(123, [strong.htmlName, strong.level]);
			}
			else if (strong.exp + weak.exp >= strong.upgradeExp)
			{
				var upgradeLevel : int = getSoulLevelByIdExp(strong.id, strong.exp + weak.exp);
				var exp : int = (upgradeLevel == 10) ? (SoulConfigManager.instance.getConfig(strong.soulType * 10 + 10).exp - strong.exp) : weak.exp;
				StateManager.instance.checkMsg(116, null, popupMergeAlertCallback,[strong.id, weak.id, exp, upgradeLevel]);
				SoulDragManager.state = SoulDragManager.DRAGGING;
			}
			else
			{
				SoulDragManager.state = SoulDragManager.DRAGGING;
				StateManager.instance.checkMsg(115, null, popupMergeAlertCallback, [strong.id, weak.id, weak.exp]);
			}
		}

		private static function getSoulLevelByIdExp(id : uint, exp : uint) : uint
		{
			var cfg : SoulConfig = SoulConfigManager.instance.getConfig(id);

			while (cfg)
			{
				if (cfg.exp > exp)
					break;
				else if (cfg.level % 10 == 0)
					return cfg.level;

				cfg = SoulConfigManager.instance.getConfig(id++);
			}

			return cfg.level - 1;
		}

		// 计算元神大小，用于决定谁吞噬谁
		private function weight() : uint
		{
			var w : uint = 0;

			if (isExpSoul())
			{
				return 0;
			}

			w |= color << 24;
			w |= exp;

			return w;
		}

		// 弹框回调
		private function popupMergeAlertCallback(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT || type == Alert.YES_EVENT)
			{
				SoulDragManager.state = SoulDragManager.WAITING_REPLY;
				sendMergeMessage();
			}
			else if (type == Alert.CANCEL_EVENT)
			{
				SoulDragManager.state = SoulDragManager.IDLE;
				DragManage.getInstance().finishDrag(false);
			}
			_mergeTarget = null;
			return true;
		}

		// 向服务器发送元神合并请求
		private function sendMergeMessage() : void
		{
			ItemService.instance.sendMergeMessage(equipId, _mergeTarget.equipId, _mergeTargetPosition);
			_mergeTargetPosition = -1;
		}
	}
}
