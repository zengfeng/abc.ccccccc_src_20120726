package com.utils
{
	import cmodule.pathc.CLibInit;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-19
	 */
	public class Arithmetic
	{
		/** 单例对像 */
		private static var _instance : Arithmetic;

		/** 获取单例对像 */
		private static  function get instance() : Arithmetic
		{
			if (_instance == null)
			{
				_instance = new Arithmetic(new Singleton());
			}
			return _instance;
		}

		function Arithmetic(singleton : Singleton) : void
		{
			singleton;
			_lib = new CLibInit();
			_arithmetic = _lib.init();
		}

		private var _lib : CLibInit;
		private var _arithmetic : *;

		public static function get lib() : *
		{
			return instance._arithmetic;
		}
	}
}
class Singleton
{
}