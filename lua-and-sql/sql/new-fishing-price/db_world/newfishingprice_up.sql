/*
-- ############################################################################################################# --
-- 
--  ____    __                                         ______  __              ____                    __      
-- /\  _`\ /\ \__                  __                 /\__  _\/\ \            /\  _`\                 /\ \__   
-- \ \,\L\_\ \ ,_\  __  __     __ /\_\     __      ___\/_/\ \/\ \ \___      __\ \ \L\ \     __    ____\ \ ,_\  
--  \/_\__ \\ \ \/ /\ \/\ \  /'_ `\/\ \  /'__`\  /' _ `\ \ \ \ \ \  _ `\  /'__`\ \  _ <'  /'__`\ /',__\\ \ \/  
--    /\ \L\ \ \ \_\ \ \_\ \/\ \L\ \ \ \/\ \L\.\_/\ \/\ \ \ \ \ \ \ \ \ \/\  __/\ \ \L\ \/\  __//\__, `\\ \ \_ 
--    \ `\____\ \__\\/`____ \ \____ \ \_\ \__/.\_\ \_\ \_\ \ \_\ \ \_\ \_\ \____\\ \____/\ \____\/\____/ \ \__\
--     \/_____/\/__/ `/___/> \/___L\ \/_/\/__/\/_/\/_/\/_/  \/_/  \/_/\/_/\/____/ \/___/  \/____/\/___/   \/__/
--                     /\___/ /\____/                                                                         
--                     \/__/  \_/__/               http://stygianthebest.github.io                                                    
--
-- ############################################################################################################# --
--
--	Fishing Price Mods
--	By StygianTheBest
-- Updated by Bite Of Storm
--
--  This increases the sell price of rare fish and other fishing loot.
--
-- ############################################################################################################# --
*/


USE acore_world;

-- ######################################################--
--	FISH
-- ######################################################--

-- Items
UPDATE `item_template` SET `BuyPrice`=15000 WHERE `entry`=6360;  -- Steelscale Crushfish
UPDATE `item_template` SET `BuyPrice`=1200 WHERE `entry`=6651;  -- Broken Wine Bottle
UPDATE `item_template` SET `BuyPrice`=77700 WHERE `entry`=19808;  -- Rockhide Strongfish
UPDATE `item_template` SET `BuyPrice`=120000 WHERE `entry`=27442;  -- Goldenscale Vendorfish
UPDATE `item_template` SET `BuyPrice`=100000 WHERE `entry`=34484;  -- Old Ironjaw
UPDATE `item_template` SET `BuyPrice`=100000 WHERE `entry`=34486;  -- Old Crafty
UPDATE `item_template` SET `BuyPrice`=650000 WHERE `entry`=44505;  -- Dustbringer
UPDATE `item_template` SET `BuyPrice`=600000 WHERE `entry`=44703;  -- Dark Herring
UPDATE `item_template` SET `BuyPrice`= `BuyPrice` * 10, `SellPrice`=`BuyPrice` WHERE `entry` IN (6360,6651,19808,27442,34484,34486,44505,44703);

-- Mud Snapper
UPDATE `item_template` SET `BuyPrice`= `BuyPrice` * 10, `SellPrice`=`BuyPrice` WHERE `entry` IN (6292,6294,6295);

-- Catfish
UPDATE `item_template` SET `BuyPrice`= `BuyPrice` * 10, `SellPrice`=`BuyPrice` WHERE `entry` IN (6309,6310,6311,6363,6364);

-- Grouper
UPDATE `item_template` SET `BuyPrice`= `BuyPrice` * 10, `SellPrice`=`BuyPrice` WHERE `entry` IN (13876,13877,13878,13879,13880);

-- Redgill
UPDATE `item_template` SET `BuyPrice`= `BuyPrice` * 10, `SellPrice`=`BuyPrice` WHERE `entry` IN (13885,13886,13882,13883,13884,13887);

-- Salmon
UPDATE `item_template` SET `BuyPrice`=50000, `SellPrice`=`BuyPrice` WHERE `entry`=13901;  -- 15 Pound Salmon
UPDATE `item_template` SET `BuyPrice`=100000, `SellPrice`=`BuyPrice` WHERE `entry`=13902;  -- 18 Pound Salmon
UPDATE `item_template` SET `BuyPrice`=250000, `SellPrice`=`BuyPrice` WHERE `entry`=13903;  -- 22 Pound Salmon
UPDATE `item_template` SET `BuyPrice`=500000, `SellPrice`=`BuyPrice` WHERE `entry`=13904;  -- 25 Pound Salmon
UPDATE `item_template` SET `BuyPrice`=750000, `SellPrice`=`BuyPrice` WHERE `entry`=13905;  -- 29 Pound Salmon
UPDATE `item_template` SET `BuyPrice`=1000000, `SellPrice`=`BuyPrice` WHERE `entry`=13906;  -- 32 Pound Salmon

-- Lobster
UPDATE `item_template` SET `BuyPrice`= `BuyPrice` * 100, `SellPrice`=`BuyPrice` WHERE `entry` IN (13907,13908,13909,13910,13911,13912,13913);

-- Mightfish
UPDATE `item_template` SET `BuyPrice`= `BuyPrice` * 100, `SellPrice`=`BuyPrice` WHERE `entry` IN (13914,13915,13916,13917);

-- ######################################################--
--	FISHING RARES
-- ######################################################--

UPDATE item_template SET `BuyPrice`=250000, `SellPrice`=250000 WHERE entry = 6297;  -- Old Skull (Can be fished in the lava pool where Ragnaros spawns)
UPDATE item_template SET `BuyPrice`=750000, `SellPrice`=750000 WHERE entry = 18365;  -- A Thoroughly Read Copy of Nat's Anglin'
UPDATE item_template SET `BuyPrice`=1000000, `SellPrice`=1000000 WHERE entry = 18335;  -- Pristine Black Diamond
UPDATE item_template SET `BuyPrice`=1000000, `SellPrice`=1000000 WHERE entry = 34826;  -- 0000old Wedding Band
UPDATE item_template SET `BuyPrice`=2500000, `SellPrice`=2500000 WHERE entry = 45994;  -- Lost Ring 
UPDATE item_template SET `BuyPrice`=2500000, `SellPrice`=2500000 WHERE entry = 45995;  -- Lost Necklace 
UPDATE item_template SET `BuyPrice`=5000000, `SellPrice`=7500000 WHERE entry = 8350;  -- The 1 Ring
UPDATE item_template SET `BuyPrice`=5000000, `SellPrice`=7500000 WHERE entry = 34837;  -- The 2 Ring 
UPDATE item_template SET `BuyPrice`=5000000, `SellPrice`=7500000 WHERE entry = 45859;  -- The 5 Ring

-- END OF LINE