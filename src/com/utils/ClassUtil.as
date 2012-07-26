package com.utils
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author yangyiqiang
	 */
	public class ClassUtil
	{
		private static var _varStringDic : Dictionary = new Dictionary(true);

		public static function getClassVariable(obj : *) : Vector.<String>
		{
			var className : String = getQualifiedClassName(obj);
			if (_varStringDic[className] != null) return _varStringDic[className];
			var xml : XML = describeType(obj);
			var xmlList : XMLList = xml.descendants("variable");
			var objs : Vector.<Object>=new Vector.<Object>();
			var strV : Vector.<String>=new Vector.<String>();
			for each (var str:XML in xmlList)
				objs.push({name:str.attribute("name"), value:str["metadata"]["arg"].@value});
			objs.sort(fun);
			for each (var value:Object in objs)
			{
				strV.push(value["name"]);
			}
			_varStringDic[className] = strV;
			return strV;
		}

		public static function arrayToClass(vo : *, arr : Array) : *
		{
			if (!vo || !arr) return vo;
			var variables : Vector.<String>=getClassVariable(vo);
			var max : int = arr.length;
			for (var i : int = 0;i < max;i++)
			{
				if (!variables[i]) return vo;
				vo[variables[i]] = arr[i];
			}
			return vo;
		}

		public static function xmlToClass(vo : *, xml : XML) : *
		{
			if (!vo || !xml) return vo;
			var variables : Vector.<String>=getClassVariable(vo);
			var max : int = variables.length;
			for (var i : int = 0;i < max;i++)
			{
				vo[variables[i]] = xml[variables[i]];
			}
			return vo;
		}

		private static function fun(obj : Object, obj2 : Object) : int
		{
			return obj["value"] - obj2["value"];
		}
	}
}
