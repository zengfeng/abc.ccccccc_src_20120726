package game.module.battle.view {
	import com.utils.PotentialColorUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.module.battle.battleData.resultData;
	
	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;
	
	import net.AssetData;
	
	
	public class BTResult extends GComponent
	{
		private var _ok : GButton;
		
		private var _textResult:TextField;

		public function BTResult()
		{
			_base = new GComponentData();
			_base.width = 292;
			_base.height = 166;
			_base.parent = UIManager.root;
			_base.x = 500;
			_base.y = 200;
			super(base);
			initView();
		}

		private function initView() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData("BattlePanel", "Numbers"));
			addChild(bg);

			var btData : GButtonData = new GButtonData();
			_ok = new GButton(btData);
			_ok.text = "确定";
			_ok.addEventListener(MouseEvent.CLICK, onClick);
			_ok.x = 108;
			_ok.y = 115;
			addChild(_ok);
					
			_textResult = new TextField();
			_textResult.x = -4;
			_textResult.y = 70;
			_textResult.width = this.width;
			_textResult.autoSize = TextFieldAutoSize.CENTER;
			_textResult.wordWrap = true;
			
			var fm:TextFormat = new flash.text.TextFormat();
			fm.leading = 5;
			_textResult.setTextFormat(fm);
			
			addChild(_textResult);
		}
		
		private function resetTextPosition():void
		{
			_textResult.x = -4;
			_textResult.y = 70;
		}
		
		private function getTextStr(result:uint, res:resultData):String
		{
			var i:int = 0;
			var silverNum:uint = 0;   //银币数量
			var honorNum:uint = 0;    //修为数量
			var expNum:uint = 0;      //经验数量
			var itemNameArr:Array = [];  //物品名
			var itemid:uint = 0;
			var itemname:String = "";
			var itemnum:uint = 0;
			var itemcolor:String = "";
			var color:uint = 0;
			
			if(res)
			{
				expNum = res.exp;
				for(i = 0; i < res.rewardlist.length; ++i)
				{
					if(((res.rewardlist[i] >> 16)&0xFFFF) == 25003) //silver
					{
						silverNum = res.rewardlist[i] & 0xFFFF;
					}
					else if(((res.rewardlist[i] >> 16)&0xFFFF) == 25004) //honor
					{
						honorNum = res.rewardlist[i] & 0xFFFF;
					}
					else
					{
						itemid = (res.rewardlist[i] >> 16)&0xFFFF;
						var item:Item = ItemManager.instance.newItem(itemid);
						if(!item)continue;
						itemnum = res.rewardlist[i] & 0xFFFF;
						itemname = item.htmlName;
						color = item.color;
						itemcolor = PotentialColorUtils.getColorOfStr(color);
						itemNameArr.push({itemName:itemname, itemNum:itemnum, itemColor:itemcolor});
					}
				}
			}
			
			var htmlStr:String = "";
			var firstRowNum:uint = 0;
			if(expNum > 0)
				++firstRowNum;
			if(honorNum > 0)
				++firstRowNum;
			if(silverNum > 0)
				++firstRowNum;
			
			//if(result == 1) //战斗胜利
			{
				if(firstRowNum == 0)
				{
					for(i = 0; i < itemNameArr.length; ++i)
					{
						if(i == 0)
							htmlStr += "         ";
						htmlStr += itemNameArr[i].itemName + "<font color='"+ itemNameArr[i].itemColor +"'"+  ">"+ "×" + itemNameArr[i].itemNum + "</font>";
						if( (i+1)%3 == 0 )
						{
							htmlStr += "\n";
							htmlStr += "         ";
							_textResult.y -= 20;
						}
						else
						{
							htmlStr += "       ";
						}
					}
				}
				else if(firstRowNum == 1)
				{
					if(itemNameArr.length == 1)
						htmlStr += "                                       ";
					else if(itemNameArr.length == 2)
						htmlStr += "                 ";
					else if(itemNameArr.length == 0 || itemNameArr.length >= 3)
						htmlStr += "                                        ";
					
					if(expNum > 0)
						htmlStr += "<font size='12' color='#2F1F00'>"+ "经验</font>" + "<font color = '#279F15'>"+ "+" + expNum + "</font>";
					else if(silverNum > 0)
						htmlStr += "<font size='12' color='#2F1F00'>"+ "银币</font>" + "<font color = '#279F15'>"+ "+" + silverNum + "</font>";
					else if(honorNum > 0)
						htmlStr += "<font size='12' color='#2F1F00'>"+ "修为</font>" + "<font color = '#279F15'>"+ "+" + honorNum + "</font>";
					
					
					if(itemNameArr.length <=2)
					{
						for(i = 0; i < itemNameArr.length; ++i)
						{
							if(itemNameArr.length == 1)
								htmlStr += "           ";
							else if(itemNameArr.length == 2)
								htmlStr += "      ";
							htmlStr += itemNameArr[i].itemName + "<font color='"+ itemNameArr[i].itemColor +"'"+  ">"+ "×" + itemNameArr[i].itemNum + "</font>";
						}
					}
					else
					{
						//换行
						htmlStr += "\n";
						for(i = 0; i < itemNameArr.length; ++i)
						{
							if(i == 0)
								htmlStr += "         ";
							htmlStr += itemNameArr[i].itemName + "<font color='"+ itemNameArr[i].itemColor +"'"+  ">"+ "×" + itemNameArr[i].itemNum + "</font>";
							if( (i+1)%3 == 0 )
							{
								htmlStr += "\n";
								htmlStr += "         ";
								_textResult.y -= 20;
							}
							else
							{
								htmlStr += "       ";
							}
						}
					}
				}
				else if(firstRowNum == 2)
				{
					var b_lab:Boolean = false;
					if(itemNameArr.length == 1)
						htmlStr += "                 ";
					else if(itemNameArr.length == 0 || itemNameArr.length >= 1)
						htmlStr += "                   ";
					
					if(expNum > 0)
					{
						b_lab = true;
						htmlStr += "<font size='12' color='#2F1F00'>"+ "经验</font>" + "<font color = '#279F15'>"+ "+" + expNum + "</font>";
					}
					if(silverNum > 0)
					{
						b_lab = true;
						if(b_lab)
							htmlStr += "           ";
						htmlStr += "<font size='12' color='#2F1F00'>"+ "银币</font>" + "<font color = '#279F15'>"+ "+" + silverNum + "</font>";
					}
					if(honorNum > 0)
					{
						if(b_lab)
							htmlStr += "           ";
						htmlStr += "<font size='12' color='#2F1F00'>"+ "修为</font>" + "<font color = '#279F15'>"+ "+" + honorNum + "</font>";
					}
					
					
					if(itemNameArr.length ==1)
					{
						htmlStr += "           ";
						htmlStr += itemNameArr[i].itemName + "<font color='"+ itemNameArr[i].itemColor +"'"+  ">"+ "×" + itemNameArr[i].itemNum + "</font>";
					}
					else
					{
						htmlStr += "\n";
						for(i = 0; i < itemNameArr.length; ++i)
						{
							if(i == 0)
								htmlStr += "           ";
							htmlStr += itemNameArr[i].itemName + "<font color='"+ itemNameArr[i].itemColor +"'"+  ">"+ "×" + itemNameArr[i].itemNum + "</font>";
							if( (i+1)%3 == 0 )
							{
								htmlStr += "\n";
								htmlStr += "         ";
								_textResult.y -= 20;
							}
							else
							{
								htmlStr += "       ";
							}
						}
					}
				}
				else if(firstRowNum == 3)
				{
					htmlStr += "            ";
					
					if(expNum > 0)
					{
						htmlStr += "<font size='12' color='#2F1F00'>"+ "经验</font>" + "<font color = '#279F15'>"+ "+" + expNum + "</font>";
					}
					if(silverNum > 0)
					{
						htmlStr += "           ";
						htmlStr += "<font size='12' color='#2F1F00'>"+ "银币</font>" + "<font color = '#279F15'>"+ "+" + silverNum + "</font>";
					}
					if(honorNum > 0)
					{
						htmlStr += "           ";
						htmlStr += "<font size='12' color='#2F1F00'>"+ "修为</font>" + "<font color = '#279F15'>"+ "+" + honorNum + "</font>";
					}
					
					
					if(itemNameArr.length > 0)
					{
						//换行
						htmlStr += "\n";
						_textResult.y -= 20;
						for(i = 0; i < itemNameArr.length; ++i)
						{
							if(i == 0)
								htmlStr += "         ";
							htmlStr += itemNameArr[i].itemName + "<font color='"+ itemNameArr[i].itemColor +"'"+  ">"+ "×" + itemNameArr[i].itemNum + "</font>";
							if( (i+1)%3 == 0 )
							{
								htmlStr += "\n";
								htmlStr += "         ";
								_textResult.y -= 20;
							}
							else
							{
								htmlStr += "       ";
							}
						}
					}
				}
			}
			return htmlStr;
		}
		
		//sysType:系统类型  result：战斗结果  res：
		public function setTextResult(sysType:uint, result:uint, res:resultData):void
		{
			if(!res)return;
			resetTextPosition();

			if(sysType == BTSystem.FT_DUGEON)   //副本
			{
				if(result == 1 )//战斗胜利
				{
					_textResult.htmlText = getTextStr(result, res); ;
				}
				else
				{
					_textResult.htmlText = "<font size='12' color='#2F1F00' >" + "胜败乃兵家常事，增强实力后再次挑战吧！" + "</font>" ;
				}
			}
			else if(sysType == BTSystem.FT_QUESTNPC)//任务
			{
				if(result == 1 )//战斗胜利
				{
					_textResult.htmlText = "" ;
				}
				else
				{
					_textResult.htmlText = "" ;
				}
			}
			else if(sysType == BTSystem.FT_COUNTRY)//国战
			{
				if(result == 1 )//战斗胜利
				{
					_textResult.htmlText = getTextStr(result, res);
				}
				else
				{
					_textResult.htmlText = getTextStr(result, res);
				}
			}
			else if(sysType == BTSystem.FT_BOSS || sysType == BTSystem.FT_GUILDDUGEON  || sysType == BTSystem.FT_GBODYGUARD)  //boss战,家族寻宝
			{
				var dmgPer:Number = res.exp / 100;
				if(result == 1)
				{
				    _textResult.htmlText = "<font size='12' color='#2F1F00'>"+ "                          你对BOSS造成了</font>" + "<font color = '#279F15'>"+ dmgPer + "%" + "</font>" + 
					                       "<font size='12' color='#2F1F00'>"+ "伤害</font>";
				}
				else
				{
					_textResult.htmlText = "<font size='12' color='#2F1F00'>"+ "                          你对BOSS造成了</font>" + "<font color = '#279F15'>"+ dmgPer + "%" + "</font>" + 
						                   "<font size='12' color='#2F1F00'>"+ "伤害</font>";
				}
			}
			else if(sysType == BTSystem.FT_ATHLETICS)  //竞技场
 			{
				if(result == 1 )//战斗胜利
				{
					_textResult.htmlText = getTextStr(result, res);
				}
				else
				{
					_textResult.htmlText = getTextStr(result, res);
				}
			}
			else if(sysType == BTSystem.FT_GUARD )   //运镖(要分打劫别人和被别人打劫s)， 家族运镖
			{
				if(BTSystem.INSTANCE().getGuardResult() == 0) //打劫别人
				{	
					//打劫别人
					if(result == 1 )//战斗胜利
					{
						_textResult.htmlText =  getTextStr(result, res);
					}
					else
					{
						_textResult.htmlText = "<font size='12' color='#2F1F00' >" + "胜败乃兵家常事，增强实力后再次挑战吧！" + "</font>" ;
					}
				}
				else if(BTSystem.INSTANCE().getGuardResult() == 0)  //被别人打劫
				{
					if(result == 1 )//战斗胜利
					{
						_textResult.htmlText = "" ;
					}
					else
					{
						_textResult.htmlText = "" ;
					}
				}	
			}
			else if( sysType == BTSystem.FT_LOCKBOSS) //锁妖塔
			{	
				if(result == 1) //战斗胜利
				{

					_textResult.htmlText = getTextStr(result, res);
					
				}
				else
				{
					_textResult.htmlText = "<font size='12' color='#2F1F00' >" + "胜败乃兵家常事，增强实力后再次挑战吧！" + "</font>" ;
				}
			}
			else if( sysType == BTSystem.FT_ARTIFACTS ) //神器
			{
				_textResult.htmlText = "" ;
			}
		}

		private function onClick(evt : Event) : void
		{
			this.hide();
	
			if (BTSystem.mc_Victory && BTSystem.mc_Victory.parent)
			{
				if(BTSystem.mc_Victory.parent.contains(BTSystem.mc_Victory))
					BTSystem.mc_Victory.parent.removeChild(BTSystem.mc_Victory);
			}

			if (BTSystem.mc_Lose && BTSystem.mc_Lose.parent)
			{
				if(BTSystem.mc_Lose.parent.contains(BTSystem.mc_Lose))
					BTSystem.mc_Lose.parent.removeChild(BTSystem.mc_Lose);
			}
			
			BTSystem.INSTANCE().end();
			BTSystem.INSTANCE().sendEnd(1);
		}

		public function close() : void
		{
			this.hide();
			if (BTSystem.INSTANCE())
			{
				if (UIManager.root)
				{
					if (UIManager.root.contains(BTSystem.mc_Victory))
					{
						UIManager.root.removeChild(BTSystem.mc_Victory);
					}

					if (UIManager.root.contains(BTSystem.mc_Lose))
					{
						UIManager.root.removeChild(BTSystem.mc_Lose);
					}
				}
			}
		}

		override public function show() : void
		{
			// this.x = (UIManager.stage.stageWidth-_base.width)/2;
			// this.y = (UIManager.stage.stageHeight-_base.height)/2 -100;
			super.show();
		}
	}
}