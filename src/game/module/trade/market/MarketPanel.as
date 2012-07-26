package game.module.trade.market {
	import effects.GEffect;

	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.config.ItemConfig;
	import game.core.item.config.ItemConfigManager;
	import game.core.item.equipment.Equipment;
	import game.core.item.soul.Soul;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.net.core.Common;
	import game.net.data.CtoC.CCUserDataChangeUp;
	import game.net.data.CtoS.CSListSale;
	import game.net.data.StoC.SCBuyout;
	import game.net.data.StoC.SCListSale;

	import gameui.cell.GCell;
	import gameui.cell.LabelSource;
	import gameui.containers.GPanel;
	import gameui.containers.GTreePanel;
	import gameui.controls.GButton;
	import gameui.controls.GComboBox;
	import gameui.controls.GLabel;
	import gameui.core.ScaleMode;
	import gameui.data.GButtonData;
	import gameui.data.GComboBoxData;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.data.GTreePanelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import model.TreeNode;

	import net.AssetData;

	import utils.DictionaryUtil;

	import com.commUI.pager.Pager;
	import com.greensock.TweenLite;
	import com.utils.StringUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;


	/**
	 * @author zheng
	 */
	public class MarketPanel extends GPanel
	{
		// =====================
		// @定义
		// =====================
		private static const GOODS_LIST_SIZE : uint = 5;
		private static var reg : RegExp;
		private static var input_flag : int = 0;
		private static var _listNullLabel_PosX : int = 340;
		
	    private static var _stoneSystemOpenLevel:int=150;
		// =====================
		// @属性
		// =====================
		private var _pager : Pager;
		private var page_flag : int = 0;
		private var _priceButton_up : GButton;
		private var _priceButton_down : GButton;
		private var _countButton_up : GButton;
		private var _countButton_down : GButton;
		private var _comboBox : GComboBox;
		private var clearBtn_Label : GLabel;
		private var listNull_Label : GLabel;
		private var _goodsList : Vector.<MarketListCell>;
		private var _goodsListItem : MarketListCell;
		// 添加左側的分類樹
		public var _tree : GTreePanel;
		private var _root : TreeNode;
		private var _childQt : TreeNode;
		private var _childZb : TreeNode;
		private var _childYs : TreeNode;
		private var _childLz : TreeNode;
		private var _commonNode : Vector.<TreeNode> = new Vector.<TreeNode>();
		private var _zhuanbeiNode : Vector.<TreeNode> = new Vector.<TreeNode>();
		private var _yuanshenNode : Vector.<TreeNode> = new Vector.<TreeNode>();
		private var _bigNode : Vector.<TreeNode>;
		private var treeRecover_id : uint;
		private var _model : MarketModel;

		// =====================
		// @创建
		// =====================
		public function MarketPanel()
		{
			//trace("MarketPanel Construct from:" + getTimer());
			_model = new MarketModel();
			var data : GPanelData = new GPanelData();
			data.width = 675;
			data.height = 350;
			data.bgAsset = new AssetData(UI.TRADE_BACKGROUND_BIG);
			super(data);
			//trace("MarketPanel Construct to:" + getTimer());
		}

		override protected function create() : void
		{
			super.create();
			addBg();
			addTextLabel();
			addSearchComboBox();
			// addLabel();
			addTree();
			addGoodsList();
			addListNullLabel();
		}

		private function addGoodsList() : void
		{
			_goodsList = new Vector.<MarketListCell>();

			for (var i : int = 0;i < GOODS_LIST_SIZE;i++)
			{
				_goodsListItem = new MarketListCell();
				_goodsListItem.x = 145;
				_goodsListItem.y = 55.8 + 50 * i;
				addChild(_goodsListItem);
				_goodsList.push(_goodsListItem);
			}
		}

		private function addBg() : void
		{
			// 标题列表背景
			var bg_1 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_1));
			bg_1.width = 665;
			bg_1.height = 25;
			bg_1.x = 5;
			bg_1.y = 30;
			addChild(bg_1);

			// 树表和列表分割竖线
			var bg_2 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_2));
			bg_2.width = 2;
			bg_2.height = 292;
			bg_2.x = 145;
			bg_2.y = 56;
			addChild(bg_2);

			// 列表浅色背景条
			var bg_3 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_3));
			bg_3.width = 523;
			bg_3.height = 50;
			bg_3.x = 147;
			bg_3.y = 56;
			addChild(bg_3);

			// 列表深色背景条
			var bg_4 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_4));
			bg_4.width = 523;
			bg_4.height = 50;
			bg_4.x = 147;
			bg_4.y = 56 + 50 * 1;
			addChild(bg_4);

			// 列表浅色背景条
			var bg_5 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_3));
			bg_5.width = 523;
			bg_5.height = 50;
			bg_5.x = 147;
			bg_5.y = 56 + 50 * 2;
			addChild(bg_5);

			// 列表深色背景条
			var bg_6 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_4));
			bg_6.width = 523;
			bg_6.height = 50;
			bg_6.x = 147;
			bg_6.y = 56 + 50 * 3;
			addChild(bg_6);

			// 列表浅色背景条
			var bg_7 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_3));
			bg_7.width = 523;
			bg_7.height = 50;
			bg_7.x = 147;
			bg_7.y = 56 + 50 * 4;
			addChild(bg_7);

			//			// 解释图标
			// var bg_8:Sprite = UIManager.getUI(new AssetData(UI.ICON_HINT));
			// bg_8.x = 20;
			// bg_8.y = 10;
			// addChild(bg_8);

			// 小白条下
			var panelBg : Sprite = UIManager.getUI(new AssetData(UI.TRADE_MARKET_WHITELINE));
			panelBg.width = 441;
			panelBg.height = 2;
			panelBg.x = 170;
			panelBg.y = 307.5;
			_content.addChild(panelBg);
			// 小白条上
			var panelBg1 : Sprite = UIManager.getUI(new AssetData(UI.TRADE_MARKET_WHITELINE));
			panelBg1.width = 665;
			panelBg1.height = 2;
			panelBg1.x = 6;
			panelBg1.y = 55;
			_content.addChild(panelBg1);

			// 小白条上上
			var panelBg2 : Sprite = UIManager.getUI(new AssetData(UI.TRADE_MARKET_WHITELINE));
			panelBg2.width = 665;
			panelBg2.height = 1;
			panelBg2.x = 6;
			panelBg2.y = 28.6;
			_content.addChild(panelBg2);

			// 搜索背景
			var panelBg4 : Sprite = UIManager.getUI(new AssetData(UI.TRADE_SEARCHEDITBG));
			panelBg4.width = 13;
			panelBg4.height = 13;
			panelBg4.x = 516;
			panelBg4.y = 9;
			_content.addChildAt(panelBg4, 2);
		}
        /*创建标题列表*/
		private function addTextLabel() : void
		{
			addText("物品目录", 52, 20, 50, 32, 12);
			addText("商品", 28, 20, 210, 32, 12);
			addText("数量", 28, 20, 320, 32, 12);
			addText("出售人", 42, 20, 415, 32, 12);
			addText("价格", 28, 20, 520, 32, 12);
			addText("操作", 28, 20, 610, 32, 12);
			addSortButton();
		}
        /*创建提示信息文本 没有显示*/
		private function addLabel() : void
		{
			var _data : GLabelData = new GLabelData();
			_data.width = 162;
			_data.height = 18;
			_data.x = 37;
			_data.y = 7;
			_data.textFieldFilters = [];
			clearBtn_Label = new GLabel(_data);
			clearBtn_Label.text = "<font color='#000000'>完成的交易单，只保存10时间</font>";
			_content.addChild(clearBtn_Label);
		}
        /*创建未搜索到任何东西的提示信息*/        
		private function addListNullLabel() : void
		{
			var _data : GLabelData = new GLabelData();
			_data.width = 250;
			_data.height = 50;
			_data.x = _listNullLabel_PosX;
			_data.y = 72;
			_data.textFieldFilters = [];
			_data.textFormat.size = 14;
			_data.showEffect = new GEffect();
			listNull_Label = new GLabel(_data);
			listNull_Label.text = StringUtils.addBold(StringUtils.addColor("抱歉，没有搜索到相关物品", "#2F1F00"));
			addChild(listNull_Label);
			listNull_Label.hide();
		}

        /*添加排序列表*/
		private function addSortButton() : void
		{
			var buttonData : GButtonData = new GButtonData();
			buttonData.upAsset = new AssetData(UI.MARKET_SORTUP_UP);
			buttonData.overAsset = new AssetData(UI.MARKET_SORTUP_OVER);
			buttonData.downAsset = new AssetData(UI.MARKET_SORTUP_DOWN);
			// TODO: 这个皮肤找不到
			// buttonData.disabledAsset = new AssetData("EnterButtonSkin_Disable");
			buttonData.width = 41;
			buttonData.height = 23;
			buttonData.x = 520;
			buttonData.y = 31;
			_priceButton_up = new GButton(buttonData);
			addChild(_priceButton_up);
			_priceButton_up.addEventListener(MouseEvent.CLICK, priceButtonUpHandler);

			buttonData.upAsset = new AssetData(UI.MARKET_SORTDOWN_UP);
			buttonData.overAsset = new AssetData(UI.MARKET_SORTDOWN_OVER);
			buttonData.downAsset = new AssetData(UI.MARKET_SORTDOWN_DOWN);
			_priceButton_down = new GButton(buttonData);
			addChild(_priceButton_down);
			_priceButton_down.addEventListener(MouseEvent.CLICK, priceButtonDownHandler);
			_priceButton_down.hide();

			buttonData.upAsset = new AssetData(UI.MARKET_SORTUP_UP);
			buttonData.overAsset = new AssetData(UI.MARKET_SORTUP_OVER);
			buttonData.downAsset = new AssetData(UI.MARKET_SORTUP_DOWN);
			buttonData.x = 320;
			_countButton_up = new GButton(buttonData);
			addChild(_countButton_up);
			_countButton_up.addEventListener(MouseEvent.CLICK, countButtonUpHandler);

			buttonData.upAsset = new AssetData(UI.MARKET_SORTDOWN_UP);
			buttonData.overAsset = new AssetData(UI.MARKET_SORTDOWN_OVER);
			buttonData.downAsset = new AssetData(UI.MARKET_SORTDOWN_DOWN);
			_countButton_down = new GButton(buttonData);
			addChild(_countButton_down);
			_countButton_down.addEventListener(MouseEvent.CLICK, countButtonDownHandler);
			_countButton_down.hide();
		}
        /*方法 添加textfield*/
		private function addText(text : String, width : int, height : int, x : int, y : int, size : int) : TextField // type中 1=名字 2=数量 3=拥有者 4=价格
		{
			var textField : TextField = new TextField();
			var format : TextFormat = new TextFormat();
			format.size = size;
			format.color = 0xffffff;
			format.align = TextFormatAlign.CENTER;
			textField.mouseEnabled = false;
			textField.width = width;
			textField.height = height;
			textField.text = text;
			textField.x = x;
			textField.y = y;
			textField.setTextFormat(format);
			addChild(textField);
			return textField;
		}

	    /*创建搜索框*/
		private function addSearchComboBox() : void
		{
			// var bg:Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_5));
			// bg.x = 510;
			// bg.y = 7;
			// bg.width = 150;
			// bg.height = 20;
			// addChild(bg);

			var data : GComboBoxData = new GComboBoxData();
			data.x = 510;
			data.y = 3;
			data.width = 150;
			data.editable = true;
			data.listData.width = 150;
			data.listData.height=200;
			data.listData.rows=10;
			data.textInputData.hintText = "请输入物品关键字";
			data.textInputData.indent = 20;
			data.listData.scaleMode=ScaleMode.SCALE9GRID;
			_comboBox = new GComboBox(data);
			_comboBox.model.max = 0;
			_comboBox.model.source = [new LabelSource("")];
			_comboBox.selectionModel.index = 0;
			_comboBox.selectionModel.addEventListener(Event.CHANGE, selection_changeHandler);
			_comboBox.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			_comboBox.addEventListener(Event.CHANGE, textDeleteHandler);
			_comboBox.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);

			_content.addChildAt(_comboBox, 1);
		}
        /*创建树上的节点*/
		private function addTreeNode() : void
		{
			_bigNode= new Vector.<TreeNode>();
			_root = _tree.model.getRoot();
			addNodeData(_root, "装备", _bigNode, 20);
			addNodeData(_root, "元神", _bigNode, 30);
			addNodeData(_root, "强化", _bigNode, 40);
			
			
//			addNodeData(_root, "天材地宝", _bigNode, 50);
			if (UserData.instance.level >= _stoneSystemOpenLevel)
			{
			    addNodeData(_root, "原石", _bigNode, 60);
			}

			addNodeData(_root, "其他", _bigNode, 10);
			
			
			_childZb = _tree.model.getRoot().getChildren()[0];
			addNodeData(_childZb, "头饰", _zhuanbeiNode, 21);
			addNodeData(_childZb, "上衣", _zhuanbeiNode, 22);
			addNodeData(_childZb, "靴子", _zhuanbeiNode, 23);
			addNodeData(_childZb, "项链", _zhuanbeiNode, 24);
			addNodeData(_childZb, "腰带", _zhuanbeiNode, 25);
			addNodeData(_childZb, "戒指", _zhuanbeiNode, 26);
			addNodeData(_childZb, "碎片", _zhuanbeiNode, 27);

		    _childYs = _tree.model.getRoot().getChildren()[1];
			addNodeData(_childYs, "绿色元神", _yuanshenNode, 31);
			addNodeData(_childYs, "蓝色元神", _yuanshenNode, 32);
			addNodeData(_childYs, "紫色元神", _yuanshenNode, 33);
			
			
			if (UserData.instance.level >= _stoneSystemOpenLevel)
			{
				addGemNode();
				_childQt = _tree.model.getRoot().getChildren()[4];
			}
			
			else
			{
				_childQt = _tree.model.getRoot().getChildren()[3];
			}			
			addNodeData(_childQt, "节日", _commonNode, 11);
//			addNodeData(_childPt, "碎片", _commonNode, 12);
//			addNodeData(_childPt, "消耗品", _commonNode, 13);




			refreshTree();
		}
        /*创建原石子节点*/        
		private function addGemNode() : void
		{

			_childLz = _tree.model.getRoot().getChildren()[3];
			addNodeData(_childLz, "力量原石", _yuanshenNode, 61);
			addNodeData(_childLz, "敏捷原石", _yuanshenNode, 62);
			addNodeData(_childLz, "体魄原石", _yuanshenNode, 63);
			addNodeData(_childLz, "命中原石 ", _yuanshenNode, 64);
			addNodeData(_childLz, "高爆原石", _yuanshenNode, 65);
			addNodeData(_childLz, "防破原石", _yuanshenNode, 66);
			addNodeData(_childLz, "高反原石 ", _yuanshenNode, 67);
			addNodeData(_childLz, "生命原石", _yuanshenNode, 68);
			addNodeData(_childLz, "速度原石", _yuanshenNode, 69);
			addNodeData(_childLz, "攻击原石 ", _yuanshenNode, 71);
			addNodeData(_childLz, "降势原石", _yuanshenNode, 72);
			addNodeData(_childLz, "穿透原石 ", _yuanshenNode, 73);
			addNodeData(_childLz, "高涨原石", _yuanshenNode, 74);
			
		 // addNodeData(_childLz, "原石", _yuanshenNode, 75);
		}
        /*意义不明*/
		private function addNodeData(nodeParent : TreeNode, text : String, nodeChildren : Vector.<TreeNode>, value : int = 0) : void
		{
			var _obj : Object = new Object();
			_obj["lable"] = "<font color='#000000'>  " + text + "</font>";
			_obj["data"] = value;
			_obj["childrens"] = [];
			nodeChildren.push(new TreeNode(nodeParent, _obj));
		}
        /*创建界面左侧的树*/
		private function addTree() : void
		{
			var treeData : GTreePanelData = new GTreePanelData();
			treeData.bgAsset = new AssetData(UI.TRADE_TREEBG);

			treeData.vGap = 0;
			treeData.hGap = 0;
			treeData.width = 138;
			treeData.height = 290;
			treeData.x = 6;
			treeData.y = 57;

			_tree = new GTreePanel(treeData);
			_tree.addEventListener(GCell.SINGLE_CLICK, tree_singleClickHandler);
			_tree.cell = MarketPropCell;
			addChild(_tree);
			_tree.source = initData();
			addTreeNode();
			this.layout();
		}

		private function initData() : Object
		{
			var _data : Object = new Object();
			_data["lable"] = "";
			return _data;
		}

		// =====================
		// @更新
		// =====================
        /*初始化状态，当交易面板关闭后再被打开时执行*/
		public function initState() : void
		{
			_model.initpage = MarketModel.PAGEINIT_REQ;
			_model.initmarket = 0;
		//	tree_id=0;
			_model.market_type = MarketModel.LISTALL;
		}
        
        /*保存状态 交易面板关闭时执行*/		
		public function saveState() : void
		{
			_model.initpage = MarketModel.PAGEINIT_REQ;
			_model.market_list_type = 0;
			
			if (treeRecover_id!= 0)                 // 更新樹形控件
				{
					// _tree.closeTreeItem(_bigNode[voTrade.current_treeid/10-1]);
					closeTreeItemByData(_model.current_treeid);
//					closeTreeItem(_bigNode[int(_model.current_treeid / 10 - 1)]);
					treeRecover_id=0;
				}
		}
		

        /*更新拍卖列表*/
		private function updateSaleList() : void
		{
			var cmd : CSListSale = new CSListSale();
			// 在重新打开面板时进行刷新
			if (_model.initmarket == 0)                       //当市场关闭后被重新打开时执行 列表显示市场中的所有物品 默认排序
			{
				cmd.listtype = MarketModel.DEFAULTSORT << 16 | 0;
				cmd.param = MarketModel.FINDALL;
				cmd.begin = 0;
				cmd.cnt = GOODS_LIST_SIZE;
				Common.game_server.sendMessage(0xB7, cmd);
				_model.initmarket = 1;
				
//				if (tree_id!= 0)                 // 更新樹形控件
//				{
//					// _tree.closeTreeItem(_bigNode[voTrade.current_treeid/10-1]);
//					closeTreeItem(_bigNode[int(_model.current_treeid / 10 - 1)]);
//					tree_id=0;
//				}
			}
				
			// 在切换页签时进行刷新  需要判断切页之前保存的状态 1列出所有物品 2根据树上的分类进行的查找 3根据搜索框进行的查找
			else                                                                        
			{
								
				cmd.listtype = _model.market_sort_type << 16 | _model.market_list_type;

				if (_model.market_type == MarketModel.LISTALL)           //列出所有物品
				{
					cmd.param = MarketModel.FINDALL;
				}
				else if (_model.market_list_type == MarketModel.LISTPAGE_ID)   //根据分页查找
				{
					cmd.param = _model.current_treeid;
				}
				else if (_model.market_list_type == MarketModel.LISTITEM_ID)    //根据物品ID查找
				{
				    var item:Item;
				    item = _comboBox.list.selection["value"];
					
			      if (item is Soul)
			      {
				   var minlevelid : uint = (item as Soul).minLevelId;
				   var maxlevelid : uint = (item as Soul).maxLevelId;

				//   var cmd : CSListSale = new CSListSale();
				       cmd.listtype = 2 | 0 << 16;
				       cmd.param = maxlevelid | minlevelid << 16;
			      }
				  else
				  {
					cmd.param = _model.current_itemid;
				  }
					
				}
				cmd.begin = _model.begin;
				cmd.cnt = GOODS_LIST_SIZE;
				Common.game_server.sendMessage(0xB7, cmd);
			}
		}

        /*更新搜索框的列表*/
		private function updateComboBox() : void
		{
			var str : String = _comboBox.textInputText;

			// if(str>='0'&&str<='9')
			// return;
			if (str != "")
			{
				if (int(str).toString() == str)
					return;

//				var searchResult : Array = new Array();
				var itemName : String;

				var uniqItems : Dictionary = new Dictionary();                      //创建Object对象
	
	
				for each (var conf:ItemConfig in DictionaryUtil.getValues(ItemConfigManager.instance.configDict))   //遍历ItemConfig类
				{
					// 猥琐方法获取搜索名称
					var item : Item = ItemManager.instance.newItem(conf.id);     //根据id号获取物品
					itemName = item.searchName;
					if (itemName.search(str) != -1)                    //物品名字中包含要搜索的字符 继续
					{ 
						if(item.color!=1)                              //判断是否是白色物品，白色物品不显示
					  {
						if(item.binding==false)                        //判断是否是绑定物品，绑定物品不显示
						{
						if (!uniqItems.hasOwnProperty(item.name))      //将物品名称作为uniqItem的键值
						{
							uniqItems[item.name] = item;               //将物品的属性最为将物品名称作为uniqItem的属性
						}
						}
					  }
					}
				}

				var labels : Array = [];
				_comboBox.model.source = labels;

				var nameStr : String = "";
				var len:int = 0;				

				for each (var result:Item in DictionaryUtil.getValues(uniqItems).sortOn("id", Array.NUMERIC))                  //对uniqItems进行遍历 为字体加颜色并加入label数组
				{

						nameStr = StringUtils.addColorById(result.name, result.color);
						labels.push(new LabelSource(nameStr, result));
						len++;				
				}			
				if (len == 0)                                            //如果搜索结果为空 不显示下拉框
					return;
					
				_comboBox.model.source = labels;                         //将数组写入下拉框
				_comboBox.showList();                                    //显示下拉框
				_comboBox.list.setSelected(true, 0);
			}
		    else
			{
				_comboBox.hideList();
			}
		}

        /*收到物品列表信息时，对物品列表进行刷新操作*/
		private function onListSale(list : SCListSale) : void
		{
			_model.current_treeid = treeRecover_id;
			var i : int = 0;

			// 判断列表是否为空 是否显示无物品的提示文档
			if (list.sale.length == 0)
			{
				listNull_Label.show();
				listNull_Label.alpha = 0;
				TweenLite.to(listNull_Label, 0.2, {alpha:1, overwrite:0});
			}
			else
			{
				listNull_Label.alpha = 1;
				listNull_Label.hide();
			}

			// 显示有内容的单元格
			while (i < list.sale.length)
			{
				var count : int;
				var itemid : int = list.sale[i].item;
				var item : Item = ItemManager.instance.newItem(itemid);
				if (item is Equipment)                                          //取出物品 如果是装备 数量为1
				{
					(item as Equipment).enhanceLevel = list.sale[i].param;
					count = 1;
				}
				else if (item is Soul)          //取出物品 如果是元神 数量为1
				{
					count = 1;
				}
				else
				{
					count = list.sale[i].param;    
				}
				//设置一条物品信息 应该用VO传输比较合理
				_goodsList[i].setLabel(item, item.name, count.toString(), list.sale[i].seller.toString(), list.sale[i].price.toString(), itemid, i, list.sale[i].id);

				i++;
			}

			// 显示空白单元格
			while (i < GOODS_LIST_SIZE)              //如果物品数少于一页可显示的物品数 显示空白物品行
			{
				_goodsList[i].clearListCell();
				i++;
			}

			_model.begin = list.begin;                //记录当前页第一件物品的初始条数
			_model.total = list.total;                //记录当前页物品的总条数，用于显示翻页控件的页数
			var listCount : int = _model.total;

			var pagecount : int = Math.ceil(listCount / GOODS_LIST_SIZE);    //计算当前页数
			if (pagecount == 0)
				pagecount++;

			if (page_flag == 0)                       //如果page_flag为零，创建翻页控件
			{
				_pager = new Pager(4);
				_pager.y = 317;
				_pager.setPage(1, pagecount);
				_content.addChild(_pager);
				_pager.addEventListener(Event.CHANGE, pageItemChangeHandler);
				layoutPager();

				page_flag = 1;
				_model.pagecountnow = pagecount;
			}

			if (_model.initpage == MarketModel.PAGEINIT_REQ)         // 重新打开面板时需要初始化翻页控件
			{
				_pager.setPage(1, pagecount);
				layoutPager();
				_model.initpage = MarketModel.PAGEINIT_NREQ;
				_model.begin = 0;
				_comboBox.textInput.text = "";

				if (_model.current_treeid != 0)                      // 重新打开面板时需要初始化树形控件
				{
					// _tree.closeTreeItem(_bigNode[voTrade.current_treeid/10-1]);
					closeTreeItemByData(_model.current_treeid);
					_model.current_treeid = 1;
				}

				sortClear();                                         // 重新打开面板时需要初始化排序按钮
			}

			if (pagecount != _model.pagecountnow)                    // 因为市场中的物品个数变化，当前页数与原来的页数不相等
			{
				// _pageItem.refershTotel(pagecount);
				var j : int = _pager.model.page;
				_model.begin = (j - 1) * GOODS_LIST_SIZE;
				_pager.setPage(j, pagecount);
				layoutPager();
				_model.pagecountnow = pagecount;
			}
		}

		private function layoutPager() : void
		{
			_pager.x = _pager.parent.width - _pager.width - 14;
		}

		private function closeTreeItem(item : TreeNode) : void
		{
			while (item && item.getParent())
			{
				_tree.closeTreeItem(item);
				item = item.getParent();
			}
		}
		
		private function closeTreeItemByData(data : int) : void 
		{
			var rootId:int = int(data/10)*10;
			for each (var node:TreeNode in _bigNode)
			{
				if (node.getData()["data"] == rootId)
				{
					closeTreeItem(node);
				}
			}
		}
		

		// =====================
		// @交互
		// =====================
		override public function show() : void
		{
			super.show();
			GLayout.layout(this);
		}

		override public function hide() : void
		{
			super.hide();
		}
        /*控制切页-显示*/
		override protected function onShow() : void
		{
			// 监听item结束信息
			Common.game_server.addCallback(0xB7, onListSale);
			// 监听购买成功信息
			Common.game_server.addCallback(0xB9, onBuyout);

			Common.game_server.addCallback(0xFFF1, onUserLevelUp);

			updateSaleList();
			
			if(_model.userlevel<_stoneSystemOpenLevel&&UserData.instance.level>=_stoneSystemOpenLevel)
			{
			   treeDataChangeUp();
			}
		}

		private function updateTree() : void
		{
		}
        /*控制切页-隐藏*/
		override protected function onHide() : void
		{
			_comboBox.textInput.text = "";                              //切页是否刷新搜索框呢？？
		//	_comboBox.list.model.clear();		
			_comboBox.list.hide();
		//	_model.current_treeid=0;
		//	tree_id=0;
			Common.game_server.removeCallback(0xB7, onListSale);
			Common.game_server.removeCallback(0xB9, onBuyout);
			Common.game_server.removeCallback(0xFFF1, onUserLevelUp);
			_model.userlevel=UserData.instance.level;
		}
