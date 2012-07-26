package game.module.wordDonate {
	import game.manager.SignalBusManager;
	import game.module.daily.DailyManage;
	import game.net.core.Common;
	import game.net.data.CtoS.CSDonateList;
	import game.net.data.CtoS.CSDonateListCount;
	import game.net.data.CtoS.CSDonateRank;
	import game.net.data.StoC.SCDonateList;
	import game.net.data.StoC.SCDonateList.DonateListInfo;
	import game.net.data.StoC.SCDonateListCount;
	import game.net.data.StoC.SCDonateRank;
	/**
	 * @author Lv
	 */
	public class DonateProxy {
		private static var _instance:DonateProxy;
		// 本周贡献值
		public static var nowWeekContributionVaule:int;
		// 当前排名
		public static var nowWeekRank:int;
		// 开天斧等级
		public static var donateLevel:int;
		// 开天斧当前贡献值
		public static var nowContributionVaule:int;
		//贡献人数  计算页码用
		public static var contributionNum:int;
		// 贡献排名列表
		public static var contributionRank:Vector.<Object> = new Vector.<Object>();
		
		//当前页码
		public static var nowPageNum:int = 1;
		
		
		public function DonateProxy(control:Control):void{
			control;
			sToC();
		}
		public static function get instance():DonateProxy{
			if(_instance == null){
				_instance = new DonateProxy(new Control());
			}
			return _instance;
		}
 //-------------------sToC-----------------------------------------------------------
 		public function sToC():void{
			// 当前排名
			Common.game_server.addCallback(0x101, sCDenoteRank);
			//贡献人数
			Common.game_server.addCallback(0x102, sCDonateListCount);
			// 贡献排名
			Common.game_server.addCallback(0x103, cSDenoteList);
		}
		// 贡献人数
		private function sCDonateListCount(e:SCDonateListCount) : void {
			contributionNum = e.count;
			DonateControl.instance.refrePage();
		}
		// 贡献排名
		private function cSDenoteList(e:SCDonateList) : void {
			if(contributionRank.length>0)clearnVec();
			var list:Vector.<DonateListInfo> = e.list;
			for each(var donatel:DonateListInfo in list){
				var obj:Object = new Object();
				obj["id"] = donatel.id;
				obj["name"] = donatel.name;
				obj["color"] = donatel.color;
				obj["level"] = donatel.level;
				obj["vaule"] = donatel.count;
				contributionRank.push(obj);
			}
			DonateControl.instance.refershList();
		}
		// 当前排名
		private function sCDenoteRank(e:SCDonateRank) : void {
			nowWeekContributionVaule = e.count;
			nowWeekRank = e.rank;
			donateLevel = e.level;
			nowContributionVaule = e.donateCount;
			DonateControl.instance.refershDoante();
			SignalBusManager.updateDaily.dispatch(DailyManage.ID_AXE,  DailyManage.STATE_OPENED ,e.rank);
		}
 //-------------------cToS-----------------------------------------------------------
 		//申请当前排名
 		public function applyNow():void{
			Common.game_server.sendMessage(0x101);
		}
		//申请贡献排名
		public function applyList():void{
			var cmd:CSDonateList = new CSDonateList();
			cmd.page = nowPageNum;
			Common.game_server.sendMessage(0x103,cmd);
		}
		//当前排名的总数  页码申请
		public function applyCount():void{
			var cmd:CSDonateListCount = new CSDonateListCount();
			Common.game_server.sendMessage(0x102,cmd);
		}
 //-----------------------------------------------------------------------------------------
		//清空数组
		private function clearnVec() : void {
			while(contributionRank.length>0){
				contributionRank.splice(0, 1);
			}
		}
	}
}
class Control{}
