package game.module.chat.view
{
    import flash.display.DisplayObjectContainer;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import game.module.chat.EventChat;
    import game.module.friend.ManagerFriend;
    import game.module.friend.VoFriendItem;
    import gameui.data.GPanelData;
    import net.AssetData;




    public class PlayerList extends PoupPanel
    {
        /** 竖间距 */
        private var _vGap : uint = 0;
        /** 边距 */
        private var _paddingH : uint = 3;
        private var _paddingV : uint = 6;
        private var _itemWidth : uint = 130;
        private var _itemHeight : uint = 18;
        /** 最近联系人列表 */
        protected var lastLinkData : Vector.<VoFriendItem> = ManagerFriend.getInstance().getLastLinkData();
        /** 最多缓存最近玩家条数 */
        public var maxItemsNum : uint = 10;
        private var _minHeight : uint = 150;
        public var items : Vector.<PlayerListItem> = new Vector.<PlayerListItem>();

        public function PlayerList(parentContainer : DisplayObjectContainer, globalPoint : Point, panelData : GPanelData = null)
        {
            if (panelData == null)
            {
                panelData = new GPanelData();
                panelData.bgAsset = new AssetData("GToolTip_backgroundSkin");
                panelData.width = 200;
                panelData.height = 150;
            }
            super(parentContainer, globalPoint, panelData);
        }

        /** 更新子组件 */
        private function updateItems() : void
        {
            var i : int = 0;
            var item : PlayerListItem;
            var voFriendItem : VoFriendItem;

            // 更新之前的
            for (i = 0; i < items.length; i++)
            {
                // 如果没有那么多好友就返回
                if (i >= lastLinkData.length || lastLinkData.length == 0)
                {
                    updateLayout(i);
                    return;
                }
                voFriendItem = lastLinkData[i];

                item = items[i];
                item.playerName = voFriendItem.name;
                item.x = _paddingH;
                item.y = _paddingV + (_itemHeight + _vGap) * i;
                add(item);
            }

            // 之前的不够更新则创建新的
            for (i; i < maxItemsNum; i++)
            {
                // 如果没有那么多好友就返回
                if (i >= lastLinkData.length || lastLinkData.length == 0)
                {
                    updateLayout(i);
                    return;
                }
                voFriendItem = lastLinkData[i];
                item = new PlayerListItem(voFriendItem.name, _itemWidth, _itemHeight);
                item.x = _paddingH;
                item.y = _paddingV + (_itemHeight + _vGap) * i;
                items.push(item);
                item.addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
                add(item);
            }
        }

        private function updateLayout(count : int) : void
        {
            var item : PlayerListItem;
            for (var i : int = count; i < items.length; i++)
            {
                item = items[i];
                if (item && item.parent)
                {
                    item.parent.removeChild(item);
                }
            }

            this.width = _itemWidth + _paddingH * 2 ;
            var _height : uint = (_itemHeight + _vGap) * ( count + 1) + _paddingV * 2 - _vGap;
            this.height = _height < _minHeight ? _minHeight : _height;
        }

        private function item_mouseDownHandler(event : MouseEvent) : void
        {
            var eventChat : EventChat = new EventChat(EventChat.SELECTED_PLAYER, true, true);
            var item : PlayerListItem = event.currentTarget as PlayerListItem;
            eventChat.playerName = item.playerName;
            dispatchEvent(eventChat);
            isOpen = false;
        }

        override public function set isOpen(value : Boolean) : void
        {
            super.isOpen = value;
            if (isOpen == true)
            {
                updateItems();
            }
        }
    }
}
import gameui.controls.GLabel;
import gameui.data.GLabelData;
import gameui.manager.UIManager;

import net.AssetData;

import com.utils.DrawUtils;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class PlayerListItem extends Sprite
{
    private var _playerName : String;
    private var label : GLabel;
    private var bg : DisplayObject;
    private var _color : uint = 0x7cb3ff;
    private var _overColor : uint = 0xFFFFFF;

    function PlayerListItem(playerName : String, width : uint = 100, height : uint = 20) : void
    {
        _playerName = playerName;

        DrawUtils.roundRect(this, width, height, 1, 0, 0x000000, 0x0b3452, 0.01, 0.3);
        bg = UIManager.getUI(new AssetData("GListItemSkin_Over"));
        bg.width = width;
        bg.height = height;
        bg.visible = false;
        addChild(bg);
        this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        this.addEventListener(Event.REMOVED, removedHandler);

        var labelData : GLabelData = new GLabelData();
        labelData.text = playerName.toString();
        labelData.textColor = _color;
        labelData.x = 10;
        labelData.width = width - labelData.x * 2;
        label = new GLabel(labelData);
        label.y = (height - label.height) / 2;
        addChild(label);
    }

    private function removedHandler(event : Event) : void
    {
        this.removeEventListener(Event.REMOVED, removedHandler);
        this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
    }

    private function mouseOutHandler(event : MouseEvent) : void
    {
        label.textColor = _color;
        bg.visible = false;
    }

    private function mouseOverHandler(event : MouseEvent) : void
    {
        label.textColor = _overColor;
        bg.visible = true;
    }

    public function get playerName() : String
    {
        return _playerName;
    }

    public function set playerName(name : String) : void
    {
        _playerName = name;
        label.text = _playerName;
    }
}