/************************搜索框操作函数********************************/
        /* 用户的搜索框输入事件 重新搜索*/
		private function textInputHandler(event : TextEvent) : void
		{
			updateComboBox();
		}

		/* 搜索框删除字符的事件，重新搜索*/
		private function textDeleteHandler(event : Event) : void
		{
            updateComboBox();
		}

		/*鼠标重新点回搜索框操作*/
		private function focusInHandler(event : FocusEvent) : void
		{
             updateComboBox();
		}
		
		/*选中combobox中的某一项，发送消息*/
		private function selection_changeHandler(event : Event) : void   
		{
			var item : Item;
			if (!_comboBox.list.selection)
				return;

			_model.market_type = MarketModel.LISTPART;

			item = _comboBox.list.selection["value"];
			_comboBox.textInputText = item.name;
			_model.market_list_type = MarketModel.LISTITEM_ID;
			_model.current_itemid = item.id;
			_model.begin = 0;

			if (item is Soul)
			{
				var minlevelid : uint = (item as Soul).minLevelId;
				var maxlevelid : uint = (item as Soul).maxLevelId;

				var cmd : CSListSale = new CSListSale();
				cmd.listtype = 2 | 0 << 16;
				cmd.param = maxlevelid | minlevelid << 16;
				cmd.begin = _model.begin;
				cmd.cnt = GOODS_LIST_SIZE;
				Common.game_server.sendMessage(0xB7, cmd);
			}
			else
			{
				var cmd1 : CSListSale = new CSListSale();
				cmd1.listtype = 1 | 0 << 16;
				cmd1.param = _model.current_itemid;
				cmd1.begin = _model.begin;
				cmd1.cnt = GOODS_LIST_SIZE;
				Common.game_server.sendMessage(0xB7, cmd1);
			}
			if (_model.current_treeid != 0)                 // 更新樹形控件
			{
				// _tree.closeTreeItem(_bigNode[voTrade.current_treeid/10-1]);
//				closeTreeItem(_bigNode[int(_model.current_treeid / 10 - 1)]);
				closeTreeItemByData(_model.current_treeid);
				_model.current_treeid = 1;
			}
		}
     /************************搜索框操作函数********************************/
		
		
		
	 /************************* 排序按钮操作函数***************************/
		private function priceButtonUpHandler(event : MouseEvent) : void
		{
			_priceButton_up.hide();
			_priceButton_down.show();
			_model.market_sort_type = MarketModel.PRICEDOWN;

			requireUpdateList();
		}

		private function priceButtonDownHandler(event : MouseEvent) : void
		{
			_priceButton_up.show();
			_priceButton_down.hide();
			_model.market_sort_type = MarketModel.PRICEUP;

			requireUpdateList();
		}

		private function countButtonUpHandler(event : MouseEvent) : void
		{
			_countButton_up.hide();
			_countButton_down.show();
			_model.market_sort_type = MarketModel.COUNTDOWN;

			requireUpdateList();
		}

		private function countButtonDownHandler(event : MouseEvent) : void
		{
			_countButton_up.show();
			_countButton_down.hide();
			_model.market_sort_type = MarketModel.COUNTUP;

			requireUpdateList();
		}

		private function  sortClear() : void
		{
			_priceButton_up.show();
			_priceButton_down.hide();
			_countButton_up.show();
			_countButton_down.hide();
			_model.market_sort_type = MarketModel.DEFAULTSORT;
		}
      /************************* 排序按钮操作函数***************************/
	  
	  
	  
		

		/*用户购买物品*/
		private function onBuyout(msg : SCBuyout) : void                  //购买物品
		{
			var i : int = _pager.model.page;
			_model.begin = (i - 1) * GOODS_LIST_SIZE;

			var cmd : CSListSale = new CSListSale();
			cmd.listtype = _model.market_sort_type << 16 | _model.market_list_type;
			if (_model.market_list_type == MarketModel.LISTPAGE_ID)
			{
				cmd.param = _model.current_treeid;
			}
			else if (_model.market_list_type == MarketModel.LISTITEM_ID)
			{
				var item:Item;
				    item = _comboBox.list.selection["value"];
					
			      if (item is Soul)
			      {
				   var minlevelid : uint = (item as Soul).minLevelId;
				   var maxlevelid : uint = (item as Soul).maxLevelId;

				//   var cmd : CSListSale = new CSListSale();
				       cmd.listtype = 2 | 0 << 16;
				       cmd.param = maxlevelid | minlevelid << 16;
			      }
				  else
				  {
					cmd.param = _model.current_itemid;
				  }
			}
			cmd.begin = _model.begin;
			cmd.cnt = GOODS_LIST_SIZE;
			Common.game_server.sendMessage(0xB7, cmd);
		}
		
		
		
        /*用户超过70级要刷新树 加入元神节点*/
		
		private function onUserLevelUp(msg:CCUserDataChangeUp):void
		{
			if(msg.level==_stoneSystemOpenLevel)
			{
				treeDataChangeUp();
				initState();			
				_model.current_treeid=0;	
				_model.market_type=0;
				_model.market_list_type=0;
				_model.initpage=1;
				_model.begin=0;
				treeRecover_id=0;
				updateSaleList();
				_comboBox.textInput.text = "";                              //切页是否刷新搜索框呢？？
			    _comboBox.list.hide();               
			}
		}
		private function treeDataChangeUp() : void
		{				
			    _tree.source = initData();
				_tree.clearContent();			            

				addTreeNode();	
		}
        /*刷新树*/
		public function refreshTree() : void
		{
			if (_root)
			{
				_tree.addNode(_childZb);
				_tree.addNode(_childYs);
				if (UserData.instance.level >= _stoneSystemOpenLevel)
				{
					_tree.addNode(_childLz);
				}
				
		        _tree.addNode(_childQt);
				
				this.layout();
			}
		}

		/* 分类树上事件的点击操作*/
		private function tree_singleClickHandler(event : Event) : void
		{
			sortClear();
			_comboBox.textInput.text = "";
			treeRecover_id = (event.target as MarketPropCell).getData1();
			_model.market_list_type = MarketModel.LISTPAGE_ID;
			_model.market_type = MarketModel.LISTPART;                             //修改当前搜索为分类搜索

			var cmd : CSListSale = new CSListSale();
			cmd.listtype = MarketModel.DEFAULTSORT << 16 | 0;
			cmd.param = treeRecover_id;
			cmd.begin = 0;

			cmd.cnt = GOODS_LIST_SIZE;
			Common.game_server.sendMessage(0xB7, cmd);
		}

		/* 换页控件上的点击事件*/
		private function pageItemChangeHandler(event : Event) : void
		{
			var i : int = _pager.model.page;   
			_model.begin = (i - 1) * GOODS_LIST_SIZE;

			var cmd : CSListSale = new CSListSale();
			cmd.listtype = _model.market_sort_type << 16 | _model.market_list_type;
			if (_model.market_list_type == MarketModel.LISTPAGE_ID)
			{
				cmd.param = _model.current_treeid;
			}
			else if (_model.market_list_type == MarketModel.LISTITEM_ID)
			{
				var item:Item;
				    item = _comboBox.list.selection["value"];
					
			      if (item is Soul)
			      {
				   var minlevelid : uint = (item as Soul).minLevelId;
				   var maxlevelid : uint = (item as Soul).maxLevelId;

				//   var cmd : CSListSale = new CSListSale();
				       cmd.listtype = 2 | 0 << 16;
				       cmd.param = maxlevelid | minlevelid << 16;
			      }
				  else
				  {
					cmd.param = _model.current_itemid;
				  }
			}
			cmd.begin = _model.begin;
			cmd.cnt = GOODS_LIST_SIZE;
			Common.game_server.sendMessage(0xB7, cmd);
			
			layoutPager();
		}

		// =====================
		// @其它
		// =====================
		/*
		 * 发送列表更新请求 更新列表狀態
		 */
		private function requireUpdateList() : void
		{
			var i : int = _pager.model.page;
			_model.begin = (i - 1) * GOODS_LIST_SIZE;

			var cmd : CSListSale = new CSListSale();
			cmd.listtype = _model.market_sort_type << 16 | _model.market_list_type;

			if (_model.market_list_type == MarketModel.LISTPAGE_ID)
			{
				cmd.param = _model.current_treeid;
			}
			else if (_model.market_list_type == MarketModel.LISTITEM_ID)
			{
				 var item:Item;
				    item = _comboBox.list.selection["value"];
					
			      if (item is Soul)
			      {
				   var minlevelid : uint = (item as Soul).minLevelId;
				   var maxlevelid : uint = (item as Soul).maxLevelId;

				//   var cmd : CSListSale = new CSListSale();
				       cmd.listtype = 2 | 0 << 16;
				       cmd.param = maxlevelid | minlevelid << 16;
			      }
				  else
				  {
					cmd.param = _model.current_itemid;
				  }
				
			}
			cmd.begin = _model.begin;
			cmd.cnt = GOODS_LIST_SIZE;

			// //trace("----->>>>>>list type"+voTrade.market_list_type);
			// //trace("----->>>>>>sort type"+voTrade.market_sort_type);
			// //trace("----->>>>>>sort type"+voTrade.market_sort_type);
			// //trace("----->>>>>>begin"+voTrade.begin);
			Common.game_server.sendMessage(0xB7, cmd);
		}
	}
}