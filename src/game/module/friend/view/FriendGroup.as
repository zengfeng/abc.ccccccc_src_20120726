package game.module.friend.view
{
	import game.module.friend.EventFriend;
	import game.module.friend.UtilFriend;
	import game.module.friend.VoFriendGroup;

	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.utils.DrawUtils;

	import flash.events.Event;





    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-4  ����11:49:43 
     */
    public class FriendGroup extends GCell
    {
        public static const PRE_NAME : String = "FriendGroup_";
        private var _vo : VoFriendGroup;
        private var _defalutHeight : uint = 20;
        /** 开关按钮 */
        private var _switchButton : SwitchButton;
		/** 放出一个public属性，用来作为tooltip的对象 **/
		public var switchButton_forToolTip : SwitchButton;
        /** 子组件容器 */
        private var _itemsContainer : GComponent;
        private var _items : Array;
        public var friendPanel : FriendPanel;

        public function FriendGroup(data : GCellData)
        {
            if (data)
            {
                data.height = _defalutHeight;
				data.upAsset = new AssetData(SkinStyle.emptySkin);
				data.overAsset = new AssetData(SkinStyle.emptySkin);
				data.selected_upAsset = new AssetData(SkinStyle.emptySkin);
				data.selected_overAsset = new AssetData(SkinStyle.emptySkin);
            }
            super(data);
            initViews();
            initEvents();
        }

        protected function initViews() : void
        {
            // 开关按钮
            var componentData : GComponentData = new GComponentData();
            componentData.width = _data.width;
            componentData.height = _data.height;
            _switchButton = new SwitchButton(componentData);
            addChild(_switchButton);
			
			//放出一个public属性，用来作为tooltip的对象
			switchButton_forToolTip = _switchButton;
			
            // 子组件容器
            componentData.x = 0;
            componentData.y = _defalutHeight + 1;
            _itemsContainer = new GComponent(componentData);
            //drawBg();
        }

        protected function drawBg() : void
        {
            DrawUtils.roundRect(this, this.width, this.height, 0, 20, 0x8E783D, 0x0, 0.6, 0);
        }

        /** 初始化事件（添加事件监听） */
        private function initEvents() : void
        {
            _switchButton.addEventListener(SwitchButton.SELECTED, switchButton_selectedHandler);
        }

        private function switchButton_selectedHandler(event : Event) : void
        {
            if (_switchButton.isSelected)
            {
                if (_items == null)
                {
                    createItems();
                }
                else
                {
                    updateItems();
                }
                _itemsContainer.visible = true;
                addChild(_itemsContainer);
            }
            else
            {
                if (_itemsContainer.parent)
                {
                    _itemsContainer.parent.removeChild(_itemsContainer);
                }
                this.height = _defalutHeight;
                heightChange();
            }
        }

        /** 是否选中的(打开的) */
        public function get isSelected() : Boolean
        {
            return _switchButton.isSelected;
        }

        /** 是否选中的(打开的) */
        public function set isSelected(value : Boolean) : void
        {
            _switchButton.isSelected = value;
        }

        private function clearItems() : void
        {
            var item : FriendItem;
            while (_itemsContainer.numChildren > 0)
            {
                item = _itemsContainer.getChildAt(0) as FriendItem;
                if (item)
                {
                    delete _itemsContainer.removeChild(item);
                }
            }
            _items = null;
        }

        private function createItems() : void
        {
            clearItems();
            if (vo == null) return;
			UtilFriend.sortFriend(vo.childen);
            var i : int = 0;
            _items = [];
            var cellData : GCellData = new GCellData();
            cellData.width = data.width;
            var postionY : uint = 0;
            var item : FriendItem;
            for (i = 0; i < vo.childen.length; i++)
            {
                cellData.index = i;
                cellData.y = postionY;
                item = new FriendItem(cellData);
                item.groupElement = this;
                item.source = vo.childen[i];
                _itemsContainer.addChild(item);
                _items.push(item);
                postionY += item.height;
            }
            this.height = postionY + _defalutHeight + 1;
            heightChange();
        }

        public function updateItems() : void
        {
            UtilFriend.sortFriend(vo.childen);
            var cellData : GCellData = new GCellData();
            cellData.width = data.width;
            var item : FriendItem;
            var postionY : uint = 0;
            var i : int = 0;
            for (i = 0; i < vo.childen.length; i++)
            {
                item = _items[i];
                if (item == null)
                {
                    item = new FriendItem(cellData);
                    _items.push(item);
                }
                _itemsContainer.addChildAt(item, i);
                item.groupElement = this;
                item.source = vo.childen[i];
                item.y = postionY;
                postionY += item.height;
            }

            while (_items.length > vo.childen.length)
            {
                item = _items.pop() as FriendItem;
                if (item)
                {
                    delete _itemsContainer.removeChild(item);
                }
            }
            this.height = postionY + _defalutHeight + 1;
            heightChange();
        }

        /** 抛出高改变事伯 */
        private function heightChange() : void
        {
            //drawBg();
            var event : EventFriend = new EventFriend(EventFriend.HEIGHT_CHANGE, true);
            dispatchEvent(event);
        }

        /** 更新显示 */
        public function updateView() : void
        {
            vo = vo;
        }

        override public function set source(value : *) : void
        {
            super.source = value;
            vo = value;
        }

        public function get vo() : VoFriendGroup
        {
            return _vo;
        }

        public function set vo(vo : VoFriendGroup) : void
        {
            _vo = vo;
            this.name = PRE_NAME + vo.id;
            _switchButton.source = vo;
        }
		
		public function refreshOnline():void
		{
			_switchButton.source = vo ;
		}
    }
}
import game.module.friend.ProtoCtoSFriend;
import game.module.friend.VoFriendGroup;

