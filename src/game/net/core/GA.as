package game.net.core {
	import log4a.Logger;

	import flash.external.ExternalInterface;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class GA
	{
		/**
		 * ## 统计事件
		PreLoading 部分
		创建角色：
		Loader 载入，开始可执行 AS 代码：
		已创建角色：_gaq.push(['ue._trackEvent', 'InitGame', 'CharCreation', 'StartLoading'])
		未创建角色：_gaq.push(['ue._trackEvent', 'PreLoading', 'CharCreation', 'StartLoading'])
		记录变量：
		_gaq.push(['_setCustomVar', 1, _src])
		创建角色页载入完毕：_gaq.push(['ue._trackTiming', 'PreLoading', 'CharCreation', <创建角色页面加载了多少豪秒，非负整数>, 'FinishLoading'])
		创建角色页面停留时间：_gaq.push(['ue._trackTiming', 'PreLoading', 'StayTime', <停留了多少毫秒，非负整数>, 'CharCreation'])
		预加载资源：每个需要预加载的资源，有个唯一的 <UniqueAssetsName>
		_gaq.push(['ue._trackEvent' , 'PreLoading', '<UniqueAssetsName>', 'StartLoading'])
		_gaq.push(['ue._trackEvent' , 'PreLoading', 'AssetsLoadedCount' , '', <总共预加载了多少个资源，非负整数>])
		_gaq.push(['ue._trackTiming', 'PreLoading', '<UniqueAssetsName>', <这个资源一共加载了多少豪秒，非负整数>, 'FinishLoading'])
		_gaq.push(['ue._trackTiming', 'PreLoading', 'AssetsLoadedTime'  , <预加载的资源总计耗时多少豪秒，非负整数>, '<角色性别职业ID>'])
		创建完毕后，记录变量
		_gaq.push(['ue._setCustomVar', 2, '<角色性别职业ID>'])
		升级：_gaq.push(['ue._trackEvent', 'Level', 'Up', '<角色性别职业ID>', <数字级别>])
		 */
		private static var _instance : GA;

        private var _roleEnterTime:int;	
		private var _roleLoadTime:int;	
		
		
		private var _createNewLoadStart : int;
		private var _createRolePageStayTime : int;
   //创建新角色开始
		
		public function GA()
		{
			if (_instance)
			{
				throw Error("---ScrollMessage--is--a--single--model---");
			}
		}

		public static function get instance() : GA
		{
			if (_instance == null)
			{
				_instance = new GA();
			}
			return _instance;
		}

		public function start() : void
		{
			// 继续上次角色
			GASignals.gaLoginContinueRole.add(onLoginContinueRole);
			// 创建新角色（开始加载）
			GASignals.gaLoginCreateRole.add(onLoginCreateRole);
			// 进入创建新角色页面（加载结束）
			GASignals.gaCreateRoleEnterPage.add(onCreateRoleEnterPage);
			// 角色创建完成
			GASignals.gaCreateRoleComplete.add(onCreateRoleComplete);
			// 预加载资源开始
			GASignals.gaPreLoadAssetStart.add(onPreLoadAssetStart);
			// 预加载资源完成
			GASignals.gaPreLoadAssetComplete.add(onPreLoadAssetComplete);
			// 预加载全部开始
		    GASignals.gaPreLoadAssetAllStart.add(onPreLoadAssetAllStart);
			// 预加载全部完成
			GASignals.gaPreLoadAssetAllComplete.add(onPreLoadAssetAllComplete);
			// 升级
			GASignals.gaRoleLevelUp.add(onRoleLevelUp);
		}

		private function onLoginContinueRole() : void
		{
			
			Logger.info("继续上次角色");
            
			var arr:Array=new Array();
			arr=["ue._trackEvent", "InitGame", "CharCreation", "StartLoading"];
			pushDataToWeb(arr);
		}

		private function onLoginCreateRole() : void
		{
		    Logger.info("创建新角色页面（开始加载）");
			_roleEnterTime=getTimer();
			
			
			var arr:Array=new Array();
			arr=["ue._trackEvent", "PreLoading", "CharCreation", "StartLoading"];
			pushDataToWeb(arr);
		}

		private function onCreateRoleEnterPage() : void
		{
			_roleLoadTime=getTimer()-_roleEnterTime;
			
			_createNewLoadStart=getTimer();
			
		    Logger.info("进入创建新角色页面（加载结束） 加载时间："+_roleLoadTime.toString());
			
			
			var arr:Array=new Array();
			arr=["ue._trackTiming", "PreLoading", "CharCreation", _roleLoadTime, "FinishLoading"];
			pushDataToWeb(arr);
		}

		private function onCreateRoleComplete(jobId:int=0) : void
		{
			_createRolePageStayTime=getTimer()-_createNewLoadStart;
			Logger.info("角色创建完成(点击角色创建按钮)");		

           var arr:Array=new Array();          
		   arr=["ue._trackTiming", "PreLoading", "StayTime", _createRolePageStayTime, "CharCreation"];
		   pushDataToWeb(arr);
		}

		private function onPreLoadAssetStart(assetName:String) : void
		{
		    Logger.info("预加载资源开始");	
		}

		private function onPreLoadAssetComplete(assetName:String) : void
		{
			
			Logger.info("预加载资源完成");	
			try
			{
				if (ExternalInterface.available)
				{
					ExternalInterface.call("PreLoadAssetComplete",assetName);
				}
			}
			catch (e : *)
			{
				throw Error("--function--error--");
			}
		}
		
		private function onPreLoadAssetAllStart():void
		{
	        Logger.info("预加载全部开始");
		    try
			{
				if (ExternalInterface.available)
				{
					ExternalInterface.call("PreLoadAssetAllStart");
				}
			}
			catch (e : *)
			{
				throw Error("--function--error--");
			}
		}

		private function onPreLoadAssetAllComplete() : void
		{
		    Logger.info("预加载全部完成");
		    try
			{
				if (ExternalInterface.available)
				{
					ExternalInterface.call("PreLoadAssetAllComplete");
				}
			}
			catch (e : *)
			{
				throw Error("--function--error--");
			}
		}

		private function onRoleLevelUp(jobId:int,level:int) : void
		{
		   Logger.info("用户升级");
           
		   
		   var userData:Array=new Array();
		   userData=["name","sex",jobId];

		   
		   var arr:Array=new Array();          
		   arr=["ue._trackEvent", "Level", "Up", userData, level];
		   pushDataToWeb(arr);
		}	
		
		private function pushDataToWeb(dataArr:Array):void
		{
//			throw new Error("--function--error--");
		  	try
			{
				if (ExternalInterface.available)
				{
					ExternalInterface.call("gaq_push",dataArr);
				}
			}
			catch (e : *)
			{
				throw new Error("--function--error--");
			}
		}
	}
}
