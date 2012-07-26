package game.module.vip.view
{
	import game.manager.VersionManager;

	import net.LibData;

	import game.core.IModuleInferfaces;
	import game.core.IAssets;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.vip.VIPItemVO;
	import game.module.vip.config.VIPConfig;
	import game.module.vip.config.VIPConfigManager;
	import game.module.vip.config.VIPItem;
	import game.net.core.Common;
	import game.net.data.StoC.SCPlayerInfoChange;

	import gameui.controls.GButton;
	import gameui.controls.GList;
	import gameui.controls.GProgressBar;
	import gameui.data.GButtonData;
	import gameui.data.GListData;
	import gameui.data.GPanelData;
	import gameui.data.GProgressBarData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author ME
	 */
	public class VIPView extends GCommonWindow implements IModuleInferfaces, IAssets
	{
		// ======================================================
		// 属性
		// ======================================================
		private var _progressBar : GProgressBar;
		private var _vipList : GList;
		private var _nowVipLevelText : TextField;
		private var _nextVipLevelText : TextField;
		private var _vipInfoLevelText : TextField;
		private var _vipInfoLevelUpText : TextField;
		private var _button : GButton;
		private var _currVIPConfig : VIPConfig;
		private var _nextVIPConfig : VIPConfig;
		private var _hyperlink : TextField;
		private var _maxVipLevel : int;
		private var _chestIcon : Sprite;

		// ======================================================
		// 方法
		// ======================================================
		// --------------------------------------------
		// 创建
		// --------------------------------------------
		public function VIPView()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 611;
			data.height = 382;
			data.allowDrag = true;
			data.parent = ViewManager.instance.uiContainer;
			super(data);
		}

		private function addVipViewBg() : void
		{
			var viewBg : Sprite = UIManager.getUI(new AssetData(UI.VIP_BG));
			viewBg.x = 5;
			viewBg.y = 0;
			viewBg.width = 596;
			viewBg.height = 377;
			addChildAt(viewBg, 1);
		}

		private function addGirlPicture() : void
		{
			var girlPicture : Sprite = UIManager.getUI(new AssetData("VIP_Girl", "vip"));
			girlPicture.x = -110;
			girlPicture.y = -77;
			addChild(girlPicture);
		}

		private function addVipListTitleBg() : void
		{
			var listBgBg : Sprite = UIManager.getUI(new AssetData("VIP_New_List_Bg_Bg", "vip"));
			listBgBg.x = 195;
			listBgBg.y = 132;
			listBgBg.width = 396;
			listBgBg.height = 200;
			addChild(listBgBg);

			var listBg : Sprite = UIManager.getUI(new AssetData("VIP_New_List_Bg", "vip"));
			listBg.x = 195;
			listBg.y = 132;
			listBg.width = 396 - 10 - 3;
			listBg.height = 175;
			addChild(listBg);

			var listTitleBg : Sprite = UIManager.getUI(new AssetData("VIP_New_Tilte_Bg", "vip"));
			listTitleBg.x = 195;
			listTitleBg.y = 108;
			listTitleBg.width = 396;
			listTitleBg.height = 24;
			addChild(listTitleBg);
		}

		private function addVipIcon() : void
		{
			var vipIcon : Sprite = UIManager.getUI(new AssetData("VIP_New_Icon", "vip"));
			vipIcon.x = 170;
			vipIcon.y = -9;
			addChild(vipIcon);
		}

		private function addChestIcon() : void
		{
			_chestIcon = UIManager.getUI(new AssetData("VIP_New_Chest", "vip"));
			// 从美术获取的资源,mouseEnable会被默认置为false
			_chestIcon.mouseEnabled = true;
			_chestIcon.x = 528;
			_chestIcon.y = 11;
			addChild(_chestIcon);
		}

		private function addVipInfoText() : void
		{
			var textFormat : TextFormat = new TextFormat();
			textFormat.bold = true;

			_vipInfoLevelText = UICreateUtils.createTextField(null, "", 300, 25, 131 + 157, 12 + 10, UIManager.getTextFormat(14, 0x2f1f00, TextFormatAlign.LEFT));
			_vipInfoLevelText.defaultTextFormat = textFormat;
			addChild(_vipInfoLevelText);

			_vipInfoLevelUpText = UICreateUtils.createTextField(null, "", 300, 25, 131 + 157, 30 + 15, UIManager.getTextFormat(14, 0x2f1f00, TextFormatAlign.LEFT));
			_vipInfoLevelUpText.defaultTextFormat = textFormat;
			addChild(_vipInfoLevelUpText);
		}

		private function addVipProgressBar() : void
		{
			var data : GProgressBarData = new GProgressBarData();
			data.x = 130 + 160;
			data.y = 50 + 27;
			data.width = 296 + 6;
			data.height = 14;
			data.padding = 4;
			data.paddingY = 4;
			data.paddingX = 4;
			data.trackAsset = new AssetData(UI.VIP_PROGRESSBAR_TRACKSKIN, "vip");
			data.barAsset = new AssetData(UI.VIP_PROGRESSBAR_BARSKIN, "vip");
			_progressBar = new GProgressBar(data);
			addChild(_progressBar);
		}

		private function addRechargeButton() : void
		{
			var buttonData : GButtonData = new GButtonData();
			buttonData.upAsset = new AssetData("VIP_New_Button_Up", "vip");
			buttonData.overAsset = new AssetData("VIP_New_Button_Over", "vip");
			buttonData.downAsset = new AssetData("VIP_New_Button_Down", "vip");
			_button = new GButton(buttonData);
			_button.x = 346;
			_button.y = 323;
			_button.width = 100;
			_button.height = 37;
			addChild(_button);
		}

		private function addVipListTitle() : void
		{
			var textFormat : TextFormat = new TextFormat();
			textFormat.bold = true;

			_nextVipLevelText = UICreateUtils.createTextField("", null, 200, 20, 265, 110, UIManager.getTextFormat(12, 0xffffff, TextFormatAlign.LEFT));
			_nextVipLevelText.defaultTextFormat = textFormat;
			addChild(_nextVipLevelText);
		}

		private function addVipListText() : void
		{
			var data : GListData = new GListData();
			data.padding = 0;
			data.x = 195 + 2;
			data.y = 132;
			data.width = 396 - 5;
			data.height = 175;
			data.hGap = 0;
			// data.rows = VIPConfigManager.instance.getNItems();
			data.rows = 0;
			data.bgAsset = new AssetData(SkinStyle.emptySkin);
			data.verticalScrollPolicy = GPanelData.ON;
			data.scrollBarData.wheelSpeed = 25;
			data.cell = VIPListCell;
			data.cellData.width = 386;
			data.cellData.height = 25;
			_vipList = new GList(data);
			addChild(_vipList);
		}

		private function addHyperlinkText() : void
		{
			_hyperlink = UICreateUtils.createTextField(null, "", 150, 20, 455, 110);
			_hyperlink.textColor = 0xff3300;
			_hyperlink.htmlText = "<b><u>点击查看更多VIP功能</u></b>";
			_hyperlink.mouseEnabled = true;
			_hyperlink.selectable = false;
			addChild(_hyperlink);
		}

		private function addVipListOutline() : void
		{
			var listOutline : Sprite = UIManager.getUI(new AssetData("VIP_New_List_Outline", "vip"));
			listOutline.x = 195 - 1;
			listOutline.y = 105;
			listOutline.width = 396 + 1.5;
			listOutline.height = 202 + 3;
			addChild(listOutline);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateVIP() : void
		{
			_currVIPConfig = VIPConfigManager.instance.getConfigItems(UserData.instance.vipLevel);
			_nextVIPConfig = VIPConfigManager.instance.getConfigItems(UserData.instance.vipLevel + 1);
		}

		private function updateVipInfoText() : void
		{
			if (UserData.instance.vipLevel < _maxVipLevel)
			{
				_vipInfoLevelText.htmlText = StringUtils.addColor("VIP等级:", "#2f1f00") + StringUtils.addColor(String(UserData.instance.vipLevel), "#ff3300");
				_vipInfoLevelUpText.htmlText = StringUtils.addColor("再充", "#2f1f00") + StringUtils.addColor(String(_nextVIPConfig.gold - UserData.instance.totalTopup), "#ff3300") + StringUtils.addColor("元宝  将成为VIP", "#2f1f00") + StringUtils.addColor(String(UserData.instance.vipLevel + 1), "#ff3300");
			}
			else
			{
				_vipInfoLevelText.htmlText = StringUtils.addColor("VIP等级:", "#2f1f00") + StringUtils.addColor(String(UserData.instance.vipLevel), "#ff3300");
				_vipInfoLevelUpText.visible = false;
			}
		}

		private function updateVipProgressBar() : void
		{
			if (UserData.instance.vipLevel < _maxVipLevel)
			{
				_progressBar.value = UserData.instance.totalTopup / _nextVIPConfig.gold * 100;
				_progressBar.text = String(UserData.instance.totalTopup) + "/" + String(_nextVIPConfig.gold);
			}
			else
			{
				_progressBar.value = UserData.instance.totalTopup / _currVIPConfig.gold * 100;
				_progressBar.text = String(UserData.instance.totalTopup) + "/" + String(_currVIPConfig.gold);
			}
		}

		private function updateVipListTitle() : void
		{
			if (UserData.instance.vipLevel < _maxVipLevel)
			{
				_nextVipLevelText.htmlText = StringUtils.addColor("VIP", "#ff3300") + StringUtils.addColor(String(UserData.instance.vipLevel + 1), "#ff3300") + StringUtils.addColor("的特权", "#2f1f00");
			}
			else
			{
				_nextVipLevelText.htmlText = StringUtils.addColor("VIP", "#ff3300") + StringUtils.addColor(String(UserData.instance.vipLevel), "#ff3300") + StringUtils.addColor("的特权", "#2f1f00");
			}
		}

		private function updateVipListText() : void
		{
			var cellItems : Array = [];
			var bg : int = 0;
			var vo : VIPItemVO ;
			var i : int;

			if (UserData.instance.vipLevel == _maxVipLevel)
			{
				_nextVIPConfig = _currVIPConfig;
			}

			for ( i = 0; i < _nextVIPConfig.items.length; i++)
			{
				vo = new VIPItemVO();
				var nextItem : VIPItem = _nextVIPConfig.items[i];
				var currItem : VIPItem = _currVIPConfig.getItem(nextItem.id);

				vo.name = nextItem.name;
				if (currItem)
				{
					vo.currState = getTimesString(_currVIPConfig.getOpenNumber(currItem.id), currItem.text);
				}
				else
				{
					vo.currState = "";
				}

				if (UserData.instance.vipLevel < _maxVipLevel)
					vo.nextState = getTimesString(_nextVIPConfig.getOpenNumber(nextItem.id), nextItem.text);
				else
					vo.nextState = vo.currState;

				// 判断特权是否有变化，有变化才给下一级特权开启情况文字赋上指定红色颜色，否则为默认棕色
				if (vo.currState != vo.nextState)
					vo.nextLevelColor = 0xff3300;
				else
					vo.nextLevelColor = 0x2f1f00;

				vo.bgInt = bg % 2;
				vo.vipListNum = bg + 1;
				cellItems.push(vo);
				bg++;
			}

			_vipList.model.source = cellItems;
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override public function show() : void
		{
			super.show();
			updateVIP();
			updateVipInfoText();
			updateVipProgressBar();
			updateVipListTitle();
			updateVipListText();

			Common.game_server.addCallback(0x11, playerInfoChange);
			ToolTipManager.instance.registerToolTip(_chestIcon, ToolTip, provideToolTip);
			_button.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			_hyperlink.addEventListener(MouseEvent.ROLL_OVER, hyperlinkRollOverHandler);
			_hyperlink.addEventListener(MouseEvent.CLICK, hyperlinkClickHandler);
			_hyperlink.addEventListener(MouseEvent.ROLL_OUT, hyperlinkRollOutHandler);
		}

		override public function hide() : void
		{
			Common.game_server.removeCallback(0x11, playerInfoChange);
			ToolTipManager.instance.destroyToolTip(_chestIcon);
			_button.removeEventListener(MouseEvent.CLICK, buttonClickHandler);
			_hyperlink.removeEventListener(MouseEvent.ROLL_OVER, hyperlinkRollOverHandler);
			_hyperlink.removeEventListener(MouseEvent.CLICK, hyperlinkClickHandler);
			_hyperlink.removeEventListener(MouseEvent.ROLL_OUT, hyperlinkRollOutHandler);
			super.hide();
		}

		private function playerInfoChange(e : SCPlayerInfoChange) : void
		{
			updateVIP();
			updateVipInfoText();
			updateVipProgressBar();
			updateVipListTitle();
			updateVipListText();
		}

		private function buttonClickHandler(event : MouseEvent) : void
		{
			var url : URLRequest = new URLRequest("http://www.xd.com/orders/create/");
			navigateToURL(url, "_blank");
		}

		private function hyperlinkRollOverHandler(event : MouseEvent) : void
		{
			_hyperlink.textColor = 0xff6633;
		}

		private function hyperlinkClickHandler(event : MouseEvent) : void
		{
			_hyperlink.textColor = 0xd04f24;
			var url : URLRequest = new URLRequest("http://www.xd.com/orders/create/");
			navigateToURL(url, "_blank");
		}

		private function hyperlinkRollOutHandler(event : MouseEvent) : void
		{
			_hyperlink.textColor = 0xff3300;
		}

		private static function getTimesString(openNumber : int, text : String) : String
		{
			if (openNumber == 0)
				return "开启";
			else
				return String(openNumber) + text;
		}

		private function provideToolTip() : String
		{
			var text : String = "";

			if (UserData.instance.vipLevel < _maxVipLevel)
			{
				text += "下级VIP礼包：" + "\r";

				for (var i : int = 0; i < _nextVIPConfig.treasurePackages.length; i = i + 2)
				{
					var item : Item = ItemManager.instance.newItem(int(_nextVIPConfig.treasurePackages[i]));
					// text += "赠送 " + '<font size="12"><b>' + item.htmlName + '</b></font>' + StringUtils.addColorById("×" + String(_nextVIPConfig.treasurePackages[i + 1]), item.color) + "\r";
					if (item.name == "修为")
					{
						text += "赠送 " + StringUtils.addColor(item.name + "×" + String(_nextVIPConfig.treasurePackages[i + 1]), "#ffff00") + "\r";
					}
					else
					{
						text += "赠送 " + '<font size="12">' + item.htmlName + '</font>' + StringUtils.addColorById("×" + String(_nextVIPConfig.treasurePackages[i + 1]), item.color) + "\r";
					}
				}
			}
			else
			{
				text = "恭喜你，你的VIP已经到达顶级啦！" + "\r";
			}

			return text;
		}

		public function initModule() : void
		{
			title = "VIP充值";
			_maxVipLevel = VIPConfigManager.instance.getMaxVipLevel();

			addVipViewBg();
			addGirlPicture();
			addVipListTitleBg();
			addVipIcon();
			addChestIcon();
			addVipInfoText();
			addVipProgressBar();
			addRechargeButton();
			addVipListTitle();
			addVipListText();
			addHyperlinkText();
			addVipListOutline();
		}

		public function getResList() : Array
		{
			return [new LibData(VersionManager.instance.getUrl("assets/swf/vip.swf"), "vip")];
		}
	}
}
