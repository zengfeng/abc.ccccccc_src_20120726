package com.commUI
{
    import com.utils.UIUtil;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import game.manager.ViewManager;
    import gameui.manager.UIManager;




    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-3-8   ����4:55:03 
     */
    public class UIPlayerStatus extends Sprite
    {
        public function UIPlayerStatus(singleton : Singleton) : void
        {
            singleton;
        }

        /** 单例对像 */
        private static var _instance : UIPlayerStatus;

        /** 获取单例对像 */
        static public function get instance() : UIPlayerStatus
        {
            if (_instance == null)
            {
                _instance = new UIPlayerStatus(new Singleton());
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 战斗冷却中特效文字 */
        private var _battleEffectText : Sprite;

        /** 战斗冷却中特效文字 */
        private function get battleEffectText() : Sprite
        {
            if (_battleEffectText == null)
            {
                _battleEffectText = SwfEffectText.getMC(SwfEffectText.ID_BATTLEING);
            }
            return _battleEffectText;
        }

        /** CD时间 */
        private var _cdTimer : UiDieTimer;

        /** CD时间 */
        public function get cdTimer() : UiDieTimer
        {
            if (_cdTimer == null)
            {
                _cdTimer = new UiDieTimer();
            }
            return _cdTimer;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 显示 */
        public function show() : void
        {
            ViewManager.instance.uiContainer.addChild(this);
            if(stage)stage.addEventListener(Event.RESIZE, layout);
            layout();
        }

        /** 隐藏 */
        public function hide() : void
        {
            if(stage != null)
            {
                stage.removeEventListener(Event.RESIZE, layout);
            }
            clear();
            if (parent) parent.removeChild(this);
        }

        /** 清理 */
        public function clear() : void
        {
            clearBattleing();
            clearCD();
        }

        /** 清理  战斗冷却中 */
        public function clearBattleing() : void
        {
            if (_battleEffectText != null && _battleEffectText.parent) _battleEffectText.parent.removeChild(_battleEffectText);
        }

        /** 清理  CD */
        public function clearCD() : void
        {
            if (_cdTimer != null)
            {
                cdCompleteCall = null;
                cdInstantBtnCall = null;
                cdQuickenBtnCall = null;
                stopCDTime();
            }
        }

        /** 设置布局 */
        private function layout(event : Event = null) : void
        {
            UIUtil.alignStageHCenter(this);
            y = 158;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 战斗冷却中 */
        public function battleing() : void
        {
            clearCD();
            if (contains(battleEffectText) == false) addChild(battleEffectText);
            show();
        }

        /** 设置CD时间 */
        public function setCDTime(time : Number) : void
        {
            if (time == 0)
            {
                stopCDTime();
                hide();
                return;
            }
            clearBattleing();
            cdTimer.time = time;
            if(contains(cdTimer) == false) addChild(cdTimer);
            show();
        }

        /** 停止CD时间 */
        public function stopCDTime() : void
        {
            cdTimer.stop();
        }

        /** CD加速按钮回调 */
        public function set cdQuickenBtnCall(fun : Function) : void
        {
            cdTimer.buttonClickCall = fun;
        }

        /** CD立即按钮回调 */
        public function set cdInstantBtnCall(fun : Function) : void
        {
        }

        /** CD完成回调 */
        public function set cdCompleteCall(fun : Function) : void
        {
            if(cdTimer) cdTimer.completeCall = fun;
        }
    }
}
class Singleton
{
}