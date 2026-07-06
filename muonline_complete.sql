-- =============================================
-- MuOnline Season 13 - Complete Database Script
-- Generated: 2026-07-05 04:47:20
-- =============================================

USE [MuOnline]
GO

-- =============================================
-- MuOnline Season 13 - Complete Database Schema
-- Generated: 2026-07-05 04:46:24
-- =============================================

USE [MuOnline]
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[AccountCharacter]') AND xtype = 'U')
CREATE TABLE [dbo].[AccountCharacter] (
    [Number] INT NULL,
    [Id] VARCHAR NULL,
    [GameID1] VARCHAR NULL,
    [GameID2] VARCHAR NULL,
    [GameID3] VARCHAR NULL,
    [GameID4] VARCHAR NULL,
    [GameID5] VARCHAR NULL,
    [GameID6] VARCHAR NULL,
    [GameID7] VARCHAR NULL,
    [GameID8] VARCHAR NULL,
    [GameIDC] VARCHAR NULL,
    [MoveCnt] TINYINT NULL,
    [ExtClass] INT NULL,
    [ExtWarehouse] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[BackSpringDetails]') AND xtype = 'U')
CREATE TABLE [dbo].[BackSpringDetails] (
    [id] BIGINT NULL,
    [author] VARCHAR NULL,
    [victim] VARCHAR NULL,
    [situation] TINYINT NULL,
    [date] DATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[BossHuntLog]') AND xtype = 'U')
CREATE TABLE [dbo].[BossHuntLog] (
    [id] BIGINT NULL,
    [AccountID] NVARCHAR NULL,
    [Name] NVARCHAR NULL,
    [Monster] INT NULL,
    [Map] INT NULL,
    [Damage] INT NULL,
    [Date] DATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[Builds]') AND xtype = 'U')
CREATE TABLE [dbo].[Builds] (
    [Name] NVARCHAR NULL,
    [rebuild_name] NVARCHAR NULL,
    [Strength] INT NULL,
    [Dexterity] INT NULL,
    [Vitality] INT NULL,
    [Energy] INT NULL,
    [Leadership] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[CashShopData]') AND xtype = 'U')
CREATE TABLE [dbo].[CashShopData] (
    [AccountID] VARCHAR NULL,
    [WCoinC] INT NULL,
    [WCoinP] INT NULL,
    [GoblinPoint] INT NULL,
    [Retido] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[CashShopDataLog]') AND xtype = 'U')
CREATE TABLE [dbo].[CashShopDataLog] (
    [idx] BIGINT NULL,
    [AccountID] NVARCHAR NULL,
    [WCoinC_old] INT NULL,
    [WCoinC_new] INT NULL,
    [date] DATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[CashShopDataLogSource]') AND xtype = 'U')
CREATE TABLE [dbo].[CashShopDataLogSource] (
    [idx] BIGINT NULL,
    [account] NVARCHAR NULL,
    [amountWC] INT NULL,
    [amountWP] INT NULL,
    [amountGP] INT NULL,
    [source] NVARCHAR NULL,
    [date] DATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[CashShopInventory]') AND xtype = 'U')
CREATE TABLE [dbo].[CashShopInventory] (
    [BaseItemCode] INT NULL,
    [MainItemCode] INT NULL,
    [AccountID] VARCHAR NULL,
    [InventoryType] INT NULL,
    [PackageMainIndex] INT NULL,
    [ProductBaseIndex] INT NULL,
    [ProductMainIndex] INT NULL,
    [CoinValue] FLOAT NULL,
    [ProductType] INT NULL,
    [GiftName] VARCHAR NULL,
    [GiftText] VARCHAR NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[CashShopPeriodicItem]') AND xtype = 'U')
CREATE TABLE [dbo].[CashShopPeriodicItem] (
    [ItemSerial] INT NULL,
    [Time] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[Character]') AND xtype = 'U')
CREATE TABLE [dbo].[Character] (
    [AccountID] VARCHAR NULL,
    [Name] VARCHAR NULL,
    [cLevel] INT NULL,
    [LevelUpPoint] INT NULL,
    [Class] TINYINT NULL,
    [Experience] INT NULL,
    [Strength] INT NULL,
    [Dexterity] INT NULL,
    [Vitality] INT NULL,
    [Energy] INT NULL,
    [Leadership] INT NULL,
    [Inventory] VARBINARY NULL,
    [MagicList] VARBINARY NULL,
    [Money] INT NULL,
    [Life] REAL NULL,
    [MaxLife] REAL NULL,
    [Mana] REAL NULL,
    [MaxMana] REAL NULL,
    [BP] REAL NULL,
    [MaxBP] REAL NULL,
    [Shield] REAL NULL,
    [MaxShield] REAL NULL,
    [MapNumber] SMALLINT NULL,
    [MapPosX] SMALLINT NULL,
    [MapPosY] SMALLINT NULL,
    [MapDir] TINYINT NULL,
    [PkCount] INT NULL,
    [PkLevel] INT NULL,
    [PkTime] INT NULL,
    [MDate] SMALLDATETIME NULL,
    [LDate] SMALLDATETIME NULL,
    [CtlCode] TINYINT NULL,
    [DbVersion] TINYINT NULL,
    [Quest] VARBINARY NULL,
    [ChatLimitTime] INT NULL,
    [FruitPoint] INT NULL,
    [EffectList] VARBINARY NULL,
    [FruitAddPoint] INT NULL,
    [FruitSubPoint] INT NULL,
    [ResetCount] INT NULL,
    [ResetDay] INT NULL,
    [ResetWek] INT NULL,
    [MasterResetCount] INT NULL,
    [MasterResetDay] INT NULL,
    [MasterResetWek] INT NULL,
    [PKRankCount] INT NULL,
    [PKCountDay] INT NULL,
    [PKCountWek] INT NULL,
    [ExtInventory] INT NULL,
    [Ruud] INT NULL,
    [HuntingUserOpen] INT NULL,
    [AutoDt0] INT NULL,
    [AutoDt1] INT NULL,
    [AutoDt2] INT NULL,
    [AutoDt3] INT NULL,
    [AutoDt4] INT NULL,
    [AutoRr] TINYINT NULL,
    [AutoRe] TINYINT NULL,
    [MUFC] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[CustomJewelBank]') AND xtype = 'U')
CREATE TABLE [dbo].[CustomJewelBank] (
    [AccountID] VARCHAR NULL,
    [Bless] INT NULL,
    [Soul] INT NULL,
    [Life] INT NULL,
    [Creation] INT NULL,
    [Guardian] INT NULL,
    [GemStone] INT NULL,
    [Harmony] INT NULL,
    [Chaos] INT NULL,
    [LowStone] INT NULL,
    [HighStone] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[CustomPick]') AND xtype = 'U')
CREATE TABLE [dbo].[CustomPick] (
    [Name] VARCHAR NULL,
    [CustomPickList] VARBINARY NULL,
    [Money] INT NULL,
    [Jewel] INT NULL,
    [ItemExc] INT NULL,
    [ItemSet] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[DailyRewardData]') AND xtype = 'U')
CREATE TABLE [dbo].[DailyRewardData] (
    [Name] VARCHAR NULL,
    [index] INT NULL,
    [result] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[DefaultClassType]') AND xtype = 'U')
CREATE TABLE [dbo].[DefaultClassType] (
    [Class] TINYINT NULL,
    [Strength] SMALLINT NULL,
    [Dexterity] SMALLINT NULL,
    [Vitality] SMALLINT NULL,
    [Energy] SMALLINT NULL,
    [MagicList] VARBINARY NULL,
    [Life] REAL NULL,
    [MaxLife] REAL NULL,
    [Mana] REAL NULL,
    [MaxMana] REAL NULL,
    [MapNumber] SMALLINT NULL,
    [MapPosX] SMALLINT NULL,
    [MapPosY] SMALLINT NULL,
    [Quest] VARBINARY NULL,
    [DbVersion] TINYINT NULL,
    [Leadership] SMALLINT NULL,
    [Level] SMALLINT NULL,
    [LevelUpPoint] SMALLINT NULL,
    [Inventory] VARBINARY NULL,
    [LevelLife] REAL NULL,
    [LevelMana] REAL NULL,
    [VitalityToLife] REAL NULL,
    [EnergyToMana] REAL NULL,
    [EffectList] VARBINARY NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[EventEntryCount]') AND xtype = 'U')
CREATE TABLE [dbo].[EventEntryCount] (
    [Account] VARCHAR NULL,
    [Name] VARCHAR NULL,
    [BCCount] INT NULL,
    [CCCount] INT NULL,
    [DSCount] INT NULL,
    [DGCount] INT NULL,
    [ITCount] INT NULL,
    [IGCount] INT NULL,
    [LastDate] SMALLDATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[EventGoldenArcher]') AND xtype = 'U')
CREATE TABLE [dbo].[EventGoldenArcher] (
    [Account] VARCHAR NULL,
    [RenaCount] INT NULL,
    [StoneCount] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[EventInventory]') AND xtype = 'U')
CREATE TABLE [dbo].[EventInventory] (
    [Name] VARCHAR NULL,
    [Items] VARBINARY NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[EventLeoTheHelper]') AND xtype = 'U')
CREATE TABLE [dbo].[EventLeoTheHelper] (
    [Name] VARCHAR NULL,
    [Status] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[EventSantaClaus]') AND xtype = 'U')
CREATE TABLE [dbo].[EventSantaClaus] (
    [Name] VARCHAR NULL,
    [Status] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[EventsCounter]') AND xtype = 'U')
CREATE TABLE [dbo].[EventsCounter] (
    [Name] NVARCHAR NULL,
    [ITEnter] INT NULL,
    [ITWins] INT NULL,
    [IGEnter] INT NULL,
    [BCEnter] INT NULL,
    [DSEnter] INT NULL,
    [CCEnter] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[ExtWarehouse]') AND xtype = 'U')
CREATE TABLE [dbo].[ExtWarehouse] (
    [AccountID] VARCHAR NULL,
    [Items] VARBINARY NULL,
    [Money] INT NULL,
    [Number] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[FavoriteMoves]') AND xtype = 'U')
CREATE TABLE [dbo].[FavoriteMoves] (
    [Name] NVARCHAR NULL,
    [move1] INT NULL,
    [move2] INT NULL,
    [move3] INT NULL,
    [move4] INT NULL,
    [move5] INT NULL,
    [data1] INT NULL,
    [data2] INT NULL,
    [data3] INT NULL,
    [data4] INT NULL,
    [data5] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[GameServerInfo]') AND xtype = 'U')
CREATE TABLE [dbo].[GameServerInfo] (
    [Number] INT NULL,
    [ItemCount] BIGINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[Gens_Rank]') AND xtype = 'U')
CREATE TABLE [dbo].[Gens_Rank] (
    [Name] VARCHAR NULL,
    [Family] INT NULL,
    [Contribution] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[Gens_Reward]') AND xtype = 'U')
CREATE TABLE [dbo].[Gens_Reward] (
    [Name] VARCHAR NULL,
    [Rank] INT NULL,
    [Status] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[GiftData]') AND xtype = 'U')
CREATE TABLE [dbo].[GiftData] (
    [Name] VARCHAR NULL,
    [Index] INT NULL,
    [Count] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[GremoryCase]') AND xtype = 'U')
CREATE TABLE [dbo].[GremoryCase] (
    [AccountID] NVARCHAR NULL,
    [Name] NVARCHAR NULL,
    [Serial] INT NULL,
    [StorageType] TINYINT NULL,
    [btRewardSource] SMALLINT NULL,
    [ItemGUID] SMALLINT NULL,
    [ReceiveDate] BIGINT NULL,
    [ExpireDate] BIGINT NULL,
    [Item] VARBINARY NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[Guild]') AND xtype = 'U')
CREATE TABLE [dbo].[Guild] (
    [G_Name] VARCHAR NULL,
    [G_Mark] VARBINARY NULL,
    [G_Score] INT NULL,
    [G_Master] VARCHAR NULL,
    [G_Count] INT NULL,
    [G_Notice] VARCHAR NULL,
    [Number] INT NULL,
    [G_Type] INT NULL,
    [G_Rival] INT NULL,
    [G_Union] INT NULL,
    [MemberCount] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[GuildMember]') AND xtype = 'U')
CREATE TABLE [dbo].[GuildMember] (
    [Name] VARCHAR NULL,
    [G_Name] VARCHAR NULL,
    [G_Level] TINYINT NULL,
    [G_Status] TINYINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[HardwareIdBlock]') AND xtype = 'U')
CREATE TABLE [dbo].[HardwareIdBlock] (
    [idx] INT NULL,
    [hardwareId] VARCHAR NULL,
    [dateExpire] DATE NULL,
    [comentario] NVARCHAR NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[HardwareIdLog]') AND xtype = 'U')
CREATE TABLE [dbo].[HardwareIdLog] (
    [id] BIGINT NULL,
    [account] VARCHAR NULL,
    [hardwareId] VARCHAR NULL,
    [date] DATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[HelperData]') AND xtype = 'U')
CREATE TABLE [dbo].[HelperData] (
    [Name] VARCHAR NULL,
    [Data] BINARY NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[HuntingRecordLog]') AND xtype = 'U')
CREATE TABLE [dbo].[HuntingRecordLog] (
    [AccountID] VARCHAR NULL,
    [Name] NCHAR NULL,
    [MapIndex] INT NULL,
    [mYear] INT NULL,
    [mMonth] INT NULL,
    [mDay] INT NULL,
    [CurrentLevel] SMALLINT NULL,
    [HuntingAccrueSecond] INT NULL,
    [NormalAccrueDamage] BIGINT NULL,
    [PentagramAccrueDamage] BIGINT NULL,
    [HealAccrueValue] BIGINT NULL,
    [MonsterKillCount] BIGINT NULL,
    [AccrueExp] BIGINT NULL,
    [Class] TINYINT NULL,
    [MaxNormalDamage] BIGINT NULL,
    [MinNormalDamage] BIGINT NULL,
    [MaxPentagramDamage] BIGINT NULL,
    [MinPentagramDamage] BIGINT NULL,
    [GetNormalAccrueDamage] BIGINT NULL,
    [GetPentagramAccrueDamage] BIGINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[ItemTracking]') AND xtype = 'U')
CREATE TABLE [dbo].[ItemTracking] (
    [idx] BIGINT NULL,
    [serial] NCHAR NULL,
    [serialNumber] BIGINT NULL,
    [action] TINYINT NULL,
    [subaction] TINYINT NULL,
    [itemOld] NVARCHAR NULL,
    [itemNew] NVARCHAR NULL,
    [accOld] NVARCHAR NULL,
    [accNew] NVARCHAR NULL,
    [date] DATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[LuckyCoin]') AND xtype = 'U')
CREATE TABLE [dbo].[LuckyCoin] (
    [AccountID] VARCHAR NULL,
    [LuckyCoin] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[LuckyItem]') AND xtype = 'U')
CREATE TABLE [dbo].[LuckyItem] (
    [ItemSerial] INT NULL,
    [DurabilitySmall] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MasterSkillTree]') AND xtype = 'U')
CREATE TABLE [dbo].[MasterSkillTree] (
    [Name] VARCHAR NULL,
    [MasterLevel] INT NULL,
    [MasterPoint] INT NULL,
    [MasterExperience] BIGINT NULL,
    [MasterSkill] VARBINARY NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MasterSkillTree_4th]') AND xtype = 'U')
CREATE TABLE [dbo].[MasterSkillTree_4th] (
    [Name] VARCHAR NULL,
    [MasterPoint] INT NULL,
    [MasterSkill] VARBINARY NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MEMB_INFO]') AND xtype = 'U')
CREATE TABLE [dbo].[MEMB_INFO] (
    [memb_guid] INT NULL,
    [memb___id] VARCHAR NULL,
    [memb__pwd] VARCHAR NULL,
    [memb_name] VARCHAR NULL,
    [sno__numb] CHAR NULL,
    [post_code] CHAR NULL,
    [addr_info] VARCHAR NULL,
    [addr_deta] VARCHAR NULL,
    [tel__numb] VARCHAR NULL,
    [phon_numb] VARCHAR NULL,
    [mail_addr] VARCHAR NULL,
    [fpas_ques] VARCHAR NULL,
    [fpas_answ] VARCHAR NULL,
    [job__code] CHAR NULL,
    [appl_days] DATETIME NULL,
    [modi_days] DATETIME NULL,
    [out__days] DATETIME NULL,
    [true_days] DATETIME NULL,
    [mail_chek] CHAR NULL,
    [bloc_code] CHAR NULL,
    [ctl1_code] CHAR NULL,
    [AccountLevel] INT NULL,
    [AccountExpireDate] SMALLDATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MEMB_STAT]') AND xtype = 'U')
CREATE TABLE [dbo].[MEMB_STAT] (
    [memb___id] VARCHAR NULL,
    [ConnectStat] TINYINT NULL,
    [ServerName] VARCHAR NULL,
    [IP] VARCHAR NULL,
    [ConnectTM] SMALLDATETIME NULL,
    [DisConnectTM] SMALLDATETIME NULL,
    [OnlineHours] INT NULL,
    [Disconnect] TINYINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MonsterKillCount]') AND xtype = 'U')
CREATE TABLE [dbo].[MonsterKillCount] (
    [Name] VARCHAR NULL,
    [MonsterClass] INT NULL,
    [MonsterKillCount] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MuCastle_DATA]') AND xtype = 'U')
CREATE TABLE [dbo].[MuCastle_DATA] (
    [MAP_SVR_GROUP] INT NULL,
    [SIEGE_START_DATE] DATETIME NULL,
    [SIEGE_END_DATE] DATETIME NULL,
    [SIEGE_GUILDLIST_SETTED] BIT NULL,
    [SIEGE_ENDED] BIT NULL,
    [CASTLE_OCCUPY] BIT NULL,
    [OWNER_GUILD] VARCHAR NULL,
    [MONEY] MONEY NULL,
    [TAX_RATE_CHAOS] INT NULL,
    [TAX_RATE_STORE] INT NULL,
    [TAX_HUNT_ZONE] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MuCastle_MONEY_STATISTICS]') AND xtype = 'U')
CREATE TABLE [dbo].[MuCastle_MONEY_STATISTICS] (
    [MAP_SVR_GROUP] INT NULL,
    [LOG_DATE] DATETIME NULL,
    [MONEY_CHANGE] MONEY NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MuCastle_NPC]') AND xtype = 'U')
CREATE TABLE [dbo].[MuCastle_NPC] (
    [MAP_SVR_GROUP] INT NULL,
    [NPC_NUMBER] INT NULL,
    [NPC_INDEX] INT NULL,
    [NPC_DF_LEVEL] INT NULL,
    [NPC_RG_LEVEL] INT NULL,
    [NPC_MAXHP] INT NULL,
    [NPC_HP] INT NULL,
    [NPC_X] TINYINT NULL,
    [NPC_Y] TINYINT NULL,
    [NPC_DIR] TINYINT NULL,
    [NPC_CREATEDATE] DATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MuCastle_REG_SIEGE]') AND xtype = 'U')
CREATE TABLE [dbo].[MuCastle_REG_SIEGE] (
    [MAP_SVR_GROUP] INT NULL,
    [REG_SIEGE_GUILD] VARCHAR NULL,
    [REG_MARKS] INT NULL,
    [IS_GIVEUP] TINYINT NULL,
    [SEQ_NUM] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MuCastle_SIEGE_GUILDLIST]') AND xtype = 'U')
CREATE TABLE [dbo].[MuCastle_SIEGE_GUILDLIST] (
    [MAP_SVR_GROUP] INT NULL,
    [GUILD_NAME] VARCHAR NULL,
    [GUILD_ID] INT NULL,
    [GUILD_INVOLVED] BIT NULL,
    [GUILD_SCORE] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MuRummyCard]') AND xtype = 'U')
CREATE TABLE [dbo].[MuRummyCard] (
    [Name] VARCHAR NULL,
    [Color] INT NULL,
    [Number] INT NULL,
    [Slot] INT NULL,
    [Status] INT NULL,
    [Sequence] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MuRummyData]') AND xtype = 'U')
CREATE TABLE [dbo].[MuRummyData] (
    [Name] VARCHAR NULL,
    [TotalScore] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[MuunInventory]') AND xtype = 'U')
CREATE TABLE [dbo].[MuunInventory] (
    [Name] VARCHAR NULL,
    [Items] VARBINARY NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[NewQuestWorld]') AND xtype = 'U')
CREATE TABLE [dbo].[NewQuestWorld] (
    [Name] NCHAR NULL,
    [NewQuestWorldList] VARBINARY NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[OfflineMode]') AND xtype = 'U')
CREATE TABLE [dbo].[OfflineMode] (
    [Name] VARCHAR NULL,
    [Status] INT NULL,
    [Attack] TINYINT NULL,
    [Ghost] INT NULL,
    [ShopOpen] INT NULL,
    [ShopText] VARCHAR NULL,
    [ServerCode] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[OptionData]') AND xtype = 'U')
CREATE TABLE [dbo].[OptionData] (
    [Name] VARCHAR NULL,
    [SkillKey] BINARY NULL,
    [GameOption] TINYINT NULL,
    [Qkey] TINYINT NULL,
    [Wkey] TINYINT NULL,
    [Ekey] TINYINT NULL,
    [ChatWindow] TINYINT NULL,
    [Rkey] TINYINT NULL,
    [QWERLevel] INT NULL,
    [ChangeSkin] TINYINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[PentagramJewel]') AND xtype = 'U')
CREATE TABLE [dbo].[PentagramJewel] (
    [AccountID] VARCHAR NULL,
    [Name] VARCHAR NULL,
    [Type] TINYINT NULL,
    [Index] TINYINT NULL,
    [Attribute] TINYINT NULL,
    [ItemSection] TINYINT NULL,
    [ItemType] SMALLINT NULL,
    [ItemLevel] TINYINT NULL,
    [OptionIndexRank1] TINYINT NULL,
    [OptionLevelRank1] TINYINT NULL,
    [OptionIndexRank2] TINYINT NULL,
    [OptionLevelRank2] TINYINT NULL,
    [OptionIndexRank3] TINYINT NULL,
    [OptionLevelRank3] TINYINT NULL,
    [OptionIndexRank4] TINYINT NULL,
    [OptionLevelRank4] TINYINT NULL,
    [OptionIndexRank5] TINYINT NULL,
    [OptionLevelRank5] TINYINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[PeriodicItem]') AND xtype = 'U')
CREATE TABLE [dbo].[PeriodicItem] (
    [ItemSerial] INT NULL,
    [Time] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[PKDetails]') AND xtype = 'U')
CREATE TABLE [dbo].[PKDetails] (
    [id] BIGINT NULL,
    [killer] VARCHAR NULL,
    [victim] VARCHAR NULL,
    [map] SMALLINT NULL,
    [x] SMALLINT NULL,
    [y] SMALLINT NULL,
    [helpers] SMALLINT NULL,
    [date] DATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[PShopItemValue]') AND xtype = 'U')
CREATE TABLE [dbo].[PShopItemValue] (
    [Name] VARCHAR NULL,
    [Slot] INT NULL,
    [Serial] INT NULL,
    [Value] INT NULL,
    [JoBValue] INT NULL,
    [JoSValue] INT NULL,
    [JoCValue] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[QuestKillCount]') AND xtype = 'U')
CREATE TABLE [dbo].[QuestKillCount] (
    [Name] VARCHAR NULL,
    [QuestIndex] INT NULL,
    [MonsterClass1] INT NULL,
    [KillCount1] INT NULL,
    [MonsterClass2] INT NULL,
    [KillCount2] INT NULL,
    [MonsterClass3] INT NULL,
    [KillCount3] INT NULL,
    [MonsterClass4] INT NULL,
    [KillCount4] INT NULL,
    [MonsterClass5] INT NULL,
    [KillCount5] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[QuestWorld]') AND xtype = 'U')
CREATE TABLE [dbo].[QuestWorld] (
    [Name] VARCHAR NULL,
    [QuestWorldList] VARBINARY NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[RankingBloodCastle]') AND xtype = 'U')
CREATE TABLE [dbo].[RankingBloodCastle] (
    [Name] VARCHAR NULL,
    [Score] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[RankingChaosCastle]') AND xtype = 'U')
CREATE TABLE [dbo].[RankingChaosCastle] (
    [Name] VARCHAR NULL,
    [Score] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[RankingDevilSquare]') AND xtype = 'U')
CREATE TABLE [dbo].[RankingDevilSquare] (
    [Name] VARCHAR NULL,
    [Score] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[RankingDuel]') AND xtype = 'U')
CREATE TABLE [dbo].[RankingDuel] (
    [Name] VARCHAR NULL,
    [WinScore] INT NULL,
    [LoseScore] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[RankingIllusionTemple]') AND xtype = 'U')
CREATE TABLE [dbo].[RankingIllusionTemple] (
    [Name] VARCHAR NULL,
    [Score] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[ReconnectData]') AND xtype = 'U')
CREATE TABLE [dbo].[ReconnectData] (
    [Name] VARCHAR NULL,
    [ServerCode] INT NULL,
    [Data] BINARY NULL,
    [Time] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[ResetData]') AND xtype = 'U')
CREATE TABLE [dbo].[ResetData] (
    [Account] VARCHAR NULL,
    [Name] VARCHAR NULL,
    [ResetDay] INT NULL,
    [ResetWek] INT NULL,
    [ResetMon] INT NULL,
    [ResetDateDay] SMALLDATETIME NULL,
    [ResetDateWek] SMALLDATETIME NULL,
    [ResetDateMon] SMALLDATETIME NULL,
    [MasterResetDay] INT NULL,
    [MasterResetWek] INT NULL,
    [MasterResetMon] INT NULL,
    [MasterResetDateDay] SMALLDATETIME NULL,
    [MasterResetDateWek] SMALLDATETIME NULL,
    [MasterResetDateMon] SMALLDATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[RuudLog]') AND xtype = 'U')
CREATE TABLE [dbo].[RuudLog] (
    [idx] BIGINT NULL,
    [AccountID] NVARCHAR NULL,
    [Name] NVARCHAR NULL,
    [Ruud_old] INT NULL,
    [Ruud_new] INT NULL,
    [Ruud_diff] INT NULL,
    [date] DATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[SNSData]') AND xtype = 'U')
CREATE TABLE [dbo].[SNSData] (
    [Name] VARCHAR NULL,
    [Data] BINARY NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_BombHunt]') AND xtype = 'U')
CREATE TABLE [dbo].[T_BombHunt] (
    [AccountID] VARCHAR NULL,
    [Name] VARCHAR NULL,
    [GameState] TINYINT NULL,
    [Score] INT NULL,
    [TileState] VARCHAR NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_BombHuntLog]') AND xtype = 'U')
CREATE TABLE [dbo].[T_BombHuntLog] (
    [mDate] DATETIME NULL,
    [AccountID] VARCHAR NULL,
    [Name] VARCHAR NULL,
    [mScore] INT NULL,
    [mClear] TINYINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_CGuid]') AND xtype = 'U')
CREATE TABLE [dbo].[T_CGuid] (
    [GUID] INT NULL,
    [Name] VARCHAR NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_FriendList]') AND xtype = 'U')
CREATE TABLE [dbo].[T_FriendList] (
    [GUID] INT NULL,
    [FriendGuid] INT NULL,
    [FriendName] VARCHAR NULL,
    [Del] TINYINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_FriendMail]') AND xtype = 'U')
CREATE TABLE [dbo].[T_FriendMail] (
    [MemoIndex] INT NULL,
    [GUID] INT NULL,
    [FriendName] VARCHAR NULL,
    [wDate] SMALLDATETIME NULL,
    [Subject] VARCHAR NULL,
    [bRead] BIT NULL,
    [Memo] VARBINARY NULL,
    [Photo] BINARY NULL,
    [Dir] TINYINT NULL,
    [Act] TINYINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_FriendMain]') AND xtype = 'U')
CREATE TABLE [dbo].[T_FriendMain] (
    [GUID] INT NULL,
    [Name] VARCHAR NULL,
    [FriendCount] TINYINT NULL,
    [MemoCount] INT NULL,
    [MemoTotal] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_LabyrinthClearLog]') AND xtype = 'U')
CREATE TABLE [dbo].[T_LabyrinthClearLog] (
    [mDate] DATETIME NULL,
    [AccountID] VARCHAR NULL,
    [Name] VARCHAR NULL,
    [mDimensionLevel] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_LabyrinthInfo]') AND xtype = 'U')
CREATE TABLE [dbo].[T_LabyrinthInfo] (
    [AccountID] VARCHAR NULL,
    [Name] VARCHAR NULL,
    [DimensionLevel] TINYINT NULL,
    [ConfigNum] SMALLINT NULL,
    [CurrentZone] TINYINT NULL,
    [VisitedCnt] TINYINT NULL,
    [VisitedList] BINARY NULL,
    [EntireExp] BIGINT NULL,
    [EntireMonKillCnt] BIGINT NULL,
    [ClearCnt] INT NULL,
    [ClearState] TINYINT NULL,
    [EndTime] SMALLDATETIME NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_LabyrinthMissionInfo]') AND xtype = 'U')
CREATE TABLE [dbo].[T_LabyrinthMissionInfo] (
    [AccountID] VARCHAR NULL,
    [Name] VARCHAR NULL,
    [ZoneNumber] TINYINT NULL,
    [MissionType] TINYINT NULL,
    [MissionValue] INT NULL,
    [AcquisitionValue] INT NULL,
    [MissionState] TINYINT NULL,
    [IsMainMission] TINYINT NULL,
    [MainMissionOrder] TINYINT NULL,
    [RewardItemType] SMALLINT NULL,
    [RewardItemIndex] SMALLINT NULL,
    [RewardValue] INT NULL,
    [RewardCheckState] TINYINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_PetItem_Info]') AND xtype = 'U')
CREATE TABLE [dbo].[T_PetItem_Info] (
    [ItemSerial] INT NULL,
    [Pet_Level] SMALLINT NULL,
    [Pet_Exp] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_RestoreItem_Inventory]') AND xtype = 'U')
CREATE TABLE [dbo].[T_RestoreItem_Inventory] (
    [AccountID] VARCHAR NULL,
    [Name] VARCHAR NULL,
    [RestoreInven] VARBINARY NULL,
    [DbVersion] TINYINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[T_WaitFriend]') AND xtype = 'U')
CREATE TABLE [dbo].[T_WaitFriend] (
    [GUID] INT NULL,
    [FriendGuid] INT NULL,
    [FriendName] VARCHAR NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[warehouse]') AND xtype = 'U')
CREATE TABLE [dbo].[warehouse] (
    [AccountID] VARCHAR NULL,
    [Items] VARBINARY NULL,
    [Money] INT NULL,
    [EndUseDate] SMALLDATETIME NULL,
    [DbVersion] TINYINT NULL,
    [pw] SMALLINT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[WZ_CW_INFO]') AND xtype = 'U')
CREATE TABLE [dbo].[WZ_CW_INFO] (
    [MAP_SVR_GROUP] INT NULL,
    [CRYWOLF_OCCUFY] INT NULL,
    [CRYWOLF_STATE] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[Z_SiegeAccTime]') AND xtype = 'U')
CREATE TABLE [dbo].[Z_SiegeAccTime] (
    [idx] INT NULL,
    [guild] NVARCHAR NULL,
    [time] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[Z_SiegeRanking]') AND xtype = 'U')
CREATE TABLE [dbo].[Z_SiegeRanking] (
    [SiegeDate] DATE NULL,
    [Name] NVARCHAR NULL,
    [SwitchAccumulatedTime] INT NULL,
    [CrownAccumulatedTime] INT NULL,
    [SiegeTotalKillCount] INT NULL,
    [SiegeTotalDeathCount] INT NULL,
    [SiegeTotalRegisterCount] INT NULL,
    [SiegeTotalBackSpring] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[Z_SiegeRegisterLog]') AND xtype = 'U')
CREATE TABLE [dbo].[Z_SiegeRegisterLog] (
    [id] INT NULL,
    [guild] NVARCHAR NULL,
    [date] DATETIME NULL,
    [adt] INT NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[Z_SiegeStatus]') AND xtype = 'U')
CREATE TABLE [dbo].[Z_SiegeStatus] (
    [switch1] NCHAR NULL,
    [switch2] NCHAR NULL,
    [crown] TINYINT NULL,
    [defending] NVARCHAR NULL
)
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('[dbo].[Z_SiegeWins]') AND xtype = 'U')
CREATE TABLE [dbo].[Z_SiegeWins] (
    [idx] INT NULL,
    [Guild] VARCHAR NULL,
    [Points] INT NULL
)
GO




-- =============================================
-- Stored Procedures
-- =============================================

CREATE PROCEDURE [dbo].[GremoryCase_AddItem]
	@szAccountID nvarchar(10),
	@szName nvarchar(10),
	@StorageType tinyint,
	@btRewardSource tinyint ,
	@ReceiveDate bigint ,
	@ExpireDate bigint ,
	@szItem varbinary(16)
AS
BEGIN
	SET NOCOUNT ON;
GO

CREATE PROCEDURE [dbo].[GremoryCase_CheckUseItem]
	@ItemGUID int,
	@AuthCode int
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS (SELECT * FROM GremoryCase WHERE ItemGUID = @ItemGUID AND Serial = @AuthCode)
	BEGIN
		SELECT 1 AS ResultCode
	END
	ELSE
	BEG
GO

CREATE PROCEDURE [dbo].[GremoryCase_DeleteItem]
	@ItemGUID int,
	@AuthCode int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM GremoryCase WHERE ItemGUID = @ItemGUID AND Serial = @AuthCode
END
GO

CREATE PROCEDURE [dbo].[GremoryCase_GetItemList]
	@szAccountID nvarchar(10),
	@szName nvarchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM GremoryCase WHERE AccountID = @szAccountID AND ((Name = @szName AND StorageType = 2) OR StorageType = 1) ORD
GO

CREATE PROCEDURE [dbo].[InsertBuild]
	@Name varchar(10),
	@DtName varchar(16),
	@Strength int,
	@Dexterity int,
	@Vitality int,
	@Energy int,
	@Leadership int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RowCount int;
	SET @RowCount = 0
	SELEC
GO

CREATE PROCEDURE [dbo].[InsertHardwareId]
	@Account varchar(10),
	@HardwareId varchar(45)
AS
BEGIN
	SET NOCOUNT ON;
	--Blocked PCs
	UPDATE MEMB_STAT
	SET Disconnect = 1
	WHERE (SELECT COUNT(*) FROM HardwareIdBlock WHERE hardwareId = @HardwareId 
GO

CREATE PROCEDURE [dbo].[ItemTrackingSave]
@serial bigint,
@action tinyint,
@subaction tinyint,
@itemOld varbinary(16),
@itemNew varbinary(16),
@accOld nvarchar(10),
@accNew nvarchar(10)
AS
BEGIN
	SET NOCOUNT ON;
    INSERT INTO [dbo].[ItemTr
GO

CREATE PROCEDURE [dbo].[LoadBuild]
	@Name varchar(10),
	@BuildName varchar(16)	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [Strength],[Dexterity],[Vitality],[Energy],[Leadership]
	FROM [MuOnline].[dbo].[Builds]
	WHERE [Name] = @Name AND [rebuild_name] =
GO

CREATE Procedure [dbo].[WZ_BanAccount] 
@Account varchar(10),
@BlocCode int
AS
BEGIN
SET NOCOUNT ON
SET	XACT_ABORT ON
DECLARE @Result tinyint
SET @Result = 0
If EXISTS ( SELECT memb___id FROM MEMB_INFO WHERE memb___id = @Account )
	begin
GO

CREATE Procedure [dbo].[WZ_BanCharacter] 
@Name varchar(10),
@CtlCode int
AS
BEGIN
SET NOCOUNT ON
SET	XACT_ABORT ON
DECLARE @Result tinyint
SET @Result = 0
If EXISTS ( SELECT Name FROM Character WHERE Name = @Name )
	begin
		SET @Result	
GO

 /****************************************************************  
TITLE    : ????? BombHuntLog ????  
EX       : EXEC dbo.WZ_BombHuntLogSetSave 'AccountID','test',5  
PROJECT  : MU   
CALL     :   
INPUT    :   
OUTPUT   :   
GO

/****************************************************************  
TITLE    : ?????  Delete  
EX       : EXEC dbo.WZ_BombHuntSetDelete 'AccountID','test',5  
PROJECT  : MU   
CALL     :   
INPUT    :   
OUTPUT   :   
REVERSION: 
GO

/****************************************************************  
TITLE    : ????? BombHunt ????  
EX       : EXEC dbo.WZ_BombHuntSetSave 'AccountID','test',0, 0, '0003'  
PROJECT  : MU   
CALL     :   
INPUT    :   
OUTPUT   :   
GO

/****************************************************************  
TITLE    : ????? BombHunt Select  
EX       : EXEC dbo.WZ_BombHuntSetSelect 'AccountID','test'  
PROJECT  : MU   
CALL     :   
INPUT    :   
OUTPUT   :   
REVER
GO

--
-- Definition for stored procedure WZ_CONNECT_MEMB : 
--
CREATE PROCEDURE [dbo].[WZ_CONNECT_MEMB]
@memb___id varchar(10),
@ServerName  varchar(50),
@IP varchar(20)	
 AS
Begin	
set nocount on
	Declare  @find_id varchar(10)	
	Declare  @Connec
GO

CREATE Procedure [dbo].[WZ_CreateCharacter] 
	@AccountID		varchar(10),		--// °èÁ¤ Á¤º¸ 
	@Name			varchar(10),		--// Ä³¸¯ÅÍ 
	@Class			tinyint			--// Class Type
AS
Begin
	SET NOCOUNT ON
	SET	XACT_ABORT ON
	DECLARE		@Result		tinyint
	--//  °á°ú°
GO

CREATE PROCEDURE [dbo].[WZ_CreateCharacter_GetVersion]
AS
BEGIN
	SELECT 1
End
GO

--
-- Definition for stored procedure WZ_CS_CheckSiegeGuildList : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ???????? ??? ????.
--// ??	: MuStudio 
--// ???	: 2005.0
GO

--
-- Definition for stored procedure WZ_CS_GetAllGuildMarkRegInfo : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ??? ??? ???? ??? ????.
--// ??	: ????
GO

--
-- Definition for stored procedure WZ_CS_GetCalcRegGuildList : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ?? ???? ?? ??? ???? ???? ???? ?????. (?? 
GO

--
-- Definition for stored procedure WZ_CS_GetCastleMoneySts : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ??? ?? ????? ????.
--// ??	: ???? 1? 
--/
GO

--
-- Definition for stored procedure WZ_CS_GetCastleMoneyStsRange : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ??? ?? ????? ????.
--// ??	: ???? 1? 
GO

--
-- Definition for stored procedure WZ_CS_GetCastleNpcInfo : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ??? NPC ??? ????.
--// ??	: ???? 1? 
--// 
GO

--
-- Definition for stored procedure WZ_CS_GetCastleTaxInfo : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ????? ????.
--// ??	: ???? 1? 
--// ???	: 200
GO

--
-- Definition for stored procedure WZ_CS_GetCastleTotalInfo : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ????? ????.
--// ??	: ???? 1? 
--// ???	: 2
GO

--
-- Definition for stored procedure WZ_CS_GetCsGuildUnionInfo : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ??? ????? ???? ????.
--// ??	: ???? 1? 
--// ???	: 20
GO

--
-- Definition for stored procedure WZ_CS_GetGuildMarkRegInfo : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ??? ??? ???? ??? ????.
--// ??	: ???? 1?
GO

--
-- Definition for stored procedure WZ_CS_GetOwnerGuildMaster : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ??? ??? ????? ??? ????.
--// ??	: ???? 1? 
GO

--
-- Definition for stored procedure WZ_CS_GetSiegeGuildInfo : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ???? ???? ??? ????.
--// ??	: ???? 1? 
--
GO

CREATE PROCEDURE	[dbo].[WZ_CS_ModifyCastleOwnerInfo]
	@iMapSvrGroup		SMALLINT,
	@iCastleOccupied	INT,
	@szOwnGuildName	VARCHAR(8)
As
Begin
	BEGIN TRANSACTION
	SET NOCOUNT ON
	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCastle_DATA  WITH (READUNC
GO

--
-- Definition for stored procedure WZ_CS_ModifyCastleSchedule : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ????? (????, ????) ? ????.
--// ??	: ???? 
GO

--
-- Definition for stored procedure WZ_CS_ModifyGuildGiveUp : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ??? ????? ?? ??? ????.
--// ??	: ???? 1? 
GO

--
-- Definition for stored procedure WZ_CS_ModifyGuildMarkRegCount : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ??? ???? ????? ????.
--// ??	: ???? 
GO

--
-- Definition for stored procedure WZ_CS_ModifyGuildMarkReset : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ??? ???? ????? ??? ??.
--// ??	: ???? 1
GO

--
-- Definition for stored procedure WZ_CS_ModifyMoney : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ? ??? ????.
--// ??	: ???? 1? 
--// ???	: 2004.11.
GO

--
-- Definition for stored procedure WZ_CS_ModifySiegeEnd : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ?? ??? ????.
--// ??	: ???? 1? 
--// ???	: 2
GO

--
-- Definition for stored procedure WZ_CS_ModifyTaxRate : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ??? ????.
--// ??	: ???? 1? 
--// ???	: 2004.11.
GO

--
-- Definition for stored procedure WZ_CS_ReqNpcBuy : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ??? NPC? ????. (NPC ??? ????.)
--// ??	: ???? 1? 
--
GO

--
-- Definition for stored procedure WZ_CS_ReqNpcRemove : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ??? NPC? ????.
--// ??	: ???? 1? 
--// ???	: 2004
GO

--
-- Definition for stored procedure WZ_CS_ReqNpcRepair : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ??? NPC? ????.
--// ??	: ???? 1? 
--// ???	: 2004
GO

--
-- Definition for stored procedure WZ_CS_ReqNpcUpdate : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ??? NPC ??? ???? -> NPC ??? ??? ????.
--// ??	: ??
GO

--
-- Definition for stored procedure WZ_CS_ReqNpcUpgrade : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ??? NPC? ????? ??.
--// ??	: ???? 1? 
--// ???	:
GO

--
-- Definition for stored procedure WZ_CS_ReqRegAttackGuild : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ???? ??? ??? ??? ??.
--// ??	: ???? 1? 
--//
GO

--
-- Definition for stored procedure WZ_CS_ReqRegGuildMark : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ???? ??? ??? ????.
--// ??	: ???? 1? 
--// ???
GO

--
-- Definition for stored procedure WZ_CS_ResetCastleSiege : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ????? ????? (?? ??? ??? ?)
--// ??	: ???? 1? 
GO

--
-- Definition for stored procedure WZ_CS_ResetCastleTaxInfo : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ??? ??? ??.
--// ??	: ???? 1? 
--// ???	
GO

--
-- Definition for stored procedure WZ_CS_ResetRegSiegeInfo : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ???? ?? ???? ??? ??.
--// ??	: ???? 1? 
-
GO

--
-- Definition for stored procedure WZ_CS_ResetSiegeGuildInfo : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ???? ???? ??? ??.
--// ??	: ???? 1? 
--
GO

CREATE Procedure [dbo].[WZ_CS_SetSiegeGuildInfo]
	@iMapSvrGroup		SMALLINT,
	@szGuildName		VARCHAR(8),
	@iGuildID		INT,
	@iGuildInvolved		INT,
	@iCsGuildScore	INT
AS
BEGIN
	BEGIN TRANSACTION
	SET NOCOUNT ON
	INSERT INTO MuCastle_SIEGE_GUILD
GO

--
-- Definition for stored procedure WZ_CS_SetSiegeGuildOK : 
--
--//************************************************************************
--// << ? ??? - ?? ???? >>
--// 
--// ??	: ?? ? (????) ? ?? ???? ???? ??? ????? ????? ??? ??.
--// ??	: 
GO

CREATE Procedure [dbo].[WZ_CustomArenaRanking] 
@Account varchar(10),
@Name varchar(10),
@ArenaNumber int,
@UserScore int,
@UserRank int
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
IF(@ArenaNumber = 0)
BEGIN
IF(@UserRank = 1)
BEGIN
UPDA
GO

CREATE Procedure [dbo].[WZ_CustomMonsterReward] 
@Account varchar(10),
@Name varchar(10),
@MonsterClass int,
@MapNumber int,
@RewardValue1 int,
@RewardValue2 int,
@RewardValue3 int,
@Damage int
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
INS
GO

CREATE PROCEDURE [dbo].[WZ_CW_InfoLoad]
@MapServerGroup int
AS
Begin
set nocount on
SELECT CRYWOLF_OCCUFY, CRYWOLF_STATE FROM WZ_CW_INFO
WHERE MAP_SVR_GROUP=@MapServerGroup
end
GO

CREATE PROCEDURE [dbo].[WZ_CW_InfoSave]
@iMapServerGroup int,
@iState int,
@iOccupy int
AS
Begin
set nocount on
UPDATE WZ_CW_INFO
SET CRYWOLF_OCCUFY=@iOccupy, CRYWOLF_STATE=@iState
WHERE MAP_SVR_GROUP=@iMapServerGroup
end
GO

CREATE Procedure [dbo].[WZ_DeleteCharacter] 
@Account varchar(10),
@Name varchar(10)
AS
BEGIN
SET NOCOUNT ON
SET	XACT_ABORT ON
DECLARE @Result tinyint
SET @Result = 0
If NOT EXISTS ( SELECT  Name  FROM  Character WHERE Name = @Name )
	beg
GO

--
-- Definition for stored procedure WZ_DelMail : 
--
CREATE procedure [dbo].[WZ_DelMail]
	@Name varchar(10),  @MemoIndex int
as 
BEGIN
	DECLARE @ErrorCode int
	DECLARE @UserGuid  int
	SET	XACT_ABORT ON
	Set	nocount on 	
	SET @ErrorCode
GO

--
-- Definition for stored procedure WZ_DISCONNECT_MEMB : 
--
CREATE PROCEDURE [dbo].[WZ_DISCONNECT_MEMB]
@memb___id varchar(10)
 AS
Begin	
set nocount on
	Declare  @find_id varchar(10)	
	Declare @ConnectStat tinyint
	Set @ConnectStat = 0		-- 
GO

--
-- Definition for stored procedure WZ_FriendAdd : 
--
-- ?? ??? ????.
/* ?? : 
 1 : ??
 2 : ?? ?? ???? ???? ??
 3 : ??  GUID? ???? ???.
 4 : ?? GUID? ??? ????.
 5 : ??? GUID? ???? ???.
 6 : ??? GUID? ??? ????.
*/
CREATE procedure [dbo].[WZ
GO

--
-- Definition for stored procedure WZ_FriendDel : 
--
-- ??? ???? ????.
CREATE procedure [dbo].[WZ_FriendDel]
	@Name varchar(10),  @FriendName varchar(10)
as 
BEGIN
	DECLARE @ErrorCode int
	DECLARE @UserGuid  int
	DECLARE @FriendGuid  in
GO

CREATE procedure [dbo].[WZ_Get_DBID]
as
/*begin
select * from WZ_CreateCharacter_Version
end*/
BEGIN
	SELECT 1 as Version
End
GO

CREATE Procedure [dbo].[WZ_GetAccountLevel] 
@Account varchar(10)
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
SELECT AccountLevel As AccountLevel,AccountExpireDate As AccountExpireDate FROM MEMB_INFO WHERE memb___id=@Account
SET NOCOUNT OFF
SET
GO

CREATE PROCEDURE [dbo].[WZ_GetCharacterGensInfo]
@Name varchar(10),
@Family int
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
	IF ( @Family = 1 )
		BEGIN
			SELECT Rank, Contribution FROM Gens_Duprian WHERE Name = @Name
		END
	ELSE
		BEGIN
GO

CREATE Procedure [dbo].[WZ_GetEventEntryInfo]
@Account varchar(10),
@Name varchar(10)
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
DECLARE @BCCount int
DECLARE @CCCount int
DECLARE @DSCount int
DECLARE @DGCount int
DECLARE @ITCount int
DECLARE
GO

--
-- Definition for stored procedure WZ_GetItemSerial : 
--
CREATE procedure [dbo].[WZ_GetItemSerial]
as
BEGIN	
	DECLARE @ItemSerial	bigint
	set nocount on
	begin transaction
		update GameServerInfo set @ItemSerial = ItemCount = ItemCount+1
GO

/****************************************************************
TITLE    : ?? ?? ??? DB ???? ?? ????
EX       : EXEC dbo.WZ_GetLoadRestoreItemInventory 'AccountID','test'
PROJECT  : MU 
CALL     : 
INPUT    : 
OUTPUT   : 
REVERSION:
---
GO

CREATE Procedure [dbo].[WZ_GetMasterResetInfo]
@Account varchar(10),
@Name varchar(10)
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
DECLARE @MasterReset int
DECLARE @MasterResetDay int
DECLARE @MasterResetWek int
DECLARE @MasterResetMon int
S
GO

CREATE Procedure [dbo].[WZ_GetResetInfo]
@Account varchar(10),
@Name varchar(10)
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
DECLARE @Reset int
DECLARE @ResetDay int
DECLARE @ResetWek int
DECLARE @ResetMon int
SELECT @Reset=ResetCount,@Reset
GO

--
-- Definition for stored procedure WZ_GuildCreate : 
--
CREATE procedure [dbo].[WZ_GuildCreate]
	@GuildName	varchar(8),
	@MasterName 	varchar(10)
as 
BEGIN
	DECLARE @ErrorCode int
	SET @ErrorCode = 0
	SET XACT_ABORT ON
	Set		nocount on 
GO

CREATE PROCEDURE [dbo].[WZ_HuntingRecordDelete]
	@szAccountID varchar(10),
	@szName nchar(10),
	@iMapIndex smallint,
	@iYear smallint,
	@btMonth smallint,
	@btDay smallint
AS
BEGIN
	SET NOCOUNT ON;
        DELETE FROM HuntingRecordLog WHERE
GO

CREATE PROCEDURE [dbo].[WZ_HuntingRecordInfoSave]
	@szID varchar(10),	@szName varchar(10),	@iMapIndex tinyint,	@iYear int,	@iMonth int,	@iDay int,
	@iUserLevel smallint,	@iHuntingTime int,	@iDealDamage bigint,	@iDealElementalDamage bigint,	@iHealAmount
GO

CREATE PROCEDURE [dbo].[WZ_HuntingRecordInfoUserOpenLoad]
	@szId varchar (10),
	@szName varchar (10)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT HuntingUserOpen FROM Character WHERE AccountID=@szId AND Name=@szName
END
GO

CREATE PROCEDURE [dbo].[WZ_HuntingRecordInfoUserOpenSave]
	@szId varchar (10),
	@szName varchar (10),
	@btOpen int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Character SET HuntingUserOpen=@btOpen WHERE AccountID=@szId AND Name=@szName	
END
GO

CREATE PROCEDURE [dbo].[WZ_HuntingRecordLoad] 
	@szId varchar (10),
	@szName varchar (10),
	@iMapIndex int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT MapIndex,mYear,mMonth, mDay,
	CurrentLevel,HuntingAccrueSecond,NormalAccrueDamage,PentagramAccrueDamage,H
GO

CREATE PROCEDURE [dbo].[WZ_HuntingRecordLoad_Current]
	@szID varchar(10),	@szName varchar(10),	@iMapIndex tinyint,	@iYear int,	@iMonth int,	@iDay int	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT MapIndex,mYear,mMonth,mDay,	CurrentLevel,HuntingAccrueSecond,Nor
GO

/**dbo.WZ_Labyrinth_End_Update		*******************************************
TITLE	 : ????? ?? ?? ??
Project  : ?
CALL     : ?? 
DATABASE : MuOnline
TABLES   : T_LabyrinthInfo
EX       :
exec 
Result   :
REVERSION
---------------------------
GO

/**dbo.WZ_Labyrinth_Info_Load	***********************************************
TITLE	 : ????? ?? ?? ??
Project  : ?
CALL     : ?? 
DATABASE : MuOnline
TABLES   : T_LabyrinthInfo
EX       :
exec 
Result   :
REVERSION
-------------------------
GO

/**dbo.WZ_Labyrinth_Info_Save	***********************************************
TITLE	 : ????? ?? ?? ??
Project  : ?
CALL     : ?? 
DATABASE : MuOnline
TABLES   : T_LabyrinthInfo
EX       :
exec 
Result   :
REVERSION
-------------------------
GO

/**dbo.WZ_Labyrinth_Info_Update	***********************************************
TITLE	 : ????? ?? ??
Project  : ?
CALL     : ?? 
DATABASE : MuOnline
TABLES   : T_LabyrinthInfo
EX       :
exec 
Result   :
REVERSION
--------------------------
GO

/**dbo.WZ_Labyrinth_Mission_Delete	***********************************************
TITLE	 : ????? ?? ?? ??
Project  : ?
CALL     : ?? 
DATABASE : MuOnline
TABLES   : T_LabyrinthMissionInfo
EX       :
exec 
Result   :
REVERSION
-------------
GO

/**dbo.WZ_Labyrinth_Info_Save	***********************************************
TITLE	 : ????? ?? ?? ??(?? ?? ? ??)
Project  : ?
CALL     : ?? 
DATABASE : MuOnline
TABLES   : T_LabyrinthMissionInfo
EX       :
exec 
Result   :
REVERSION
------
GO

/**dbo.WZ_Labyrinth_Mission_Load	***********************************************
TITLE	 : ????? ?? ?? ??
Project  : ?
CALL     : ?? 
DATABASE : MuOnline
TABLES   : T_LabyrinthMissionInfo
EX       :
exec 
Result   :
REVERSION
---------------
GO

/**dbo.WZ_Labyrinth_Mission_Update	*******************************************
TITLE	 : ????? ?? ?? ??
Project  : ?
CALL     : ?? 
DATABASE : MuOnline
TABLES   : T_LabyrinthMissionInfo
EX       :
exec 
Result   :
REVERSION
-----------------
GO

/**dbo.WZ_Labyrinth_Path_Load	***********************************************
TITLE	 : ????? ?? ?? ??(?? ???)
Project  : ?
CALL     : ?? 
DATABASE : MuOnline
TABLES   : T_LabyrinthInfo
EX       :
exec 
Result   :
REVERSION
-----------------
GO

/**dbo.WZ_Labyrinth_Reward_Complete_Update	***********************************
TITLE	 : ????? ?? ?? ?? ?? ??
Project  : ?
CALL     : ?? 
DATABASE : MuOnline
TABLES   : T_LabyrinthMissionInfo
EX       :
exec 
Result   :
REVERSION
-----------
GO

/**dbo.WZ_Labyrinth_Reward_Update	*******************************************
TITLE	 : ????? ?? ?? ??
Project  : ?
CALL     : ?? 
DATABASE : MuOnline
TABLES   : T_LabyrinthMissionInfo
EX       :
exec 
Result   :
REVERSION
------------------
GO

/****************************************************************    
TITLE    : ??? ?? ?? ??? ? ?? ?? ?? (??? ???)
EX       : EXEC dbo.WZ_LabyrinthClearLogSetSave 'AccountID','test', 5
PROJECT  : MU     
CALL     :     
INPUT    :  
GO

CREATE Procedure [dbo].[WZ_RenameCharacter] 
@Account varchar(10),
@OldName varchar(10),
@NewName varchar(10)
AS
BEGIN
SET NOCOUNT ON
SET	XACT_ABORT ON
DECLARE @Result tinyint
SET @Result = 1
If EXISTS ( SELECT  Name  FROM  Character WHER
GO

CREATE Procedure [dbo].[WZ_SetAccountLevel] 
@Account varchar(10),
@AccountLevel int,
@AccountExpireTime int
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
DECLARE @CurrentAccountLevel int
DECLARE @CurrentAccountExpireDate smalldatetime
SELECT @
GO

CREATE Procedure [dbo].[WZ_SetEventEntryInfo]
@Account varchar(10),
@Name varchar(10),
@BCCount int,
@CCCount int,
@DSCount int,
@DGCount int,
@ITCount int,
@IGCount int
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
IF NOT EXISTS ( SELECT * FR
GO

--
-- Definition for stored procedure WZ_SetGuildDelete : 
--
CREATE PROCEDURE  [dbo].[WZ_SetGuildDelete]
	@GuildName		varchar(10)
As
Begin
	SET NOCOUNT ON
	Declare		@Result		int
	Set @Result	= 1 
	Begin Transaction									
		--// Guild mem
GO

CREATE Procedure [dbo].[WZ_SetMasterResetInfo] 
@Account varchar(10),
@Name varchar(10),
@Reset int,
@MasterReset int,
@MasterResetDay int,
@MasterResetWek int,
@MasterResetMon int
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
UPDATE Character 
GO

CREATE Procedure [dbo].[WZ_SetPkInfo] 
@Account varchar(10),
@Name varchar(10)
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
UPDATE Character SET PKRankCount=PKRankCount+1,PKCountDay=PKCountDay+1,PKCountWek=PKCountWek+1 WHERE AccountID=@Account AND 
GO

CREATE Procedure [dbo].[WZ_SetResetInfo] 
@Account varchar(10),
@Name varchar(10),
@Reset int,
@ResetDay int,
@ResetWek int,
@ResetMon int
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON
UPDATE Character SET ResetCount=@Reset,ResetDay=@ResetDay,Re
GO

/****************************************************************
TITLE    :?? ?? ??? DB ??? ????
EX       : EXEC dbo.WZ_SetSaveRestoreInventory 'AccountID','test',0xFFFFFFF
PROJECT  : MU 
CALL     : 
INPUT    : 
OUTPUT   : 
REVERSION:
--
GO

--
-- Definition for stored procedure WZ_UserGuidCreate : 
--
/*
-- ??? ?? GUID? ???? ???? GUID? ????.
*/
CREATE procedure [dbo].[WZ_UserGuidCreate]
	@Name varchar(10)
as 
BEGIN
	DECLARE @ErrorCode int
	DECLARE @UserGuid  int
	SET @ErrorC
GO

--
-- Definition for stored procedure WZ_WaitFriendAdd : 
--
/*  ?? ?? ??? ??? ????.
-- Name :?? ?? 
-- FriendName : ?? ??
return : 
	0 : ??,
 	2 : ?? GUID ?? ??
       	3 : ?? GUID ?? ??
	4 : ?? ?? ??
	5 : ?? ?? ??
	6 : ?? ??? 6 ???
-- 
GO

--
-- Definition for stored procedure WZ_WaitFriendDel : 
--
-- ??? ???? ????.
CREATE procedure [dbo].[WZ_WaitFriendDel]
	@Name varchar(10),  @FriendName varchar(10)
as
BEGIN
	DECLARE @ErrorCode int
	DECLARE @UserGuid  int
	DECLARE @FriendGui
GO

--
-- Definition for stored procedure WZ_WriteMail : 
--
-- ??? ????.
/*
 return 
 2 : ?? ???? GUID? ???? ???.
 3 : ?? ???? ?? ???? ???? ? ? ??.
 4 : ??? ????? ????
 5 : ??? ?? ??? ?????.
 6 : ??? ?? 6 ???
 10 ?? : ??
*/
CREATE procedure 
GO

CREATE PROCEDURE [dbo].[Z_BackSpringDetails]
	@Author varchar(10),
	@Victim varchar(10),
	@Situation int
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [dbo].[BackSpringDetails] ([author],[victim],[situation])
     VALUES (@Author,@Victim,@Situati
GO

-- =============================================
-- Author:		Léo Ferrarezi
-- Create date: 18 10 2016
-- Description:	Load castle siege ranking data
-- =============================================
CREATE PROCEDURE [dbo].[Z_CS_RankingLoad]
	@Name
GO

-- =============================================
-- Author:		Léo Ferrarezi
-- Create date: 25 01 2017
-- Description:	Save castle siege ranking data (version 2)
-- =============================================
CREATE PROCEDURE [dbo].[Z_CS_RankingSav
GO

CREATE PROCEDURE [dbo].[Z_PKDetails]
	@Killer varchar(10),
	@Victim varchar(10),
	@Map int,
	@X int,
	@Y int,
	@Helpers int
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [dbo].[PKDetails] ([killer],[victim],[map],[x],[y],[helpers])
     VALUES (
GO




-- =============================================
-- Views
-- =============================================

CREATE VIEW [dbo].[Gens_Duprian]
AS
SELECT TOP (100) PERCENT Row_Number() OVER (ORDER BY Contribution DESC, Name ASC) AS Rank, Name, Family, Contribution
FROM         dbo.Gens_Rank
WHERE     (Family = '1')
ORDER BY Contribution DESC, Name ASC
GO

CREATE VIEW [dbo].[Gens_Varnert]
AS
SELECT TOP (100) PERCENT Row_Number() OVER (ORDER BY Contribution DESC, Name ASC) AS Rank, Name, Family, Contribution
FROM         dbo.Gens_Rank
WHERE     (Family = '2')
ORDER BY Contribution DESC, Name ASC
GO

-- =============================================
-- Functions
-- =============================================

--
-- Definition for user-defined function UFN_MD5_CHECKVALUE : 
--
/****** ??:  ??????? dbo.UFN_MD5_CHECKVALUE    ????: 2006-11-8 21:18:35 ******/
-- ??? : UFN_MD5_ENCODEVALUE()
-- ?? : ?????? ???? MD5 ?? ???? ??? ??
CREATE FUNCTION [dbo].[UFN_M
GO

--
-- Definition for user-defined function UFN_MD5_ENCODEVALUE : 
--
/****** ??:  ??????? dbo.UFN_MD5_ENCODEVALUE    ????: 2006-11-8 21:18:35 ******/
-- ??? : UFN_MD5_ENCODEVALUE()
-- ?? : ?????? ???? ???? MD5 ?? ??
CREATE FUNCTION [dbo].[UFN_MD5
GO



