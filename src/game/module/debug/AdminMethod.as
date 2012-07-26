package game.module.debug
{
	import flash.utils.ByteArray;

	/**
	 * Admin Method
	 */
	public class AdminMethod
	{
		public static const PREFIX : String = "admin";

		public static const ADMIN_HELP : String = "ah";

		public static const TO_AI : String = "toAI";

		public static const EXEC : String = "exec";

		private function toAI(params : Array) : void
		{
		}

		private function exec(params : Array) : void
		{
		}

		public function AdminMethod() : void
		{
		}

		public function run(params : Array) : void
		{
			if (params.length == 0) return;
			var method : String = params.shift();
			switch(method)
			{
				case TO_AI:
					toAI(params);
					break;
				case EXEC:
					exec(params);
					break;
			}
		}
	}
}
