-- --------------------------------------------------------
-- Host:                         142.44.206.173
-- Server version:               8.0.18 - MySQL Community Server - GPL
-- Server OS:                    Linux
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for soegame2
CREATE DATABASE IF NOT EXISTS `soegame2` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `soegame2`;

-- Dumping structure for table soegame2.bankaccounts
CREATE TABLE IF NOT EXISTS `bankaccounts` (
  `AccountNumber` int(11) NOT NULL,
  `AccountType` varchar(45) NOT NULL,
  `Label` varchar(45) NOT NULL DEFAULT 'My New Account',
  `OwnerCharacterID` int(11) NOT NULL,
  `BusinessID` int(11) DEFAULT NULL,
  `DateOpened` date NOT NULL,
  `Balance` int(11) NOT NULL DEFAULT '0',
  `IsFrozen` tinyint(4) NOT NULL DEFAULT '0',
  `IsClosed` tinyint(4) NOT NULL DEFAULT '0',
  `IsPrimary` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`AccountNumber`),
  UNIQUE KEY `AccountNumber_UNIQUE` (`AccountNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.bankcards
CREATE TABLE IF NOT EXISTS `bankcards` (
  `CardID` int(11) NOT NULL AUTO_INCREMENT,
  `CardHolderCharacterID` int(11) NOT NULL,
  `AccountNumber` int(11) NOT NULL,
  `CurrentCardNumber` bigint(8) DEFAULT NULL,
  `PinNumber` int(11) NOT NULL,
  PRIMARY KEY (`CardID`),
  UNIQUE KEY `CurrentCardNumber_UNIQUE` (`CurrentCardNumber`),
  KEY `CardID_idx` (`CardID`),
  KEY `CardHolderCharacterID_idx` (`CardHolderCharacterID`),
  KEY `AccountNumber_idx` (`AccountNumber`),
  KEY `CurrentCardNumber_idx` (`CurrentCardNumber`),
  KEY `PinNumber_idx` (`PinNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=1868 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.bankpermissions
CREATE TABLE IF NOT EXISTS `bankpermissions` (
  `PermissionID` int(11) NOT NULL AUTO_INCREMENT,
  `CharacterID` int(11) NOT NULL,
  `AccountNumber` int(11) NOT NULL,
  `Deposit` tinyint(4) DEFAULT '0',
  `Withdraw` tinyint(4) DEFAULT '0',
  `Transfer` tinyint(4) DEFAULT '0',
  `Manage` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`PermissionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.banktransactions
CREATE TABLE IF NOT EXISTS `banktransactions` (
  `TransactionID` int(11) NOT NULL AUTO_INCREMENT,
  `SenderAccountNumber` int(11) NOT NULL,
  `RecipientAccountNumber` int(11) NOT NULL,
  `CardNumber` bigint(8) DEFAULT NULL,
  `Amount` int(11) NOT NULL,
  `Type` varchar(45) NOT NULL,
  `Timestamp` datetime NOT NULL,
  `Title` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`TransactionID`),
  KEY `TransactionID_idx` (`TransactionID`),
  KEY `SenderAccountNumber_idx` (`SenderAccountNumber`),
  KEY `RecipientAccountNumber_idx` (`RecipientAccountNumber`),
  KEY `CardNumber_idx` (`CardNumber`),
  KEY `Amount_idx` (`Amount`),
  KEY `Type_idx` (`Type`),
  KEY `Timestamp_idx` (`Timestamp`),
  KEY `Title_idx` (`Title`)
) ENGINE=InnoDB AUTO_INCREMENT=212962 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `BanID` int(11) NOT NULL AUTO_INCREMENT,
  `BanExpiry` datetime NOT NULL DEFAULT '2099-12-31 23:59:59',
  `BanLifted` tinyint(1) NOT NULL DEFAULT '0',
  `BannedBy` varchar(255) NOT NULL DEFAULT 'SYSTEM',
  `BanReason` varchar(256) NOT NULL DEFAULT 'You are banned from SoE',
  `BannedTime` datetime NOT NULL,
  `Username` varchar(64) DEFAULT NULL,
  `SteamID` varchar(64) DEFAULT NULL,
  `DiscordID` varchar(64) DEFAULT NULL,
  `LiveID` varchar(64) DEFAULT NULL,
  `XboxID` varchar(64) DEFAULT NULL,
  `LicenseHash` varchar(64) DEFAULT NULL,
  `IP` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`BanID`)
) ENGINE=InnoDB AUTO_INCREMENT=2118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.bills
CREATE TABLE IF NOT EXISTS `bills` (
  `BillID` int(11) NOT NULL AUTO_INCREMENT,
  `BillCharID` int(11) NOT NULL,
  `BillAmt` int(11) DEFAULT NULL,
  `BillDue` datetime DEFAULT NULL,
  `BillNote` varchar(256) DEFAULT NULL,
  `BillPaid` tinyint(4) DEFAULT '0',
  `BillType` varchar(32) DEFAULT NULL,
  `BillData` varchar(32) DEFAULT NULL,
  `BillData2` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`BillID`),
  KEY `BillCharID_idx` (`BillCharID`),
  KEY `BillAmt_idx` (`BillAmt`),
  KEY `BillDue_idx` (`BillDue`),
  KEY `BillNote_idx` (`BillNote`),
  KEY `BillPaid_idx` (`BillPaid`),
  KEY `BillType_idx` (`BillType`),
  KEY `BillID_idx` (`BillID`),
  KEY `BillData_idx` (`BillData`)
) ENGINE=InnoDB AUTO_INCREMENT=4963 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.bleeteraccounts
CREATE TABLE IF NOT EXISTS `bleeteraccounts` (
  `AccountID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Password` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `DisplayName` longtext,
  `OwnerCharID` int(11) NOT NULL,
  `CreatedDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=1769 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.bleetermessages
CREATE TABLE IF NOT EXISTS `bleetermessages` (
  `MessageID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) NOT NULL,
  `Content` longtext NOT NULL,
  `CharID` int(11) NOT NULL,
  `DateTime` datetime NOT NULL,
  PRIMARY KEY (`MessageID`) USING BTREE,
  KEY `MessageID_idx` (`MessageID`),
  KEY `AccountID_idx` (`AccountID`),
  KEY `CharID_idx` (`CharID`),
  KEY `DateTime_idx` (`DateTime`)
) ENGINE=InnoDB AUTO_INCREMENT=45771 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.callsigns
CREATE TABLE IF NOT EXISTS `callsigns` (
  `CharID` int(15) NOT NULL,
  `Callsign` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`CharID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `CharID` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) NOT NULL,
  `FirstGiven` varchar(45) NOT NULL,
  `LastGiven` varchar(45) NOT NULL,
  `DOB` date DEFAULT '1970-01-01',
  `Gender` varchar(16) NOT NULL DEFAULT 'Male',
  `Appearance` json NOT NULL,
  `Gamestate` json NOT NULL,
  `PrisonTime` int(11) NOT NULL DEFAULT '0',
  `StateDebt` int(11) NOT NULL DEFAULT '0',
  `CivType` varchar(16) NOT NULL DEFAULT 'CIV',
  `Employer` varchar(64) DEFAULT NULL,
  `JobTitle` varchar(64) DEFAULT NULL,
  `Settings` json NOT NULL,
  `Playtime` int(11) NOT NULL DEFAULT '0',
  `Permissions` json DEFAULT NULL,
  `FirstSeen` datetime DEFAULT NULL,
  `LastSeen` datetime DEFAULT NULL,
  PRIMARY KEY (`CharID`),
  KEY `CharID_idx` (`CharID`),
  KEY `UserID_idx` (`UserID`),
  KEY `FirstGiven_idx` (`FirstGiven`),
  KEY `LastGiven_idx` (`LastGiven`),
  KEY `DOB_idx` (`DOB`),
  KEY `Gender_idx` (`Gender`),
  KEY `PrisonTime_idx` (`PrisonTime`),
  KEY `StateDebt_idx` (`StateDebt`),
  KEY `CivType_idx` (`CivType`),
  KEY `Employer_idx` (`Employer`),
  KEY `JobTitle_idx` (`JobTitle`),
  KEY `Playtime_idx` (`Playtime`),
  KEY `FirstSeen_idx` (`FirstSeen`),
  KEY `LastSeen_idx` (`LastSeen`)
) ENGINE=InnoDB AUTO_INCREMENT=2439 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.cocapps
CREATE TABLE IF NOT EXISTS `cocapps` (
  `ApplicationID` int(11) NOT NULL AUTO_INCREMENT,
  `OwnerName` varchar(64) DEFAULT NULL,
  `OwnerSSN` int(11) DEFAULT NULL,
  `Owner2Name` varchar(64) DEFAULT NULL,
  `Owner2SSN` int(11) DEFAULT NULL,
  `BusinessName` varchar(128) DEFAULT NULL,
  `BusinessType` varchar(32) DEFAULT NULL,
  `BusinessLocation` varchar(128) DEFAULT NULL,
  `BusinessImage` varchar(1028) DEFAULT NULL,
  `BusinessDescription` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `BusinessVision` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ApplicationStatus` varchar(32) DEFAULT 'Pending',
  `PhoneNumber` varchar(12) DEFAULT NULL,
  `Email` varchar(64) DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL,
  `RejectionReason` longtext,
  `StatusChangedTimestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`ApplicationID`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.courtrecords
CREATE TABLE IF NOT EXISTS `courtrecords` (
  `RecordID` int(11) NOT NULL AUTO_INCREMENT,
  `CharID` int(11) DEFAULT NULL,
  `Type` varchar(15) DEFAULT NULL,
  `RecordData` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'No Data Found',
  `IssuedBy` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Data Not Found',
  `ShowOnRecord` tinyint(4) NOT NULL DEFAULT '1',
  `Timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`RecordID`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.electioncandidates
CREATE TABLE IF NOT EXISTS `electioncandidates` (
  `CandidateID` int(11) NOT NULL AUTO_INCREMENT,
  `ElectionID` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL DEFAULT '',
  `Organisation` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`CandidateID`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.elections
CREATE TABLE IF NOT EXISTS `elections` (
  `ElectionID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `VotingOpen` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ElectionID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.electionvotes
CREATE TABLE IF NOT EXISTS `electionvotes` (
  `VoteID` int(11) NOT NULL AUTO_INCREMENT,
  `ElectionID` int(11) NOT NULL,
  `CandidateID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `CharID` int(11) NOT NULL,
  `DateTime` datetime NOT NULL,
  PRIMARY KEY (`VoteID`)
) ENGINE=InnoDB AUTO_INCREMENT=474 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.emailaccounts
CREATE TABLE IF NOT EXISTS `emailaccounts` (
  `AccountID` int(11) NOT NULL AUTO_INCREMENT,
  `Email` longtext,
  `Password` longtext,
  `OwnerCharID` int(11) DEFAULT NULL,
  `CreatedDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=657 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.emailmessages
CREATE TABLE IF NOT EXISTS `emailmessages` (
  `EmailID` int(11) NOT NULL AUTO_INCREMENT,
  `EmailFrom` longtext NOT NULL,
  `EmailTo` longtext NOT NULL,
  `Content` longtext NOT NULL,
  `CharID` int(11) NOT NULL,
  `SentDateTime` datetime NOT NULL,
  PRIMARY KEY (`EmailID`)
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.factionrosters
CREATE TABLE IF NOT EXISTS `factionrosters` (
  `EntryID` int(11) NOT NULL AUTO_INCREMENT,
  `FactionID` int(11) NOT NULL DEFAULT '0',
  `CharID` int(11) NOT NULL DEFAULT '0',
  `Title` varchar(32) NOT NULL DEFAULT 'Member',
  `Name` varchar(32) NOT NULL DEFAULT 'Unknown',
  `Role` varchar(16) NOT NULL DEFAULT 'member',
  `Permissions` json DEFAULT NULL,
  `Rate` int(4) DEFAULT '0',
  PRIMARY KEY (`EntryID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=808 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.factions
CREATE TABLE IF NOT EXISTS `factions` (
  `FactionID` int(11) NOT NULL AUTO_INCREMENT,
  `FactionName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'No Name',
  `FactionType` varchar(16) NOT NULL DEFAULT 'business',
  `FactionSubtype` varchar(30) NOT NULL DEFAULT 'repair',
  `FactionLeader` int(11) NOT NULL DEFAULT '0',
  `FactionData` json DEFAULT NULL,
  `Strikes` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`FactionID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.gameanalytics
CREATE TABLE IF NOT EXISTS `gameanalytics` (
  `EntryID` int(11) NOT NULL AUTO_INCREMENT,
  `PlayerCount` float NOT NULL DEFAULT '0',
  `RecordType` enum('tick','hour','day','month') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'tick',
  `RecordGlob` json DEFAULT NULL,
  `DateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`EntryID`),
  KEY `EntryID_idx` (`EntryID`),
  KEY `PlayerCount_idx` (`PlayerCount`),
  KEY `RecordType_idx` (`RecordType`),
  KEY `DateTime_idx` (`DateTime`)
) ENGINE=InnoDB AUTO_INCREMENT=117795 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.gametestanalytics
CREATE TABLE IF NOT EXISTS `gametestanalytics` (
  `EntryID` int(11) NOT NULL AUTO_INCREMENT,
  `PlayerCount` float NOT NULL DEFAULT '0',
  `RecordType` enum('tick','hour','day','month') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'tick',
  `DateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`EntryID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.gangapps
CREATE TABLE IF NOT EXISTS `gangapps` (
  `ApplicationID` int(11) NOT NULL AUTO_INCREMENT,
  `LeaderName` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `LeaderSSN` int(11) DEFAULT NULL,
  `Member1Name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Member1SSN` int(11) DEFAULT NULL,
  `Member2Name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Member2SSN` int(11) DEFAULT NULL,
  `Member3Name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Member3SSN` int(11) DEFAULT NULL,
  `GangName` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `GangArea` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `GangStory` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `GangOperations` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ApplicationStatus` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'Pending',
  `Timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`ApplicationID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.inventoryitems
CREATE TABLE IF NOT EXISTS `inventoryitems` (
  `ItemID` int(11) NOT NULL AUTO_INCREMENT,
  `InvType` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `InvData` varchar(64) DEFAULT NULL,
  `ItemType` varchar(32) NOT NULL,
  `ItemAmt` int(11) NOT NULL DEFAULT '1',
  `ItemMeta` json NOT NULL,
  `ItemHealth` int(11) NOT NULL DEFAULT '100',
  `Slot` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ItemID`) USING BTREE,
  KEY `InvType_idx` (`InvType`),
  KEY `InvData_idx` (`InvData`),
  KEY `ItemType_idx` (`ItemType`),
  KEY `ItemAmt_idx` (`ItemAmt`),
  KEY `ItemHealth_idx` (`ItemHealth`),
  KEY `Slot_idx` (`Slot`)
) ENGINE=InnoDB AUTO_INCREMENT=1052691 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.licenses
CREATE TABLE IF NOT EXISTS `licenses` (
  `LicenseID` int(11) NOT NULL AUTO_INCREMENT,
  `LicenseNumber` bigint(20) DEFAULT NULL,
  `CharacterID` int(11) NOT NULL,
  `Type` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IssueDate` date NOT NULL,
  `ExpiryDate` date NOT NULL,
  `Picture` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `IsSuspended` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`LicenseID`) USING BTREE,
  UNIQUE KEY `licenseId_UNIQUE` (`LicenseID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.loans
CREATE TABLE IF NOT EXISTS `loans` (
  `LoanID` int(11) NOT NULL AUTO_INCREMENT,
  `CharID` int(11) NOT NULL,
  `StartDate` datetime NOT NULL,
  `LastBill` datetime DEFAULT CURRENT_TIMESTAMP,
  `TotalBalance` int(11) NOT NULL,
  `AmountPaid` int(11) DEFAULT '0',
  `Interval` enum('daily','weekly','monthly') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'monthly',
  `MinimumIntervalPayment` int(11) NOT NULL DEFAULT '0',
  `RecipientAccountNumber` int(11) NOT NULL DEFAULT '2',
  `Label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Loan',
  `LoanAPR` float DEFAULT '0',
  `LoanData` varchar(255) DEFAULT '0',
  PRIMARY KEY (`LoanID`)
) ENGINE=InnoDB AUTO_INCREMENT=336 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.outfits
CREATE TABLE IF NOT EXISTS `outfits` (
  `OutfitID` int(11) NOT NULL AUTO_INCREMENT,
  `CharID` int(11) NOT NULL DEFAULT '0',
  `Name` varchar(32) NOT NULL DEFAULT '',
  `Outfit` json DEFAULT NULL,
  PRIMARY KEY (`OutfitID`)
) ENGINE=InnoDB AUTO_INCREMENT=9440 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.phonecalls
CREATE TABLE IF NOT EXISTS `phonecalls` (
  `CallID` int(11) NOT NULL AUTO_INCREMENT,
  `FromNumber` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ToNumber` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `CharID` int(11) DEFAULT NULL,
  `ReceivedDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`CallID`)
) ENGINE=InnoDB AUTO_INCREMENT=35005 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.phonecontacts
CREATE TABLE IF NOT EXISTS `phonecontacts` (
  `UID` int(20) NOT NULL AUTO_INCREMENT,
  `IMEI` varchar(20) NOT NULL DEFAULT '',
  `Name` varchar(100) NOT NULL DEFAULT '',
  `Number` varchar(100) NOT NULL DEFAULT '',
  `Email` varchar(100) NOT NULL DEFAULT '',
  `Notes` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`UID`)
) ENGINE=InnoDB AUTO_INCREMENT=7656 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.phonedevices
CREATE TABLE IF NOT EXISTS `phonedevices` (
  `IMEI` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Style` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `SaleDate` datetime NOT NULL,
  `DeviceOwnerID` int(11) NOT NULL,
  `DevicePhoneNumber` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `DevicePin` int(11) DEFAULT NULL,
  `DeviceBackground` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Volume` int(11) NOT NULL DEFAULT '5',
  `BleeterVolume` int(11) NOT NULL DEFAULT '5',
  `BleeterAccount` int(11) DEFAULT NULL,
  `EmailAccount` int(11) DEFAULT NULL,
  `YellowPagesAccount` int(11) DEFAULT NULL,
  PRIMARY KEY (`IMEI`),
  UNIQUE KEY `IMEI` (`IMEI`),
  KEY `DevicePhoneNumber_idx` (`DevicePhoneNumber`),
  KEY `DevicePin_idx` (`DevicePin`),
  KEY `Volume_idx` (`Volume`),
  KEY `BleeterVolume_idx` (`BleeterVolume`),
  KEY `BleeterAccount_idx` (`BleeterAccount`),
  KEY `EmailAccount_idx` (`EmailAccount`),
  KEY `YellowPagesAccount_idx` (`YellowPagesAccount`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.phonenotes
CREATE TABLE IF NOT EXISTS `phonenotes` (
  `NoteID` int(11) NOT NULL AUTO_INCREMENT,
  `IMEI` varchar(50) DEFAULT NULL,
  `Content` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `LastModified` timestamp NULL DEFAULT NULL,
  `CharID` int(11) DEFAULT NULL,
  PRIMARY KEY (`NoteID`)
) ENGINE=InnoDB AUTO_INCREMENT=664 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.phonetexts
CREATE TABLE IF NOT EXISTS `phonetexts` (
  `UID` int(11) NOT NULL AUTO_INCREMENT,
  `fromNumber` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `toNumber` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` varchar(1028) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `timestamp` datetime NOT NULL,
  `charid` int(11) DEFAULT NULL,
  PRIMARY KEY (`UID`)
) ENGINE=InnoDB AUTO_INCREMENT=38417 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.presets
CREATE TABLE IF NOT EXISTS `presets` (
  `PresetID` int(11) NOT NULL AUTO_INCREMENT,
  `CharID` int(11) NOT NULL DEFAULT '0',
  `VehHash` varchar(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Unknown',
  `PresetName` varchar(45) NOT NULL DEFAULT 'Unknown',
  `VehCustomizations` json NOT NULL,
  PRIMARY KEY (`PresetID`),
  KEY `PresetID_idx` (`PresetID`),
  KEY `CharID_idx` (`CharID`),
  KEY `VehHash_idx` (`VehHash`),
  KEY `PresetName_idx` (`PresetName`)
) ENGINE=InnoDB AUTO_INCREMENT=1510 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.properties
CREATE TABLE IF NOT EXISTS `properties` (
  `PropertyID` int(11) NOT NULL AUTO_INCREMENT,
  `Address` varchar(128) NOT NULL DEFAULT 'Undefined',
  `Value` int(11) NOT NULL DEFAULT '100',
  `Interior` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Shell` varchar(24) DEFAULT NULL,
  `GarageSize` int(11) NOT NULL DEFAULT '1',
  `Coords` json NOT NULL,
  `Flags` json DEFAULT NULL,
  `Creator` int(11) NOT NULL DEFAULT '0',
  `PaidOut` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`PropertyID`)
) ENGINE=InnoDB AUTO_INCREMENT=372 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.propertyaccess
CREATE TABLE IF NOT EXISTS `propertyaccess` (
  `AccessID` int(11) NOT NULL AUTO_INCREMENT,
  `PropertyID` int(11) NOT NULL,
  `CharID` int(11) NOT NULL,
  `Access` varchar(16) NOT NULL DEFAULT 'guest',
  PRIMARY KEY (`AccessID`),
  KEY `AccessID_idx` (`AccessID`),
  KEY `PropertyID_idx` (`PropertyID`),
  KEY `CharID_idx` (`CharID`),
  KEY `Access_idx` (`Access`)
) ENGINE=InnoDB AUTO_INCREMENT=1831 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.propertyfurniture
CREATE TABLE IF NOT EXISTS `propertyfurniture` (
  `FurnitureID` int(11) NOT NULL AUTO_INCREMENT,
  `PropertyID` int(11) NOT NULL,
  `ObjHash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ObjPosition` json NOT NULL,
  PRIMARY KEY (`FurnitureID`)
) ENGINE=InnoDB AUTO_INCREMENT=8108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.queuepriority
CREATE TABLE IF NOT EXISTS `queuepriority` (
  `PriorityID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `FiveMIdentifier` int(11) unsigned DEFAULT NULL,
  `PriorityType` enum('Staff','Emergency Services') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`PriorityID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.records
CREATE TABLE IF NOT EXISTS `records` (
  `RecordID` int(11) NOT NULL AUTO_INCREMENT,
  `CharID` int(11) NOT NULL DEFAULT '0',
  `Type` varchar(16) NOT NULL DEFAULT 'bill',
  `Amount` int(11) NOT NULL DEFAULT '0',
  `Reason` varchar(2048) DEFAULT 'Data Not Found',
  `IssuedBy` varchar(128) NOT NULL DEFAULT 'Data Not Found',
  `ShowOnRecord` tinyint(4) NOT NULL DEFAULT '1',
  `Timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`RecordID`),
  KEY `CharID_idx` (`CharID`),
  KEY `Type_idx` (`Type`),
  KEY `Amount_idx` (`Amount`),
  KEY `IssuedBy_idx` (`IssuedBy`),
  KEY `ShowOnRecord_idx` (`ShowOnRecord`),
  KEY `Timestamp_idx` (`Timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=3854 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.rehab
CREATE TABLE IF NOT EXISTS `rehab` (
  `RehabID` int(11) NOT NULL AUTO_INCREMENT,
  `CharID` int(11) NOT NULL DEFAULT '0',
  `HeldBy` varchar(128) NOT NULL DEFAULT 'Unknown',
  `Reason` varchar(1024) DEFAULT 'Unknown',
  `Active` tinyint(4) NOT NULL DEFAULT '1',
  `Timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`RehabID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.scenes
CREATE TABLE IF NOT EXISTS `scenes` (
  `SceneID` int(11) NOT NULL AUTO_INCREMENT,
  `SceneColor` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'White',
  `SceneDist` int(3) NOT NULL DEFAULT '5',
  `SceneText` varchar(750) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'No Text Provided',
  `SceneCoords` json DEFAULT NULL,
  `ScenePlaced` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `SceneExpiry` datetime DEFAULT NULL,
  PRIMARY KEY (`SceneID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=383 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.staff
CREATE TABLE IF NOT EXISTS `staff` (
  `UserID` int(11) NOT NULL DEFAULT '0',
  `Rank` enum('admin','moderator','developer') DEFAULT NULL,
  `Username` varchar(50) DEFAULT NULL,
  `TimeHired` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.taxrates
CREATE TABLE IF NOT EXISTS `taxrates` (
  `RateID` varchar(50) NOT NULL DEFAULT '',
  `Label` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `RatePercentage` int(11) NOT NULL DEFAULT '0',
  `AppliesToType` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`RateID`),
  UNIQUE KEY `AppliesToType` (`AppliesToType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.users
CREATE TABLE IF NOT EXISTS `users` (
  `UserID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(32) NOT NULL,
  `Password` varchar(128) DEFAULT NULL,
  `ForumAccount` varchar(128) DEFAULT NULL,
  `Identifiers` json DEFAULT NULL,
  `FirstSeen` datetime DEFAULT NULL,
  `LastSeen` datetime DEFAULT NULL,
  `Playtime` int(11) NOT NULL DEFAULT '0',
  `UsedIPs` json DEFAULT NULL,
  `Settings` json DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `CADValue` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`UserID`),
  KEY `UserID_idx` (`UserID`),
  KEY `Username_idx` (`Username`),
  KEY `Password_idx` (`Password`),
  KEY `ForumAccount_idx` (`ForumAccount`),
  KEY `FirstSeen_idx` (`FirstSeen`),
  KEY `LastSeen_idx` (`LastSeen`),
  KEY `Playtime_idx` (`Playtime`),
  KEY `remember_token_idx` (`remember_token`),
  KEY `CADValue_idx` (`CADValue`)
) ENGINE=InnoDB AUTO_INCREMENT=1527 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.valet
CREATE TABLE IF NOT EXISTS `valet` (
  `VehicleID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `OwnerID` int(11) DEFAULT '0',
  `VehModel` varchar(100) DEFAULT 'Unknown',
  `VehHash` varchar(45) DEFAULT 'Unknown',
  `VehRegistration` varchar(10) DEFAULT '0',
  `VehCustomization` json DEFAULT NULL,
  `Fuel` float DEFAULT '100',
  `EngineCondition` float DEFAULT '1000',
  `BodyCondition` float DEFAULT '1000',
  `IsOut` tinyint(4) DEFAULT '0',
  `Location` varchar(100) DEFAULT 'Unknown',
  PRIMARY KEY (`VehicleID`)
) ENGINE=InnoDB AUTO_INCREMENT=2299 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.weedgrowing
CREATE TABLE IF NOT EXISTS `weedgrowing` (
  `PlantID` int(11) NOT NULL AUTO_INCREMENT,
  `OwnerID` int(11) NOT NULL,
  `PlantStage` enum('seed','tiny','medium','large','harvest') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'seed',
  `PlantPosition` json NOT NULL,
  `PlantedTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `LastGrew` datetime DEFAULT NULL,
  `PropertyID` int(11) DEFAULT NULL,
  PRIMARY KEY (`PlantID`),
  KEY `PlantID_idx` (`PlantID`),
  KEY `OwnerID_idx` (`OwnerID`),
  KEY `PlantStage_idx` (`PlantStage`),
  KEY `PlantedTime_idx` (`PlantedTime`),
  KEY `LastGrew_idx` (`LastGrew`),
  KEY `PropertyID` (`PropertyID`)
) ENGINE=InnoDB AUTO_INCREMENT=54012 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.yellowpagesaccounts
CREATE TABLE IF NOT EXISTS `yellowpagesaccounts` (
  `AccountID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` longtext,
  `Password` longtext,
  `OwnerCharID` int(11) DEFAULT NULL,
  `CreatedDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`AccountID`)
) ENGINE=InnoDB AUTO_INCREMENT=373 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table soegame2.yellowpagesads
CREATE TABLE IF NOT EXISTS `yellowpagesads` (
  `AdvertID` int(11) NOT NULL AUTO_INCREMENT,
  `AccountID` int(11) NOT NULL,
  `Category` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `Content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `Email` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `Phone` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `CharID` int(11) NOT NULL,
  `DateTime` datetime NOT NULL,
  PRIMARY KEY (`AdvertID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=847 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
