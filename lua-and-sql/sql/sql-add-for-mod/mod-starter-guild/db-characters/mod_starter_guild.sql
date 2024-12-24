UPDATE `guild`
SET
	`name`='За Орду',
	`leaderguid`=1,
	`EmblemStyle`=164,
	`EmblemColor`=16,
	`BorderStyle`=1,
	`BorderColor`=16,
	`BackgroundColor`=5,
	`motd`='Лок`Тар Огар! Победа или смерть!'
WHERE `guildid`=1;

UPDATE `guild`
SET
	`name`='За Альянс',
	`leaderguid`=2,
	`EmblemStyle`=128,
	`EmblemColor`=16,
	`BorderStyle`=0,
	`BorderColor`=10,
	`BackgroundColor`=32,
	`motd`='Штормград приветствует вашу службу Альянсу!'
WHERE `guildid`=2;

DELETE FROM `guild_rank` WHERE `guildid`=1 OR `guildid`=2;
INSERT INTO `guild_rank` (`guildid`, `rid`, `rname`, `rights`, `BankMoneyPerDay`) VALUES
	(1, 0, 'Мастер Орды', 1962495, 4294967295),
	(1, 1, 'Офицер Орды', 1962495, 10000000),
	(1, 2, 'Ветеран Орды', 795123, 1000000),
	(1, 3, 'Рядовой Орды', 270419, 1000000),
	(1, 4, 'Новобранец', 262211, 100000),
	(2, 0, 'Мастер Альянса', 1962495),
	(2, 1, 'Офицер Альянса', 1962495, 10000000),
	(2, 2, 'Ветеран Альянса', 795123, 1000000),
	(2, 3, 'Рядовой Альянса', 270419, 1000000),
	(2, 4, 'Новобранец', 262211, 100000);