import gameui.controls.GButton;
import gameui.core.GComponent;
import gameui.core.GComponentData;
import gameui.data.GButtonData;
import gameui.manager.UIManager;

import net.AssetData;

import com.utils.DrawUtils;
import com.utils.LabelUtils;
import com.utils.StringUtils;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.ui.Keyboard;





class SwitchButton extends GComponent
{
    public static const SELECTED : String = "selected";
    private var _vo : VoFriendGroup;
    /** 开关图标 */
    public var switchIco : Bitmap;
    public static var TreeFolderIcoSkin1_Up : BitmapData = DrawUtils.drawBitmapData(UIManager.getUI(new AssetData("tree_node_up")));
    public static var TreeFolderIcoSkin1_Over : BitmapData = DrawUtils.drawBitmapData(UIManager.getUI(new AssetData("tree_node_over")));
    public static var TreeFolderIcoSkin1_SelectUp : BitmapData = DrawUtils.drawBitmapData(UIManager.getUI(new AssetData("tree_node_selup")));
    public static var TreeFolderIcoSkin1_SelectOver : BitmapData = DrawUtils.drawBitmapData(UIManager.getUI(new AssetData("tree_node_selover")));
    /** 名称Label */
    public var nameLabel : TextField;
    /** 重命名按钮 */
    public var renameButton : GButton;
    /** 删除按钮 */
    public var deleteButton : GButton;
    
    private var textColor:uint = 0x222222;
    private var textOverColor:uint = 0x444444;

    function SwitchButton(data : GComponentData)
    {
        super(data);
        initViews();
        initEvents();
    }

    protected function initViews() : void
    {
		DrawUtils.roundRect(this, this.width, this.height, 0, 0, 0, 0, 0, 0);
        // 开关图标
        switchIco = new Bitmap(TreeFolderIcoSkin1_Up.clone());
        switchIco.x = 10;
        switchIco.y = (_base.height - switchIco.height) / 2;
        addChild(switchIco);
        // 名称Label
        nameLabel = LabelUtils.createContentBold();
        nameLabel.selectable = false;
        nameLabel.mouseEnabled = false;
        nameLabel.textColor = textColor;
        nameLabel.width = 100;
        nameLabel.height = 20;
        nameLabel.x = 24;
        nameLabel.y = 2;
        nameLabel.text = "组名 0/100";
        addChild(nameLabel);
        // 删除按钮
        var buttonData : GButtonData = new GButtonData();
		buttonData.upAsset = new AssetData("DeleteButtonSkin_Up");
		buttonData.overAsset = new AssetData("DeleteButtonSkin_Over");
		buttonData.downAsset = new AssetData("DeleteButtonSkin_Down");
        buttonData.width = 13;
        buttonData.height = 13;
        buttonData.y = (_base.height - buttonData.height) / 2;
        buttonData.x = _base.width - buttonData.width - 5;
        deleteButton = new GButton(buttonData);
		deleteButton.visible = false;
        //addChild(deleteButton);
        // 重命名按钮
		buttonData = buttonData.clone();
		buttonData.upAsset = new AssetData("EditButtonSkin_Up");
		buttonData.overAsset = new AssetData("EditButtonSkin_Over");
		buttonData.downAsset = new AssetData("EditButtonSkin_Down");
        buttonData.x = buttonData.x - buttonData.width - 5;
        renameButton = new GButton(buttonData);
		renameButton.visible = false;
        //addChild(renameButton);
    }

