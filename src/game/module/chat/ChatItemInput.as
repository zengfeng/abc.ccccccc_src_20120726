package game.module.chat
{
    import flash.utils.Dictionary;
    import game.core.item.Item;


    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-31 ����2:35:36
     */
    public class ChatItemInput
    {
        function ChatItemInput(singleton : Singleton) : void
        {
            singleton;
        }

        /** 单例对像 */
        private static var _instance : ChatItemInput;

        /** 获取单例对像 */
        public static function get instance() : ChatItemInput
        {
            if (_instance == null)
            {
                _instance = new ChatItemInput(new Singleton());
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** infoDic[key] = info */
        public var infoDic : Dictionary = new Dictionary();
        /** keyDic[info] = key */
        public var keyDic : Dictionary = new Dictionary();
        public var length : int = 0;
        public var maxLength : int = 100;
        private var reText : String;

        public function clear() : void
        {
            reText = null;
            length = 0;
            for (var key:String in infoDic)
            {
                delete infoDic[key];
            }

            for (var info:String in keyDic)
            {
                delete infoDic[info];
            }
        }

        public function get regExp() : RegExp
        {
            if (reText == null || reText == "")
            {
                return null;
            }
            return new RegExp(reText, "img");
        }

        /** 插入Item */
        public function insertItem(info : String, name : String, color : Number) : String
        {
            var key : String = keyDic[info];
            if (key == null)
            {
                key = name + length;
                infoDic[key] = [info, name, color];
                keyDic [info] = key;
                length++;
            }

            if (!reText)
            {
                reText = key;
            }
            else
            {
                reText += "|" + key;
            }
            return key;
        }

        /** 调用filterInfo调用的次数 */
        private var userFilterInfoCount : int = 0;

        /** 过滤输入信息 */
        public function filterInfo(str : String) : String
        {
            if (regExp == null || str == null || str == "" || str.length < 3) return str;
            // 根据正则替换字符串
            str = str.replace(regExp, regHandler);
            userFilterInfoCount++;
            if (userFilterInfoCount > 10)
            {
                reText = null;
            }
            return str;
        }

        /**  处理过滤的函数 */
        private function regHandler() : String
        {
            // 获取正则获取的字符串
            var key : String = arguments[0];
            var arr : Array = infoDic[key];
            // 替换成*
            return ChatTag.item(arr[0], arr[1], arr[2]);
        }

        /** 
         * 插入ITEM 缓存输入发送前
         * @return key
         */
        public static function insert(info : String, name : String, color : Number) : String
        {
            return ChatItemInput.instance.insertItem(info, name, color);
        }

        /** 过滤输入信息 */
        public static function getFilterStr(str : String) : String
        {
            return ChatItemInput.instance.filterInfo(str);
        }
    }
}
class Singleton
{
}
