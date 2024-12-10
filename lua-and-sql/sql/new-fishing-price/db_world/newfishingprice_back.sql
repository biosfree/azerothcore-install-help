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
UPDATE `item_template` SET `BuyPrice`=12905, `SellPrice`=2581 WHERE `entry`=6360;  -- Steelscale Crushfish'
UPDATE `item_template` SET `BuyPrice`=1173, `SellPrice`=234 WHERE `entry`=6651;  -- Broken Wine Bottle'
UPDATE `item_template` SET `BuyPrice`=77783, `SellPrice`=15556 WHERE `entry`=19808;  -- Rockhide Strongfish'
UPDATE `item_template` SET `BuyPrice`=1200000, `SellPrice`=60000 WHERE `entry`=27442;  -- Goldenscale Vendorfish'
UPDATE `item_template` SET `BuyPrice`=10000, `SellPrice`=2500 WHERE `entry`=34484;  -- Old Ironjaw'
UPDATE `item_template` SET `BuyPrice`=10000, `SellPrice`=2500 WHERE `entry`=34486;  -- Old Crafty'
UPDATE `item_template` SET `BuyPrice`=659636, `SellPrice`=131927 WHERE `entry`=44505;  -- Dustbringer'
UPDATE `item_template` SET `BuyPrice`=590415, `SellPrice`=118083 WHERE `entry`=44703;  -- Dark Herring'

-- Mud Snapper
UPDATE `item_template` SET `BuyPrice`=34, `SellPrice`=8 WHERE `entry`=6292;  -- 10 Pound Mud Snapper'
UPDATE `item_template` SET `BuyPrice`=40, `SellPrice`=10 WHERE `entry`=6294;  -- 12 Pound Mud Snapper'
UPDATE `item_template` SET `BuyPrice`=48, `SellPrice`=12 WHERE `entry`=6295;  -- 15 Pound Mud Snapper'

-- Catfish
UPDATE `item_template` SET `BuyPrice`=400, `SellPrice`=100 WHERE `entry`=6309;  -- 17 Pound Catfish
UPDATE `item_template` SET `BuyPrice`=600, `SellPrice`=150 WHERE `entry`=6310;  -- 19 Pound Catfish
UPDATE `item_template` SET `BuyPrice`=750, `SellPrice`=187 WHERE `entry`=6311;  -- 22 Pound Catfish
UPDATE `item_template` SET `BuyPrice`=1000, `SellPrice`=250 WHERE `entry`=6363;  -- 26 Pound Catfish
UPDATE `item_template` SET `BuyPrice`=1500, `SellPrice`=375 WHERE `entry`=6364;  -- 32 Pound Catfish

-- Grouper
UPDATE `item_template` SET `BuyPrice`=100, `SellPrice`=25 WHERE `entry`=13876;  -- 40 Pound Grouper
UPDATE `item_template` SET `BuyPrice`=120, `SellPrice`=30 WHERE `entry`=13877;  -- 47 Pound Grouper
UPDATE `item_template` SET `BuyPrice`=130, `SellPrice`=32 WHERE `entry`=13878;  -- 53 Pound Grouper
UPDATE `item_template` SET `BuyPrice`=140, `SellPrice`=35 WHERE `entry`=13879;  -- 59 Pound Grouper
UPDATE `item_template` SET `BuyPrice`=150, `SellPrice`=37 WHERE `entry`=13880;  -- 68 Pound Grouper

-- Redgill
UPDATE `item_template` SET `BuyPrice`=240, `SellPrice`=60 WHERE `entry`=13882;  -- 42 Pound Redgill
UPDATE `item_template` SET `BuyPrice`=240, `SellPrice`=60 WHERE `entry`=13883;  -- 45 Pound Redgill
UPDATE `item_template` SET `BuyPrice`=300, `SellPrice`=75 WHERE `entry`=13884;  -- 49 Pound Redgill
UPDATE `item_template` SET `BuyPrice`=200, `SellPrice`=50 WHERE `entry`=13885;  -- 34 Pound Redgill
UPDATE `item_template` SET `BuyPrice`=200, `SellPrice`=50 WHERE `entry`=13886;  -- 37 Pound Redgill
UPDATE `item_template` SET `BuyPrice`=300, `SellPrice`=75 WHERE `entry`=13887;  -- 52 Pound Redgill

