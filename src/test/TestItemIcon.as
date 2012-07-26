package test
{
	import com.commUI.icon.ItemIcon;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import game.core.item.ItemManager;
	import gameui.controls.GButton;




	/**
	 * @author jian
	 */
	public class TestItemIcon extends Sprite
	{
		private var _icon:ItemIcon;
		
		public function TestItemIcon()
		{
			_icon = UICreateUtils.createItemIcon({x:50, y:0, showBorder:true, showBg:true, showRollOver:true, showToolTip:true});
			var button:GButton = UICreateUtils.createGButton("刷新图标", 0, 0, 0, 70);
			
			addChild(_icon);
			addChild(button);
			
			button.addEventListener(MouseEvent.CLICK, button_mouseClickHandler);
		}

		private function button_mouseClickHandler(event:MouseEvent) : void
		{
			var id:int = Math.random() * 20;
			_icon.source = ItemManager.instance.newItem(id);
			
			//trace ("Refresh Icon");
		}
		
		
	}
}
