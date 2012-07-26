/* ----------------------------------------------------------------------------------------------------------------------------------------------- /

Download - 资源加载 - NEROKING.COM

< --- Public Vars ------------------------------------------------------------------------------------------------------------------------------ >

※ 提示回调函数传递 Loader 本身的常量（静态，常量）
public static const SELF:String = "Download_SELF";

※ 下载线程数（静态）
public static var thread:int = 3;

< --- Public Functions ------------------------------------------------------------------------------------------------------------------------ >

※ 加载资源（静态）
public static function load(url:String,onComplete:Function=null,onCompleteParams:Array=null,onError:Function=null,onErrorParams:Array=null,priority:Boolean=false,context:LoaderContext=null):Loader
@url:String - 下载资源的URL（绝对路径）
@onComplete:Function = null - 下载成功后执行的函数
@onCompleteParams:Array = null - 下载成功后执行函数的参数 ( 想传递Download实例本身请向数组内传入 Download.SELF )
@onError:Function = null - 下载失败时执行的函数
@onErrorParams:Array = null - 下载失败时执行函数的参数 ( 想传递Download实例本身请向数组内传入 Download.SELF )
@priority:Boolean = false - 是否优先加载
@context:LoaderContext = null - 用于定义程序域的 LoaderContext 对象

※ 中断加载（静态）
public static function kill(loader:Loader):void
@loader:Loader - 需要中断加载的 Loader

※ 添加预载（静态）
public static function addPreload(url:String,context:LoaderContext=null):void
@url:String - 预载资源的URL（绝对路径）
@context:LoaderContext = null - 用于定义程序域的 LoaderContext 对象

※ 取消预载（静态）
public static function removePreload(url:String):void
@url:String - 预载资源的URL（绝对路径）

※ 取消所有预载（静态）
public static function removeAllPreload():void

※ 返回加载百分比（静态，返回 0 - 100，只对3K以上文件有效）
public static function getPercent(loader:Loader):int
@loader:Loader - 需要返回加载百分比的 Loader

/ ----------------------------------------------------------------------------------------------------------------------------------------------- */
package com.utils
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.setTimeout;

	public class Download
	{
		// --- Vars ------------------------------------------------------------------------------------------------------------------------------- //
		// 提示回调函数传递 Loader 本身的常量
		public static const SELF : String = "Download_SELF";

		// 同时加载的线程数
		public static var thread : uint = 3;

		// 载入失败后重新尝试载入的次数
		private static var reloadNum : uint = 2;

		// 是否正在预载
		private static var preloading : Boolean = false;

		// 正在下载的序列组
		private static var loadingList : Vector.<Loader> = new Vector.<Loader>();

		private static var loadingConfigs : Vector.<LoaderConfig> = new Vector.<LoaderConfig>();

		// 等待下载的序列组
		private static var waitingList : Vector.<Loader> = new Vector.<Loader>();

		private static var waitingConfigs : Vector.<LoaderConfig> = new Vector.<LoaderConfig>();

		// 预加载的序列组
		private static var preloadList : Vector.<Loader> = new Vector.<Loader>();

		private static var preloadConfigs : Vector.<LoaderConfig> = new Vector.<LoaderConfig>();

		// 已完成加载的资源URL列表
		private static var loadedList : Vector.<String> = new Vector.<String>();

		// --- Public Functions ------------------------------------------------------------------------------------------------------------------ //
		// 加载资源
		public static function load(url : String, onComplete : Function = null, onCompleteParams : Array = null, onError : Function = null, onErrorParams : Array = null, priority : Boolean = false, context : LoaderContext = null) : Loader
		{
			// 停止预载
			stopPreload_func();

			// 过滤预载列表
			removePreload(url);

			// 建立 Loader 及 LoaderConfig
			var loader : Loader = getResource_func(url);
			var loaderConfig : LoaderConfig = new LoaderConfig();
			loaderConfig.url = url;
			loaderConfig.onComplete = onComplete;
			loaderConfig.onCompleteParams = onCompleteParams;
			loaderConfig.onError = onError;
			loaderConfig.onErrorParams = onErrorParams;
			loaderConfig.context = context;
			loaderConfig.reloadNum = reloadNum;

			// 预载处理
			if (loader.content != null)
			{
				if (loaderConfig.onComplete != null)
				{
					setTimeout(delayRun_func,100,loader,loaderConfig);
				}
				return loader;
			}

			// 添加侦听事件
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete_func);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError_func);

			// 序列判断
			if (loadingList.length < thread)
			{
				loadingList.push(loader);
				loadingConfigs.push(loaderConfig);
				loader.load(new URLRequest(loaderConfig.url),loaderConfig.context);
				loaderConfig.loading = true;
			}
			else
			{
				if (priority)
				{
					waitingList.unshift(loader);
					waitingConfigs.unshift(loaderConfig);
				}
				else
				{
					waitingList.push(loader);
					waitingConfigs.push(loaderConfig);
				}
			}

			// 返回
			return loader;
		}

		// 中断加载
		public static function kill(loader : Loader) : void
		{
			// 移除侦听
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadComplete_func);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loadError_func);

			// 移除 Loader 以及 LoaderConfig
			var index : int = loadingList.indexOf(loader);
			if (index != -1)
			{
				if (loadingConfigs[index].loading)
				{
					try
					{
						loader.close();
						loader.unloadAndStop();
					}
					catch(e : IOError)
					{
					}
				}
				loadingList.splice(index,1);
				loadingConfigs.splice(index,1);
			}
			else
			{
				index = waitingList.indexOf(loader);
				if (index != -1)
				{
					waitingList.splice(index,1);
					waitingConfigs.splice(index,1);
					loader.unloadAndStop();
				}
				else
				{
					return;
				}
			}

			// 调整加载序列
			if (waitingList.length > 0)
			{
				var length : int = waitingList.length;
				for (var i : int = 0 ; i < length ; i++)
				{
					if (loadingList.length < thread)
					{
						// 向正在加载序列添加 Loader 及 LoaderConfig
						waitingList[0].load(new URLRequest(waitingConfigs[0].url),waitingConfigs[0].context);
						waitingConfigs[0].loading = true;
						loadingList.push(waitingList.shift());
						loadingConfigs.push(waitingConfigs.shift());
					}
					else
					{
						return;
					}
				}
			}
			else if (loadingList.length == 0)
			{
				// 开始预载
				startPreload_func();
			}
		}

		// 添加预载
		public static function addPreload(url : String, context : LoaderContext = null) : void
		{
			// 过滤已经下载完成的资源路径
			var length : int = loadedList.length;
			for (var i : int = 0 ; i < length ; i++)
			{
				if (loadedList[i] == url)
				{
					return;
				}
			}

			// 添加预载数据
			var loaderConfig : LoaderConfig = new LoaderConfig();
			loaderConfig.url = url;
			loaderConfig.context = context;
			preloadConfigs.push(loaderConfig);

			// 触发预载
			if (loadingList.length == 0 && waitingList.length == 0)
			{
				startPreload_func();
			}
		}

		// 取消预载
		public static function removePreload(url : String) : void
		{
			var length : int = preloadConfigs.length;
			for (var i : int = 0 ; i < length ; i++)
			{
				if (preloadConfigs[i].url == url)
				{
					if (preloading && i == 0)
					{
						return;
					}
					else
					{
						preloadConfigs.splice(i,1);
						return;
					}
				}
			}
		}

		// 取消所有预载
		public static function removeAllPreload() : void
		{
			if (preloading)
			{
				preloadConfigs.splice(1,preloadConfigs.length - 1);
			}
			else
			{
				preloadConfigs.splice(0,preloadConfigs.length);
			}
		}

		// --- Private Functions ----------------------------------------------------------------------------------------------------------------- //
		// 提取预载完成的资源
		private static function getResource_func(url : String) : Loader
		{
			var length : int = preloadList.length;
			for (var i : int = 0 ; i < length ; i++)
			{
				if (preloadList[i].contentLoaderInfo.url == url)
				{
					return preloadList.splice(i,1)[0];
				}
			}
			return new Loader();
		}

		// 载入完成
		private static function loadComplete_func(evt : Event) : void
		{
			var index : int = loadingList.indexOf(LoaderInfo(evt.target).loader);
			var onComplete : Function = loadingConfigs[index].onComplete;
			var onCompleteParams : Array = loadingConfigs[index].onCompleteParams;

			// 加载成功时执行函数
			if (onComplete != null)
			{
				if (onCompleteParams != null)
				{
					var SelfIndex : int = onCompleteParams.indexOf(Download.SELF);
					if (SelfIndex != -1)
					{
						onCompleteParams.splice(SelfIndex,1,LoaderInfo(evt.target).loader);
					}
				}
				onComplete.apply(null,onCompleteParams);
			}

			// 提示不在载入中
			loadingConfigs[index].loading = false;

			// 加入已经完成下载的资源列表
			loadedList.push(LoaderInfo(evt.target).url);

			// 结束加载线程
			kill(LoaderInfo(evt.target).loader);
		}

		// 载入失败
		private static function loadError_func(evt : IOErrorEvent) : void
		{
			var index : int = loadingList.indexOf(LoaderInfo(evt.target).loader);
			var onError : Function = loadingConfigs[index].onError;
			var onErrorParams : Array = loadingConfigs[index].onErrorParams;

			// 重试下载
			loadingConfigs[index].reloadNum--;
			if (loadingConfigs[index].reloadNum >= 0)
			{
				LoaderInfo(evt.target).loader.load(new URLRequest(loadingConfigs[index].url),loadingConfigs[index].context);
			}
			else
			{
				// 加载失败时执行函数
				if (onError != null)
				{
					if (onErrorParams != null)
					{
						var SelfIndex : int = onErrorParams.indexOf(Download.SELF);
						if (SelfIndex != -1)
						{
							onErrorParams.splice(SelfIndex,1,LoaderInfo(evt.target).loader);
						}
					}
					onError.apply(null,onErrorParams);
				}

				//trace("warring ---> url unable load : " + loadingConfigs[index].url);

				// 提示不在载入中
				loadingConfigs[index].loading = false;

				// 结束加载线程
				kill(LoaderInfo(evt.target).loader);
			}
		}

		// 开始预载
		private static function startPreload_func() : void
		{
			if (preloadConfigs.length > 0)
			{
				preloading = true;
				var loader : Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,preloadEvent_func);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,preloadEvent_func);
				loader.load(new URLRequest(preloadConfigs[0].url),preloadConfigs[0].context);
				preloadList.push(loader);
			}
			else
			{
				preloading = false;
			}
		}

		// 停止预载
		private static function stopPreload_func() : void
		{
			if (preloading)
			{
				preloading = false;
				var length : int = preloadList.length;
				var loader : Loader = preloadList.splice(length - 1,1)[0];
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,preloadEvent_func);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,preloadEvent_func);
				loader.close();
				loader.unloadAndStop();
			}
		}

		// 预载侦听
		private static function preloadEvent_func(evt : Event) : void
		{
			var length : int = preloadList.length;
			preloadList[length - 1].contentLoaderInfo.removeEventListener(Event.COMPLETE,preloadEvent_func);
			preloadList[length - 1].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,preloadEvent_func);
			if (evt.type == Event.COMPLETE)
			{
				loadedList.push(preloadList[length - 1].contentLoaderInfo.url);
			}
			else
			{
				var loader : Loader = preloadList.splice(length - 1,1)[0];
				loader.unloadAndStop();
			}
			preloadConfigs.shift();
			startPreload_func();
		}

		// 延迟执行回调函数
		private static function delayRun_func(loader : Loader, loaderConfig : LoaderConfig) : void
		{
			var onComplete : Function = loaderConfig.onComplete;
			var onCompleteParams : Array = loaderConfig.onCompleteParams;

			if (onCompleteParams != null)
			{
				var SelfIndex : int = onCompleteParams.indexOf(Download.SELF);
				if (SelfIndex != -1)
				{
					onCompleteParams.splice(SelfIndex,1,loader);
				}
			}
			onComplete.apply(null,onCompleteParams);
		}
	}
}