    /** 初始化事件（添加事件监听） */
    private function initEvents() : void
    {
        // this.addEventListener(Event.REMOVED, removedHandler);
        this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

        renameButton.addEventListener(MouseEvent.CLICK, renameButton_clickHandler);
        renameButton.addEventListener(MouseEvent.MOUSE_UP, stopPropagationFun);
        deleteButton.addEventListener(MouseEvent.CLICK, deleteButton_clickHandler);
        deleteButton.addEventListener(MouseEvent.MOUSE_UP, stopPropagationFun);
    }

    // private function removedHandler(event : Event) : void
    // {
    // this.removeEventListener(Event.REMOVED, removedHandler);
    // this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
    // this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
    // this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
    // this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
    //
    // renameButton.removeEventListener(MouseEvent.CLICK, renameButton_clickHandler);
    // renameButton.removeEventListener(MouseEvent.MOUSE_UP, stopPropagationFun);
    // deleteButton.removeEventListener(MouseEvent.CLICK, deleteButton_clickHandler);
    // deleteButton.removeEventListener(MouseEvent.MOUSE_UP, stopPropagationFun);
    //
    // delete this;
    // }
    private function deleteButton_clickHandler(event : MouseEvent) : void
    {
        // 向服务器发送协议 -- 删除好友组
//        ProtoCtoSFriend.instance.cs_DelFriendGrp(vo.id);
    }

    private function renameButton_clickHandler(event : MouseEvent) : void
    {
        isRenameing = true;
    }

    private function stopPropagationFun(event : MouseEvent) : void
    {
        event.stopPropagation();
    }

    private function mouseOverHandler(event : MouseEvent) : void
    {
        //switchIco.bitmapData = isSelected ? TreeFolderIcoSkin1_SelectOver : TreeFolderIcoSkin1_Over;
        if(!isRenameing)
		{
			nameLabel.textColor = textOverColor;
			// if(_vo.id != ModelFriend.instance.DEFAULT_GROUP_ID_1)
			// {
			// deleteButton.visible = true;
			// renameButton.visible = true;
			// }
		}
    }

    private function mouseOutHandler(event : MouseEvent) : void
    {
        //switchIco.bitmapData = isSelected ? TreeFolderIcoSkin1_SelectUp : TreeFolderIcoSkin1_Up;
		deleteButton.visible = false;
		renameButton.visible = false;
        if(!isRenameing) nameLabel.textColor = textColor;
    }

    private function mouseDownHandler(event : MouseEvent) : void
    {
        //switchIco.bitmapData = isSelected ? TreeFolderIcoSkin1_SelectUp : TreeFolderIcoSkin1_Up;
    }

    private function mouseUpHandler(event : MouseEvent) : void
    {
        if (isRenameing == true) return;
        isSelected = !isSelected;
        //switchIco.bitmapData = isSelected ? TreeFolderIcoSkin1_SelectUp : TreeFolderIcoSkin1_Up;
    }

    private function nameLabel_mouseDownHandler(event : MouseEvent) : void
    {
        event.stopPropagation();
    }

    private function stage_mouseDownHandler(event : MouseEvent) : void
    {
//        cs_ChgGroupName();
    }
    
    /** 验证 */
    private function nameLabel_checkout(event:Event = null):void
    {
        var str:String = nameLabel.text;
        if(StringUtils.UTFLength(str) > 10)
        {
            nameLabel.text = StringUtils.UTFSubstr(str,  10);
        }
    }

