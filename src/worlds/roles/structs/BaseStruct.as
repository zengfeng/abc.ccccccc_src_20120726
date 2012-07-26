package worlds.roles.structs
{
	import com.utils.PotentialColorUtils;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class BaseStruct
	{
		public var id : int;
		public var name : String;
		public var potential : int = -1;
		public var color : uint = 0xffee00;
		public var colorStr : String = "#ffee00";
		public var x : int;
		public var y : int;
		public var speed : Number = 4;

		public function setPotential(value : int) : void
		{
			potential = value;
			color = PotentialColorUtils.getColor(potential);
			colorStr = PotentialColorUtils.getColorOfStr(potential);
		}
	}
}
