package game.module.wordDonate {
	import flash.text.TextFormatAlign;
	import flash.text.TextField;
	import com.utils.UICreateUtils;
	import flash.events.MouseEvent;
	import game.definition.UI;

	import gameui.containers.GPanel;
	import gameui.controls.GLabel;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	import net.RESManager;

	import com.greensock.layout.AlignMode;
	import com.utils.StringUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;

	/**
	 * @author 1
	 */
	public class ContributionItem extends GPanel {
		private var titleArr:Array = ["排名","名字","等级","本周贡献"];
		public var nameStr:TextField;
		public var rankStr:TextField;
		private var levelStr:TextField;
		private var contributionStr:TextField;
		private var bg:Sprite;
		public function ContributionItem() {
			_data = new GPanelData();
			initData();
			super(_data);
			initView();
			initEvent();
		}

		private function initData() : void {
			_data.width = 298;
			_data.height = 25;
			_data.bgAsset=new AssetData(SkinStyle.emptySkin);   //取消背景
		}

		private function initEvent() : void {
		}

		private function initView() : void {
			addBG();
			addPanel();
		}
		private var bg1:MovieClip;
		private var bg2:Sprite;
		private function addBG() : void {
			bg1 = RESManager.getMC(new AssetData(UI.CONTRBG1));
			_content.addChild(bg1);
			bg2 = UIManager.getUI(new AssetData(UI.CONTRBG2));
			bg2.visible = false;
			_content.addChild(bg2);
			
			bg = UIManager.getUI(new AssetData("Clan_List_Head_Bg"));
			bg.width = 298;
			bg.height = 24;
			_content.addChild(bg);
			
		}
		//获取title标题
		public function getTitle():void{
			rankStr.text = titleArr[0];
			nameStr.text = titleArr[1];
			levelStr.text = titleArr[2];
			contributionStr.text = titleArr[3];
			rankStr.textColor = nameStr.textColor = levelStr.textColor = contributionStr.textColor = 0xFFFFFF;
		}
		/**
		 * bgColor:背景颜色转变
		 */
		public function setBgAlpha(bgColor:Boolean = true):void{
			bg2.visible = false;
			bg.visible = false;
			if(bgColor)
				bg1.gotoAndStop(1);
			else
				bg1.gotoAndStop(2);
		}
		public var rank:int = 1;
		public var playerID:int ;
		private var color1:uint;
		/**
		 * 《设置具体数值》
		 * rank:玩家排名
		 * name:玩家名称
		 * level:玩家等级
		 * contr:玩家本周贡献
		 * bgColor:背景颜色转变
		 * id:玩家id
		 * color:颜色值
		 */
		public function setContent(rank1:uint,name:String,level:uint,contr:uint,id:int,color:uint):void{
			rankStr.htmlText = String(rank1);
			nameStr.htmlText = name;
			levelStr.htmlText = String(level);
			contributionStr.htmlText = String(contr) + " 个";
			rank = rank1;
			playerID = id;
			color1 = color;
			nameStr.htmlText =StringUtils.addColorById(String(nameStr.text), color1);
			nameStr.addEventListener(MouseEvent.MOUSE_OVER, onover);
			nameStr.addEventListener(MouseEvent.MOUSE_OUT, onout);
		}
		/**
		 * 清空
		 */
		public function clearAll():void{
			rankStr.htmlText = "";
			nameStr.htmlText = "";
			levelStr.htmlText = "";
			contributionStr.htmlText = "";
			nameStr.removeEventListener(MouseEvent.ROLL_OVER, onover);
			nameStr.removeEventListener(MouseEvent.ROLL_OUT, onout);
			bg2.visible = false;
		}

		private function onout(event : MouseEvent) : void {
			nameStr.htmlText =  StringUtils.addEvent( StringUtils.addColorById(String(nameStr.text),color1) , "to") ;
		}

		private function onover(event : MouseEvent) : void {
			var str:String = StringUtils.addLine( StringUtils.addColorById(String(nameStr.text),color1));
			nameStr.htmlText =  StringUtils.addEvent( str , "to") ;
		}
		public var color:uint;
		/**
		 * 《设置颜色》
		 * color:颜色值
		 */
		public function setNameColor(color:uint):void{
			color = color;
			StringUtils.addColorById(nameStr.text, (color + 1));
		}
		/**
		 * 《设置背景》
		 */
		public function setBackGround():void{
			bg2.visible = true;
			bg.visible = false;
		}

		private function addPanel() : void {
			
			rankStr = UICreateUtils.createTextField(null, "1", 38, 25,0,0, new TextFormat(null,null,"0x2F1F00",null,null,null,null,null,TextFormatAlign.CENTER));
			
			nameStr = UICreateUtils.createTextField(null, "name", 122, 25,38,0, new TextFormat(null,null,"0x2F1F00",null,null,null,null,null,TextFormatAlign.CENTER));
			
			levelStr = UICreateUtils.createTextField(null, "21", 57, 25,160,0, new TextFormat(null,null,"0x2F1F00",null,null,null,null,null,TextFormatAlign.CENTER));
			
			contributionStr = UICreateUtils.createTextField(null, "本周贡献", 86, 25,217,0, new TextFormat(null,null,"0x2F1F00",null,null,null,null,null,TextFormatAlign.CENTER));
			
			_content.addChild(rankStr);
			
			_content.addChild(nameStr);
			
			_content.addChild(levelStr);
			
			_content.addChild(contributionStr);
			
			nameStr.mouseEnabled = true ;
			nameStr.selectable = false ;
			nameStr.autoSize = "center";
		}
	}
}
