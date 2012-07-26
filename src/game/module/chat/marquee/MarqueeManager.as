package game.module.chat.marquee
{
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import flash.display.Sprite;
	/**
	 * @author 1
	 */
	public class MarqueeManager 
	{
		private static var _instance : MarqueeManager;
		private var _MarqueePanel:MarqueeView;
		private var _marqueeModel:MarqueeModel;
		public function MarqueeManager()
		{
			if (_instance)
			{
				throw Error("---ScrollMessage--is--a--single--model---");
			}
			
			initView();
		}

		
			
        public static function get instance() : MarqueeManager
		{
			if (_instance == null)
			{
				_instance = new MarqueeManager();
			}
			return _instance;
		}
		
		private function initView():void
		{
		   addMarquee();		   
//		   SignalBusManager.battleStart.add(hideMarqueePanel);
//		   SignalBusManager.battleEnd.add(showMarqueePanel);
		   
		}
		
		private function addMarquee():void
		{
			_marqueeModel=new MarqueeModel();
           
		    var data:GComponentData=new GComponentData();
			_MarqueePanel=new MarqueeView(data,_marqueeModel);
			_MarqueePanel.hide();
			
		}
		
		private var i:int=1;
		public function showMarquee(str : String) : void
		{			
//			str="我是跑马灯我是跑马灯我是跑马灯我是跑马灯"+i.toString();
			_marqueeModel.marqueeMsg.push(str);
//			_MarqueePanel.setModel(_marqueeModel);
			_MarqueePanel.show();
			_MarqueePanel.playMarquee(str);
			i++;
		}	
		
		private function hideMarqueePanel(n:int):void
		{
			_MarqueePanel.hide();
		}
		
		private function showMarqueePanel():void
		{
			_MarqueePanel.show();
		}
	}
}
