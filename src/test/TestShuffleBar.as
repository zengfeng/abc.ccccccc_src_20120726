package test
{
	import com.utils.UICreateUtils;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import game.module.soul.abyss.ShuffleBar;
	import gameui.controls.GButton;
	import project.Game;





	/**
	 * @author jian
	 */
	public class TestShuffleBar extends Game
	{
		public function TestShuffleBar()
		{
			super();
		}

		private var _bar : ShuffleBar;

		override protected function initGame() : void
		{
			_bar = new ShuffleBar(10);

			addChild(_bar);
			_bar.x = 20;
			_bar.y = 100;

			var leftButton : GButton = UICreateUtils.createGButton("左移");
			leftButton.x = 20;
			addChild(leftButton);

			var rightButton : GButton = UICreateUtils.createGButton("右移");
			rightButton.x = 100;
			addChild(rightButton);

			var addButton : GButton = UICreateUtils.createGButton("添加");
			addButton.x = 180;
			addChild(addButton);
			
			var leftMostButton : GButton = UICreateUtils.createGButton("最左");
			leftMostButton.x = 260;
			addChild(leftMostButton);

			var rightMostButton : GButton = UICreateUtils.createGButton("最右");
			rightMostButton.x = 340;
			addChild(rightMostButton);			

			addButton.addEventListener(MouseEvent.CLICK, addButton_clickHandler);
			leftButton.addEventListener(MouseEvent.CLICK, leftButton_clickHandler);
			rightButton.addEventListener(MouseEvent.CLICK, rightButton_clickHandler);
			leftMostButton.addEventListener(MouseEvent.CLICK, leftMostButton_clickHandler);
			rightMostButton.addEventListener(MouseEvent.CLICK, rightMostButton_clickHandler);
		}

		private function addButton_clickHandler(event : MouseEvent) : void
		{
			var icon:Sprite = getIcon();
			icon.addEventListener(MouseEvent.CLICK, cell_selectHandler);
			_bar.addChild(icon);
		}

		private function leftButton_clickHandler(event : MouseEvent) : void
		{
			_bar.shuffleLeft();
		}

		private function rightButton_clickHandler(event : MouseEvent) : void
		{
			_bar.shuffleRight();
		}
		
		private function leftMostButton_clickHandler(event:MouseEvent):void
		{
			_bar.shuffleLeftMost();
		}
		
		private function rightMostButton_clickHandler(event:MouseEvent):void
		{
			_bar.shuffleRightMost();
		}
		
		private function cell_selectHandler(event:MouseEvent):void
		{
			_bar.removeChild(event.target as DisplayObject);
		}
		
		private var _n:int = 0;

		private function getIcon() : Sprite
		{
			
			var icon : Sprite = new Sprite();

			icon.graphics.beginFill(0x996633);
			icon.graphics.lineStyle(2);
			icon.graphics.drawCircle(24, 24, 24);
			
			var tf:TextField = new TextField();
			tf.mouseEnabled = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = _n.toString();
			tf.x = (icon.width - tf.width) * 0.5;
			tf.y = (icon.height - tf.height) * 0.5;
			_n++;
			icon.addChild(tf);

			return icon;
		}
		

	}
}
