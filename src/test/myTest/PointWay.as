package test.myTest {
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author Lv
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="640", height="480")]
	public class PointWay extends Sprite {
		private var mapSp:Sprite;
		private var w:int = 60;
		private var h:int = 46;
		private var mapArr:Array = new Array();
		private var goo:Number = 0.3;
		private var roadMen:MovieClip;
		private var roadList:Array;
		public function PointWay() {
			greatMap();
			roadMens();
		}

		private function roadMens() : void {
			roadMen = drawRect(2);
			var _tmpx:uint=Math.round(Math.random() * (w-1));
			var _tmpy:uint=Math.round(Math.random() * (h-1));
			roadMen.px=_tmpx;
			roadMen.py=_tmpy;
			roadMen.x=_tmpx * 10;
			roadMen.y=_tmpy * 10;
			mapArr[_tmpy][_tmpx].go=0;
			mapSp.addChild(roadMen);
		}

		private function greatMap() : void {
			mapSp = new Sprite();
			mapSp.x = 10;
			mapSp.y = 10;
			this.addChild(mapSp);
			mapSp.addEventListener(MouseEvent.MOUSE_DOWN,mapMousedown);
			for(var y:int = 0; y < h; y++){
				mapArr.push(new Array());
				for(var x:int = 0; x < w; x++){
					var mapPoint:uint=Math.round(Math.random() - goo);
					var point:MovieClip = drawRect(mapPoint);
					mapArr[y].push(point);
					mapArr[y][x].px = x;
					mapArr[y][x].py = y;
					mapArr[y][x].go = mapPoint;
					mapArr[y][x].x = x * 10;
					mapArr[y][x].y = y * 10;
					mapSp.addChild(mapArr[y][x]);
				}
			}
		}

		private function mapMousedown(event : MouseEvent) : void {
			var endMC:MovieClip = event.target as MovieClip;
			if(endMC.go == 0){
				if(roadList){
					for each(var m:MovieClip in roadList){
						m.alpha=1;
					}
					roadList = [];
				}
			}
		}

		private function drawRect(mapPoint : uint) : MovieClip {
			var mc:MovieClip = new MovieClip();
			var color:uint;
			switch (mapPoint) {
				case 0 :
					color=0x999999;//可通过为灰色
					break;
				case 1 :
					color=0x000000;//不可通过为黑色
					break;
				default :
					color=0xFF0000;//否则为寻路人
			}//End switch
			mc.graphics.beginFill(color);
			mc.graphics.lineStyle(0.2,0xFFFFFF);
			mc.graphics.drawRect(0,0,10,10);
			mc.graphics.endFill();
			return mc;
		}
	}
}
