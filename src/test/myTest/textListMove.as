package test.myTest
{
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import gameui.data.GButtonData;
	import gameui.controls.GButton;
	import gameui.data.GLabelData;
	import gameui.controls.GLabel;
	import flash.display.Sprite;

	/**
	 * @author Lv
	 */
	public class textListMove extends Sprite
	{
		private var listVec:Vector.<GLabel> = new Vector.<GLabel>();
		private var label:GLabel;
		private var btn:GButton;
		public function textListMove()
		{
			for(var i:int = 0 ; i < 7; i++){
				var data:GLabelData = new GLabelData();
				data.text = "我是list移动的例子";
				data.x = 50;
				data.y = 50 + i *30;
				data.width = 120;
				label = new GLabel(data);
				addChild(label);
				listVec.push(label);
				if(i == 6){
					label.alpha = 0;
				}
			}
			var databtn:GButtonData = new GButtonData();
			databtn.labelData.text = "改变";
			databtn.x = 200;
			databtn.y = 50;
			btn= new GButton(databtn);
			addChild(btn);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, ondown);
		}

		private function ondown(event : MouseEvent) : void {
			change();
			
		}
		private function change() : void {
			for(var i:int = 0;i < listVec.length ; i++){
				if(i == 0)
					TweenLite.to(listVec[i],0.8,{y:listVec[i].y -30, alpha:0, overwrite:0,onComplete:ShowHarmComplete_func,onCompleteParams:[listVec[i]]});
				else
					TweenLite.to(listVec[i],0.8,{y:listVec[i].y -30, alpha:1, overwrite:0});
			}
		}
		
		private function ShowHarmComplete_func(label:GLabel):void{
			listVec.shift();
			label.y = 50 + 6 *30;
			label.alpha = 0;
			listVec.push(label);
			//change();
		}
	}
}
