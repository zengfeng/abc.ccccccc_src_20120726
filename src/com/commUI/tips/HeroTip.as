package com.commUI.tips
{
    import com.commUI.tooltip.SimpleHeroTip;
    import com.commUI.tooltip.ToolTip;
    import com.commUI.tooltip.ToolTipData;
    import com.utils.ItemUtils;
    import com.utils.UIUtil;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import game.core.hero.HeroChatInterface;
    import game.core.hero.VoHero;
    import game.core.item.Item;
    import game.core.item.ItemChatInterface;
    import gameui.manager.UIManager;






    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-4-1 ����5:22:38
     */
    public class HeroTip
    {
        function HeroTip(singleton : Singleton)
        {
        }

        private static var _instance : HeroTip;

        public static function  get instance() : HeroTip
        {
            if (_instance == null)
            {
                _instance = new HeroTip(new Singleton());
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

        /** 当前TIP */
        public var tip : ToolTip;

        public function setInfo(info : String) : void
        {
            close();
            var voHero : VoHero = HeroChatInterface.decodeStringToHero(info);
            if (tip == null)
            {
                var data : ToolTipData = new ToolTipData();
                tip = new SimpleHeroTip(data);
            }
            tip.source = voHero;
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
            instance.close();
        }

        public static function showInfo(info : String) : void
        {
            instance.setInfo(info);
        }
    }
}
class Singleton
{
}