package game.module.mapGroupBattle.uis
{
    import game.module.mapGroupBattle.auxiliarys.Status;
    import com.utils.StringUtils;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import gameui.core.GComponent;
    import gameui.core.GComponentData;
    import gameui.manager.UIManager;




    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-1-16 ����7:25:16
     */
    public class UiPlayerItem extends GComponent
    {
        /** 状态ICON */
        private var statusIcon : UiPlayerStatusIcon;
        /** 玩家名称 */
        private var playerNameTF : TextField;
        /** 最高连杀 */
        private var maxKillTF : TextField;
        /** 玩家ID */
        public var playerId : int = 0;
        /** 颜色 */
        public var color : uint = 0;

        function UiPlayerItem(playerId : int, playerName : String, color : String, status : int, width : int = 168, height : int = 26) : void
        {
            _base = new GComponentData();
            _base.width = width;
            _base.height = height;
            super(_base);
            // 初始化视图
            initViews();
            this.playerId = playerId;
            this.setPlayerName(playerName, color);
            this.status = status;
        }

        /** 初始化视图 */
        protected function initViews() : void
        {
            // 状态ICON
            statusIcon = new UiPlayerStatusIcon();
            statusIcon.x = 3;
            statusIcon.y = 2;
            addChild(statusIcon);
            // 玩家名称
            var textFormat : TextFormat = new TextFormat();
            textFormat.size = 12;
            textFormat.color = 0x003333;
            textFormat.align = TextFormatAlign.LEFT;
            textFormat.font = UIManager.defaultFont;
            var tempTF : TextField = new TextField();
            tempTF.selectable = false;
            tempTF.defaultTextFormat = textFormat;
            tempTF.width = _base.width;
            tempTF.height = 20;
            tempTF.x = 20;
            tempTF.y = 3;
            tempTF.text = "大海明月";
//            tempTF.filters = [FilterUtils.defaultTextEdgeFilter];
            addChild(tempTF);
            playerNameTF = tempTF;

            // 最高连杀
            textFormat = new TextFormat();
            textFormat.size = 12;
            textFormat.color = 0x2F1F00;
            textFormat.align = TextFormatAlign.RIGHT;
            textFormat.font = UIManager.defaultFont;
            tempTF = new TextField();
            tempTF.selectable = false;
            tempTF.defaultTextFormat = textFormat;
            tempTF.width = 60;
            tempTF.height = 20;
            tempTF.x = 95;
            tempTF.y = 3;
            tempTF.text = "99连杀";
//            tempTF.filters = [FilterUtils.defaultTextEdgeFilter];
            addChild(tempTF);
            maxKillTF = tempTF;
        }

        /** 玩家状态 */
        public function get status() : int
        {
            if (statusIcon)
            {
                return statusIcon.status;
            }
            return Status.UNKNOW;
        }

        public function set status(value : int) : void
        {
            if (statusIcon)
            {
                statusIcon.status = value;
            }

            if (value == Status.DIE)
            {
                if (playerNameTF)
                {
                    playerNameTF.textColor = 0x999999;
                }
            }
            else
            {
                if (playerNameTF)
                {
                    playerNameTF.textColor = color;
                }
            }
        }

        /** 最高连杀 */
        public function set maxKill(value : int) : void
        {
            maxKillTF.text = value + "连杀";
        }

        /** 设置玩家名称 */
        public function setPlayerName(value : String, colorStr : String) : void
        {
            color = StringUtils.StringToColor(colorStr);
            if (playerNameTF)
            {
                playerNameTF.htmlText = value;
                playerNameTF.textColor = color;
                // playerNameTF.htmlText = "<font color='" + colorStr + "'>" + value + "</font>";
            }
        }

        /** 添加到列表 */
        public function addToList() : void
        {
        }

        /** 退出 */
        public function quit() : void
        {
            if(playerList) playerList.removePlayerItem(playerId, true);
        }

        public function get playerList() : UiPlayerList
        {
            if (this.parent && this.parent.parent)
            {
                return this.parent.parent as UiPlayerList;
            }
            return null;
        }
    }
}
