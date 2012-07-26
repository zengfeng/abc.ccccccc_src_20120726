package game.manager {
	import com.commUI.transanim.KeyFrameAnimManager;
	import com.commUI.transanim.TransKeyFrame;
	import com.shortybmc.CSV;
	import com.utils.RegExpUtils;
	import flash.utils.Dictionary;
	import game.core.data.ParseMonsterSkillConfig;
	import game.core.hero.HeroConfig;
	import game.core.hero.HeroConfigManager;
	import game.core.hero.JobGrowth;
	import game.core.hero.PotentialGrowth;
	import game.core.hero.VoHeroProp;
	import game.core.hero.VoProp;
	import game.core.item.config.ItemConfig;
	import game.core.item.config.ItemConfigManager;
	import game.core.item.config.SutraConfig;
	import game.core.item.functionItem.FunItem;
	import game.core.item.functionItem.FunManage;
	import game.core.item.prof.ProfItem;
	import game.core.item.prof.ProfItemManage;
	import game.core.item.prop.ItemProp;
	import game.core.item.prop.ItemPropManager;
	import game.core.item.soul.SoulConfig;
	import game.core.item.soul.SoulConfigManager;
	import game.core.item.sutra.StepPropManager;
	import game.core.item.sutra.sutraSkill.SutraManager;
	import game.core.item.sutra.sutraSkill.SutraSkillItem;
	import game.core.menu.MenuManager;
	import game.core.menu.VoMenuButton;
	import game.core.prop.Prop;
	import game.core.prop.PropManager;
	import game.core.user.ExperienceConfig;
	import game.core.user.StateManager;
	import game.core.user.SysMsgVo;
	import game.module.artifact.ArtifactManage;
	import game.module.artifact.VoArtifact;
	import game.module.battle.Formation;
	import game.module.battle.battleData.AttackData;
	import game.module.daily.DailyManage;
	import game.module.daily.VoAction;
	import game.module.daily.VoDaily;
	import game.module.daily.VoNotice;
	import game.module.enhance.EnhanceRule;
	import game.module.enhance.EnhanceRuleManager;
	import game.module.formation.formationManage.FMManager;
	import game.module.formation.formationManage.VoFM;
	import game.module.gem.identify.GemMasterManager;
	import game.module.gem.identify.GemMasterVO;
	import game.module.guild.GuildManager;
	import game.module.guild.vo.VoGuild;
	import game.module.guild.vo.VoGuildAction;
	import game.module.guild.vo.VoGuildTrend;
	import game.module.mapClanEscort.MCEConfig;
	import game.module.mapGroupBattle.GBConfig;
	import game.module.mapMining.MiningUtils;
	import game.module.mapWorld.WorldMapConfig;
	import game.module.moduleMenuConfig.ModuleMenuConfig;
	import game.module.monsterPot.MonsterPotManager;
	import game.module.notification.ICOMenuManager;
	import game.module.notification.VoICOButton;
	import game.module.pack.merge.MergeConfig;
	import game.module.pack.merge.MergeManager;
	import game.module.quest.QuestManager;
	import game.module.quest.VoMonster;
	import game.module.quest.VoNpc;
	import game.module.quest.VoNpcLink;
	import game.module.quest.guide.GuideMange;
	import game.module.quest.guide.VoGuide;
	import game.module.quest.guide.VoGuideStep;
	import game.module.riding.RidingUtils;
	import game.module.settings.SettingData;
	import game.module.settings.SettingVo;
	import game.module.userBuffStatus.BuffStatusConfig;
	import game.module.vip.config.VIPConfigManager;
	import game.module.wordDonate.donateManage.DonateManage;
	import game.module.wordDonate.donateManage.DonateRewardManager;
	import game.module.wordDonate.donateManage.DonateVo;
	import game.net.core.Common;
	import worlds.maps.configs.ParseBattleMonstersConfig;
	import worlds.maps.configs.ParseMapConfig;
	import worlds.maps.configs.ParseMapLoadFilesConfig;










	/**
	 * @author 缺硒
	 */
	public final class XmlPraseManage {
		public static function prase() : void {
			parseProperty();
			parseNpc();
			parseMonster();
			parseMonsterSkills();
			parseBattleMonsters();
			parseMapLoadFilesConfig();
			parseMaps();
			parseHero();
			parseItem();
			parseMenu();
			parseFormation2();
			parseAttackData();
			parseVip();
			parseEnhance();
			parseSysMsg();
			parseSetting();
			parseFunction();
			parsePotential();
			parseHeroProp();
			parseGemIdentify();
			parseGuildActionData();
			parseArtifact();
			// parseGuildActionTime();
			parseGuildExperience();
			parseGuildTrend();
			parseClanEscortPath();
			parseEnhProp();
			parseReward();
			parseDonate();
			parseUserBuffStatus();
			parseGroupBattle();
			parseWorldMap();
			parseFilterText();
			parseDaily();
			parseGuide();
			parseKeyFrame() ;
			parseProfExp();
			parseMaterialMerge();
			parseMonsterPotXML();
			parseModuleMenuConfig();
			parseMining();
			
			parseMount();
			tempArray = null;
		}

		public static function praseBattle() : void {
			parseNpc();
			parseMonster();
			parseHero();
			parseAttackData();
		}
		
		/** 解析模块菜单配置 */
		private static function parseModuleMenuConfig():void{
			var xml : XML = RSSManager.getInstance().getData("moduleMenuConfig");
			if (!xml) return;
			ModuleMenuConfig.getInstance().parseXmlData(xml);
			RSSManager.getInstance().deleteData("moduleMenuConfig");
		}

		
		/**解析炼妖壶配置文件*/
		private static function parseMonsterPotXML():void{
			var xml : XML = RSSManager.getInstance().getData("monsterPot");
			if (!xml) return;
			MonsterPotManager.instance.model.parseXmlData(xml);
			RSSManager.getInstance().deleteData("monsterPot");
		}
		
		/** 解析怪物技能配置 */
		private static function parseMonsterSkills():void
		{
			/** 解析物品二级属性表 **/
			tempArray = (RSSManager.getInstance().getData("monster_prop_client", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			ParseMonsterSkillConfig.instance.parseConfig(tempArray);
			RSSManager.getInstance().deleteData("monster_prop_client", RSSManager.TYPE_CSV);
		}
		
		/** 解析副本战斗怪物配置 */
		private static function parseBattleMonsters() : void
		{
			tempArray = (RSSManager.getInstance().getData("battleMonsters", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			ParseBattleMonstersConfig.parse(tempArray);
			RSSManager.getInstance().deleteData("battleMonsters", RSSManager.TYPE_CSV);
		}
		
		
		
		/** 解析地图资源预加载文件配置 */
		private static function parseMapLoadFilesConfig():void{
			var xml : XML = RSSManager.getInstance().getData("mapLoadFile");
			if (!xml) return;
			ParseMapLoadFilesConfig.parse(xml);
			RSSManager.getInstance().deleteData("mapLoadFile");
		}
		
		
		/** 解析地图配置 */
		private static function parseMaps() : void
		{
			var mapXmlDic : Dictionary = RSSManager.getInstance().mapDic;
			ParseMapConfig.parse(mapXmlDic);
			for (var key:String in  mapXmlDic)
			{
				delete mapXmlDic[key];
			}
		}

		private static var tempArray : Array;

		/** 解析NPC **/
		private static function parseNpc() : void {
			tempArray = (RSSManager.getInstance().getData("npc", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray)
			{
				var vo : VoNpc = new VoNpc();
				vo.parse(arr);
				RSSManager.npcList[vo.id]=vo;
				if(!QuestManager.getInstance().mapNpcDic[vo.mapId])
					QuestManager.getInstance().mapNpcDic[vo.mapId]=[];
				(QuestManager.getInstance().mapNpcDic[vo.mapId] as Array).push(vo);
			}
			RSSManager.getInstance().deleteData("npc", RSSManager.TYPE_CSV);
		}

		/** 解析Monster **/
		private static function parseMonster() : void {
			tempArray = (RSSManager.getInstance().getData("monster", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray) {
				var vo : VoMonster = new VoMonster();
				vo.parse(arr);
				RSSManager.mosterList[vo.id]=vo;
			}
			RSSManager.getInstance().deleteData("monster", RSSManager.TYPE_CSV);
		}

		/** 解析Hero **/
		private static function parseHero() : void {
			/** 解析物品二级属性表 **/
			tempArray = (RSSManager.getInstance().getData("hero_prop", RSSManager.TYPE_CSV) as CSV).getData();

			if (!tempArray) return;
			for each ( arr in tempArray) {
				var prop : VoHeroProp = new VoHeroProp();
				prop.parse(arr);
				HeroConfigManager.instance.addProp(prop);
			}
			tempArray = (RSSManager.getInstance().getData("hero", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray) {
				var vo : HeroConfig = new HeroConfig();
				vo.parse(arr);
				HeroConfigManager.instance.addConfig(vo);
			}
			RSSManager.getInstance().deleteData("hero", RSSManager.TYPE_CSV);
			parseJobGrow();
		}

		/** 解析HeroJob **/
		private static function parseJobGrow() : void {
			tempArray = (RSSManager.getInstance().getData("vars", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			var jobGrowths : Vector.<JobGrowth> = new Vector.<JobGrowth>(3);
			jobGrowths[0] = new JobGrowth(1);
			jobGrowths[1] = new JobGrowth(2);
			jobGrowths[2] = new JobGrowth(3);

			for each ( var arr:Array in tempArray) {
				if (!arr) continue;
				jobGrowths[0][arr[0]] = arr[2];
				jobGrowths[1][arr[0]] = arr[3];
				jobGrowths[2][arr[0]] = arr[4];
			}

			HeroConfigManager.instance.setJobGrowths(jobGrowths);
			RSSManager.getInstance().deleteData("vars", RSSManager.TYPE_CSV);
		}

		/** 解析item**/
		private static function parseItem() : void {
			/** 解析物品二级属性表 **/
			tempArray = (RSSManager.getInstance().getData("item_prop", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			var dic : Dictionary = new Dictionary(true);
			for each ( arr in tempArray) {
				var prop : ItemProp = new ItemProp();
				prop.parse(arr);
				dic[prop.id] = prop;
				ItemPropManager.instance.addProp(prop);
			}
			RSSManager.getInstance().deleteData("item_prop", RSSManager.TYPE_CSV);

			/** 解析物品表 **/
			tempArray = (RSSManager.getInstance().getData("item", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray) {
				var config : ItemConfig = new ItemConfig();
				config.parse(arr);
				ItemConfigManager.instance.addConfig(config);
			}
			dic = null;
			RSSManager.getInstance().deleteData("item", RSSManager.TYPE_CSV);

			/** 解析法宝物品表 **/
			tempArray = (RSSManager.getInstance().getData("weapon", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each ( arr in tempArray) {
				var sutraConfig : SutraConfig = new SutraConfig();
				sutraConfig.parse(arr);
				ItemConfigManager.instance.addConfig(sutraConfig);
			}
			RSSManager.getInstance().deleteData("weapon", RSSManager.TYPE_CSV);

			/** 解析升级经验表 **/
			tempArray = (RSSManager.getInstance().getData("experience", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			ExperienceConfig.parse(tempArray);
			RSSManager.getInstance().deleteData("experience", RSSManager.TYPE_CSV);

			/** 解析元神等级经验表 **/
			tempArray = (RSSManager.getInstance().getData("soul", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (arr in tempArray) {
				var cfg : SoulConfig = new SoulConfig();
				cfg.parse(arr);
				SoulConfigManager.instance.addConfig(cfg);
			}
			RSSManager.getInstance().deleteData("soul", RSSManager.TYPE_CSV);
		}

		/** 解析菜单配置 **/
		private static function parseMenu() : void {
			var xml : XML = RSSManager.getInstance().getData("menu");
			if (!xml) return;
			for each (var item:XML in xml["item"]) {
				var vo : VoMenuButton = new VoMenuButton();
				vo.prase(item);
				MenuManager.getInstance().initMenuVo(vo);
			}
			for each (item in xml["actionItem"]) {
				vo = new VoMenuButton();
				vo.prase(item);
				MenuManager.getInstance().initMenuVo(vo);
			}
			RSSManager.getInstance().deleteData("menu");
			xml = RSSManager.getInstance().getData("npc_action");
			var link : VoNpcLink;
			for each (item in xml["item"]) {
				link = new VoNpcLink();
				link.parse(item);
				QuestManager.getInstance().voNpcLinkDic[link.id] = link;
			}
			RSSManager.getInstance().deleteData("npc_action");

			xml = RSSManager.getInstance().getData("icoMenu");
			var ioc : VoICOButton;
			for each (item in xml["item"]) {
				ioc = new VoICOButton();
				ioc.prase(item);
				ICOMenuManager.getInstance().initIocVo(ioc);
			}
			RSSManager.getInstance().deleteData("icoMenu");
		}

		/**解析阵形配置**/
		private static function parseFormation2() : void {
			var xml : XML = RSSManager.getInstance().getData("formation");
			if (!xml) return;
			for each (var item:XML in xml["item"]) {
				var vo : VoFM = new VoFM();
				vo.parse(item);
				FMManager.instance.fmToVo(vo);
			}
			for each (var upgrad:XML in xml["upgradFM"]) {
				FMManager.instance.changeUpgradeXml(upgrad);
			}
			RSSManager.getInstance().deleteData("formation");
		}

		/**解析战斗背景map**/
		private static function parseBattleMap() : void {
			var xml : XML = RSSManager.getInstance().getData("battleMap");
			if (!xml) return;
			for each (var item:XML in xml["item"]) {
				AttackData.LoadBattleMapData(item);
			}
			RSSManager.getInstance().deleteData("battleMap");
		}

		/**解析战斗数据**/
		private static function parseAttackData() : void {
			parseSkillType();
			parseAttackType();
			parseBuffer();
			parseBattleMap();
		}

		/**解析skillType**/
		private static function parseSkillType() : void {
			tempArray = (RSSManager.getInstance().getData("skillType", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			AttackData.LoadSkillTable(tempArray);
			RSSManager.getInstance().deleteData("skillType", RSSManager.TYPE_CSV);
		}

		/**解析attackType**/
		private static function parseAttackType() : void {
			tempArray = (RSSManager.getInstance().getData("attackType", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			AttackData.LoadAtkTable(tempArray);
			RSSManager.getInstance().deleteData("attackType", RSSManager.TYPE_CSV);
		}

		/**  解析vip配置文件 */
		private static function parseVip() : void {
			var xml : XML = RSSManager.getInstance().getData("vip", RSSManager.TYPE_XML);
			VIPConfigManager.instance.parseVIPXml(xml);
			RSSManager.getInstance().deleteData("vip", RSSManager.TYPE_XML);
		}

		/**解析战斗中的阵型buffer**/
		private static function parseBuffer() : void {
			tempArray = (RSSManager.getInstance().getData("buffer", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			Formation.LoadFormationBuffer(tempArray);
			RSSManager.getInstance().deleteData("buffer", RSSManager.TYPE_CSV);
		}

		/**解析强化规则**/
		private static function parseEnhance() : void {
			tempArray = (RSSManager.getInstance().getData("enhance", RSSManager.TYPE_CSV) as CSV).getData();

			if (!tempArray) return;
			var length : uint = tempArray.length;
			// 解析跳过第一行表头
			for (var i : uint = 0; i < length; i++) {
				var  rule : EnhanceRule = new EnhanceRule();
				rule.parse(tempArray[i]);
				EnhanceRuleManager.getInstance().addRule(rule);
			}
			RSSManager.getInstance().deleteData("enhance", RSSManager.TYPE_CSV);
		}

		/** 滚屏信息 */
		private static function parseSysMsg() : void {
			var xml : XML = RSSManager.getInstance().getData("sysmsg");
			if (!xml) return;
			for each (var item:XML in xml["msg"]) {
				var vo : SysMsgVo = new SysMsgVo();
				vo.prase(item);
				StateManager.instance.initMsg(vo);
			}
			RSSManager.getInstance().deleteData("sysmsg");
		}

		/** 滚屏信息 */
		private static function parseSetting() : void {
			var xml : XML = RSSManager.getInstance().getData("setting");
			if (!xml) return;
			for each (var item:XML in xml["item"]) {
				var vo : SettingVo = new SettingVo();
				vo.parse(item);
				SettingData.initVo(vo);
			}
			SettingData.parseObj(Common.los.getAt("setting"));
			RSSManager.getInstance().deleteData("setting");
		}

		/** Function 上线信息 **/
		private static function parseFunction() : void {
			tempArray = (RSSManager.getInstance().getData("function", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray) {
				var vo : FunItem = new FunItem();
				vo.parse(arr);
				FunManage.instance.funVo(vo);
			}
			RSSManager.getInstance().deleteData("function", RSSManager.TYPE_CSV);
		}

		/** 解析潜力提升概率*/
		private static function parsePotential() : void {
			// PotentialUp.upProb = (RSSManager.getInstance().getData("potential", RSSManager.TYPE_CSV) as CSV).getData();
			// PotentialProbability.parseTable((RSSManager.getInstance().getData("potential", RSSManager.TYPE_CSV) as CSV).getData());
			RSSManager.getInstance().deleteData("potential", RSSManager.TYPE_CSV);
		}

		/** 解析显示将领属性 **/
		private static function parseHeroProp() : void {
			var xml : XML = RSSManager.getInstance().getData("heroPanel");
			if (!xml) return;

			var arr : Array = [];
			for each (var item:XML in xml["HeroPropPanel"]["item"]) {
				var vo : VoProp = new VoProp();

				vo.tips = item.@tips;
				vo.id = item.@id;
				vo.name = item.@name;
				vo.htmlText = item.children();
				vo.text = item.@text;
				arr.push(vo);
			}
			HeroConfigManager.heroDisplayProps = arr;
		}

		/** 解析灵珠鉴定表 **/
		private static function parseGemIdentify() : void {
			tempArray = (RSSManager.getInstance().getData("identify", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray) {
				var vo : GemMasterVO = new GemMasterVO();
				vo.parse(arr);
				GemMasterManager.instance.masters.push(vo);
			}
			RSSManager.getInstance().deleteData("identify", RSSManager.TYPE_CSV);
		}

		/**
		 * 神器
		 */
		private static function parseArtifact() : void
		{
			tempArray = (RSSManager.getInstance().getData("artifacts", RSSManager.TYPE_CSV) as CSV).getData();
			if ( !tempArray ) return ;
			for each (var arr:Array in tempArray)
			{
				var vo : VoArtifact = new VoArtifact();
				vo.parse(arr);
				ArtifactManage.instance().initVo(vo);
			}
		}

        private static function parseGuildActionData() : void
        {
            tempArray = (RSSManager.getInstance().getData("guildaction", RSSManager.TYPE_CSV) as CSV).getData();
            if ( !tempArray ) return ;
			//TODO
            VoGuildAction.parseGuildActionConfig(tempArray);
			GuildManager.instance.initAction(); 
            RSSManager.getInstance().deleteData("guildaction", RSSManager.TYPE_CSV);
        }

        // private static function parseGuildActionTime() : void
        // {
        // tempArray = (RSSManager.getInstance().getData("gatime", RSSManager.TYPE_CSV) as CSV).getData();
        // if ( !tempArray ) return ;
        // ClanManager.loadActionTime(tempArray);
        // RSSManager.getInstance().deleteData("gatime", RSSManager.TYPE_CSV);
        // }
        private static function parseGuildExperience() : void
        {
            tempArray = (RSSManager.getInstance().getData("guildlvl", RSSManager.TYPE_CSV) as CSV).getData();
            if ( !tempArray ) return ;
            VoGuild.loadGuildExp(tempArray);
            RSSManager.getInstance().deleteData("guildlvl", RSSManager.TYPE_CSV);
        }

        private static function parseGuildTrend() : void
        {
            var xml : XML = RSSManager.getInstance().getData("guildtrend");
            if (!xml) return;
            for each (var item:XML in xml["trend"])
            {
				VoGuildTrend.loadTrendConfig(item);
				// var vo : VoTrendConfig = new VoTrendConfig();
				// vo.parse(item);
				// ClanManager.trends[vo.trendId] = vo ;
			}
			RSSManager.getInstance().deleteData("guildtrend");
		}

		private static function parseClanEscortPath() : void {
			tempArray = (RSSManager.getInstance().getData("ge_waypoint", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray) {
				MCEConfig.parsePlace(arr);
			}

			RSSManager.getInstance().deleteData("ge_waypoint", RSSManager.TYPE_CSV);
		}

		// enh_prop表解析
		private static function parseEnhProp() : void {
			tempArray = (RSSManager.getInstance().getData("enh_prop", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray) {
				if (arr[0] == 0) {
					var vo : PotentialGrowth = new PotentialGrowth();
					vo.parse(arr);
					HeroConfigManager.instance.setPotentialGrowth(vo);
				} else if (arr[0] == 1) {
					StepPropManager.instance.parseTable(arr);
				}
				else if (arr[0] == 3)
				{
					var id : int = Number(String(arr[2]).substr(0, 1));
					var flag : int = Number(String(arr[2]).substr(String(arr[2]).length - 1, 1));
					ArtifactManage.instance().getVo(id).parseProp(arr, flag == 1);
				}
			}
			RSSManager.getInstance().deleteData("enh_prop", RSSManager.TYPE_CSV);
			
			//符文

			tempArray = (RSSManager.getInstance().getData("hero_skill", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr2:Array in tempArray) {
				var vo2 : SutraSkillItem = new SutraSkillItem();
				vo2.parse(arr2);
				SutraManager.instance.setSutraSkillVo(vo2);
			}
			RSSManager.getInstance().deleteData("hero_skill", RSSManager.TYPE_CSV);
		}

		private static function parseProperty() : void {
			tempArray = (RSSManager.getInstance().getData("property", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;

			for each (var arr:Array in tempArray) {
				var prop : Prop = new Prop();
				prop.parse(arr);
				PropManager.instance.setProp(prop);
			}
			RSSManager.getInstance().deleteData("property", RSSManager.TYPE_CSV);
		}

		// 奖励获取
		private static function parseReward() : void {
			var xml : XML = RSSManager.getInstance().getData("Reward");
			if (!xml) return;
			// 获取开天斧的奖励
			for each (var item:XML in xml["Donate"]["item"]) {
				var rank : int = int(item.@id);
				var rank2 : int = int(item.@max);
				var str : String = item;
				if (rank == rank2)
					DonateRewardManager.saveDonateRewardDic[rank] = str;
				else {
					for (var i : int = rank;i < rank2;i++) {
						DonateRewardManager.saveDonateRewardDic[i] = str;
					}
				}

				DonateRewardManager.saveDonateRewardTipsVec.push(str);
				DonateRewardManager.saveDonateRewardMaxRank = rank;
			}
			RSSManager.getInstance().deleteData("Reward");
		}

		// 获取开天斧经验列表
		private static function parseDonate() : void {
			tempArray = (RSSManager.getInstance().getData("donate_exp", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			DonateManage.getDonateMaxLevel = tempArray.length - 1;
			for each (var arr:Array in tempArray) {
				var prop : DonateVo = new DonateVo();
				prop.parse(arr);
				DonateManage.instance.setProp(prop);
			}
			RSSManager.getInstance().deleteData("donate_exp", RSSManager.TYPE_CSV);
		}

		/** 玩家BUFF和STATUS */
		private static function parseUserBuffStatus() : void {
			var xml : XML = RSSManager.getInstance().getData("userBuffStatus");
			if (!xml) return;
			BuffStatusConfig.parseConfig(xml);
			RSSManager.getInstance().deleteData("userBuffStatus");
		}

		/** 国战 */
		private static function parseGroupBattle() : void {
			var xml : XML = RSSManager.getInstance().getData("groupBattle");
			if (!xml) return;
			GBConfig.parseConfig(xml);
			RSSManager.getInstance().deleteData("groupBattle");
		}

		/** 世界地图 */
		private static function parseWorldMap() : void {
			var xml : XML = RSSManager.getInstance().getData("worldMap");
			if (!xml) return;
			WorldMapConfig.parseConfig(xml);
			RSSManager.getInstance().deleteData("worldMap");
		}

		/***/
		private static function parseFilterText() : void {
			var str : String = RSSManager.getInstance().getData("filterText", RSSManager.TYPE_XML);
			if (!str) return;
			RegExpUtils.text = str;
			RSSManager.getInstance().deleteData("filterText", RSSManager.TYPE_XML);

			var strF : String = RSSManager.getInstance().getData("filterTextF", RSSManager.TYPE_XML);
			if (!strF) return;
			RegExpUtils.textF = strF;
			RSSManager.getInstance().deleteData("filterTextF", RSSManager.TYPE_XML);
		}

		/**
		 * 日常配置
		 */
		private static function parseDaily() : void {
			var xml : XML = RSSManager.getInstance().getData("daily", RSSManager.TYPE_XML);
			if (!xml) return;
			for each (var item:XML in xml["daily"]["item"]) {
				var vo : VoDaily = new VoDaily();
				vo.parse(item);
				DailyManage.getInstance().initDailyVo(vo);
			}
			for each ( item in xml["action"]["item"]) {
				var vo2 : VoAction = new VoAction();
				vo2.parse(item);
				DailyManage.getInstance().initActionVo(vo2);
			}
			var defdesc : String = xml.notice.@default_desc ;
			var defjoin : String = xml.notice.@default_join ;
			VoNotice.DEFAULT_DESC = defdesc.split("|") ;
			VoNotice.DEFAULT_JOIN = defjoin ;
			for each ( item in xml["notice"]["item"] ) {
				var vo3 : VoNotice = new VoNotice() ;
				vo3.parse(item);
				DailyManage.getInstance().initNoticeVo(vo3);
			}
			RSSManager.getInstance().deleteData("daily", RSSManager.TYPE_XML);
		}

		/**关键帧动画*/
		private static function parseKeyFrame() : void {
			var xml : XML = RSSManager.getInstance().getData("keyframe", RSSManager.TYPE_XML);
			if ( !xml )
				return ;
			for each ( var item:XML in xml["anim"] ) {
				var anim : Vector.<TransKeyFrame> = new Vector.<TransKeyFrame>() ;
				for each ( var frame:XML in item["frame"] ) {
					var vo : TransKeyFrame = new TransKeyFrame() ;
					vo.parse(frame) ;
					anim.push(vo);
				}
				KeyFrameAnimManager.instance.addAnimation(int(item.@id), anim);
			}
		}

		/**
		 * 新手引导配置
		 */
		private static function parseGuide() : void {
			var xml : XML = RSSManager.getInstance().getData("guide", RSSManager.TYPE_XML);
			if (!xml) return;
			for each (var item:XML in xml["item"]) {
				var vo : VoGuide = new VoGuide();
				vo.parse(item);
				for each (var item2:XML in item["step"]) {
					var step : VoGuideStep = new VoGuideStep(vo.targetId);
					step.prase(item2);
					vo.steps.push(step);
				}
				GuideMange.getInstance().initVo(vo);
			}
			RSSManager.getInstance().deleteData("guide", RSSManager.TYPE_XML);
		}


		/**
		 * 解析修为值
		 */
		private static function parseProfExp() : void {
			tempArray = (RSSManager.getInstance().getData("prof_exp", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray) {
				var vo : ProfItem = new ProfItem();
				vo.parse(arr);
				ProfItemManage.instance.profVo(vo);
			}
			RSSManager.getInstance().deleteData("prof_exp", RSSManager.TYPE_CSV);
		}

		/**
		 * 解析合成配置表
		 */
		private static function parseMaterialMerge() : void
		{
			tempArray = (RSSManager.getInstance().getData("material_merge", RSSManager.TYPE_CSV) as CSV).getData();
			if (!tempArray) return;
			for each (var arr:Array in tempArray)
			{
				var vo : MergeConfig = new MergeConfig();
				vo.parse(arr);
				MergeManager.instance.addConfig(vo);
			}
			RSSManager.getInstance().deleteData("material_merge", RSSManager.TYPE_CSV);
		}

		/**
		 * 解析采矿配置文件
		 */
		private static function parseMining() : void
		{
			var xml : XML = RSSManager.getInstance().getData("mining", RSSManager.TYPE_XML);
			if (!xml) return;
			
			MiningUtils.BATCH_TIMES = xml.rule.BatchTimes;
			MiningUtils.VIP_LEVEL = xml.rule.VipLevel;
			MiningUtils.GOLD_COST = xml.rule.CostGold;
			MiningUtils.MAP_ID = xml.rule.MapId;
			
			for each (var npcXML:XML in xml.npc["stone"])
			{
				MiningUtils.addStone(npcXML.@id, npcXML.@flameX, npcXML.@flameY);
			}

			RSSManager.getInstance().deleteData("mining", RSSManager.TYPE_XML);
		}
		
	     /**
		 * 解析坐骑配置文件
		 */
		 private static function parseMount():void
		 {
		    tempArray = (RSSManager.getInstance().getData("mount", RSSManager.TYPE_CSV) as CSV).getData();
            RidingUtils.praseMountCSV(tempArray);
			
			
			RSSManager.getInstance().deleteData("mount", RSSManager.TYPE_CSV);
		 }
		
	}
}
