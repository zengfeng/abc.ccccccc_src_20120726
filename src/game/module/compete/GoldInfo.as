package game.module.compete
{
	import com.utils.TimeUtil;
	import com.utils.TextFormatUtils;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import game.manager.RSSManager;
	import gameui.containers.GPanel;
	import gameui.controls.GLabel;
	import gameui.data.GPanelData;
	import gameui.skin.SkinStyle;
	import net.AssetData;




	/**
	 * @author zheng
	 */
	public class GoldInfo extends GPanel
	{
		// =====================
		// @属性
		// =====================	
        private var _prop : Dictionary = new Dictionary(true);
		
			
		
		public function GoldInfo(_data:GPanelData)
		{
			_data.width = 575;
			_data.height = 50;
			_data.bgAsset = new AssetData(SkinStyle.emptySkin);
			super(_data);
			initView();
		//	create();
		}
		// =====================
		// @创建
		// =====================	   
		private function initView() : void
		{
			addInfoText();
			
		}
		
		private var _goldinfo:TextField;
		private var _goldinfo_content:String;
		private function addInfoText():void
		{
			var _format:TextFormat=new TextFormat();
			_goldinfo=new TextField();
			_goldinfo.defaultTextFormat=TextFormatUtils.goldinfo;
			_goldinfo.filters = [new GlowFilter(0x000000, 0.8, 2, 2, 8, 1, false, false)];
			_goldinfo.width=600;
			_goldinfo.height=50;
			_goldinfo.x=0;
			_goldinfo.y=10;
			_goldinfo.mouseEnabled=false;
			_goldinfo_content="当前排名****** 可以获得*****修为 于####领取";
			_goldinfo.text=_goldinfo_content;
			addChild(_goldinfo);
			_goldinfo.visible=false;
		}
		
		// =====================
		// @刷新
		// =====================	
		public function refreshInfoText() : void
		{
		    var date : Date = new Date();
			var time:uint=VoCompete.bonusTime;
			date.setTime(VoCompete.bonusTime * 1000);
			var weekDay:uint=date.day;
			var hour:uint=date.hours;
			var minutes:uint=date.minutes;
			var rank:int=VoCompete.myRank;
			var xiuwei:String=getxiuwei(rank);
			
			
			_goldinfo_content="当前排名****** 可以获得*****修为 于####领取";
			_goldinfo_content = _goldinfo_content.replace("******",rank);   //排名数
			_goldinfo_content = _goldinfo_content.replace("*****",xiuwei);    //多少声望
			
			if(weekDay>3||weekDay==3&&hour>19||weekDay==3&&hour==19&&minutes>30||weekDay==0&&hour<19||weekDay==0&&hour==19&&minutes<30)
			{
			_goldinfo_content = _goldinfo_content.replace("####","周日19:30");    //于什么时候领取
			}
			else
			{
			_goldinfo_content = _goldinfo_content.replace("####","周三19:30");    //于什么时候领取	
			}
			_goldinfo.text=_goldinfo_content;
			_goldinfo.visible=true;
		}
		
		// =====================
		// @不修改
		// =====================	
//	    override protected function create():void
//		{
//			addGoldInfoLabel();
//		//	addPriceText();
//		}	
		public function getxiuwei(rank:uint) : String
		{
			var xiuweistr : String = "";
			var rank_int : int = rank;
			if (rank_int == 1)
			{
				xiuweistr = "1200";
			}
			else if (rank_int == 2)
			{
				xiuweistr = "800";
			}
			else if (rank_int == 3)
			{
				xiuweistr = "600";
			}
			else if (rank_int <= 10 && rank_int >= 4)
			{
				xiuweistr = "500";
			}
			else if (rank_int <= 30 && rank_int >= 11)
			{
				xiuweistr = "400";
			}
			else if (rank_int <= 100 && rank_int >= 31)
			{
				xiuweistr = "300";
			}
			else if (rank_int <= 500 && rank_int >= 101)
			{
				xiuweistr = "200";
			}
			else if (rank_int <= 1000 && rank_int >= 501)
			{
				xiuweistr = "150";
			}
			else if (rank_int > 1000)
			{
				xiuweistr = "100";
			}
            return xiuweistr;
		}
		
		private function addGoldInfoLabel():void
		{
			
		}
			
	   override public function show():void
		{
			super.show();
		//	GLayout.layout(this);
		}
		
		override public function hide():void
		{
			
			super.hide();
		}
		
	}
}
