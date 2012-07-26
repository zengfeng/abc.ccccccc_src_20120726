package game.module.chat.view
{
	import com.commUI.alert.Alert;
	import com.utils.PotentialColorUtils;
	import flash.display.DisplayObject;
	import flash.text.engine.FontWeight;
	import flash.text.engine.TextBaseline;
	import flashx.textLayout.conversion.ITextImporter;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.DivElement;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.LineBreak;
	import flashx.textLayout.formats.TextDecoration;
	import game.module.chat.ChatUntils;
	import game.module.chat.VoChatMsg;
	import game.module.chat.config.ChannelColor;
	import game.module.chat.config.ChannelId;
	import game.module.chat.config.ChatConfig;
	import game.module.chat.config.Face;
	import gameui.manager.UIManager;






	public class MsgTemplate
	{
		public function MsgTemplate()
		{
		}

		public static function test() : FlowElement
		{
			var div : DivElement = new DivElement();
			var p : ParagraphElement = new ParagraphElement();
			var span : SpanElement = new SpanElement();
			span.text = "在上世纪80年代，日本决定以美制F-16战斗机为模板与美国联合开发F-2战斗机。尽管这并非纯粹的联合开发，但双方都曾期待这将成为未来真正意义上的联合开发的范本。";
			p.addChild(span);
			div.addChild(p);
			for (var i : int = 0; i < 60; i++)
			{
				p = new ParagraphElement();
				span = new SpanElement();
				span.text = "消息(Message) ----- " + i;
				p.addChild(span);
				div.addChild(p);
			}
			return div;
		}

		/** 
		 * 私聊窗口消息
		 * @param vo:MessageVo 消息数据结构
		 *  */
		public static function whisperWindowMessage(vo : VoChatMsg) : FlowElement
		{
			var p : ParagraphElement;
			switch(vo.channelId)
			{
				// 私聊 频道 
				case ChannelId.WHISPER:
					p = parseWhisperWindow(vo) as ParagraphElement;
					p.color = 0x2F1F00;
					break;
				// 提示 频道 
				case ChannelId.PROMPT:
					p = parsePromptMessage(vo) as ParagraphElement;
					p.color = 0xff0000;
					break;
				// 日期
				case ChannelId.DATE:
					p = parseDateMessage(vo) as ParagraphElement;
					return p;
					break;
			}
			p.fontFamily = UIManager.defaultFont;
			p.lineBreak = LineBreak.TO_FIT;
			p.alignmentBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
			p.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
			// p.linkHoverFormat = {color:0x0000AD00};
			// p.linkActiveFormat = {color:0x0000AD00,textDecoration:TextDecoration.UNDERLINE};
			// p.textDecoration = TextDecoration.NONE;
			return p;
		}

		/** 
		 * 解析私聊窗口消息
		 * @param vo:MessageVo 消息数据结构
		 *  */
		public static function parseWhisperWindow(vo : VoChatMsg) : FlowElement
		{
			var p : ParagraphElement = new ParagraphElement();
			var flowElement : FlowElement;
			var i : int;
			var arr : Array;

			// 服务器ID
			if (vo.serverId > 0)
			{
				flowElement = server(vo.serverId);
				p.addChild(flowElement);
			}

			// 发送玩家
			flowElement = span("[" + vo.playerName + "]:\n");
			flowElement.fontWeight = FontWeight.BOLD;
			flowElement.color = PotentialColorUtils.getColor(vo.playerColorPropertyValue);
			// if (vo.playerName == ChatConfig.selfPlayerName)
			// {
			// flowElement.color = 0x000000;
			// }
			// else
			// {
			// flowElement.color = 0x339900;
			// }
			p.addChild(flowElement);

			// 信息
			arr = info(vo.content);
			for (i = 0; i < arr.length; i++)
			{
				flowElement = arr[i] as FlowElement;
				if (flowElement)
				{
					p.addChild(flowElement);
				}
			}

			// if (vo.playerName == ChatConfig.selfPlayerName)
			// {
			// p.color = 0x000000;
			// }
			// else
			// {
			// p.color = 0x996600;
			// }
			return p;
		}

		/** 
		 * 消息
		 * @param vo:VoChatMsg 消息数据结构
		 *  */
		public static function message(vo : VoChatMsg) : FlowElement
		{
			if (vo.content.length > 7 && vo.content.indexOf("[color:") == 0)
			{
				var channelIds : Array = [ChannelId.NOTIC, ChannelId.SYSTEM, ChannelId.PROMPT, ChannelId.SYSTEM_NOTIC];
				if (channelIds.indexOf(vo.channelId) == -1)
				{
					vo.color = parseInt(vo.content.substring(vo.content.indexOf(":") + 1, vo.content.indexOf("]")));
				}
				else
				{
					vo.color = -1;
				}
				vo.content = vo.content.substring(vo.content.indexOf("]") + 1, vo.content.length);
			}

			var p : ParagraphElement;
			switch(vo.channelId)
			{
				// 世界 频道
				case ChannelId.WORLD:
				// 地区 频道 
				case ChannelId.AREA:
				// 队伍 频道 
				case ChannelId.TEAM:
				// 家族 频道 
				case ChannelId.CLAN:
				// 公告 频道 
				case ChannelId.NOTIC:
					p = parseNormalMessage(vo) as ParagraphElement;
					break;
				// 私聊 频道 
				case ChannelId.WHISPER:
					p = parsePMMessage(vo) as ParagraphElement;
					break;
				//                 //  公告 频道 
				// case ChannelId.NOTIC:
				// p = parseNoticMessage(vo) as ParagraphElement;
				// break;
				// 系统 频道 
				case ChannelId.SYSTEM:
				// 系统通告 频道 
				case ChannelId.SYSTEM_NOTIC:
				// 提示 频道 
				case ChannelId.PROMPT:
					p = parsePromptMessage(vo) as ParagraphElement;
					break;
			}

			// p.fontFamily = "宋体,Arial,幼体,楷体,华文行楷,隶体";
			// p.fontFamily = UIManager.defaultFont;
			p.color = vo.color > 0 ? vo.color : ChannelColor.dic[vo.channelId];
			p.lineBreak = LineBreak.EXPLICIT;
			// p.alignmentBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
			p.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
			// p.linkHoverFormat = {color:0x0000AD00};
			// p.linkActiveFormat = {color:0x0000AD00,textDecoration:TextDecoration.UNDERLINE};
			// p.textDecoration = TextDecoration.NONE;

			return p;
		}

		/** 
		 * 解析正常(世界, 地区, 队伍, 家族)消息
		 * @param vo:MessageVo 消息数据结构
		 *  */
		public static function parseNormalMessage(vo : VoChatMsg) : FlowElement
		{
			var p : ParagraphElement = new ParagraphElement();
			var flowElement : FlowElement;
			var i : int;
			var arr : Array;
			// 频道
			flowElement = channel(vo.channelId);
			p.addChild(flowElement);

			flowElement = span(" ");
			p.addChild(flowElement);

			// 服务器ID
			if (vo.serverId > 0)
			{
				flowElement = server(vo.serverId);
				p.addChild(flowElement);
			}

			// 玩家
			if (vo.playerName)
			{
				flowElement = player(vo.playerName, vo.playerColorPropertyValue);
				p.addChild(flowElement);
			}

			// 信息
			arr = info(vo.playerName ? "：" + vo.content : vo.content);
			for (i = 0; i < arr.length; i++)
			{
				flowElement = arr[i] as FlowElement;
				if (flowElement)
				{
					p.addChild(flowElement);
				}
			}

			return p;
		}

		/** 
		 * 解析私聊消息
		 * @param vo:MessageVo 消息数据结构
		 *  */
		public static function parsePMMessage(vo : VoChatMsg) : FlowElement
		{
			var p : ParagraphElement = new ParagraphElement();
			var flowElement : FlowElement;
			var i : int;
			var arr : Array;
			// 频道
			flowElement = channel(vo.channelId);
			p.addChild(flowElement);

			// 服务器ID
			if (vo.serverId > 0)
			{
				flowElement = server(vo.serverId);
				p.addChild(flowElement);
			}

			// 发送玩家
			if (vo.playerName && vo.playerName == ChatConfig.selfPlayerName)
			{
				flowElement = span("我对");
				p.addChild(flowElement);
			}
			else
			{
				flowElement = player(vo.playerName, vo.playerColorPropertyValue);
				p.addChild(flowElement);

				flowElement = span("对");
				p.addChild(flowElement);
			}

			// 接收玩家
			if (vo.recPlayerName && vo.recPlayerName == ChatConfig.selfPlayerName)
			{
				flowElement = span("我说");
				p.addChild(flowElement);
			}
			else
			{
				flowElement = player(vo.recPlayerName, vo.recPlayerColorPropertyValue);
				p.addChild(flowElement);
			}

			// 信息
			arr = info("：" + vo.content);
			for (i = 0; i < arr.length; i++)
			{
				flowElement = arr[i] as FlowElement;
				if (flowElement)
				{
					p.addChild(flowElement);
				}
			}

			return p;
		}

		/** 
		 * 解析公告消息
		 * @param vo:MessageVo 消息数据结构
		 *  */
		public static function parseNoticMessage(vo : VoChatMsg) : FlowElement
		{
			var p : ParagraphElement = new ParagraphElement();
			var flowElement : FlowElement;
			var i : int;
			var arr : Array;

			// 服务器ID
			if (vo.serverId > 0)
			{
				flowElement = server(vo.serverId);
				p.addChild(flowElement);
			}

			// 玩家
			if (vo.playerName)
			{
				flowElement = player(vo.playerName, vo.playerColorPropertyValue);
				p.addChild(flowElement);
			}

			// 信息
			arr = info("：" + vo.content);
			for (i = 0; i < arr.length; i++)
			{
				flowElement = arr[i] as FlowElement;
				if (flowElement)
				{
					p.addChild(flowElement);
				}
			}

			return p;
		}

		/** 
		 * 解析提示消息
		 * @param vo:MessageVo 消息数据结构
		 *  */
		public static function parsePromptMessage(vo : VoChatMsg) : FlowElement
		{
			if (vo.isHTMLFormat)
			{
				return parseHTML(vo.content);
			}
			var p : ParagraphElement = new ParagraphElement();
			var flowElement : FlowElement;
			var i : int;
			var arr : Array;

			// 信息
			arr = info(vo.content);
			for (i = 0; i < arr.length; i++)
			{
				flowElement = arr[i] as FlowElement;
				if (flowElement)
				{
					p.addChild(flowElement);
				}
			}
			return p;
		}

		private  static var importer : ITextImporter;

		public static function parseHTML(htmlText : String) : FlowElement
		{
			if (importer == null)
			{
				importer = TextConverter.getImporter(TextConverter.TEXT_FIELD_HTML_FORMAT);
			}

			importer.throwOnError = false;
			var textFlow : TextFlow = importer.importToFlow(htmlText);
			if (!textFlow)
			{
				var errors : Vector.<String> = importer.errors;
				// deal with import errors
			}
			else
			{
				if (textFlow.numChildren > 0)
				{
					return textFlow.getChildAt(0);
				}
			}

			return new ParagraphElement();
		}

		/** 
		 * 解析日期消息
		 * @param vo:MessageVo 消息数据结构
		 *  */
		public static function parseDateMessage(vo : VoChatMsg) : FlowElement
		{
			var p : ParagraphElement = new ParagraphElement();
			var str : String = "日期：@DATE@ ——离线消息                     ";
			var date : Date = new Date();
			var today : uint = date.dateUTC;
			date.time = parseInt(vo.content);
			if (today == date.date)
			{
				str = str.replace(/@DATE@/gi, "今天");
			}
			else if (today == date.date + 1)
			{
				str = str.replace(/@DATE@/gi, "昨天");
			}
			else
			{
				str = str.replace(/@DATE@/gi, date.fullYearUTC + "/" + (date.monthUTC + 1) + "/" + date.dateUTC);
			}
			var span : SpanElement = span(str);
			span.color = 0x333333;
			span.fontSize = 14;
			span.fontWeight = FontWeight.BOLD;
			span.textDecoration = TextDecoration.UNDERLINE;
			p.addChild(span);
			return p;
		}

		/** 
		 * 频道
		 * @param channelId:uint 频道id
		 *  */
		public static function channel(channelId : uint) : FlowElement
		{
			// 元件
			var inlineGraphicElement : InlineGraphicElement = new InlineGraphicElement();
			var link : LinkElement = new LinkElement();

			inlineGraphicElement.source = ChatUntils.getChannelLabelGraphic(channelId);
			if (inlineGraphicElement.source) DisplayObject(inlineGraphicElement.source).filters = [];
			return inlineGraphicElement;

			link.target = channelId.toString();
			// var span : SpanElement = span("〖" + ChannelName.dic[channelId] + "〗");
			// span.color = ChannelColor.dic[channelId];
			// span.textDecoration = TextDecoration.NONE;
			// link.addChild(span);
			link.addChild(inlineGraphicElement);

			// 样式
			inlineGraphicElement.textDecoration = TextDecoration.NONE;
			// inlineGraphicElement.lineHeight = 27;
			return link;
		}

		/** 
		 * 服务器
		 * @param id:uint id
		 *  */
		public static function server(id : uint) : FlowElement
		{
			var span : SpanElement = span(id.toString());
			span.backgroundColor = 0x000000;
			span.backgroundAlpha = 0.2;
			span.color = 0xFFFFFF;
			return span;
		}

		/** 
		 * 玩家
		 * @param playerName:String 玩家名称
		 * @param playerColorValue:uint 玩家颜色判断值
		 *  */
		public static function player(playerName : String, playerColorValue : Number) : FlowElement
		{
			if (playerName == ChatConfig.selfPlayerName)
			{
				var span : FlowElement = span(playerName);
				span.color = PotentialColorUtils.getColor(playerColorValue);
				span.textDecoration = TextDecoration.UNDERLINE;
				return span;
			}
			// 元件
			var link : LinkElement = new LinkElement();

			var linkSpan : SpanElement = new SpanElement();
			linkSpan.text = playerName;

			link.href = "event:" + MsgTextFlowEvent.CLICK_PLAYER;
			link.target = playerName;

			link.addChild(linkSpan);

			// 样式
			linkSpan.textDecoration = TextDecoration.UNDERLINE;
			link.linkNormalFormat = {color:PotentialColorUtils.getColor(playerColorValue)};
			return link;
		}

		/** 
		 * 玩家
		 * @param playerName:String 玩家名称
		 * @param playerColorValue:uint 玩家颜色判断值
		 *  */
		public static function player2(playerName : String, playerColorValue : Number) : FlowElement
		{
			if (playerName == ChatConfig.selfPlayerName)
			{
				var span : FlowElement = span("『" + playerName + "』");
				span.color = PotentialColorUtils.getColor(playerColorValue);
				return span;
			}
			// 元件
			var link : LinkElement = new LinkElement();

			var span1 : SpanElement = new SpanElement();
			var span2 : SpanElement = new SpanElement();
			span1.text = "『";
			span2.text = "』";

			var linkSpan : SpanElement = new SpanElement();
			linkSpan.text = playerName;

			link.href = "event:" + MsgTextFlowEvent.CLICK_PLAYER;
			link.target = playerName;

			link.addChild(span1);
			link.addChild(linkSpan);
			link.addChild(span2);

			// 样式
			// link.textDecoration = TextDecoration.NONE;
			// span2.textDecoration = TextDecoration.NONE;
			// span1.textDecoration = TextDecoration.NONE;
			// linkSpan.textDecoration = TextDecoration.NONE;
			link.linkNormalFormat = {color:PotentialColorUtils.getColor(playerColorValue)};
			// link.linkActiveFormat = {textDecoration:TextDecoration.UNDERLINE};
			return link;
		}

		/** 
		 * 信息
		 * @param content:String 信息内容
		 *  */
		public static function info(content : String) : Array
		{
			var arr : Array = new Array();
			if (content == "" || content == null) return arr;

			/**
			 * #123  表情
			 * [g:id:color:name] 物品
			 * [p:color:name] 玩家
			 * [n:id:color:name] NPC
			 * [m:id:name:x:y] 地图
			 * [i:info:color:name] Item
			 * [h:info:color:name] Hero
			 * */
			var re : RegExp = /(#\d{1,2})|(\[g:\d*:.{0,8}:[^\[,\]]*\])|(\[p:.{0,8}:[^\[^\]]*\])|(\[n:\d*:.{0,8}:[^\[^\]]*\])|(\[m:\d*:[^\[^\]]*\:\d*:\d*\])|(\[h:[^\[,\]]*:.{0,8}:[^\[,\]]*\])|(\[\i:[^\[,\]]*:.{0,8}:[^\[,\]]{0,10}\])/ig;
			var matchArr : Array = content.match(re);
			var splitArr : Array = content.split(re);

			var id : Number;
			var color : Number;
			var name : String;
			var array : Array;
			var flowElement : FlowElement;

			for (var i : int = 0; i < splitArr.length; i++)
			{
				flowElement = null;
				var str : String = splitArr[i];
				// 如果不是特殊字符
				if (matchArr.indexOf(str) == -1)
				{
					if (str != "" && str != null)
					{
						arr.push(span(str));
					}
				}
				else
				{
					// 如果是表情
					if (str.indexOf("#") == 0)
					{
						id = parseInt(str.replace("#", ""));
						flowElement = face(id);
					}
					// 如果是Item
					else if (str.indexOf("[i:") == 0)
					{
						str = str.substring(3, str.length - 1);
						array = str.split(":");
						var itemInfo : String = array[0];
						color = array[1];
						name = array[2];
						flowElement = item(itemInfo, name, color);
					}
					// 如果是Hero
					else if (str.indexOf("[h:") == 0)
					{
						str = str.substring(3, str.length - 1);
						array = str.split(":");
						var heroInfo : String = array[0];
						color = array[1];
						name = array[2];
						flowElement = hero(heroInfo, name, color);
					}
					// 如果是物品
					else if (str.indexOf("[g:") == 0)
					{
						str = str.substring(3, str.length - 1);
						array = str.split(":");
						id = array[0];
						color = array[1];
						name = array[2];
						flowElement = goods(id, name, color);
					}
					// 如果是玩家
					else if (str.indexOf("[p:") == 0)
					{
						str = str.substring(3, str.length - 1);
						array = str.split(":");
						color = array[0];
						name = array[1];
						flowElement = player(name, color);
					}
					// 如果是NPC
					else if (str.indexOf("[n:") == 0)
					{
						str = str.substring(3, str.length - 1);
						array = str.split(":");
						id = array[0];
						color = array[1];
						name = array[2];
						flowElement = npc(id, name, color);
					}
					// 如果是地图
					else if (str.indexOf("[m:") == 0)
					{
						str = str.substring(3, str.length - 1);
						array = str.split(":");
						id = array[0];
						color = 0xB7FC78;
						name = array[1];
						var x : int = array[2];
						var y : int = array[3];
						flowElement = map(id, name, color, x, y);
						arr.push(flowElement);
						arr.push(span(" "));
						flowElement = mapTransport(id, name, color, x, y);
						arr.push(span(" "));
					}

					if (flowElement)
					{
						arr.push(flowElement);
					}
					else
					{
						arr.push(span(str));
					}
				}
			}
			return arr;
		}

		/**
		 * 字符转成Span
		 * */
		public static function span(str : String) : SpanElement
		{
			var span : SpanElement = new SpanElement();
			span.text = str;
			return span;
		}

		/**
		 * 表情
		 * */
		public static function face(value : uint) : FlowElement
		{
			var face : DisplayObject = Face.getFace(value);
			if (face == null) return null;
			var inlineGraphicElement : InlineGraphicElement = new InlineGraphicElement();
			inlineGraphicElement.source = face;
			return inlineGraphicElement;
		}

		/** 
		 * 物品
		 * @param id:uint id
		 * @param name:String 名称
		 * @param color:uint 颜色
		 *  */
		public static function item(info : String, name : String, color : Number) : FlowElement
		{
			// 元件
			var link : LinkElement = new LinkElement();
			var span1 : SpanElement = new SpanElement();
			var span2 : SpanElement = new SpanElement();
			span1.text = "[";
			span2.text = "]";

			var linkSpan : SpanElement = new SpanElement();
			linkSpan.text = name;

			link.href = "event:" + MsgTextFlowEvent.CLICK_ITEM;
			link.target = info;

			link.addChild(span1);
			link.addChild(linkSpan);
			link.addChild(span2);

			// 样式
			link.textDecoration = TextDecoration.NONE;
			span2.textDecoration = TextDecoration.NONE;
			span1.textDecoration = TextDecoration.NONE;
			linkSpan.textDecoration = TextDecoration.UNDERLINE;
			link.linkNormalFormat = {color:PotentialColorUtils.getColor(color)};
			return link;
		}

		/** 
		 * hero
		 * @param info:string 信息
		 * @param name:String 名称
		 * @param color:uint 颜色
		 *  */
		public static function hero(info : String, name : String, color : Number) : FlowElement
		{
			// 元件
			var link : LinkElement = new LinkElement();
			var span1 : SpanElement = new SpanElement();
			var span2 : SpanElement = new SpanElement();
			span1.text = "[";
			span2.text = "]";

			var linkSpan : SpanElement = new SpanElement();
			linkSpan.text = name;

			link.href = "event:" + MsgTextFlowEvent.CLICK_HERO;
			link.target = info;

			link.addChild(span1);
			link.addChild(linkSpan);
			link.addChild(span2);

			// 样式
			link.textDecoration = TextDecoration.NONE;
			span2.textDecoration = TextDecoration.NONE;
			span1.textDecoration = TextDecoration.NONE;
			linkSpan.textDecoration = TextDecoration.UNDERLINE;
			link.linkNormalFormat = {color:PotentialColorUtils.getColor(color)};
			return link;
		}

		/** 
		 * 物品
		 * @param id:uint id
		 * @param name:String 名称
		 * @param color:uint 颜色
		 *  */
		public static function goods(id : uint, name : String, color : Number) : FlowElement
		{
			// 元件
			var link : LinkElement = new LinkElement();
			var span1 : SpanElement = new SpanElement();
			var span2 : SpanElement = new SpanElement();
			span1.text = "[";
			span2.text = "]";

			var linkSpan : SpanElement = new SpanElement();
			linkSpan.text = name;

			link.href = "event:" + MsgTextFlowEvent.CLICK_GOODS;
			link.target = id + "";

			link.addChild(span1);
			link.addChild(linkSpan);
			link.addChild(span2);

			// 样式
			link.textDecoration = TextDecoration.NONE;
			span2.textDecoration = TextDecoration.NONE;
			span1.textDecoration = TextDecoration.NONE;
			linkSpan.textDecoration = TextDecoration.UNDERLINE;
			link.linkNormalFormat = {color:PotentialColorUtils.getColor(color)};
			return link;
		}

		/** 
		 * npc
		 * @param id:uint id
		 * @param name:String 名称
		 * @param color:uint 颜色
		 *  */
		public static function npc(id : uint, name : String, color : Number) : FlowElement
		{
			// 元件
			var link : LinkElement = new LinkElement();

			var linkSpan : SpanElement = new SpanElement();
			linkSpan.text = name;

			link.href = "event:" + MsgTextFlowEvent.CLICK_NPC;
			link.target = id.toString();

			link.addChild(linkSpan);

			// 样式
			linkSpan.textDecoration = TextDecoration.UNDERLINE;
			link.linkNormalFormat = {color:color};
			return link;
		}

		/** 
		 * 地图
		 * @param id:uint id
		 * @param name:String 名称
		 * @param color:uint 颜色
		 *  */
		public static function map(id : uint, name : String, color : Number, x : int, y : int) : FlowElement
		{
			// 元件
			var link : LinkElement = new LinkElement();

			var linkSpan : SpanElement = new SpanElement();
			linkSpan.text = name + "(" + x + "," + y + ")";

			link.href = "event:" + MsgTextFlowEvent.CLICK_MAP;
			link.target = id + "_" + x + "_" + y;

			link.addChild(linkSpan);

			// 样式
			linkSpan.textDecoration = TextDecoration.UNDERLINE;
			link.linkNormalFormat = {color:color};
			return link;
		}

		/** 
		 * 地图传送
		 * @param id:uint id
		 * @param name:String 名称
		 * @param color:uint 颜色
		 *  */
		public static function mapTransport(id : uint, name : String, color : Number, x : int, y : int) : FlowElement
		{
			// 元件
			var link : LinkElement = new LinkElement();

			var linkSpan : SpanElement = new SpanElement();
			linkSpan.text = "传送";

			link.href = "event:" + MsgTextFlowEvent.CLICK_MAP_TRANSPORT;
			link.target = id + "_" + x + "_" + y;

			link.addChild(linkSpan);

			// 样式
			linkSpan.textDecoration = TextDecoration.NONE;
			link.linkNormalFormat = {color:color};
			return link;
		}
	}
}