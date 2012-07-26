package game.module.mapConvoy.ui {
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.mapConvoy.ConvoyConfig;
	import game.module.mapConvoy.ConvoyProto;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;

	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.data.GTitleWindowData;
	import gameui.group.GToggleGroup;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.quickshop.SingleQuickShop;
	import com.utils.UICreateUtils;
	import com.utils.UIUtil;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-3-12   ����12:01:12 
     */
    public class ConvoyOptionPanel extends GCommonWindow
    {
        public function ConvoyOptionPanel()
        {
            _instance = this;
            var data : GTitleWindowData = new GTitleWindowData();
            data.width = 338;
            data.height = 190;
            data.parent = ViewManager.instance.uiContainer;
            super(data);
            initViews();
        }

        /** 单例对像 */
        private static var _instance : ConvoyOptionPanel;

        /** 获取单例对像 */
        static public function get instance() : ConvoyOptionPanel
        {
            if (_instance == null)
            {
                _instance = new ConvoyOptionPanel();
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        private var bodyTop : int = 0;
        private var bodyWidth : int = 315;
        private var bodyHeight : int = 180;
        private var bodyContainer : Sprite;
        private var okButton : GButton;
        private var group : GToggleGroup = new GToggleGroup();
        private var optionList : Vector.<XiangLuOptionItem> = new Vector.<XiangLuOptionItem>();

        override protected function initViews() : void
        {
            super.initViews();
            title = "仙龟拜佛";
            bodyContainer = new Sprite();
            bodyContainer.x = (_base.width - bodyWidth) / 2 - 2 ;
            bodyContainer.y = bodyTop;
            _contentPanel.addChild(bodyContainer);

            // 背景1
            var sprite : Sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
            sprite.width = bodyWidth;
            sprite.height = bodyHeight;
            sprite.x = 0;
            sprite.y = 0;
            bodyContainer.addChild(sprite);
            var bg1 : Sprite = sprite;
            // 背景2
            sprite = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND2));
            sprite.width = bg1.width - 16;
            sprite.height = 100;
            sprite.x = 8;
            sprite.y = 28;
            bodyContainer.addChild(sprite);
            // 选择本次使用的香炉:
            var label : GLabel = UICreateUtils.createGLabel({width:200, height:25, x:8, y:8, enabled:false, textColor:0x000000, textFieldFilters:[]});
            label.text = "选择本次使用的香炉:";
            bodyContainer.addChild(label);
            // 确定按钮
            var button : GButton = UICreateUtils.createGButton("确定");
            button.x = (bodyContainer.width - button.width) / 2;
            button.y = bodyContainer.height - button.height - 15;
            bodyContainer.addChild(button);
            button.addEventListener(MouseEvent.CLICK, okButton_onClick);
            okButton = button;

            // 香炉选项
            optionList = new Vector.<XiangLuOptionItem>();
            var option : XiangLuOptionItem;
            option = new XiangLuOptionItem(ConvoyConfig.XIANG_LU_1);
            option.radioButton.group = group;
            bodyContainer.addChild(option);
            optionList.push(option);
            option.radioButton.selected = true;

            option = new XiangLuOptionItem(ConvoyConfig.XIANG_LU_2);
            option.radioButton.group = group;
            bodyContainer.addChild(option);
            optionList.push(option);

            option = new XiangLuOptionItem(ConvoyConfig.XIANG_LU_3);
            option.radioButton.group = group;
            bodyContainer.addChild(option);
            optionList.push(option);

            option = new XiangLuOptionItem(ConvoyConfig.XIANG_LU_4);
            option.radioButton.group = group;
            bodyContainer.addChild(option);
            optionList.push(option);

            for (var i : int = 0; i < optionList.length; i++)
            {
                option = optionList[i];
                option.x = 20 + i * (option.width + 17);
                option.y = 33;
            }
        }

        private function okButton_onClick(event : MouseEvent) : void
        {
            var optionId : int = group.selection.source;
            if (optionId != ConvoyConfig.XIANG_LU_1)
            {
                var goodsId : int = ConvoyConfig.xiangLuGoodsDic[optionId];
                var item : Item = ItemManager.instance.getPileItem(ConvoyConfig.xiangLuGoodsDic[optionId]);
                if (item.nums < 1)
                {
                    SingleQuickShop.show(goodsId);
                    return;
                }
            }

            ConvoyProto.instance.cs_start(optionId);
            hide();
        }

        private function refresh(isUpdateSelected : Boolean = false) : void
        {
            var option : XiangLuOptionItem ;
            if (isUpdateSelected == true)
            {
                option = optionList[0];
                option.radioButton.selected = true;
            }

            for (var i : int = 1; i < optionList.length; i++)
            {
                option = optionList[i];
                option.refresh();
            }
        }

        /** CC监听 -- 0xFFF2 监听香炉更新 */
        private function cc_xiangLuRefresh(msg : CCPackChange) : void
        {
            // 消耗品→装备→元神→灵珠→强化→天材地宝
            // 1,2,4,8,16,32
            if (msg.topType == 1)
            {
                refresh();
            }
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        override public function show() : void
        {
            UIUtil.alignStageCenter(this);
            refresh(true);
            super.show();
            stage.addEventListener(Event.RESIZE, onStageResize);

            // CC监听 -- 0xFFF2 监听香炉更新
            Common.game_server.addCallback(0xFFF2, cc_xiangLuRefresh);
        }

        override public function hide() : void
        {
            // CC监听 -- 0xFFF2 监听香炉更新
            Common.game_server.removeCallback(0xFFF2, cc_xiangLuRefresh);
            stage.removeEventListener(Event.RESIZE, onStageResize);
            super.hide();
        }

        private function onStageResize(event : Event) : void
        {
            UIUtil.alignStageCenter(this);
        }

        override public function get stage() : Stage
        {
            return UIUtil.stage;
        }
    }
}
