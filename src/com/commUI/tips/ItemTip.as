package com.commUI.tips
{
    import com.commUI.tooltip.ToolTip;
    import com.commUI.tooltip.ToolTipData;
    import com.utils.ItemUtils;
    import com.utils.UIUtil;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;
    import game.core.item.Item;
    import game.core.item.ItemChatInterface;
    import game.core.item.ItemManager;
    import gameui.manager.UIManager;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-29 ����10:46:12
     */
    public class ItemTip
    {
        function ItemTip(singleton : Singleton)
        {
        }

        private static var _instance : ItemTip;

        public static function  get instance() : ItemTip
        {
            if (_instance == null)
            {
                _instance = new ItemTip(new Singleton());
            }
            return _instance;
        }

        public function get stage() : Stage
        {
            return UIUtil.stage;
        }

        public function get root() : Sprite
        {
            return UIManager.root;
        }

        public function layout() : void
        {
            if (tip == null) return;
            tip.x = root.mouseX;
            tip.y = root.mouseY;
            if (tip.x + tip.width + 10 > stage.stageWidth)
            {
                tip.x = UIManager.stage.mouseX - tip.width;
            }

            if (tip.y + tip.height + 10 > stage.stageHeight)
            {
                tip.y = UIManager.stage.mouseY - tip.height;
            }
        }

        private var tipDic : Dictionary = new Dictionary();

        private function setTitp(tipClass : Class, item : Item) : ToolTip
        {
            var tip : ToolTip = tipDic[tipClass];
            if (tip == null)
            {
                var data : ToolTipData = new ToolTipData();
                tip = new tipClass(data);
                tipDic[tipClass] = tip;
            }
            tip.source = item;
            return tip;
        }

        /** 当前TIP */
        public var tip : DisplayObject;

        public function setId(id : int) : void
        {
            close();
            var item : Item = ItemManager.instance.newItem(id);
            var tipClass : Class = ItemUtils.getItemToolTipClass(item);
            tip = setTitp(tipClass, item);
            layout();
            root.addChild(tip);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, close);
        }

        public function setInfo(info : String) : void
        {
            close();
            var item : Item = ItemChatInterface.decodeStringToItem(info);
            var tipClass : Class = ItemUtils.getItemToolTipClass(item);
            tip = setTitp(tipClass, item);
            layout();
            root.addChild(tip);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, close);
        }

        public function close(event : MouseEvent = null) : void
        {
            if (tip == null || tip.parent == null) return;
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, close);
            if (tip && tip.parent)
            {
                tip.parent.removeChild(tip);
            }
        }

        public static function close() : void
        {
            ItemTip.instance.close();
        }

        public static function show(id : int) : void
        {
            var tip : ItemTip = ItemTip.instance;
            tip.setId(id);
        }

        public static function showInfo(info : String) : void
        {
            ItemTip.instance.setInfo(info);
        }
    }
}
class Singleton
{
}