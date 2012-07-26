package  game.module.mapDuplUI
{
	import flash.display.SimpleButton;
	import flash.utils.getTimer;
	import flash.utils.clearTimeout;
	import log4a.Logger;
	import game.definition.UI;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;

	import com.commUI.SwfEmbedFont;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;









    /**
     *  @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-4-17
     */
    public class NextDoButton extends GComponent
    {
        public function NextDoButton()
        {
            _base = new GComponentData();
            _base.width = 85;
            _base.height = 85;
            super(_base);
            initViews();
        }

        public var gotoBattleButton : DisplayObject;
        public var gotoExitButton : DisplayObject;
        public var getRewardButton : DisplayObject;
        public var walkingButton : Sprite;

        private function initViews() : void
        {
            gotoBattleButton = SwfEmbedFont.getSimpleButton(UI.DUPL_BUTTON_GO);
            gotoExitButton = SwfEmbedFont.getSimpleButton(UI.DUPL_BUTTON_EXIT);
            getRewardButton = SwfEmbedFont.getSimpleButton(UI.DUPL_BUTTON_GET_REWARD);
            walkingButton = SwfEmbedFont.getUI(UI.DUPL_BUTTON_WALKING);
            this.addEventListener(MouseEvent.CLICK, onClick);
        }

        public var onClickGotoBattleCall : Function;
        public var onClickGotoExitCall : Function;
        public var onClickGetRewardCall : Function;
		private var preClickTime:Number = 0;

        private function onClick(event : MouseEvent) : void
        {
			if(getTimer() - preClickTime < 1000) return;
			preClickTime = getTimer();
            switch(nextDo)
            {
                case NextDo.GOTO_BATTLE:
                    if (onClickGotoBattleCall != null) onClickGotoBattleCall.apply();
                    break;
                case NextDo.GOTO_EXIT:
                    if (onClickGotoExitCall != null) onClickGotoExitCall.apply();
                    break;
                case NextDo.GET_REWARD:
                    // if (onClickGetRewardCall != null) onClickGetRewardCall.apply();
                    break;
                default:
                    if (onClickGotoBattleCall != null) onClickGotoBattleCall.apply();
                    break;
            }
        }

        private var _nextDo : String = NextDo.GOTO_BATTLE;

        public function get nextDo() : String
        {
            return _nextDo;
        }

        private function showGoButton() : void
        {
			clearTimeout(hideGoButtonRemoveGoButtonTimer);
            gotoBattleButton.alpha = 1;
            if (hideGoButtonY == true)
            {
                hideGoButtonY = false;
                gotoBattleButton.x -= 500;
            }
            addGoButton();
        }

        private var hideGoButtonY : Boolean = false;
		private var hideGoButtonRemoveGoButtonTimer:uint;

        private function hideGoButton() : void
        {
            gotoBattleButton.alpha = 0;
            if (hideGoButtonY == false)
            {
                hideGoButtonY = true;
                gotoBattleButton.x += 500;
            }
            hideGoButtonRemoveGoButtonTimer = setTimeout(removeGoButton, 10);
        }

        private function addGoButton() : void
        {
            if (gotoBattleButton.parent == null) addChild(gotoBattleButton);
        }

        private function removeGoButton() : void
        {
            if (gotoBattleButton.parent != null) gotoBattleButton.parent.removeChild(gotoBattleButton);
        }
        private function showWalkingButton():void
        {
            if (walkingButton.parent != null) walkingButton.parent.removeChild(walkingButton);
        }

        public function set nextDo(what : String) : void
        {
            if (what != NextDo.WALKING) _nextDo = what;
            switch(what)
            {
                case NextDo.GOTO_BATTLE:
                	showGoButton();
//                    if (gotoBattleButton.parent == null) addChild(gotoBattleButton);
                    if (gotoExitButton.parent != null) gotoExitButton.parent.removeChild(gotoExitButton);
                    if (getRewardButton.parent != null) getRewardButton.parent.removeChild(getRewardButton);
                    if (walkingButton.parent != null) walkingButton.parent.removeChild(walkingButton);
                    break;
                case NextDo.GOTO_EXIT:
                    if (gotoExitButton.parent == null) addChild(gotoExitButton);
                    if (gotoBattleButton.parent != null) gotoBattleButton.parent.removeChild(gotoBattleButton);
                    if (getRewardButton.parent != null) getRewardButton.parent.removeChild(getRewardButton);
                    if (walkingButton.parent != null) walkingButton.parent.removeChild(walkingButton);
                    break;
                case NextDo.GET_REWARD:
                    // if (getRewardButton.parent == null) addChild(getRewardButton);
                    if (getRewardButton.parent != null) getRewardButton.parent.removeChild(getRewardButton);
                    if (gotoBattleButton.parent != null) gotoBattleButton.parent.removeChild(gotoBattleButton);
                    if (gotoExitButton.parent != null) gotoExitButton.parent.removeChild(gotoExitButton);
                    if (walkingButton.parent != null) walkingButton.parent.removeChild(walkingButton);
                    break;
                case NextDo.WALKING:
                    if (walkingButton.parent == null) addChild(walkingButton);
                	hideGoButton();
//                    if (gotoBattleButton.parent != null) gotoBattleButton.parent.removeChild(gotoBattleButton);
                    if (getRewardButton.parent != null) getRewardButton.parent.removeChild(getRewardButton);
                    if (gotoExitButton.parent != null) gotoExitButton.parent.removeChild(gotoExitButton);
                    break;
                default:
                    if (gotoBattleButton.parent == null) addChild(gotoBattleButton);
                	hideGoButton();
//                    if (gotoExitButton.parent != null) gotoExitButton.parent.removeChild(gotoExitButton);
                    if (getRewardButton.parent != null) getRewardButton.parent.removeChild(getRewardButton);
                    if (walkingButton.parent != null) walkingButton.parent.removeChild(walkingButton);
                    break;
            }
        }
    }
}
