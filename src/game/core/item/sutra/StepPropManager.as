package game.core.item.sutra
{
	import flash.utils.Dictionary;
	import game.core.item.prop.ItemProp;
	import game.core.prop.PropManager;

	/**
	 * @author jian
	 */
	public class StepPropManager
	{
		// =====================
		// 单例
		// =====================
		private static var __instance:StepPropManager;
		
		public static function get instance ():StepPropManager
		{
			if (!__instance)
				__instance = new StepPropManager();
			
			return __instance;
		}
		
		public function StepPropManager():void
		{
			if (__instance)
				throw (Error("单例错误!"));

			init();
		}
		
		// =====================
		// 属性
		// =====================
		private var _stepProps:Dictionary;
		private var _nullProp:ItemProp = new ItemProp();
		
		// =====================
		// 方法
		// =====================
		private function init():void
		{
			_stepProps = new Dictionary();
//			_stepPropsApp = new Dictionary();
		}
		
		public function getStepProp(configHeroID:uint, step:uint):ItemProp /* of Prop */
		{
			if (step == 0)
				return _nullProp;
				
			var prop:ItemProp = _stepProps[getKey(configHeroID, step)];
			
			if (!prop)
				return null;
			return prop;
		}
		
		private function setStepProp(configHeroID:uint, step:uint, prop:ItemProp):void
		{
			_stepProps[getKey(configHeroID, step)] = prop;
		}
		
		public function parseTable(arr:Array):void
		{
			if (arr[0] != 1)
				return;
			
			var configHeroID:uint = arr[1];
			var step:uint = arr[2];
			var prop:ItemProp = new ItemProp();
			var len:uint = arr.length;
			var propId:uint;
			var propKey:String;
			var value:Number;
			
			for (var i:uint = 3; i< len; i+=2)
			{
				if (!arr[i])
					break;
				propId = arr[i];
				value = arr[i+1];
				propKey = PropManager.instance.getPropByID(propId).key;
				prop[propKey] = value;
			}
			
			setStepProp(configHeroID, step, prop);
		}
		
		private static function getKey(configHeroID:uint, step:uint):String
		{
			return (configHeroID + "_" + step);
		}
		
	}
}
