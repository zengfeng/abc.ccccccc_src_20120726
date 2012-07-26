package test.debugTool
{
	import game.definition.UI;

	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.controls.GCheckBox;
	import gameui.data.GCheckBoxData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	/**
	 * @author 1
	 */
	public class DebugChildListCell extends GCell
	{
		
		private var _nameText:TextField;
		private var _classText:TextField;
		private var _vo:DebugToolVO;
		private var _selectCKBox:GCheckBox;
		
	    public function DebugChildListCell(data : GCellData)
		{
			data.upAsset = new AssetData(SkinStyle.emptySkin);
			data.overAsset = new AssetData(UI.LIGHT_TRANSPARENT_BG);
			data.selected_upAsset = new AssetData(UI.TRADE_DARK_BACKGRAND);
			data.selected_overAsset = null;
			data.disabledAsset = null;
			super(data);
		}
		
		
	    override protected function create() : void
		{
			super.create();
			addLabel();		
			addCheckBox();				
		}

		private function addCheckBox() : void
		{
			var data : GCheckBoxData = UICreateUtils.checkBoxDataDark.clone();

			data.x = 2;
			data.y = 1;
			_selectCKBox = new GCheckBox(data);

			addChild(_selectCKBox);
		}

		private function addContainerBorder() : void
		{
			var _bg:Sprite=new Sprite();
		    _bg.graphics.lineStyle(5,0xffff12);
			_bg.graphics.drawRect(0, 0, this.width, this.height);
			_bg.graphics.endFill();
			addChild(_bg);
		}
		
		private function addNoContainerBorder():void
		{
			var _bg:Sprite=new Sprite();
		    _bg.graphics.lineStyle(5,0x121123);
			_bg.graphics.drawRect(0, 0, this.width, this.height);
			_bg.graphics.endFill();
			addChild(_bg);
		}

		private function addLabel() : void
		{
	       _nameText = UICreateUtils.createTextField(null, "xxoo",110, 19, 20, 2, UIManager.getTextFormat(13, 0x000000, TextFormatAlign.LEFT));
		   addChild(_nameText);
		   
		   _classText = UICreateUtils.createTextField(null, "xxoo",240, 19, 160, 2, UIManager.getTextFormat(13, 0x000000, TextFormatAlign.LEFT));
		   addChild(_classText);
		}
		
		private function updateItem():void
		{
			_nameText.htmlText=_vo.objectName;
			_classText.htmlText=_vo.objectClass;
			
			if(_vo.objectContainer)
			{
 			    addContainerBorder();
			}
			else
			{
				addNoContainerBorder();
			}
		}
		
		
		public function clearSel():void
		{
			_selectCKBox.selected=false;
		}
		
		override protected function onShow() : void
		{
			super.onShow();
			this.addEventListener(MouseEvent.CLICK, onMouseDown);
		}
		
	    override protected function onHide() : void
		{
			super.onHide();
			this.removeEventListener(MouseEvent.CLICK, onMouseDown);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			
			if(_selectCKBox.selected)
			{
				_selectCKBox.selected=false;
			}
			else
			{
				_selectCKBox.selected=true;
			    var selectEvent:DebugToolEvent=new DebugToolEvent(DebugToolEvent.ITEMSELECT,true);			
			    selectEvent.vo=_vo;
			    dispatchEvent(selectEvent);
			}
		}
		
		override public function set source(value : *) : void
		{
			_vo = value as DebugToolVO;
			updateItem();
		}
		
		
		
	}
}
