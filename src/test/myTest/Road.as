package test.myTest {
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author Lv
	 */
	public class Road extends Sprite {
		private var starMC:MovieClip;
		private var endMC:MovieClip;
		private var mapArr:Array;
		private var h:int;
		private var w:int;
		private var backRoadArr:Array = new Array();
		private var openArr:Array = new Array();
		private var closeArr:Array = new Array();
		public function Road() {
		}
		
		public function searchRoad(star:MovieClip,end:MovieClip,arr:Array):Array{
			starMC = star;
			endMC = end;
			mapArr = arr;
			h = mapArr[0].length;
			w = mapArr.length;
			openArr.push(starMC);
			while (true) {
				if (openArr.length<1) {
					return backRoadArr;
					break;
				}
				var thisPoint:MovieClip=openArr.splice(getMinF(),1)[0];
				if (thisPoint==endMC) {
					while (thisPoint.father!=starMC.father) {
						backRoadArr.push(thisPoint);
						thisPoint=thisPoint.father;
					}
					return backRoadArr;//返回路径列表
					break;
				}
				closeArr.push(thisPoint);
				addAroundPoint(thisPoint);
			}//End while
			return null;
		}

		private function addAroundPoint(thisPoint : MovieClip) : void {
		}

		private function getMinF() : uint {
			return null;
		}
	}
}
