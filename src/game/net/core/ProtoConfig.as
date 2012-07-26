package game.net.core {
	
	import game.net.core.Common;
	public class ProtoConfig{
		public static function initConfing() : void{
			Common.messageDic[0xFA]="game.net.data.StoC.SCGDFinish";
			Common.messageDic[0xBD]="game.net.data.StoC.SCPurchaseState";
			Common.messageDic[0x14]="game.net.data.StoC.SCOtherInfo";
			Common.messageDic[0x93]="game.net.data.StoC.SCTeamChat";
			Common.messageDic[0x10]="game.net.data.StoC.SCPlayerInfo";
			Common.messageDic[0x2C6]="game.net.data.StoC.SCGuildQuite";
			Common.messageDic[0x5A]="game.net.data.StoC.SCDelSpecialNotification";
			Common.messageDic[0x2C2]="game.net.data.StoC.SCMemberPosition";
			Common.messageDic[0xB1]="game.net.data.StoC.SCBConfirm";
			Common.messageDic[0xF9]="game.net.data.StoC.SCGDReBirth";
			Common.messageDic[0x2FD]="game.net.data.StoC.SCGuildEscorFinish";
			Common.messageDic[0x2D]="game.net.data.StoC.SCTrainInfo";
			Common.messageDic[0x12]="game.net.data.StoC.SCGuideUpdate";
			Common.messageDic[0x3B]="game.net.data.StoC.SCFishReady";
			Common.messageDic[0x5B]="game.net.data.StoC.SCChangeNotification";
			Common.messageDic[0x200]="game.net.data.StoC.SCItemList";
			Common.messageDic[0x89]="game.net.data.StoC.SCChallengeDemon";
			Common.messageDic[0x203]="game.net.data.StoC.SCItemChange";
			Common.messageDic[0x22]="game.net.data.StoC.SCCityPlayers";
			Common.messageDic[0xC5]="game.net.data.StoC.SCGroupBattlePlayerEnter";
			Common.messageDic[0xD5]="game.net.data.StoC.SCInstantConvoyRes";
			Common.messageDic[0x98]="game.net.data.StoC.SCOfflineWhisper";
			Common.messageDic[0x35]="game.net.data.StoC.SCBeginConvey";
			Common.messageDic[0x01]="game.net.data.StoC.SCUserRegister";
			Common.messageDic[0xF2]="game.net.data.StoC.SCGDEnter";
			Common.messageDic[0xC0]="game.net.data.StoC.SCGroupBattleEnter";
			Common.messageDic[0x1F]="game.net.data.StoC.SCPlayerInfoChange2";
			Common.messageDic[0x2F7]="game.net.data.StoC.SCGEResult";
			Common.messageDic[0x2C1]="game.net.data.StoC.SCDisbandGuild";
			Common.messageDic[0x23]="game.net.data.StoC.SCCityLeave";
			Common.messageDic[0xC9]="game.net.data.StoC.SCGroupBattleSortUpdate";
			Common.messageDic[0x2CA]="game.net.data.StoC.SCGuildMemberInfoChg";
			Common.messageDic[0xB8]="game.net.data.StoC.SCSaleState";
			Common.messageDic[0x303]="game.net.data.StoC.SCFeastFinish";
			Common.messageDic[0xE000]="game.net.data.StoC.SCBackendCommand";
			Common.messageDic[0x2FB]="game.net.data.StoC.SCGuildEscorPrepare";
			Common.messageDic[0x1C1]="game.net.data.StoC.SCStoreBuyRet";
			Common.messageDic[0x15]="game.net.data.StoC.SCHeroEnhance";
			Common.messageDic[0x0D]="game.net.data.StoC.SCEnterCode";
			Common.messageDic[0x95]="game.net.data.StoC.SCLoudspeaker";
			Common.messageDic[0x5D]="game.net.data.StoC.SCListContactNotification";
			Common.messageDic[0xCA]="game.net.data.StoC.SCGroupBattleGroupDataReply";
			Common.messageDic[0x4F]="game.net.data.StoC.SCRecentOnline";
			Common.messageDic[0xC3]="game.net.data.StoC.SCGroupBattlePlayerUpdate";
			Common.messageDic[0xB7]="game.net.data.StoC.SCListSale";
			Common.messageDic[0x79]="game.net.data.StoC.SCHeroBet";
			Common.messageDic[0x8A]="game.net.data.StoC.SCResetDemon";
			Common.messageDic[0x2CE]="game.net.data.StoC.SCSelfGuildInfo";
			Common.messageDic[0x18]="game.net.data.StoC.SCHeroSummonStatus";
			Common.messageDic[0x66]="game.net.data.StoC.SCBattleInfo";
			Common.messageDic[0x2F8]="game.net.data.StoC.SCGELeave";
			Common.messageDic[0x101]="game.net.data.StoC.SCDonateRank";
			Common.messageDic[0x1D1]="game.net.data.StoC.SCMiningPlayerStart";
			Common.messageDic[0xC6]="game.net.data.StoC.SCGroupBattlePlayerLeave";
			Common.messageDic[0x2F6]="game.net.data.StoC.SCGEPlayerRevive";
			Common.messageDic[0x2F0]="game.net.data.StoC.SCListGuildTrend";
			Common.messageDic[0xB0]="game.net.data.StoC.SCBeginTrade";
			Common.messageDic[0x97]="game.net.data.StoC.SCSystemAnnounce";
			Common.messageDic[0x205]="game.net.data.StoC.SCGemChange";
			Common.messageDic[0x293]="game.net.data.StoC.SCAbyssLootResult";
			Common.messageDic[0xB9]="game.net.data.StoC.SCBuyout";
			Common.messageDic[0x2F9]="game.net.data.StoC.SCGEEnterInfo";
			Common.messageDic[0x1A0]="game.net.data.StoC.SCAthleticsQuery";
			Common.messageDic[0x02]="game.net.data.StoC.SCUserLogin";
			Common.messageDic[0x2F4]="game.net.data.StoC.SCGEDrayComplete";
			Common.messageDic[0x1A2]="game.net.data.StoC.SCAthleticsHistory";
			Common.messageDic[0x1C0]="game.net.data.StoC.SCStoreQuery";
			Common.messageDic[0x2F3]="game.net.data.StoC.SCGEDraySyn";
			Common.messageDic[0x2D2]="game.net.data.StoC.SCGuildActEvent";
			Common.messageDic[0x92]="game.net.data.StoC.SCGuildChat";
			Common.messageDic[0xD7]="game.net.data.StoC.SCLoopQuestDataRes";
			Common.messageDic[0xFD]="game.net.data.StoC.SCGDReviveReject";
			Common.messageDic[0x1C]="game.net.data.StoC.SCSetSquad";
			Common.messageDic[0xF1]="game.net.data.StoC.SCGDBegin";
			Common.messageDic[0x2E6]="game.net.data.StoC.SCBossPlayerStateList";
			Common.messageDic[0x72]="game.net.data.StoC.SCGiftCount";
			Common.messageDic[0x2CD]="game.net.data.StoC.SCGuildReject";
			Common.messageDic[0x2E3]="game.net.data.StoC.SCBossPlayerDmg";
			Common.messageDic[0xC7]="game.net.data.StoC.SCGroupBattlePlayerLost";
			Common.messageDic[0xBE]="game.net.data.StoC.SCResell";
			Common.messageDic[0x204]="game.net.data.StoC.SCDecomposeResult";
			Common.messageDic[0xFFF1]="game.net.data.StoC.SCGatewayCommand";
			Common.messageDic[0xD8]="game.net.data.StoC.SCLoopQuestSubmitRes";
			Common.messageDic[0x2D1]="game.net.data.StoC.SCGuildDrinkTea";
			Common.messageDic[0x26]="game.net.data.StoC.SCMultiAvatarInfoChange";
			Common.messageDic[0x8B]="game.net.data.StoC.SCDemonLoot";
			Common.messageDic[0x37]="game.net.data.StoC.SCFishBegin";
			Common.messageDic[0x2E8]="game.net.data.StoC.SCBossFightEnd";
			Common.messageDic[0xF5]="game.net.data.StoC.SCGDStateList";
			Common.messageDic[0xD2]="game.net.data.StoC.SCConvoyInfoRes";
			Common.messageDic[0x08]="game.net.data.StoC.SCSystemMessage";
			Common.messageDic[0x20]="game.net.data.StoC.SCPlayerWalk";
			Common.messageDic[0xB2]="game.net.data.StoC.SCTradeStatus";
			Common.messageDic[0x2A]="game.net.data.StoC.SCBarrier";
			Common.messageDic[0x2A1]="game.net.data.StoC.SCGemMergeResult";
			Common.messageDic[0x2F5]="game.net.data.StoC.SCGEPlayerBattle";
			Common.messageDic[0x4C]="game.net.data.StoC.SCShowContactMore";
			Common.messageDic[0x202]="game.net.data.StoC.SCSellItem";
			Common.messageDic[0xB3]="game.net.data.StoC.SCListTrade";
			Common.messageDic[0xC1]="game.net.data.StoC.SCGroupBattleQuit";
			Common.messageDic[0x2C8]="game.net.data.StoC.SCViewOtherGuild";
			Common.messageDic[0x19]="game.net.data.StoC.SCHeroNewList";
			Common.messageDic[0x13]="game.net.data.StoC.SCDailyInfo";
			Common.messageDic[0x00]="game.net.data.StoC.SCPing";
			Common.messageDic[0xD0]="game.net.data.StoC.SCConvoyBeginRes";
			Common.messageDic[0x32]="game.net.data.StoC.SCQuestStepUpdate";
			Common.messageDic[0x59]="game.net.data.StoC.SCDelNotification";
			Common.messageDic[0x2C0]="game.net.data.StoC.SCGuildRequestG";
			Common.messageDic[0xCB]="game.net.data.StoC.SCGroupBattleReadyReply";
			Common.messageDic[0x4D]="game.net.data.StoC.SCRecentContact";
			Common.messageDic[0x2E]="game.net.data.StoC.SCTrainComplete";
			Common.messageDic[0x1E]="game.net.data.StoC.SCSwitchSquad";
			Common.messageDic[0x0E]="game.net.data.StoC.SCWallowUpdate";
			Common.messageDic[0xF6]="game.net.data.StoC.SCGDBossInfo";
			Common.messageDic[0x292]="game.net.data.StoC.SCAbyssAward";
			Common.messageDic[0x2FC]="game.net.data.StoC.SCGuildEscorStart";
			Common.messageDic[0x78]="game.net.data.StoC.SCHeroBetInfo";
			Common.messageDic[0x75]="game.net.data.StoC.SCTakeOnlineGift";
			Common.messageDic[0xBB]="game.net.data.StoC.SCSelfPurchase";
			Common.messageDic[0xFC]="game.net.data.StoC.SCGDStart";
			Common.messageDic[0x25]="game.net.data.StoC.SCTransport";
			Common.messageDic[0x28]="game.net.data.StoC.SCAvatarInfo";
			Common.messageDic[0xE3]="game.net.data.StoC.SCActivateArtifactsRes";
			Common.messageDic[0x2C5]="game.net.data.StoC.SCGuildPass";
			Common.messageDic[0xF4]="game.net.data.StoC.SCGDBattleResult";
			Common.messageDic[0x302]="game.net.data.StoC.SCFeastStart";
			Common.messageDic[0x2E1]="game.net.data.StoC.SCBossDmglist";
			Common.messageDic[0x30]="game.net.data.StoC.SCQuestList";
			Common.messageDic[0x5E]="game.net.data.StoC.SCListBattleNotification";
			Common.messageDic[0x74]="game.net.data.StoC.SCOnlineGift";
			Common.messageDic[0xE001]="game.net.data.StoC.SCBackendTopup";
			Common.messageDic[0x2CC]="game.net.data.StoC.SCListGuildRequest";
			Common.messageDic[0x4E]="game.net.data.StoC.SCDismissFans";
			Common.messageDic[0xBF]="game.net.data.StoC.SCBeginTradeAck";
			Common.messageDic[0x2D0]="game.net.data.StoC.SCGuildSpinMoney";
			Common.messageDic[0x39]="game.net.data.StoC.SCPlotBegin";
			Common.messageDic[0x96]="game.net.data.StoC.SCWhisperPtnInfo";
			Common.messageDic[0x3E]="game.net.data.StoC.SCInstantFish";
			Common.messageDic[0x1B]="game.net.data.StoC.SCSwitchSkill";
			Common.messageDic[0x280]="game.net.data.StoC.SCEnhanceResult";
			Common.messageDic[0x3A]="game.net.data.StoC.SCConveyFail";
			Common.messageDic[0x2E2]="game.net.data.StoC.SCBossBsInfo";
			Common.messageDic[0x2C4]="game.net.data.StoC.SCGuildRequest";
			Common.messageDic[0x40]="game.net.data.StoC.SCShowContact";
			Common.messageDic[0xC4]="game.net.data.StoC.SCGroupBattleTime";
			Common.messageDic[0xD4]="game.net.data.StoC.SCSTopConvoyRes";
			Common.messageDic[0x2C9]="game.net.data.StoC.SCGuildInfoChange";
			Common.messageDic[0x24]="game.net.data.StoC.SCNPCReaction";
			Common.messageDic[0x41]="game.net.data.StoC.SCContactList";
			Common.messageDic[0x58]="game.net.data.StoC.SCListNotification";
			Common.messageDic[0x27]="game.net.data.StoC.SCAvatarInfoChange";
			Common.messageDic[0x36]="game.net.data.StoC.SCFishDraw";
			Common.messageDic[0x2EA]="game.net.data.StoC.SCBossDmgUpdate";
			Common.messageDic[0x33]="game.net.data.StoC.SCNpcTrigger";
			Common.messageDic[0x1D0]="game.net.data.StoC.SCMiningResult";
			Common.messageDic[0x2E0]="game.net.data.StoC.SCBossFightBegin";
			Common.messageDic[0x1A3]="game.net.data.StoC.SCAthleticsReset";
			Common.messageDic[0x2F2]="game.net.data.StoC.SCGEInfo";
			Common.messageDic[0xF3]="game.net.data.StoC.SCGDPlayerEnter";
			Common.messageDic[0xBC]="game.net.data.StoC.SCListPurchase";
			Common.messageDic[0x304]="game.net.data.StoC.SCFeastPrepare";
			Common.messageDic[0xE0]="game.net.data.StoC.SCArtifactsState";
			Common.messageDic[0x103]="game.net.data.StoC.SCDonateList";
			Common.messageDic[0x8C]="game.net.data.StoC.SCDemonOpen";
			Common.messageDic[0x291]="game.net.data.StoC.SCMergeSoulAllFinish";
			Common.messageDic[0x1D]="game.net.data.StoC.SCLearn";
			Common.messageDic[0xD1]="game.net.data.StoC.SCArrivePonitRes";
			Common.messageDic[0x2FA]="game.net.data.StoC.SCGEPlayerBattleEnd";
			Common.messageDic[0x5C]="game.net.data.StoC.SCListRewardNotification";
			Common.messageDic[0xB6]="game.net.data.StoC.SCSelfSale";
			Common.messageDic[0x2C7]="game.net.data.StoC.SCGuildVote";
			Common.messageDic[0x2E5]="game.net.data.StoC.SCBossReBirth";
			Common.messageDic[0x2C3]="game.net.data.StoC.SCGuildList";
			Common.messageDic[0xFB]="game.net.data.StoC.SCGDPrepare";
			Common.messageDic[0x2CF]="game.net.data.StoC.SCGuildTrendMessage";
			Common.messageDic[0x88]="game.net.data.StoC.SCDemonInfo";
			Common.messageDic[0x71]="game.net.data.StoC.SCGiftTaken";
			Common.messageDic[0x55]="game.net.data.StoC.SCListRecent";
			Common.messageDic[0x70]="game.net.data.StoC.SCGiftList";
			Common.messageDic[0x3C]="game.net.data.StoC.SCCancelFishRes";
			Common.messageDic[0x102]="game.net.data.StoC.SCDonateListCount";
			Common.messageDic[0x42]="game.net.data.StoC.SCContactInfoChange";
			Common.messageDic[0x21]="game.net.data.StoC.SCCityEnter";
			Common.messageDic[0x90]="game.net.data.StoC.SCWhisper";
			Common.messageDic[0x11]="game.net.data.StoC.SCPlayerInfoChange";
			Common.messageDic[0x1A1]="game.net.data.StoC.SCAthleticsChallenge";
			Common.messageDic[0x94]="game.net.data.StoC.SCGlobalChat";
			Common.messageDic[0xB4]="game.net.data.StoC.SCTradeCount";
			Common.messageDic[0x2CB]="game.net.data.StoC.SCGuildApplyNotExist";
			Common.messageDic[0x43]="game.net.data.StoC.SCRemoveContact";
			Common.messageDic[0x2A0]="game.net.data.StoC.SCGemIdentifyResult";
			Common.messageDic[0x301]="game.net.data.StoC.SCFeastStatus";
			Common.messageDic[0xE1]="game.net.data.StoC.SCChallengeArtifactsRes";
			Common.messageDic[0x2E9]="game.net.data.StoC.SCBossDmgNew";
			Common.messageDic[0x2E7]="game.net.data.StoC.SCBossLeaveReturn";
			Common.messageDic[0x281]="game.net.data.StoC.SCEnhanceTransferResult";
			Common.messageDic[0xFFF0]="game.net.data.StoC.SCGatewayConnect";
			Common.messageDic[0xC2]="game.net.data.StoC.SCGroupBattleUpdate";
			Common.messageDic[0xF7]="game.net.data.StoC.SCGDLeave";
			Common.messageDic[0x29]="game.net.data.StoC.SCHeroPotential";
			Common.messageDic[0x31]="game.net.data.StoC.SCQuestOperateReply";
			Common.messageDic[0xB5]="game.net.data.StoC.SCStartSale";
			Common.messageDic[0x17]="game.net.data.StoC.SCHeroDonate";
			Common.messageDic[0x0F]="game.net.data.StoC.SCPlayerId";
			Common.messageDic[0xE2]="game.net.data.StoC.SCTrainArtifactsRes";
			Common.messageDic[0x1A4]="game.net.data.StoC.SCAthleticsBuy";
			Common.messageDic[0x2C]="game.net.data.StoC.SCItemTrain";
			Common.messageDic[0xD6]="game.net.data.StoC.SCConvoyNumUpdate";
			Common.messageDic[0xFFF8]="game.net.data.StoC.CCSendItemToChat";
			Common.messageDic[0xFFF4]="game.net.data.StoC.CCTeamChange";
			Common.messageDic[0xFFF9]="game.net.data.StoC.CCSendDemonToMassage";
			Common.messageDic[0xFFF3]="game.net.data.StoC.CCHeroEqChange";
			Common.messageDic[0xFFF7]="game.net.data.StoC.CCVIPLevelChange";
			Common.messageDic[0xFFF2]="game.net.data.StoC.CCPackChange";
			Common.messageDic[0xFFF6]="game.net.data.StoC.CCHeroLevelUp";
			Common.messageDic[0xFFF5]="game.net.data.StoC.CCHeroPanelOpen";
			Common.messageDic[0xFFF1]="game.net.data.StoC.CCUserDataChangeUp";
		}
	}
}