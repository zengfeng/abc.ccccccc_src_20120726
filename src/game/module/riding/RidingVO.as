package game.module.riding
{
	/**
	 * @author 1
	 */
	public class RidingVO
	{
		
		public var mountID:int;
		public var mountName:String;
		public var mountRarity:String;		
		public var mountGetType:String;
		public var mountPrice:String;
	    public var mountDescription : String;	
        //先用着
        public var mountBinding:String;		
		public var mountType : String;
		public var mountImageID: int = 40;			
		public var mountTitle : String;
		
		
		
		public function prase(arr:Array):void
		{
			mountID=arr[0];
			mountName=arr[1];
			mountRarity=arr[2];
			mountGetType=arr[3];
			mountPrice=arr[4];
			mountBinding=arr[5];
			mountDescription=arr[6];
		}
	}
	
	
	
}
