package com.utils
{
	import flash.system.LoaderContext;
	/**
	 * @author yangyiqiang
	 */
	public class LoaderConfig
	{
		public var url : String;

		public var onComplete : Function;

		public var onCompleteParams : Array;

		public var onError : Function;

		public var onErrorParams : Array;

		public var context : LoaderContext;

		public var reloadNum : int;

		public var loading : Boolean = false;
	}
}
