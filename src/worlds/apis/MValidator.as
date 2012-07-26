package worlds.apis
{
	import worlds.apis.validators.Validator;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-9
	 */
	public class MValidator
	{
		public static var walk : Validator = new Validator();
		public static var transport : Validator = new Validator();
		public static var changeMap : Validator = new Validator();
		public static var joinOtherActivity : Validator = new Validator();
	}
}
