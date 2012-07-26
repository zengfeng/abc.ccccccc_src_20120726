package worlds.maps.layers.gates
{
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import worlds.apis.GateOpened;
	import worlds.apis.MTo;
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;
	import worlds.maps.configs.MapId;
	import worlds.maps.configs.structs.GateStruct;
	import com.utils.UrlUtils;

	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-18
	 */
	public class GateControl
	{
		/** 单例对像 */
		private static var _instance : GateControl;

		/** 获取单例对像 */
		static public function get instance() : GateControl
		{
			if (_instance == null)
			{
				_instance = new GateControl(new Singleton());
			}
			return _instance;
		}

		private var dic : Dictionary = new Dictionary();

		function GateControl(singleton : Singleton) : void
		{
		}

		private var loadGateCompleteCount : int = 0;

		public function install() : void
		{
			if(MapUtil.isCurrentMapId(1)) return;
			if (loadGateCompleteCount >= 4)
			{
				setupGateList();
				return;
			}
			loadGate(0);
		}

		public function uninstall() : void
		{
			GateOpened.signalState.remove(setGateOpenClose);
			var keyArr : Array = [];
			for (var key:String in dic)
			{
				keyArr.push(key);
			}

			var gateId : int;
			while (keyArr.length > 0)
			{
				gateId = parseInt(keyArr.shift());
				removeGate(gateId);
				delete dic [gateId] ;
			}
		}

		/** 加载八卦阵(出口入口) */
		private function loadGate(skinId : int) : void
		{
			var url : String = UrlUtils.getGate(skinId);
			var key : String = "gate_" + skinId;
			RESManager.instance.load(new LibData(url, key, true), loadGate_onComplete, [key, skinId]);
		}

		/** 加载完加载八卦阵(出口入口) */
		private function loadGate_onComplete(key : String, skinId : int) : void
		{
			// 读取加载
			var loader : SWFLoader = RESManager.getLoader(key);
			if (loader == null) return;
			GatePool.instance.gateClassDic[skinId] = loader.getClass("Gate");
			loadGateCompleteCount++;
			if (loadGateCompleteCount >= 4)
			{
				// 安装载八卦阵(出口入口)列表
				setupGateList();
			}
			else
			{
				loadGate(skinId + 1);
			}
		}

		/** 安装载八卦阵(出口入口)列表 */
		private function setupGateList() : void
		{
			var linkGates : Dictionary = MapUtil.getGateStructDic();
			for each (var gateStruct:GateStruct in linkGates)
			{
				if ( GateOpened.getState(gateStruct.id) ) addGate(gateStruct);
			}
			GateOpened.signalState.add(setGateOpenClose);
		}

		public function setGateOpenClose(gateId : int, isOpen : Boolean) : void
		{
			if (isOpen)
			{
				var gate : MovieClip = dic [gateId] ;
				if (!gate )
				{
					var struct : GateStruct = MapUtil.getGateStructById(gateId);
					addGate(struct);
				}
			}
			else
			{
				removeGate(gateId);
			}
		}

		/** 加入八卦阵(出入口) */
		private function addGate(struct : GateStruct) : void
		{
			if (struct == null) return;
			var element : MovieClip = dic[struct.id];
			if (element)
			{
				element.x = struct.position.x;
				element.y = struct.position.y;
				return;
			}
			element = GatePool.instance.getObject(struct.skinId);
			element.x = struct.position.x;
			element.y = struct.position.y;
			element.rotation = struct.rotation;
			element["id"] = struct.id;
			element["toMapId"] = struct.toMapId;
			element["skinId"] = struct.skinId;
			element["callClick"] = callClick;
			GateMediator.addToLayer.call(element);
			dic [struct.id] = element;
		}

		/** 移除八卦阵(出入口) */
		private function removeGate(gateId : int) : void
		{
			var element : MovieClip = dic [gateId] ;
			if (element)
			{
				GateMediator.removeFromLayer.call(element);
				GatePool.instance.destoryObject(element);
				delete dic [gateId] ;
			}
		}

		/**  八卦阵(出入口) 点击事件 */
		private function callClick(toMapId : int, gateId : int) : void
		{
			MTo.toGate(toMapId, 0, false, arriveGate, [toMapId, gateId]);
		}

		/** 到达八卦阵(出口入口) */
		private function arriveGate(toMapId : int, gateId : int = 0) : void
		{
			if (toMapId == MapId.BACK)
			{
				MWorld.csBackMap();
				return;
			}
			MWorld.csUseGateChangeMap(gateId);
		}
	}
}
class Singleton
{
}