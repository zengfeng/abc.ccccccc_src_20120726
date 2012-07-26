package worlds.roles.proessors.walks
{
	import flash.utils.Dictionary;
	public class MoveProessorFactory
	{
		private static var _instance : MoveProessorFactory;

		public static  function get instance() : MoveProessorFactory
		{
			if (_instance == null)
			{
				_instance = new MoveProessorFactory(new Singleton());
			}
			return _instance;
		}

		function MoveProessorFactory(singleton : Singleton) : void
		{
			singleton;
			poolDic = new Dictionary();
			poolDic[ MoveProessorType.TIME] = new Vector.<TimeMoveProessor>();
			poolDic[ MoveProessorType.FRAME] = new Vector.<FrameMoveProessor>();
			poolDic[ MoveProessorType.SMOOTH_TIME] = new Vector.<SmoothTimeMoveProessor>();
		}

		private var poolDic : Dictionary;
		private const POOL_MAX_COUNT : int = 200;
		private var tempList : Vector.<*>;

		public function make(speed : Number, callUpdate : Function, callEnd : Function, type : int = 0) : AbstractMoveProcessor
		{
			var processor : AbstractMoveProcessor = getObject(type);
			processor.reset(speed, callUpdate, callEnd);
			return processor;
		}

		public function destoryObject(object : AbstractMoveProcessor, destoryed : Boolean = false) : void
		{
			if (object == null) return;
			tempList = poolDic[getType(object)];
			if (tempList.indexOf(object) != -1) return;
			if (!destoryed) object.destory();
			if (tempList.length < POOL_MAX_COUNT) tempList.push(object);
		}

		private function getObject(type : int) : AbstractMoveProcessor
		{
			tempList = poolDic[type];
			var object : AbstractMoveProcessor;
			if (tempList.length > 0)
			{
				object = tempList.pop();
				return object;
			}

			switch(type)
			{
				case  MoveProessorType.TIME:
					object = new TimeMoveProessor();
					break;
				case  MoveProessorType.FRAME:
					object = new FrameMoveProessor();
					break;
				case  MoveProessorType.SMOOTH_TIME:
					object = new SmoothTimeMoveProessor();
					break;
				default:
					object = new TimeMoveProessor();
			}
			return object;
		}
		

		private function getType(object : AbstractMoveProcessor) : int
		{
			if (object is TimeMoveProessor)
			{
				return  MoveProessorType.TIME;
			}
			else if (object is FrameMoveProessor)
			{
				return  MoveProessorType.FRAME;
			}
			else if (object is SmoothTimeMoveProessor)
			{
				return  MoveProessorType.SMOOTH_TIME;
			}
			return -1;
		}
		
	}
}
class Singleton
{
}