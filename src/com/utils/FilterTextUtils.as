package com.utils
{
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-30 ����4:44:05
     * 过滤文本
     */
    public class FilterTextUtils
    {
        public function FilterTextUtils(singleton : Singleton)
        {
            singleton;
        }

        /** 单例对像 */
        private static var _instance : FilterTextUtils;

        /** 获取单例对像 */
        static public function get instance() : FilterTextUtils
        {
            if (_instance == null)
            {
                _instance = new FilterTextUtils(new Singleton());
            }
            return _instance;
        }
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        public static var text:String;
		public static var textF:String;
        private var _regExp:RegExp;
		private var _regExpF:RegExp;
        public function get regExp():RegExp
        {
            if(_regExp == null && text != null)
            {
                _regExp = new RegExp("(" + text + ")+?","img");
            }
            return _regExp;
        }
		public function get regExpF():RegExp
        {
            if(_regExpF == null && textF != null)
            {
                _regExpF = new RegExp("(" + textF + ")+?","img");
            }
            return _regExpF;
        }
		
		/** 验证文本 */
        public function checkStr(str:String):Boolean
        {
            if(str == null) return false;
			if(regExp == null || regExpF == null) return true;
			regExp.lastIndex = 0;
			regExpF.lastIndex = 0;
			var isReg:Boolean;
			if(regExp.test(str) || regExpF.test(str))
				isReg = true;
			else
				isReg = false;
			regExp.lastIndex = 0;
			regExpF.lastIndex = 0;
			return isReg;
        }
        
        /** 获取过滤文本 */
        public function getFilterStr(str:String):String
        {
            if(str == null || regExp == null|| regExpF == null) return str;
       		//根据正则替换字符串
			regExp.lastIndex = 0;
			regExpF.lastIndex = 0;
			if(regExpF.test(str)){
				str = str.replace(regExpF,regHandlerF);
			}
			if(regExp.test(str)){
				str = str.replace(regExp,regHandler);
			}
            return str;
        }
		/**  处理过滤的函数 */       	
       	private function regHandlerF():String
       	{
       		//获取正则获取的字符串
			var s:String = String(arguments[0]);
			//替换成*
			var str:String = s.replace(/.{1}/g,"*");
			return str;
       	}
        
       	/**  处理过滤的函数 */       	
       	private function regHandler():String
       	{
       		//获取正则获取的字符串
			var s:String = String(arguments[0]);
			//替换成*
			var str:String = s.replace(/.{1}/g,"*");
			return str;
       	}
        
        public static function getFilterStr(str:String):String
        {
            return FilterTextUtils.instance.getFilterStr(str);
        }
		
		public static function checkStr(str:String):Boolean
        {
            return FilterTextUtils.instance.checkStr(str);
        }
    }
}
class Singleton
{
    
}