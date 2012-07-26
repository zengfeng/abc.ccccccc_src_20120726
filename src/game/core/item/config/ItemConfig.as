package game.core.item.config
{
	/**
	 * @author qiujian
	 */
	public class ItemConfig
	{
		public var id:uint;
		public var name:String;
		public var type:uint;
		public var level:uint;
		public var color:uint;
		public var imgID:String;
		public var stackLimit:uint;
		public var price:uint;
		public var description:String;
		public var binding:Boolean;
		
		
		protected var count : int = 0;		
		
		public function parse(arr:Array):void
		{
			if (!arr) return;

			id = arr[count++];
			name = arr.length > count ? arr[count++] : "";
			type = arr.length > count ? arr[count++] : 0;
			level = arr.length > count ? arr[count++] : 0;
			color = arr.length > count ? arr[count++] : 0;
			imgID = arr.length > count ? arr[count++] : "jw0024";
			stackLimit = arr.length > count ? arr[count++] : 1;
			if (!stackLimit) stackLimit = 1;
			price = arr.length > count ? arr[count++] : 0;
			description = arr.length > count ? arr[count++] : "";
			binding = arr.length > count ? (arr[count++]?true:false) : false;
		}
		
		public function clone ():ItemConfig
		{
			var config:ItemConfig = new ItemConfig();
			config.id = id;
			config.name = name;
			config.type = type;
			config.level = level;
			config.color = color;
			config.imgID = imgID;
			config.stackLimit = stackLimit;
			config.price = price;
			config.description = description;
			config.binding = binding;
			return config;
		}
	}
}
