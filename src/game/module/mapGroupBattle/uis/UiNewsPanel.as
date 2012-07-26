package game.module.mapGroupBattle.uis
{
	import game.net.data.StoC.GBUpdateData;
	import game.net.data.StoC.SCGroupBattlePlayerLost;

	import gameui.controls.GToggleButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GToggleButtonData;
	import gameui.group.GToggleGroup;
	import gameui.manager.UIManager;

	import model.SingleSelectionModel;

	import net.AssetData;

	import com.commUI.toggleButton.KTToggleButtonData;

	import flash.display.Sprite;
	import flash.events.Event;






	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-1-18 ����12:34:05
	 */
	public class UiNewsPanel extends GComponent
	{
		/** 背景 */
		private var bg : Sprite;
		public var buttonHeight : int = 20;
		/** 全部按钮 */
		public var allTabButton : GToggleButton;
		/** 个人按钮 */
		public var selfTabButton : GToggleButton;
		public var tabGroup : GToggleGroup = new GToggleGroup();
		/** 全部频道消息 */
		public var allMsg : ChannelMessage;
		/** 个人频道消息 */
		public var selfMsg : ChannelMessage;

		public function UiNewsPanel()
		{
			_base = new GComponentData();
			_base.width = 495;
			_base.height = 148;
			super(_base);
			initViews();
		}

		/** 初始化视图 */
		protected function initViews() : void
		{
			// 背景
			bg = UIManager.getUI(new AssetData("GroupBattle_NewsBg"));
			bg.width = _base.width;
			bg.height = _base.height;
			addChild(bg);
			// 全部按钮
			var buttonData : GToggleButtonData;
			var button : GToggleButton;
			buttonData = new KTToggleButtonData(KTToggleButtonData.NORMAL_TOGGLE_BUTTON);
			buttonData.width = 38;
			buttonData.labelData.text = "全部";
			button = new GToggleButton(buttonData);
			button.y = -buttonHeight;
			addChild(button);
			allTabButton = button;
			allTabButton.x = 3;
			// 个人按钮
			buttonData = new KTToggleButtonData(KTToggleButtonData.NORMAL_TOGGLE_BUTTON);
			buttonData.width = 38;
			buttonData.labelData.text = "个人";
			button = new GToggleButton(buttonData);
			button.y = -buttonHeight;
			addChild(button);
			selfTabButton = button;
			selfTabButton.x = 41;

			// 全部频道消息
			allMsg = new ChannelMessage(ChannelMessage.CHANNEL_ALL, _base.width - 5, _base.height);
			allMsg.x = 5;
			allMsg.y = 0;
			// 个人频道消息
			selfMsg = new ChannelMessage(ChannelMessage.CHANNEL_SELF, _base.width - 5, _base.height);
			selfMsg.x = 5;
			selfMsg.y = 0;

			tabGroup.selectionModel.addEventListener(Event.CHANGE, tabGroup_changeHandler);

			allTabButton.group = tabGroup;
			selfTabButton.group = tabGroup;
			tabGroup.selectionModel.index = 0;
		}

		private function tabGroup_changeHandler(event : Event) : void
		{
			var index : int = (event.currentTarget as SingleSelectionModel).index;
			selectIndex = index;
		}

		public function set selectIndex(index : int) : void
		{
			if (index == 0)
			{
				addChild(allMsg);
				if (selfMsg.parent) selfMsg.parent.removeChild(selfMsg);
			}
			else
			{
				addChild(selfMsg);
				if (allMsg.parent) allMsg.parent.removeChild(allMsg);
			}
		}

		/** 添加战斗动态消息 */
		public function appendBattleNews(msg : GBUpdateData) : void
		{
			allMsg.appendBattleNews(msg);
			selfMsg.appendBattleNews(msg);
		}

		/** 添加轮空动态消息 */
		public function appendEmptyWaitNews(msg : SCGroupBattlePlayerLost) : void
		{
			allMsg.appendEmptyWaitNews(msg);
			selfMsg.appendEmptyWaitNews(msg);
		}
	}
}
import game.core.user.UserData;
import game.module.mapGroupBattle.uis.NewsHTML;
import game.net.data.StoC.GBUpdateData;
import game.net.data.StoC.SCGroupBattlePlayerLost;

import gameui.controls.GScrollBar;
import gameui.core.GComponent;
import gameui.core.GComponentData;
import gameui.data.GScrollBarData;
import gameui.events.GScrollBarEvent;
import gameui.manager.UIManager;

import com.commUI.tips.ItemTip;
import com.commUI.tips.PlayerTip;

import flash.events.Event;
import flash.events.TextEvent;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFormat;





class ChannelMessage extends GComponent
{
	public static const CHANNEL_ALL : int = 0;
	public static const CHANNEL_SELF : int = 1;
	public var channel : int = CHANNEL_ALL;
	public var textWidth : int = 460;
	public var textHeight : int = 150;
	public var lineHeight : int = 18;
	public var tf : TextField;
	public var scrollBar : GScrollBar;
	public var scrollBarData : GScrollBarData;

	function ChannelMessage(channel : int, width : int = 460, height : int = 150) : void
	{
		this.channel = channel;
		_base = new GComponentData();
		_base.width = width;
		_base.height = height;
		textWidth = width - 20;
		textHeight = height;
		super(_base);
		initViews();
	}

