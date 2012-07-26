package game.core.hero
{
	import log4a.Logger;
	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public class HeroConfigManager
	{
		// =====================
		// 单例
		// =====================
		private static var __instance : HeroConfigManager;

		public static function get instance() : HeroConfigManager
		{
			if (!__instance)
				__instance = new HeroConfigManager();

			return __instance;
		}

		public function HeroConfigManager() : void
		{
			if (__instance)
				throw (Error("单例错误！"));
		}

		// =====================
		// 属性
		// =====================
		private var _configDict : Dictionary = new Dictionary();
		private var _propDict : Dictionary = new Dictionary();
		private var _jobGrowths : Vector.<JobGrowth>;
		public static var heroDisplayProps : Array /* of VoProp */;

		// =====================
		// 方法
		// =====================
		public function addConfig(conf : HeroConfig) : void
		{
			_configDict[conf.id] = conf;
		}
		
		public function getConfigById(id : int) : HeroConfig
		{
			return _configDict[id];
		}
		
		public function addProp (prop:VoHeroProp):void
		{
			_propDict[prop.id] = prop;
		}
		
		public function getPropById(id:uint):VoHeroProp
		{
			var prop:VoHeroProp = _propDict[id];
			
			if (!prop)
			{
				Logger.error("未知将领属性!" + id);
				return null;
			}
				
			return prop.clone();
		}

		public function getJobGrowthByJobId(jobId : int) : JobGrowth
		{
			return _jobGrowths[jobId - 1];
		}
		
		public function setJobGrowths(jobGrowths:Vector.<JobGrowth>):void
		{
			_jobGrowths = jobGrowths;
		}
		
		private var _potentialGrowths :Dictionary=new Dictionary();
		private var _potentialArray:Array=[120,160,180];
		public function getPotentialGrowth(jobId : int,potential:int) : PotentialGrowth
		{
			for (var i:int=0,num:int=-1;i<_potentialArray.length;i++,num++){
				if(potential>_potentialArray[i]){
					num++;
				}
			}
			if(num<0)return null;
			return _potentialGrowths[jobId+_potentialArray[i-1]];
		}
		
		public function setPotentialGrowth(value:PotentialGrowth):void
		{
			_potentialGrowths[value.id]=value;
		}
	}
}
