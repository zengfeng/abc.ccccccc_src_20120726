package game.module.chat.view
{
    import com.commUI.button.KTButtonData;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import game.module.chat.ChatUntils;
    import game.module.chat.EventChat;
    import game.module.chat.VoChannel;
    import game.module.chat.config.ChannelId;
    import game.module.chat.config.ChatConfig;
    import gameui.controls.GButton;
    import gameui.core.GComponent;
    import gameui.core.GComponentData;
    import gameui.core.ScaleMode;
    import gameui.data.GButtonData;
    import net.AssetData;




    public class ChannelComboBox extends GComponent
    {
        /** 当前按钮 */
        public var currentButton : GButton;
        /** 弹出框 */
        protected var poupList : PoupList;
        /** 当前选中的频道 */
        private var _selectedVo : VoChannel = ChatConfig.defaultInputChannel;

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 频道选择框 */
        public function ChannelComboBox()
        {
            _base = new GComponentData();
            _base.width = 47;
            _base.height = 26;
            super(_base);
            initEvents();
        }

        /** 初始化子组件 */
        override protected function create() : void
        {
            // 当前按钮
            var buttonData : GButtonData = new KTButtonData(KTButtonData.ALERT_BUTTON);
            buttonData.scaleMode = ScaleMode.SCALE9GRID;
            buttonData.width = 47;
            buttonData.height = 26;
			buttonData.labelData.textFormat.font = ChatUntils.font;
			buttonData.labelData.textFieldFilters = ChatUntils.textEdgeFilter;
            buttonData.labelData.text = selectedVo.name;
            currentButton = new GButton(buttonData);
            currentButton.resetColor(selectedVo.color, selectedVo.color);
            addChild(currentButton);
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        protected function initEvents() : void
        {
            // 当前按钮 点击事件
            currentButton.addEventListener(MouseEvent.CLICK, currentButton_clickHandler);
            // 按下事件
            this.addEventListener(MouseEvent.MOUSE_DOWN, eventStopPropagation);
        }

        /** 阻止事件流传递 */
        protected function eventStopPropagation(event : MouseEvent) : void
        {
            event.stopPropagation();
        }

        /** 当前按钮 点击事件 */
        private function currentButton_clickHandler(event : MouseEvent) : void
        {
            if (poupList == null)
            {
                var globalPoint : Point = this.localToGlobal(new Point(0, 0));
                poupList = new PoupList(this.stage, globalPoint);
                poupList.isShowWhisper = isShowWhisper;
                poupList.addEventListener(EventChat.CHANNEL_CHANGE, poupList_channelChangeHandler);
            }
            poupList.isOpen = !poupList.isOpen;
        }

        /** 弹出列表选择事件 */
        private function poupList_channelChangeHandler(event : EventChat) : void
        {
            selectedVo = event.voChannel;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 当前选中的频道 */
        public function get selectedVo() : VoChannel
        {
            return _selectedVo;
        }

        public function set selectedVo(vo : VoChannel) : void
        {
            var ids : Array = [ChannelId.SYSTEM, ChannelId.PROMPT];
            if (ids.indexOf(vo.id) != -1) return;
            if (vo.id == ChannelId.ALL) vo = ChatConfig.worldVo;
            _selectedVo = vo;
            currentButton.label.text = _selectedVo.name;
            currentButton.resetColor(_selectedVo.color, _selectedVo.color);
            // 抛出事件
            var eventChat : EventChat = new EventChat(EventChat.CHANNEL_CHANGE, true);
            eventChat.voChannel = _selectedVo;
            dispatchEvent(eventChat);
        }

        /** 是否显示私聊 */
        private var _isShowWhisper : Boolean = true;

        /** 是否显示私聊 */
        public function set isShowWhisper(value : Boolean) : void
        {
            _isShowWhisper = value;
            if (poupList) poupList.isShowWhisper = _isShowWhisper;
        }
        
        public function get isShowWhisper() : Boolean
        {
            return _isShowWhisper;
        }
        
    }
}
import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.Dictionary;
import game.module.chat.ChatUntils;
import game.module.chat.EventChat;
import game.module.chat.VoChannel;
import game.module.chat.config.ChannelId;
import game.module.chat.config.ChatConfig;
import game.module.chat.view.PoupPanel;
import gameui.controls.GButton;
import gameui.data.GButtonData;
import gameui.data.GPanelData;
import net.AssetData;
import utils.DictionaryUtil;





class PoupList extends PoupPanel
{
    /** 竖间距 */
    protected var vGap : uint = 0;
    /** 边距 */
    protected var paddingH : uint = 1;
    protected var paddingV : uint = 3;
    protected var itemWidth : uint = 45;
    protected var itemHeight : uint = 18;
    protected var minHeight : uint = 20;
    // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
    public var itemDic : Dictionary = new Dictionary();

    function PoupList(parentContainer : DisplayObjectContainer, globalPoint : Point, panelData : GPanelData = null)
    {
        if (panelData == null)
        {
            panelData = new GPanelData();
            panelData.bgAsset = new AssetData("GToolTip_backgroundSkin");
            panelData.width = 47;
        }
        super(parentContainer, globalPoint, panelData);
    }

    /**
     * 创建子组件
     * */
    override protected function installChild() : void
    {
        var channelId : int;
        var vo : VoChannel;
        var item : GButton;
        var buttonData : GButtonData = new GButtonData();
        buttonData.width = 45;
        buttonData.height = 24;
        buttonData.upAsset = new AssetData("GListItemSkin_Up");
        buttonData.overAsset = new AssetData("GListItemSkin_Over");
        buttonData.downAsset = new AssetData("GListItemSkin_Down");
        buttonData.disabledAsset = new AssetData("GListItemSkin_Up");
        buttonData.disabledColor = 0x666666;
        var i : uint;
        for (i = 0; i < ChatConfig.inputChannels.length; i++)
        {
            channelId = ChatConfig.inputChannels[i];
            vo = ChatConfig.channelVoDic[channelId];
            buttonData = buttonData.clone();
			buttonData.labelData.textFormat.font = ChatUntils.font;
			buttonData.labelData.textFieldFilters= ChatUntils.textEdgeFilter;
            buttonData.labelData.text = vo.name;
            buttonData.labelData.textColor = vo.color;
            item = new GButton(buttonData);
            item.resetColor(vo.color, vo.color);
            item.source = vo;
            item.enabled = vo.enable;
            itemDic[vo.id] = item;
            add(item);
            item.addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
        }
        var items : Array = DictionaryUtil.getValues(itemDic);
        var postionX : int = paddingH;
        var postionY : int = paddingV;
        for (i = 0; i < items.length; i++)
        {
            item = items[i];
            item.x = postionX;
            item.y = postionY;
            postionY += item.height + vGap;
        }

        this.width = item.width + paddingH * 2 ;
        this.height = (item.height + vGap) * i + paddingV * 2 - vGap;
    }

    /** 子项布局 */
    protected function layoutItems() : void
    {
        var postionY : int = paddingV;
        var item : GButton;
        var vo : VoChannel;
        var items : Array = DictionaryUtil.getValues(itemDic);
        var j:uint = 0;
        for (var i : int = 0; i < items.length; i++)
        {
            item = items[i];
            vo = item.source;
            if (vo.id == ChannelId.WHISPER && isShowWhisper == false) continue;
            item.y = postionY;
            postionY += item.height + vGap;
            j++;
        }
        this.height = (item.height + vGap) * j + paddingV * 2 - vGap;
    }

    /** 是否显示私聊 */
    private var _isShowWhisper : Boolean = true;

    /** 是否显示私聊 */
    public function set isShowWhisper(value : Boolean) : void
    {
        if (_isShowWhisper == value) return;
        _isShowWhisper = value;
        var item : GButton = itemDic[ChannelId.WHISPER];
        if (item) item.visible = value;
        layoutItems();
    }

    public function get isShowWhisper() : Boolean
    {
        return _isShowWhisper;
    }

    private function item_mouseDownHandler(event : MouseEvent) : void
    {
        var item : GButton = event.currentTarget as GButton;
        // 抛出事件
        var eventChat : EventChat = new EventChat(EventChat.CHANNEL_CHANGE, true);
        eventChat.voChannel = item.source as VoChannel;
        dispatchEvent(eventChat);
        this.isOpen = false;
    }
}