package game.module.mapGroupBattle.uis
{
    import game.module.mapGroupBattle.GBData;
    import game.module.mapGroupBattle.GBProto;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import gameui.core.GComponent;
    import gameui.core.GComponentData;
    import gameui.data.GToolTipData;
    import gameui.manager.UIManager;



    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-1-30 ����2:18:22
     */
    public class UiGroup extends GComponent
    {
        /** 阵营名称 */
        private var groupNameTF : TextField;
        /** 人数 */
        private var _playerCount : int = 0;
        /** 积分 */
        private var _score : int = 0;
        /** 阵营ID */
        public var groupId : int = 0;

        public function UiGroup(width : int, height : int)
        {
            _base = new GComponentData();
            _base.width = width;
            _base.height = height;
            _base.toolTipData = new GToolTipData();
            super(_base);
            initViews();

            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        }

        private function onMouseOver(event : MouseEvent) : void
        {
            GBProto.instance.cs_groupInfo(groupId);
        }

        /** 初始化元件 */
        protected function initViews() : void
        {
            // 阵营名称
            var textFormat : TextFormat = new TextFormat();
            textFormat.size = 12;
            textFormat.color = 0xFFFFFF;
            textFormat.align = TextFormatAlign.CENTER;
            textFormat.font = UIManager.defaultFont;
            var tempTF : TextField = new TextField();
            tempTF.selectable = false;
            tempTF.defaultTextFormat = textFormat;
            tempTF.width = 120;
            tempTF.height = 20;
            tempTF.x = (_base.width - tempTF.width) / 2;
            tempTF.y = 0;
            tempTF.text = "朱雀组(1-69级)";
            addChild(tempTF);
            groupNameTF = tempTF;

            setTip(0, 0);
        }

        /** 设置组名 */
        public function setGroupName(name : String, colorStr : String, minLevel : int, maxLevel : int) : void
        {
            var str : String = "<font color='" + colorStr + "' size='14'><b>" + name + "</b></font>";
            if (GBData.hasHighLevel == true)
            {
                if (maxLevel < 0)
                {
                    str += "(" + minLevel + "级以上)";
                }
                else
                {
                    str += "(" + minLevel + "-" + maxLevel + "级)";
                }
            }
            groupNameTF.htmlText = str;
        }

        /** 设置Tip */
        public function setTip(playerCount : int, score : int) : void
        {
            this.toolTip.source = "人数：" + playerCount + "\n积分：" + score;
        }

        /** 玩家数量 */
        public function set playerCount(value : int) : void
        {
            _playerCount = value;
            setTip(_playerCount, _score);
        }

        /** 积分 */
        public function set score(value : int) : void
        {
            _score = value;
            setTip(_playerCount, _score);
        }
    }
}
