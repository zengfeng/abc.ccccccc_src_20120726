package game.module.rewardPackage {
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.notification.ICOMenuManager;
	import game.module.notification.VoICOButton;
	import game.net.core.Common;
	import game.net.data.StoC.SCGiftList;
	import game.net.data.StoC.SCGiftTaken;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	import net.RESManager;

	import com.commUI.GCommonWindow;
	import com.commUI.button.KTButtonData;
	import com.utils.UICreateUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;





	/**
	 * @author zheng
	 */
	public class PackageRewardPanel extends GCommonWindow
	{
		public function PackageRewardPanel()
		{
			_data = new GTitleWindowData();
			_data.width = 450;
			_data.height = 320;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;
			super(_data);
		}

		private var _back : Sprite;

		private var _listPanel : GPanel;

		private var _ico : MovieClip;

		private var _icoLable : TextField;

		override protected function create() : void
		{
			super.create();
			this.title = "礼包奖励";
			_back = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			_back.x = 5;
			_back.y = 5;
			_back.width = 436;
			_back.height = 304;
			_ico = RESManager.getMC(new AssetData("icon_hint"));
			_ico.x = 21;
			_ico.y = 17;
			_icoLable = UICreateUtils.createTextField("活动奖励最多只保留10天", null, 150, 18, 47, 15,UIManager.getTextFormat());
			this.contentPanel.add(_back);
			this.contentPanel.add(_icoLable);
			this.contentPanel.add(_ico);

			var panelData : GPanelData = new GPanelData();
			panelData.x = 0;
			panelData.y = 65;
			panelData.width = 440;
			panelData.height = 200;
			panelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			_listPanel = new GPanel(panelData);
			this.contentPanel.add(_listPanel);
			
			addLables();
			for (var i : int = 0;i < 4;i++)
			{
				_list[i] = new GiftPackageItem(i);
				_list[i]["x"] = 10;
				_list[i]["y"] = 50 * i;
				_listPanel.add(_list[i]);
			}
			
			addButton();
		}

		private var _acceptAll : GButton;

		private function addButton() : void
		{
			if (!_acceptAll)
			{
				var data : KTButtonData = new KTButtonData(KTButtonData.SMALL_BUTTON);
				data.width = 80;
				data.height = 30;
				data.x = 187;
				data.y = 270;
				_acceptAll = new GButton(data);
				_acceptAll.text = "收取全部";
			}
			addChild(_acceptAll);
		}

		private function addLables() : void
		{
			var mc : MovieClip = RESManager.getMC(new AssetData("topLineBack"));
			mc.x = 10;
			mc.y = 39;
			this.contentPanel.add(mc);
			var data : GLabelData = new GLabelData();
			data.y = 80;
			data.x = 84;
			var title1 : TextField = UICreateUtils.createTextField("礼包奖励名称", null, 80, 18, 90, 43, UIManager.getTextFormat(12, 0xffffff));
			var title2 : TextField = UICreateUtils.createTextField("日期", null, 80, 18, 258, 43, UIManager.getTextFormat(12, 0xffffff));
			var title3 : TextField = UICreateUtils.createTextField("操作", null, 30, 18, 371, 43, UIManager.getTextFormat(12, 0xffffff));
			this.contentPanel.add(title1);
			this.contentPanel.add(title2);
			this.contentPanel.add(title3);
			var mc2 : MovieClip = RESManager.getMC(new AssetData("topGoldLine"));
			mc2.x = 5;
			mc2.y = 264;
			this.contentPanel.add(mc2);
		}

		override protected function onShow() : void
		{
			super.onShow();
			_acceptAll.addEventListener(MouseEvent.CLICK, onClick);
		    GiftPackageManage.instance.sendReqListMsg();
			Common.game_server.addCallback(0x70, updateGiftPanel);   //礼包列表
			Common.game_server.addCallback(0x71, onResGift);   //已领取礼包
		}

		override protected function onHide() : void
		{
			super.onHide();
			_acceptAll.removeEventListener(MouseEvent.CLICK, onClick);
			clearList();
			Common.game_server.removeCallback(0x71, onResGift);   //已领取礼包
			Common.game_server.removeCallback(0x70, updateGiftPanel);   //礼包列表
		}

		private var _list : Dictionary = new Dictionary();

		public function setdata(value : *) : void
		{
			clearList();
			var list : Vector.<VoPackReward>=value;
			
			
			if (!list) return ;
			var max : int = list.length;
//			max = max > 4 ? max : 4;
			for (var i : int = 0;i < max;i++)
			{
				if (!_list[i])
				{
					_list[i] = new GiftPackageItem(i);
					_list[i]["x"] = 10;
					_list[i]["y"] = 50 * i;
				}
				
				(_list[i] as GiftPackageItem).source =i>=list.length?null:list[i];
				_listPanel.add(_list[i]);
			}
		}

		private function clearList() : void
		{
			for each (var item:GiftPackageItem in _list)
			{
				if(item.parent)item.parent.removeChild(item);
			}
		}

		private function onClick(event : MouseEvent) : void
		{
			//NotificationProxy.opNotification(0, 0);
			GiftPackageManage.sendResGift(0);
		}
		
	    private function onResGift(msg:SCGiftTaken):void
		{	
            clearList();
			GiftPackageManage.instance.removeGifNum();
			GiftPackageManage.instance.sendReqListMsg();
		}
		
		private function removeList(gifts:Vector.<uint>):void
		{
			for each(var id:int in gifts)
			{
				for each (var item:GiftPackageItem in _list)
				{
				  if(item.id==id&&item.parent)
				  {
				   item.parent.removeChild(item);
				   break;
				  }
				}
			}
		}
		
      // private var _giftList:Vector.<VoPackReward>=new Vector.<VoPackReward>();		
	   private function updateGiftPanel(msg:SCGiftList):void
	   {
		
		    var _giftList:Vector.<VoPackReward>=new Vector.<VoPackReward>();				    
			if(msg.gifts.length==0)
			{
			   MenuManager.getInstance().closeMenuView(MenuType.GIFTALL);
			   return;
			}
			
			for(var i:int=0;i<msg.gifts.length;i++)
			{
			    var gift:VoPackReward=new VoPackReward();
				gift.giftId=msg.gifts[i].id;
				gift.giftItems=msg.gifts[i].items;
				gift.rewardExp=msg.gifts[i].exp;
				gift.rewardParams=msg.gifts[i].params;
				gift.giftTime=msg.gifts[i].time;
				var id:int=gift.giftId;
				gift.icoButton=getInfoByID(id);
				
				_giftList.push(gift);			
			}	
			
			setdata(_giftList);
		//	MenuManager.getInstance().openMenuView(MenuType.GIFTALL).target["data"] = _giftList;
	   }
	   
	   
	   private function getInfoByID(id:int):VoICOButton
	   {
		   var vo:VoICOButton;
	       vo=ICOMenuManager.getInstance().getIcoVo(id);
		   return vo;
	   }
	}
}
