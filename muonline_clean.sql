-- =============================================
-- MuOnline Season 13 - Clean Database Script
-- Mantém: Schema + Dados padrão (DefaultClassType, etc)
-- Remove: Contas, personagens, guilds, itens, etc
-- =============================================
SET NOCOUNT ON
SET XACT_ABORT ON

PRINT '=== Limpando dados de jogadores ==='

-- Contas e personagens
DELETE FROM Character
DELETE FROM AccountCharacter
DELETE FROM MasterSkillTree
DELETE FROM MasterSkillTree_4th
DELETE FROM MEMB_INFO WHERE memb___id NOT IN ('alanj','test')
DELETE FROM MEMB_STAT

-- Itens e inventários
DELETE FROM warehouse
DELETE FROM ExtWarehouse
DELETE FROM CashShopInventory
DELETE FROM CashShopPeriodicItem
DELETE FROM EventInventory
DELETE FROM MuunInventory
DELETE FROM PentagramJewel
DELETE FROM PeriodicItem
DELETE FROM T_PetItem_Info
DELETE FROM T_RestoreItem_Inventory
DELETE FROM GremoryCase

-- Guilds
DELETE FROM Guild
DELETE FROM GuildMember

-- Friends
DELETE FROM T_FriendMain
DELETE FROM T_FriendList
DELETE FROM T_FriendMail
DELETE FROM T_WaitFriend
DELETE FROM T_CGuid

-- Events
DELETE FROM EventEntryCount
DELETE FROM EventGoldenArcher
DELETE FROM EventLeoTheHelper
DELETE FROM EventSantaClaus
DELETE FROM EventsCounter
DELETE FROM LuckyCoin
DELETE FROM LuckyItem
DELETE FROM MuRummyCard
DELETE FROM MuRummyData
DELETE FROM T_BombHunt
DELETE FROM T_BombHuntLog

-- Rankings
DELETE FROM RankingBloodCastle
DELETE FROM RankingChaosCastle
DELETE FROM RankingDevilSquare
DELETE FROM RankingDuel
DELETE FROM RankingIllusionTemple

-- Logs
DELETE FROM BossHuntLog
DELETE FROM CashShopDataLog
DELETE FROM CashShopDataLogSource
DELETE FROM HardwareIdLog
DELETE FROM HuntingRecordLog
DELETE FROM ItemTracking
DELETE FROM MonsterKillCount
DELETE FROM PKDetails
DELETE FROM RuudLog
DELETE FROM T_LabyrinthClearLog

-- Castle Siege
DELETE FROM MuCastle_DATA
DELETE FROM MuCastle_MONEY_STATISTICS
DELETE FROM MuCastle_NPC
DELETE FROM MuCastle_REG_SIEGE
DELETE FROM MuCastle_SIEGE_GUILDLIST
DELETE FROM Z_SiegeAccTime
DELETE FROM Z_SiegeRanking
DELETE FROM Z_SiegeRegisterLog
DELETE FROM Z_SiegeStatus
DELETE FROM Z_SiegeWins

-- Outros
DELETE FROM CustomJewelBank
DELETE FROM CustomPick
DELETE FROM DailyRewardData
DELETE FROM FavoriteMoves
DELETE FROM GameServerInfo
DELETE FROM Gens_Rank
DELETE FROM Gens_Reward
DELETE FROM GiftData
DELETE FROM HelperData
DELETE FROM OfflineMode
DELETE FROM OptionData
DELETE FROM ReconnectData
DELETE FROM ResetData
DELETE FROM SNSData
DELETE FROM T_LabyrinthInfo
DELETE FROM T_LabyrinthMissionInfo
DELETE FROM NewQuestWorld
DELETE FROM QuestKillCount
DELETE FROM QuestWorld
DELETE FROM BackSpringDetails
DELETE FROM Builds
DELETE FROM PShopItemValue
DELETE FROM HardwareIdBlock

PRINT '=== Resetando contas padrão ==='

-- Resetar senha das contas existentes para teste
-- (use o account-creator-gui.ps1 para criar novas contas)

PRINT '=== Concluído! ==='
PRINT 'Banco de dados limpo. Schema e dados padrão preservados.'
PRINT 'Contas removidas. Use o Account Creator para criar novas contas.'
