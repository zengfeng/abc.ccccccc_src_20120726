package game.module.rewardPackage {
	import game.core.item.Item;
	import game.core.item.ItemService;
	import game.manager.VersionManager;
	import game.module.notification.ICOMenuManager;
	import game.module.notification.VoICOButton;

	import com.utils.StringUtils;
	import com.utils.TimeUtil;

	/**
	 * @author 1
	 */
	public class VoPackReward {
		public var icoButton : VoICOButton;
		private var vo : VoICOButton;
		// 礼包类型ID
		public var  giftId : int = 1;
		// 礼包物品列表
		public var giftItems : Vector.<uint> = new Vector.<uint>();
		// 礼包经验
		public var rewardExp : uint = 3;
		// 礼包时间
		public var giftTime : uint;
		// 附加参数
		public var rewardParams : Vector.<uint> = new Vector.<uint>();
		// 时间戳
		// private var _tips=vo.getOldTips();
		// 奖励名称
		public var rewardName : String;
		private var items : Vector.<Item>=new Vector.<Item>();

		public function getTips(_voPack : VoPackReward) : String {
			var itemaa : Item;
			for each (var uuid:int in _voPack.giftItems) {
				itemaa = ItemService.createItem(uuid);
				if (itemaa)
					items.push(itemaa);
			}
			items.sort(sortOn);

			var id : int = _voPack.giftId;
			rewardParams = _voPack.rewardParams;

			vo = ICOMenuManager.getInstance().getIcoVo(id);
			if(!vo){
				return "找不到 giftId=="+giftId;
			}

			// var max:int=rewardParams.length;
			var tips : String = vo.getOldTips();
			// if (id == 2) {
			for (var i : int = 1;i <= rewardParams.length;i++)
				tips = tips.replace("yy" + i, rewardParams[i - 1]);
			// } else if (id == 3) {
			// for ( i = 0;i < rewardParams.length;i++)
			// tips = tips.replace("yy" + i, rewardParams[i]);
			//				//  tips = tips.replace(new RegExp("xx2" + String(i), "g"), paramStr);
			// }

			var max : int = items.length;
			var item : Item;

			for (i = 0;i < max;i++) {
				item = items[i];
				if (i == 0) tips += "：" + item.htmlName + StringUtils.addColorById(String("×" + item.nums), item.color);
				else
				// tips += "，" + item.htmlName + "×" + StringUtils.addColorById(String(item.nums), 2);
				tips += "，" + item.htmlName + StringUtils.addColorById(String("×" + item.nums), item.color);
			}
			return tips;
		}

		public function getIcoUrl(id : int) : String {
			return VersionManager.instance.getUrl("assets/ico/gift/gift" + id + ".png");
		}

		private var _date : Date = new Date();

		public function getTimerString(time : int) : String {
			_date.time = time * 1000;
			return TimeUtil.getTime(_date, false);
		}

		private function sortOn(a : Item, b : Item) : int {
			return b.color - a.color;
		}
	}
}