-- Salmon
UPDATE `item_template` SET `BuyPrice`=100, `SellPrice`=25 WHERE `entry`=13901;  -- 15 Pound Salmon
UPDATE `item_template` SET `BuyPrice`=100, `SellPrice`=25 WHERE `entry`=13902;  -- 18 Pound Salmon
UPDATE `item_template` SET `BuyPrice`=100, `SellPrice`=25 WHERE `entry`=13903;  -- 22 Pound Salmon
UPDATE `item_template` SET `BuyPrice`=100, `SellPrice`=25 WHERE `entry`=13904;  -- 25 Pound Salmon
UPDATE `item_template` SET `BuyPrice`=100, `SellPrice`=25 WHERE `entry`=13905;  -- 29 Pound Salmon
UPDATE `item_template` SET `BuyPrice`=200, `SellPrice`=50 WHERE `entry`=13906;  -- 32 Pound Salmon

-- Lobster
UPDATE `item_template` SET `BuyPrice`=200, `SellPrice`=50 WHERE `entry`=13907;  -- 7 Pound Lobster
UPDATE `item_template` SET `BuyPrice`=220, `SellPrice`=55 WHERE `entry`=13908;  -- 9 Pound Lobster
UPDATE `item_template` SET `BuyPrice`=220, `SellPrice`=55 WHERE `entry`=13909;  -- 12 Pound Lobster
UPDATE `item_template` SET `BuyPrice`=250, `SellPrice`=62 WHERE `entry`=13910;  -- 15 Pound Lobster
UPDATE `item_template` SET `BuyPrice`=320, `SellPrice`=80 WHERE `entry`=13911;  -- 19 Pound Lobster
UPDATE `item_template` SET `BuyPrice`=360, `SellPrice`=90 WHERE `entry`=13912;  -- 21 Pound Lobster
UPDATE `item_template` SET `BuyPrice`=400, `SellPrice`=100 WHERE `entry`=13913;  -- 22 Pound Lobster

-- Mightfish
UPDATE `item_template` SET `BuyPrice`=500, `SellPrice`=125 WHERE `entry`=13914;  -- 70 Pound Mightfish
UPDATE `item_template` SET `BuyPrice`=500, `SellPrice`=125 WHERE `entry`=13915;  -- 85 Pound Mightfish
UPDATE `item_template` SET `BuyPrice`=600, `SellPrice`=150 WHERE `entry`=13916;  -- 92 Pound Mightfish
UPDATE `item_template` SET `BuyPrice`=800, `SellPrice`=200 WHERE `entry`=13917;  -- 103 Pound Mightfish

-- ######################################################--
--	FISHING RARES
-- ######################################################--

UPDATE `item_template` SET `BuyPrice`=30, `SellPrice`=7 WHERE `entry`=6297;  -- Old Skull
UPDATE `item_template` SET `BuyPrice`=4520, `SellPrice`=1130 WHERE `entry`=8350;  -- The 1 Ring
UPDATE `item_template` SET `BuyPrice`=0, `SellPrice`=0 WHERE `entry`=18335;  -- Pristine Black Diamond
UPDATE `item_template` SET `BuyPrice`=0, `SellPrice`=0 WHERE `entry`=18365;  -- A Thoroughly Read Copy of "Nat Pagle's Extreme Anglin
UPDATE `item_template` SET `BuyPrice`=600000, `SellPrice`=150000 WHERE `entry`=34826;  -- Gold Wedding Band
UPDATE `item_template` SET `BuyPrice`=45200, `SellPrice`=11300 WHERE `entry`=34837;  -- The 2 Ring
UPDATE `item_template` SET `BuyPrice`=145200, `SellPrice`=36300 WHERE `entry`=45859;  -- The 5 Ring
UPDATE `item_template` SET `BuyPrice`=187469, `SellPrice`=46867 WHERE `entry`=45994;  -- Lost Ring
UPDATE `item_template` SET `BuyPrice`=187469, `SellPrice`=46867 WHERE `entry`=45995;  -- Forgotten Necklace

-- END OF LINE