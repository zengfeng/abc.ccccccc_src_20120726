package game.module.artifact {
	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	
	import flash.display.Bitmap;
	
	import game.core.hero.HeroManager;
	import game.core.item.prop.ItemProp;
	
	import log4a.Logger;

	/**
	 * @author yangyiqiang
	 */
	public class ArtifactManage {
		private var _list : Vector.<VoArtifact> = new Vector.<VoArtifact>(20);
		public var numVec : Vector.<Bitmap> = new Vector.<Bitmap>();
		private static var _instance : ArtifactManage;
		/**
		 * 已经铸魂的次数  
		 */
		public var caseCount : int;
		/**
		 * 已经挑战的次数  
		 */
		public var battleCount : int;
		/**
		 * 铸魂的最高 次数  
		 */
		public var caseMax : int;
		public var result : int;
		public var critNum : int;
		public var lastExp : int;
		public var isBusy : Boolean = false;
		public static const FREE_BATTLE : int = 20;
		public static const FREE_CAST : int = 12;

		public function getCritNumString() : String {
			if (critNum == 0) return "";
			var num : int = 0;
			if (caseCount > FREE_CAST) num = lastExp + 1000;
			else num = lastExp + 500;
			return "连暴" + StringUtils.addColor(String(critNum), ColorUtils.HIGHLIGHT) + "次,下次暴击获得" + StringUtils.addColor(String(num), ColorUtils.HIGHLIGHT) + "经验";
		}

		public function ArtifactManage() {
			if (_instance)
				throw Error("ArtifactManage 是单类，不能多次初始化!");
		}

		public static function instance() : ArtifactManage {
			if (_instance == null)
				_instance = new ArtifactManage();
			return _instance;
		}

		public function initVo(vo : VoArtifact) : void {
			_list[vo.id - 1] = vo;
		}

		public function getVo(id : int) : VoArtifact {
			if (id >= 20 || id <= 0) {
				Logger.error("找不到ID=" + id + " 的神器！");
				return null;
			}
			return _list[id - 1];
		}

		public function getArtifactProps(index : int) : ItemProp {
			var item : ItemProp = new ItemProp();
			var max : int = (index+1) / 2;
			var bActivated:Boolean = ((index+1)%2 == 1);
			var peqProp : ItemProp;
			for (var i : int = 1;i <= max;i++) {
				if(i == max && !bActivated)
				{
					peqProp = getVo(i).getArtifactProp(1);
				}
				else
				{
					peqProp = getVo(i).getArtifactProp(2);
				}
				for each (var propKey:String in HeroManager.propV) {
					item[propKey] += peqProp[propKey];
				}
			}
			return item;
		}
		
		public function getAllArtifactPropsName(index:int):String{
			var allNameStr:String = "";
			var max : int = (index+1) / 2;
			var bActivated:Boolean = ((index+1)%2 == 1);
			for (var i : int = 1;i <= max;i++) {
				if(i == max && !bActivated)
				{	
					allNameStr += getVo(i).name + "(未激活)";
				}
				else
				{
					if(1 == max || i == max)
						allNameStr += getVo(i).name;
					else
						allNameStr +=  getVo(i).name + "、";
				}
			}
			return allNameStr;
		}

		public function getVos() : Vector.<VoArtifact> {
			return _list;
		}
	}
}
