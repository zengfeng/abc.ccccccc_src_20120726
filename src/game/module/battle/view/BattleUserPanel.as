package game.module.battle.view
{
	import game.config.StaticConfig;
	import game.manager.RSSManager;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.quest.VoMonster;

	import gameui.controls.GImage;
	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.data.GLabelData;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.AssetData;

	import com.commUI.tooltip.ToolTipManager;
	import com.utils.PotentialColorUtils;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	public class BattleUserPanel extends GComponent {
		private var _back : Sprite;
		// 背景图片
		private var _userHead : GImage;
		private var _name : TextField;
		private var _serverid : GLabel;
		private var _level : GLabel;
		private var _array : Array = [6, 3, 0];
		private var _artifactsContainer : BTArtifactBuffContainer;

		public function BattleUserPanel() {
			_base = new GComponentData();
			_base.parent = ViewManager.instance.uiContainer;
			_base.align = new GAlign(0);
			_base.x = 3;
			_base.width = 92;
			_base.height = 92;
			super(_base);

			initView();
		}

		private function initView() : void {
			_back = UIManager.getUI(new AssetData("BattleHeadPhoto_Bg"));
			_back.x = 5 + 2;
			_back.y = 15;
			addChild(_back);

			var _imgData : GImageData = new GImageData();
			_imgData.x = 13;
			_imgData.y = 0;
			_imgData.iocData.align = new GAlign(0, 0);
			_userHead = new GImage(_imgData);
			addChild(_userHead);

			var bag : Sprite = UIManager.getUI(new AssetData("BattleHeadPhoto_Fg"));
			bag.y = 10;
			bag.x = 0 + 2;
			addChild(bag);

			// name
			/*			var data : GLabelData = new GLabelData();
			data.textFormat = UIManager.getTextFormat(16, 0xffcc00, TextFormatAlign.CENTER);
			data.textFormat.align = TextFormatAlign.CENTER;
			data.textColor = 0xffcc00;
			data.width = 86;
			data.y = 100 + 2;
			data.text = "";
			// UserData.instance.playerName;
			_name = new GLabel(data);*/
			_name = UICreateUtils.createTextField("", "", 95, 20, 0, 102, UIManager.getTextFormat(16, 0xffcc00, TextFormatAlign.CENTER));
			_name.filters = [new GlowFilter(0x000000, 1, 2, 2, 6, 1, false, false)];
			// _name.filters = UIManager.getEdgeFilters(0x000000, 1, 2);
			addChild(_name);

			var data : GLabelData = new GLabelData();
			data.textColor = 0xffffff;
			data.textFormat = UIManager.getTextFormat(12);
			data.y = 12;
			data.width = 30;
			data.text = String("");
			data.x = 0;
			_level = new GLabel(data);
			addChild(_level);

			data = data.clone();
			data.textColor = 0xffffff;
			data.textFormat = UIManager.getTextFormat(10);
			data.y = 103;
			data.width = 20;
			data.text = String("");
			data.x = 4;
			_serverid = new GLabel(data);
			addChild(_serverid);
		}

		override public function show() : void {
			super.show();
		}

		override public function hide() : void {
			super.hide();
		}

		public function setName(name : String) : void {
			// _name.text = name;
			_name.x = 10;
			_name.htmlText = StringUtils.addBold(name);
		}

		public function setBackGround(id : int, turn : Boolean = false, artifact : uint = 0) : void {
			var atsLvl:uint;
			var convoyLvl:uint;
			var newbieLvl:uint;
			atsLvl = artifact & 0x7F;
			convoyLvl = (artifact >> 7) & 0x07;
			newbieLvl = (artifact >> 10);
			if (id > 4000 ) {
				var monster : VoMonster = RSSManager.getInstance().getMosterById(id);
				if (!monster) {
					Logger.error("id==>" + id);
				}
				id = monster ? monster.headImg : 0;
			}
			_userHead.url = VersionManager.instance.getUrl("assets/ico/halfBody/" + id + ".png");
			// 图片是否翻转
			if (turn) {
				_userHead.scaleX = -1;
			} else {
				_userHead.scaleX = 1;
			}

			if (turn) {
				_userHead.x = _base.width + 12;
			} else {
				_userHead.x = 0;
			}
			_userHead.y = -75 + 37;

			if(artifact > 0)
			{	
				ResourceClear();
				_artifactsContainer = new BTArtifactBuffContainer(turn ? 1 : 0);
				this.addChild(_artifactsContainer);
				if (turn) {
					_artifactsContainer.x = -_artifactsContainer.width + 8;
					_artifactsContainer.y = 95;
				} else {
					_artifactsContainer.x = 100;
					_artifactsContainer.y = 10;
				}

			}
			else
			{
				ResourceClear();
			}
			
			// 神器
			if (atsLvl > 0)
			 {
//==================================================
//TODO: 创建了BUff
//==================================================				
				var artbuff : BTArtifactBuff = new BTArtifactBuff();
				artbuff.initViews(StaticConfig.cdnRoot + "assets/ico/buffStatus/artifactbuf.jpg", atsLvl, 0);
				_artifactsContainer.addArtifact(artbuff);
				var artfactdata : BTArtifactData = new BTArtifactData(atsLvl, 0);
				ToolTipManager.instance.registerToolTip(artbuff, BTArtifactBuffTip, artfactdata);
			}
				
			//运镖
			if(convoyLvl > 0)
			{
				var artbuff2 : BTArtifactBuff = new BTArtifactBuff();
				if(convoyLvl == 1)
				{
					artbuff2.initViews(StaticConfig.cdnRoot + "assets/ico/buffStatus/buff_221.jpg", convoyLvl, 1);
				}
				else if(convoyLvl == 2)
				{
					artbuff2.initViews(StaticConfig.cdnRoot + "assets/ico/buffStatus/buff_222.jpg", convoyLvl, 1);
				}
				else if(convoyLvl == 3)
				{
					artbuff2.initViews(StaticConfig.cdnRoot + "assets/ico/buffStatus/buff_223.jpg", convoyLvl, 1);
				}
				else if(convoyLvl == 4)
				{
					artbuff2.initViews(StaticConfig.cdnRoot + "assets/ico/buffStatus/buff_224.jpg", convoyLvl, 1);
				}
				_artifactsContainer.addArtifact(artbuff2);
				var artfactdata2 : BTArtifactData = new BTArtifactData(convoyLvl, 1);
				ToolTipManager.instance.registerToolTip(artbuff2, BTGuardBuffTip, artfactdata2);
			}
			
			//新手
			if(newbieLvl > 0)
			{
				var artbuff3 : BTArtifactBuff = new BTArtifactBuff();
				artbuff3.initViews(StaticConfig.cdnRoot + "assets/ico/buffStatus/buff_210.jpg", newbieLvl, 2);
				_artifactsContainer.addArtifact(artbuff3);
				var artfactdata3 : BTArtifactData = new BTArtifactData(newbieLvl, 2);
				ToolTipManager.instance.registerToolTip(artbuff3, BTNewPlayerBuffTip, artfactdata3);
			}
		}

		public function setLevel(l : int) : void {
			_level.text = l.toString();
			_level.x = _array[_level.text.length - 1];
		}

		public function setPlayerColor(c : uint) : void {
			_name.textColor = PotentialColorUtils.getColor(c);
		}
//==================================================
// 特定头像换背景
//==================================================		
		public function ResourceClear():void
		{
			var obj : *;
			var i:uint;
			
			if (_artifactsContainer)
			{
				while (_artifactsContainer && _artifactsContainer.numChildren > 0)
				{
					obj = _artifactsContainer.getChildAt(0);
					if (_artifactsContainer.contains(obj))
						_artifactsContainer.removeChild(obj);
				}
			}
		}
	}
}