	public function initViews() : void
	{
		var textFormat : TextFormat = new TextFormat();
		textFormat.color = 0xFFFFFF;
		textFormat.letterSpacing = 0.5;
		textFormat.leading = 5;
		textFormat.font = UIManager.defaultFont;

		var style : StyleSheet = new StyleSheet();
		style.setStyle("a:link", {textDecoration:"none"});
		style.setStyle("a:hover", {textDecoration:"underline"});

		tf = new TextField();
		tf.wordWrap = true;
		tf.defaultTextFormat = textFormat;
		tf.styleSheet = style;
		tf.width = textWidth;
		tf.height = textHeight;
//		tf.filters = UIManager.getEdgeFilters(0x000000);
		addChild(tf);

		// 滚动条
		scrollBarData = new GScrollBarData();
		scrollBarData.height = textHeight;
		scrollBarData.x = _base.width - scrollBarData.width ;
		scrollBarData.y = 0;
		scrollBarData.wheelSpeed = 1;
		scrollBarData.movePre = 1;
		scrollBar = new GScrollBar(scrollBarData);
		scrollBar.resetValue(pageSize, 0, 0, 0);
		// scrollBar.visible = false;
		addChild(scrollBar);

		scrollBar.addEventListener(GScrollBarEvent.SCROLL, scrollHandler);
		tf.addEventListener(Event.SCROLL, onScroll);
		tf.addEventListener(TextEvent.LINK, onLink);
	}

	private function onLink(event : TextEvent) : void
	{
		var arr : Array = event.text.split("&");
		switch(arr[0])
		{
			case "player":
				var playerId : int = parseInt(arr[1]);
				var playerName : String = arr[2];
				PlayerTip.show(playerId, playerName, [PlayerTip.NAME_SHISPER, PlayerTip.NAME_TRADE, PlayerTip.NAME_ADD_FRIEND, PlayerTip.NAME_INVITE_CLAN, PlayerTip.NAME_COPY_PLAYER_NAME, PlayerTip.NAME_LOOK_INFO, PlayerTip.NAME_MOVE_TO_BACKLIST, PlayerTip.NAME_MOVE_OUT_BACKLIST]);
				break;
			case "goods":
				var goodsId:int = parseInt(arr[1]);
				ItemTip.show(goodsId);
				break;
		}
	}

	public function get textScrollMax() : Number
	{
		return tf.numLines;
		// return Math.floor(tf.textHeight / lineHeight);
	}

	public function get pageSize() : Number
	{
		return Math.floor(textHeight / lineHeight);
	}

	/** 文件滚动事件 */
	private function onScroll(event : Event) : void
	{
		scrollBar.removeEventListener(GScrollBarEvent.SCROLL, scrollHandler);
		tf.removeEventListener(Event.SCROLL, onScroll);

		var min : Number = 1;
		var max : Number = textScrollMax - pageSize;
		max = max <= 0 ? pageSize : max;
		var value : Number = tf.scrollV;
		scrollBar.resetValue(pageSize, min, max, value);
		var scrollSpeed : int = Math.floor(tf.numLines / 5);
		if (scrollSpeed <= 0) scrollSpeed = 1;
		// scrollBarData.movePre = scrollSpeed;
		// scrollBarData.wheelSpeed = scrollSpeed;
		tf.addEventListener(Event.SCROLL, onScroll);
		scrollBar.addEventListener(GScrollBarEvent.SCROLL, scrollHandler);
		scrollInfo();
	}

	/** 滚动条滚动事件 */
	private function scrollHandler(event : GScrollBarEvent) : void
	{
		var value : int = event.position;
		if (value <= 1)
		{
			value = 1;
		}

		tf.scrollV = event.position;
		scrollInfo();
	}

	private var htmlText : String = "";
	private var lineCount : int = 0;
	private var lineSep : String = "\n";

	public function appendHtmlText(html : String) : void
	{
		var isScrollToMax : Boolean = this.isScrollToMax();
		htmlText += lineSep + html;
		tf.htmlText = htmlText;
		lineCount++;
		if (lineCount > 100)
		{
			var firstLineEndIndex : int = htmlText.indexOf(lineSep);
			firstLineEndIndex += lineSep.length;
			htmlText = htmlText.substring(firstLineEndIndex, htmlText.length);
			lineCount--;
		}

		// if (textScrollMax >= pageSize)
		// {
		// scrollBar.visible = true;
		// }
		// else
		// {
		// scrollBar.visible = false;
		// }
		if (isScrollToMax == true)
		{
			scrollToMax();
		}
	}

	public function scrollToMax() : void
	{
		tf.scrollV = textScrollMax;
	}

	public function isScrollToMax() : Boolean
	{
		return tf.numLines - tf.scrollV <= pageSize;
	}

	/** 添加战斗动态消息 */
	public function appendBattleNews(msg : GBUpdateData) : void
	{
		// testHtml();
		if (channel == CHANNEL_SELF && msg.winPlayerId != UserData.instance.playerId && msg.losePlayerId != UserData.instance.playerId)
		{
			return;
		}

		var newsList : Vector.<String> = NewsHTML.getBattleNewsList(msg);
		for (var i : int = 0; i < newsList.length; i++)
		{
			appendHtmlText(newsList[i]);
		}
	}

	/** 添加轮空动态消息 */
	public function appendEmptyWaitNews(msg : SCGroupBattlePlayerLost) : void
	{
		if (channel == CHANNEL_SELF && msg.playerId != UserData.instance.playerId)
		{
			return;
		}

		appendHtmlText(NewsHTML.getEmptyWaitNews(msg));
	}

	private function testHtml() : void
	{
		for (var i : int = 0; i < 10; i++)
		{
			var str : String = NewsHTML.player("大海明月" + i, i);
			appendHtmlText(str);
		}
	}

	private function scrollInfo() : void
	{
//		return;
//		trace("pageSize = " + pageSize + "  textScrollMax = " + textScrollMax + "   tf.scrollV = " + tf.scrollV + "  tf.textHeight = " + tf.textHeight + " tf.numLines = " + tf.numLines + "    scrollBar.value = " + scrollBar.value);
	}
}
