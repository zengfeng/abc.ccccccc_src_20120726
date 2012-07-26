package worlds.apis.validators
{
	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-9
	 */
	public class Validator
	{
		private var list : Vector.<Function> = new Vector.<Function>();
		private var fun : Function;
		private var args : Array;

		public function add(fun : Function) : Validator
		{
			var index : int = list.indexOf(fun);
			if (index == -1)
			{
				list.push(fun);
			}
			return this ;
		}

		public function remove(fun : Function) : Validator
		{
			var index : int = list.indexOf(fun);
			if (index != -1)
			{
				list.splice(index, 1);
			}
			return this ;
		}
		
		public function reset() : Validator
		{
			if( list != null && list.length > 0 ){
				list = new Vector.<Function>() ;
			}
			return this ;
		}
		
		public function endChange():void{
			fun = null ;
			args = null ;
		}
		
		public function doValidation(fun : Function, args : Array = null) : Boolean
		{
			this.fun = fun;
			this.args = args;
			var result : Boolean = true;
			var i : int;
			var length : int = list.length;
			var callFun : Function;
			for (i = 0; i < length; i++)
			{
				callFun = list[i];
				result = callFun(this);
				if (result == false)
				{
					return false;
				}
			}
			return true;
		}

		public function go() : void
		{
			if (fun != null)
			{
				fun.apply(null, this.args);
			}
		}
	}
}
