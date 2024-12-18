DELETE FROM `motd` WHERE `realmid`=1; INSERT INTO `motd` (`realmid`, `text`) VALUES (1, 'Welcome to an AzerothCore server "Storm of Blades"');
DELETE FROM `motd_localized` WHERE realmid=1; INSERT INTO `motd_localized` (`realmid`, `locale`, `text`) VALUES (1, 'ruRU','Добро пожаловать на World of Warcraft сервер "Шторм клинков"');
