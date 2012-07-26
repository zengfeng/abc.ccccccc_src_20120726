package game.manager
{
	import com.utils.CallFunStruct;

	/**
	 * @author yangyiqiang
	 */
	public class ShowFunManage
	{
		private static var _instance : ShowFunManage;

		public function ShowFunManage()
		{
			if (_instance)
			{
				throw Error("---AvatarManager--is--a--single--model---");
			}
		}

		public static function get instance() : ShowFunManage
		{
			if (_instance == null)
			{
				_instance = new ShowFunManage();
			}
			return _instance;
		}

		private var _list : Vector.<CallFunStruct>=new Vector.<CallFunStruct>();
		
		public function addFun(struct:CallFunStruct):void
		{
			_list.push(struct);
		}
	}
}