    private function nameLabel_keyDownHandler(event : KeyboardEvent) : void
    {
        if (event.keyCode == Keyboard.ENTER)
        {
//            cs_ChgGroupName();
        }
    }
//
//    /** 发送协议 -- 修改好友组名 */
//    private function cs_ChgGroupName() : void
//    {
//        var groupId : uint = vo.id;
//        var groupName : String = StringUtils.trim(nameLabel.text);
//        if(!groupName || groupName == vo.name)
//        {
//            nameLabel.text = vo.name;
//        	isRenameing = false;
//            return;
//        }
//        
//        ProtoCtoSFriend.instance.cs_ChgGroupName(groupId, groupName);
//        isRenameing = false;
//    }

    override public function set source(value : *) : void
    {
        super.source = value;
        vo = value;
    }

    public function get vo() : VoFriendGroup
    {
        return _vo;
    }

    public function set vo(vo : VoFriendGroup) : void
    {
        _vo = vo;
        if (vo)
        {
            nameLabel.text = vo.name + " " + vo.onLineNum + "/" + vo.count;
			// if (vo.id == ModelFriend.instance.DEFAULT_GROUP_ID_1 && renameButton && deleteButton)
			// {
			// renameButton.removeEventListener(MouseEvent.CLICK, renameButton_clickHandler);
			// renameButton.removeEventListener(MouseEvent.MOUSE_UP, stopPropagationFun);
			// deleteButton.removeEventListener(MouseEvent.CLICK, deleteButton_clickHandler);
			// deleteButton.removeEventListener(MouseEvent.MOUSE_UP, stopPropagationFun);
			// deleteButton.visible = false;
			// renameButton.visible = false;
			// }
        }
    }

    /** 是否选中 */
    private var _isSelected : Boolean = false;

    /** 是否选中 */
    public function get isSelected() : Boolean
    {
        return _isSelected;
    }

    public function set isSelected(isSelected : Boolean) : void
    {
        _isSelected = isSelected;
        switchIco.bitmapData = _isSelected ? TreeFolderIcoSkin1_SelectUp : TreeFolderIcoSkin1_Up;

		// if (vo.id != ModelFriend.instance.DEFAULT_GROUP_ID_1)
		// {
		// renameButton.visible = !isSelected;
		// deleteButton.visible = !isSelected;
		// }
        dispatchEvent(new Event(SELECTED));
    }

    /** 是否正在重命名中 */
    private var _isRenameing : Boolean = false;

    /** 是否正在重命名中 */
    public function get isRenameing() : Boolean
    {
        return _isRenameing;
    }

    public function set isRenameing(isRenameing : Boolean) : void
    {
        _isRenameing = isRenameing;

        if (vo == null) return;
		// if (vo.id != ModelFriend.instance.DEFAULT_GROUP_ID_1)
		// {
		// renameButton.visible = !isRenameing;
		// deleteButton.visible = !isRenameing;
		// }
        if (_isRenameing)
        {
            nameLabel.selectable = true;
            nameLabel.mouseEnabled = true;
            nameLabel.textColor = textColor;
            nameLabel.width = _base.width - nameLabel.x;
            nameLabel.text = vo.name;
            nameLabel.border = true;
            nameLabel.type = TextFieldType.INPUT;
            nameLabel.maxChars = 10;
            nameLabel.stage.focus = nameLabel;
            nameLabel.setSelection(0, nameLabel.text.length);
            nameLabel.addEventListener(KeyboardEvent.KEY_DOWN, nameLabel_keyDownHandler);
            nameLabel.addEventListener(KeyboardEvent.KEY_UP, nameLabel_checkout);
            nameLabel.addEventListener(MouseEvent.MOUSE_DOWN, nameLabel_mouseDownHandler);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
        }
        else
        {
            nameLabel.selectable = false;
            nameLabel.mouseEnabled = false;
            nameLabel.textColor = textColor;
            nameLabel.width = 100;
            nameLabel.removeEventListener(KeyboardEvent.KEY_DOWN, nameLabel_keyDownHandler);
            nameLabel.removeEventListener(KeyboardEvent.KEY_UP, nameLabel_checkout);
            nameLabel.removeEventListener(MouseEvent.MOUSE_DOWN, nameLabel_mouseDownHandler);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
            nameLabel.text = vo.name + " (" + vo.onLineNum + "/" + vo.count + ")";
            nameLabel.border = false;
            nameLabel.type = TextFieldType.DYNAMIC;
            nameLabel.maxChars = 30;
			
			deleteButton.visible = false;
			renameButton.visible = false;
        }
    }
}
