package game.module.chat
{
    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-14  ����3:20:07 
     */
    public class VoChannel
    {
        /** ID */
        public var id : uint;
        /** 名称 */
        public var name : String;
        /** 颜色 */
        public var color : uint;
        /** 是否能用 */
        public var enable:Boolean = true;
        /** 是否开放 */
        public var isOpen:Boolean = true;
		
        function VoChannel(id:uint, name:String, color:uint, enable:Boolean = true, isOpen:Boolean = true):void
        {
            this.id = id;
            this.name = name;
            this.color = color;
            this.enable = enable;
            this.isOpen = isOpen;
			
        }
    }
}
