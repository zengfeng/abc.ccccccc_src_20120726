package game.core.prop
{
	/**
	 * @author jian
	 */
	public class Prop
	{
		public var id:uint;
		public var name:String;
		public var key:String;
		/**per 1:有%  2：无%**/
		public var per:int;
		
		public function parse(arr:Array):void
		{
			if (arr.length < 3)
				throw (Error("parseProperty错误"));
	
			id = arr[0];
			name = arr[1];
			key = arr[2];
			per = arr[3];
		}
	}
}
