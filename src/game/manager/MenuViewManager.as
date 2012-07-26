/**
 Jul 2, 2012
 USEAGE :
 */
package game.manager {


	// class start ~~~~~
	public class MenuViewManager {
		
		private static var _single:MenuViewManager=null;

		public static function getInstance():MenuViewManager{
			if(_single==null){
				_single=new MenuViewManager(new Singleton());
			}
			return _single;
		}
		
		public function MenuViewManager(singleton:Singleton) {
			
		}
		
		


		// class end ~~~~~
	}
}


class Singleton{}