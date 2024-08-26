# azerothcore-install-help
Инструкция по установке World of Warcraft: Wrath of the Lich King сервера на ядре AzerothCore в Debian 12
<!--
goal : Установка Azerothcore в Debian
     : используя ruRU локали
     : Debian v12.6 под пользователем acore
     : MySQL v8.4.2 LTS под пользователем acore
autor: biosfree
ver. : 0.9
date : 2024-08-21 17:00
-->

# Установка ![logo](https://raw.githubusercontent.com/azerothcore/azerothcore.github.io/master/images/logo-github.png) Azerothcore 2024 [:rocket:](https://biosfree.github.io/azerothcore-install-help)

1. [Подготовка OS Debian 12](#подготовка-os-debian-12-point_up_2)
	* [Установка MySQL 8.4](#установка-mysql-84-point_left)
	* [Установка основных программ и библиотек](#установка-основных-программ-и-библиотек-point_left)

2. [Подготовка AzerothCore](#подготовка-azerothcore-point_up_2)
	* [Загрузка исходников AzerothCore](#загрузка-исходников-azerothcore-point_left)
	* [Настройка и исправления для acore.sh](#настройка-и-исправления-для-acoresh-point_left)
	* [Создание чистой базы даных AzerothCore](#создание-чистой-базы-даных-azerothcore-point_left)

3. [Компиляция и настройка Azerothcore](#компиляция-и-настройка-azerothcore-point_up_2)
4. [Извлечения данных для сервера](#извлечения-данных-для-сервера-point_up_2)
	* [Подготовка диска для храниения данных](#подготовка-диска-для-храниения-данных-point_left)
	* [Извлечения данных из клиента игры](#извлечения-данных-из-клиента-игры-point_left)

5. [Заполнение SQL баз данных AzerothCore](#заполнение-sql-баз-данных-azerothcore-point_up_2)
6. [Установка дополнений для AzerothCore](#установка-дополнений-для-azerothcore-point_up_2)
	* [Установка допольнительных модулей](#установка-допольнительных-модулей-point_left)
	* [Установка дополнительных скриптов](#установка-дополнительных-скриптов-point_left)
	* [Внесение SQL правок в БД](#внесение-sql-правок-в-бд-point_left)

7. [Первый запуск сервера](#первый-запуск-сервера-point_up_2)
8. [Настрока запуска сервера как службы](#настрока-запуска-сервера-как-службы-point_up_2)
9. [Поддержка сервера в актуальном состояние](#поддержка-сервера-в-актуальном-состояние-point_up_2)

## Подготовка OS Debian 12 [:point_up_2:](#установка--azerothcore-2024-rocket)

### Установка MySQL 8.4 [:point_left:](#подготовка-os-debian-12-point_up_2)

Загрузите последний `*.deb` c официального [MySQL APT Repository](https://dev.mysql.com/downloads/repo/apt/) в `/tmp`
```bash
wget -P /tmp https://dev.mysql.com/get/mysql-apt-config_0.8.32-1_all.deb
```

Установите загруженный dep-пакет:

```bash
sudo apt update
sudo apt install /tmp/mysql-apt-config_0.8.32-1_all.deb
sudo apt update
sudo apt install mysql-server
```

>[!NOTE]
>При установке MySQL, новая учетная запись `root` уже защищена аутентификацией через `auth_socket`, поэтому вы можете спокойно оставить поле с паролем для root пустым!

>[!TIP]
>*Или воспользутесь вариантом установки из официальной [инструкции](https://dev.mysql.com/doc/refman/8.4/en/linux-installation-apt-repo.html)*:
>
>```bash
>sudo apt-get update
>sudo apt-get install gnupg -y
>sudo dpkg -i /tmp/mysql-apt-config_0.8.32-1_all.deb
>sudo apt-get update
>sudo dpkg-reconfigure mysql-apt-config
>sudo apt-get update
>sudo apt-get install mysql-server
>```

### Установка основных программ и библиотек [:point_left:](#подготовка-os-debian-12-point_up_2)

```bash
sudo apt update && sudo apt install git cmake make gcc g++ clang default-libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev lsb-release -y
```

>[!TIP]
>Так же, для использования скрипта `acore.sh`, могут пригодится дополнительные утилиты (такие как: `unzip` , `curl`),
>которые можно установить выборочно...
>
>```bash
>sudo apt update && sudo apt install unzip curl -y
>```
>
>:exclamation: или воспользоваться самим скриптом `acore.sh` и установить сразу все зависимости:
>
>```bash
>~/azerothcore/acore.sh install-deps
>```

## Подготовка AzerothCore [:point_up_2:](#установка--azerothcore-2024-rocket)

### Загрузка исходников AzerothCore [:point_left:](#подготовка-azerothcore-point_up_2)

Загрузите исходники c [официального репозитория](https://github.com/azerothcore/azerothcore-wotlk)

```bash
git -C ~ clone https://github.com/azerothcore/azerothcore-wotlk.git --branch master --single-branch azerothcore --depth 1
```

### Настройка и исправления для acore.sh [:point_left:](#подготовка-azerothcore-point_up_2)

**Создание config.sh**

```bash
cp -f ~/azerothcore/conf/dist/config.sh ~/azerothcore/conf/
```

**Настройка config.sh**

```bash
sed -i 's|BINPATH="$AC_PATH_ROOT/env/dist"|BINPATH="'${HOME}'/.local"|' ~/azerothcore/conf/config.sh
sed -i 's|CTOOLS_BUILD=${CTOOLS_BUILD:-none}|CTOOLS_BUILD="all"|' ~/azerothcore/conf/config.sh
```

**Исправления для azerothcore functions.sh**

```bash
sed -i 's/sudo cmake --install . --config $CTYPE/cmake --install . --config $CTYPE/' ~/azerothcore/apps/compiler/includes/functions.sh
sed -i '/find "$AC_BINPATH_FULL" /s/^/#/' ~/azerothcore/apps/compiler/includes/functions.sh
```

### Создание чистой базы даных AzerothCore [:point_left:](#подготовка-azerothcore-point_up_2)

- Зайти в консоль MySQL: ```sudo mysql```
- Вставить sql-запросы:

```sql
DROP USER IF EXISTS 'acore'@'localhost';
CREATE USER 'acore'@'localhost' IDENTIFIED BY 'acore' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0;
CREATE DATABASE `acore_world` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE `acore_characters` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE `acore_auth` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON `acore_world` . * TO 'acore'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `acore_characters` . * TO 'acore'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `acore_auth` . * TO 'acore'@'localhost' WITH GRANT OPTION;
EXIT

```

>[!IMPORTANT]
>**Настоятельно рекомендуется сразу же изменить пароль на случайный и сохранить в файл: `~\acore_sql_pass.txt`.**

```bash
cd ~ && sudo mysql -e 'SET PASSWORD FOR 'acore'@'localhost' TO RANDOM;' | awk 'FNR == 4 {print $6}' | tee acore_sql_pass.txt
```

>[!TIP]
>Для создания чистой базы данных и пользователя можно воспользоваться SQL заготовками из загруженных только что [исходников AzerothCore](https://github.com/azerothcore/azerothcore-wotlk/blob/master/data/sql/create/create_mysql.sql)
>
>:exclamation: *Но их использование не рекомендуется, так как они предоставят пользователю `acore` полные права на весь MySQL сервер, что может быть серьезной уязвимостью в безопасности, особенно при использовании стандартного пароля.*
>
>```bash
>sudo mysql < ~/azerothcore/data/sql/create/create_mysql.sql"
>```
>
>:exclamation: *А для удаления всей базы данных AzerothCore воспользуйтесь*:
>```bash
>sudo mysql < ~/azerothcore/data/sql/create/drop_mysql_8.sql
>```
>
>>или удалить вручную через консоль MySQL
>>```bash
>>sudo mysql
>>```
>>
>>```sql
>>REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'acore'@'localhost';
>>DROP USER 'acore'@'localhost';
>>DROP DATABASE IF EXISTS `acore_world`;
>>DROP DATABASE IF EXISTS `acore_characters`;
>>DROP DATABASE IF EXISTS `acore_auth`;
>>EXIT
>>
>>```
>

*Подсказки для управления безопасностью MySQL сервера*:

>[!NOTE]
>*Зайходим в консоль MySQL сервера под пользователем `root` если при установки не указывали пароль*:
>
>```bash
>sudo mysql
>```
>
>>*Или с паролем если указывали*:
>>
>>```bash
>>sudo mysql -p
>>```
>
>Чтобы посмотреть для всех пользователей в MySQL используемый метод аунтификации
>
>```sql
>SELECT user, host, plugin, Super_priv from mysql.user;
>```
>
>*Чтобы изменит у пользователя метод аунтификации выбираем одну команду из примера*:
>
>```sql
>ALTER USER 'acore'@'localhost' IDENTIFIED WITH auth_socket;
>ALTER USER 'acore'@'localhost' IDENTIFIED BY 'ВАШ-ДЛИННЫЙ-И-СЛОЖНЫЙ-ПАРОЛЬ';
>ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;
>ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'ВАШ-ДЛИННЫЙ-И-СЛОЖНЫЙ-ПАРОЛЬ';
>```
>
>*Чтобы дать MySQL пользователю `acore` привелегии `root`*:
>
>```sql
>GRANT ALL PRIVILEGES ON * . * TO 'acore'@'localhost' WITH GRANT OPTION;
>FLUSH PRIVILEGES;
>EXIT
>```

## Компиляция и настройка Azerothcore [:point_up_2:](#установка--azerothcore-2024-rocket)

**Первая компиляция немодифицированного сервера:**

```bash
mkdir ~/azerothcore/build
cd ~/azerothcore/build
```

```cmake
cmake ../ -DCMAKE_INSTALL_PREFIX=$HOME/.local/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=all
make -j $(nproc) install
```

>Или используя `acore.sh`
>```bash
>./azerothcore/acore.sh compiler all
>```

>[!NOTE]
>После успешной сборки сервера со всеми утилитами, в конфигурационный файл можно вернуть запрет на сборку дополнительных инструментов.
>
>```bash
>sed -i 's|CTOOLS_BUILD="all"|CTOOLS_BUILD=${CTOOLS_BUILD:-none}|' ~/azerothcore/conf/config.sh
>```

**Настройка основных конфигурационных файлов:**

```bash
for i in $( ls ~/.local/etc/*.dist ); do cp -n $i ${i%.*}; done
```

```bash
sed -i 's|^DataDir = .*|DataDir = "/mnt/wowclient/wotlk"|' ~/.local/etc/worldserver.conf
sed -i 's|^RealmZone = .*|RealmZone = 12|' ~/.local/etc/worldserver.conf
sed -i 's|^DBC.Locale = .*|DBC.Locale = 8|' ~/.local/etc/worldserver.conf
sed -i 's|^LogsDir = .*|LogsDir = "'${HOME}'/logs"|' ~/.local/etc/*.conf
sed -i 's|^TempDir = .*|TempDir = "'${HOME}'"|' ~/.local/etc/*.conf
```

>[!IMPORTANT]
>**если используем свой пароль для MySQL пользователя `acore`:**

:exclamation: *Замените `ACORESQLPASS` на ваш пароль. Чтобы посмотреть сгенерированный пароль запустите: `cat ~/acore_sql_pass.txt`*

```bash
sed -i 's/= "127.0.0.1;3306;acore;acore;/= "127.0.0.1;3306;acore;ACORESQLPASS;/' ~/.local/etc/*.conf
```

**Убедитесь что директория `logs` сушествует и при необходимости создайте её:**

>```bash
>mkdir ~/logs
>```

>[!TIP]
>*Для более тонкой настройки вашего сервера отредактируйте конфигурационные файлы в текстовом редакторе*
>
>```bash
>nano ~/.local/etc/authserver.conf
>```
>
>```bash
>nano ~/.local/etc/worldserver.conf
>```

## Извлечения данных для сервера [:point_up_2:](#установка--azerothcore-2024-rocket)

### Подготовка диска для храниения данных [:point_left:](#извлечения-данных-для-сервера-point_up_2)

**Добавление и разметка нового диска для данных**
```bsh
lsblk
sudo fdisk -l /dev/sdb
sudo fdisk /dev/sdb
```
>```
>[n] [p] [w]
>```
```bash
sudo mkfs.ext4 /dev/sdb1
```

**Монтирование нового диска**
```bash
cd /mnt
mkdir wowclient
df -h
sudo blkid
```
>Скопировать *UUID* нового раздела который выглядить как то так: (9bf6b87e-b42d-4b2a-8db7-1a470970f9a2)

**Добавление нового раздела в fstab**
```bash
sudo nano /etc/fstab
```
>UUID=(UIDD-НОВОГО-РАЗДЕЛА) /mnt/wowclient ext4 defaults 0 1
```bash
sudo reboot
```

**Копирование клиент игры в директорию**
```bash
cd /mnt/wowclient
mkdir wotlk
```
>Скопировать клиент игры в директорию `/mnt/wowclient/wotlk`

Предоставить группе `users` права на запись в деректорию
```bash
sudo chgrp users /mnt/wowclient/wotlk
sudo chmod  00770 /mnt/wowclient/wotlk
```
>Или только основному пользователю `acore`
> ```bash
> sudo chown acore:acore /mnt/wowclient/wotlk
> ```

### Извлечения данных из клиента игры [:point_left:](#извлечения-данных-для-сервера-point_up_2)

```bash
cd /mnt/wowclient/wotlk
map_extractor
vmap4_extractor
mkdir vmaps
vmap4_assembler Buildings vmaps
mkdir mmaps
mmaps_generator
```

>[!TIP]
>Есть возможность воспользоваться уже сгенерированными данными из скрипта:
>```bash
>~/azerothcore/acore.sh client-data
>```
>но они предназначены для английской локали `enGB` и в целом не рекомендуются для использования в этом руководстве.

## Заполнение SQL баз данных AzerothCore [:point_up_2:](#установка--azerothcore-2024-rocket)

>Хотя при первом запуске сервер сам запустит автозаполнение базы данных AzerothCore нам удобнее сделать это заранее, чтобы сразу заполнить IP адрес и стартовое приветствие сервера.

Для заполнение базы данный воспользуемся утилитой `dbimport`

```bash
dbimport
```

>может понадобиться проверка `dbimport.conf` на настроки подключения к базе данных
>
>```bash
>cp ~/.local/etc/dbimport.conf.dist ~/.local/etc/dbimport.conf
>nano ~/.local/etc/dbimport.conf
>```

*Настройка ip адреса сервера*:
```sql
sudo mysql acore_auth -e "UPDATE realmlist SET name = 'Шторм клинков', address = '192.168.10.101' WHERE id = '1'";
```

*Настройка приветсвия для сервера*:
```sql
sudo mysql acore_auth -e "DELETE FROM motd WHERE realmid=1; INSERT INTO motd (realmid, text) VALUES ('1', 'Добро пожаловать на World of Warcraft сервер \"Шторм клинков\"')"
```

>[!NOTE]
>Там же текста приветсвия можно изменить в консоли `worldserver`, но случаються проблемы с вводимыми символами
>```lua
>server set motd 'Добро пожаловать на World of Warcraft сервер "Шторм клинков"'
>reload motd
>```

## Установка дополнений для AzerothCore [:point_up_2:](#установка--azerothcore-2024-rocket)

### Установка допольнительных модулей [:point_left:](#установка-дополнений-для-azerothcore-point_up_2)

1. [mod-eluna:](https://github.com/azerothcore/mod-eluna)
   *Eluna Lua Engine © is a lua engine embedded to World of Warcraft emulators.* [Eluna API (AC version)](https://www.azerothcore.org/pages/eluna/index.html) | [Lua reference manual](http://www.lua.org/manual/5.2/).
   
   ```bash
   git -C $HOME/azerothcore/modules clone https://github.com/azerothcore/mod-eluna.git
   ```
   ```bash
   cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
   make -C $HOME/azerothcore/build/ -j $(nproc) install
   ```
   
   ```bash
   sed -i 's|^Eluna.ScriptPath = .*|Eluna.ScriptPath = "'${HOME}'/.local/bin/lua_scripts"|' ~/.local/etc/modules/mod_LuaEngine.conf.dist
   ```

2. [mod-auctionator:](https://github.com/araxiaonline/mod-auctionator)
   *Этот мод предназначен для поддержания здорового аукционного дома на малопосещаемом сервере.*
   
   ```bash
   git -C $HOME/azerothcore/modules clone https://github.com/araxiaonline/mod-auctionator.git
   ```
   
   ```bash
   cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
   make -C $HOME/azerothcore/build/ -j $(nproc) install
   ```

<!--
2. [mod-ah-bot:](https://github.com/azerothcore/mod-ah-bot)
   *An auction house bot.*
   
   ```bash
   git -C $HOME/azerothcore/modules clone https://github.com/azerothcore/mod-ah-bot.git
   ```
   
   ```bash
   cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
   make -C $HOME/azerothcore/build/ -j $(nproc) install
   ```
-->

3. [mod-skip-dk-starting-area:](https://github.com/biosfree/mod-skip-dk-starting-area)
	 *Skips the Death Knight starting zone.*
	 
   ```bash
   git -C $HOME/azerothcore/modules clone https://github.com/biosfree/mod-skip-dk-starting-area.git
   ```
	 
	 ```bash
	 cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
	 make -C $HOME/azerothcore/build/ -j $(nproc) install
	 ```

   >```bash
   >sed -i 's/if (player->getLevel() <= DKL)/if (player->GetLevel() <= DKL)/' ~/azerothcore/modules/mod-skip-dk-starting-area/src/SkipDK.cpp
   >```

4. [mod-solo-lfg:](https://github.com/azerothcore/mod-solo-lfg)
   *Allows for players to use dungeon finder solo or in groups less than and up to 5 players.*

	 ```bash
   git -C $HOME/azerothcore/modules clone https://github.com/azerothcore/mod-solo-lfg.git
   ```
   
   ```bash
   cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
   make -C $HOME/azerothcore/build/ -j $(nproc) install
   ```

5. [mod-solocraft:](https://github.com/azerothcore/mod-solocraft)
   *Корректирует статы игроков в рейдах в зависимости от количества игроков в группе*
   
   ```bash
   git -C $HOME/azerothcore/modules clone https://github.com/azerothcore/mod-solocraft.git
   ```
   
   ```bash
   cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
   make -C $HOME/azerothcore/build/ -j $(nproc) install
   ```

6. [mod-reagent-bank-account:](https://github.com/biosfree/mod-reagent-bank-account)

   *Этот модуль добавляет банкира реагентов, аналогичного более поздним расширениям WoW. Этот банкир может освободить место в сумке, храня реагенты для крафта для игроков. Версия для всех персонажей на аккаунте.*
   
   ```bash
   git -C $HOME/azerothcore/modules clone https://github.com/biosfree/mod-reagent-bank-account.git
   ```
   
   ```bash
   cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
   make -C $HOME/azerothcore/build/ -j $(nproc) install
   ```
   
   *Чтобы добавить reagent-bank-account NPC:*
   >С учетной записью GM зайдите в локацию, куда вы хотите добавить npc, и используйте эту команду:
   >
   >```lua
   >.npc add 290011
   >```

<!--
7. [mod-racial-trait-swap.git:](https://github.com/biosfree/mod-racial-trait-swap)
   *Racial-Trait NPC, that allows you, for a ingame cost of gold (configurable), to trade out your racial traits for another.*
   
   ```bash
   git -C ~/azerothcore/modules clone https://github.com/biosfree/mod-racial-trait-swap.git
   ```
   
   ```bash
   cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
   make -C $HOME/azerothcore/build/ -j $(nproc) install
   ```
   
   *Чтобы добавить racial-trait-swap NPC:*
   >С учетной записью GM зайдите в локацию, куда вы хотите добавить npc, и используйте эту команду:
   >
   >```lua
   >.npc add 98888
   >```
-->

7. [mod-gain-honor-guard:](https://github.com/azerothcore/mod-gain-honor-guard)
   *Этот модуль дает игрокам возможность фармить стражников и/или элиту для получения чести.*
   
   ```bash
   git -C $HOME/azerothcore/modules clone https://github.com/azerothcore/mod-gain-honor-guard.git
   ```
   
   ```bash
   cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
   make -C $HOME/azerothcore/build/ -j $(nproc) install
   ```

8. [mod-transmog:](https://github.com/azerothcore/mod-transmog)
   *Это модуль добавляет в игру возможность трансмогрификации на основе кода: [Rochet2 Transmog Script](http://rochet2.github.io/Transmogrification.html)*
      
   ```bash
   git -C $HOME/azerothcore/modules clone https://github.com/azerothcore/mod-transmog.git
   ```
   
   ```bash
   cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
   make -C $HOME/azerothcore/build/ -j $(nproc) install
   ```
      
   *Чтобы добавить reagent-bank-account NPC:*
   >С учетной записью GM зайдите в локацию, куда вы хотите добавить npc, и используйте эту команду:
   >
   >```lua
   >.npc add 190010
   >```

#### Установка допольнительных модулей при помощи `acore.sh` [:point_left:](#установка-дополнений-для-azerothcore-point_up_2)

>[!TIP]
>Так же модули можно устанавливать используюя `acore.sh` c префиксом `mi` (*module-install*) и `НАЗВАНИЕ МОДА`
>>*Название берём из [каталога AzerothCore](https://www.azerothcore.org/catalogue.html#/home)*
>
>*Например:*
>```bash
>azerothcore/acore.sh mi mod-eluna
>azerothcore/acore.sh mi mod-reagent-bank
>azerothcore/acore.sh mi mod-gain-honor-guard
>azerothcore/acore.sh mi mod-guildfunds
>azerothcore/acore.sh compiler build
>```
>
>```bash
>azerothcore/acore.sh mi mod-npc-beastmaster
>azerothcore/acore.sh compiler build
>```
>
>*Чтобы добавить beastmaster NPC:*
>>С учетной записью gm зайдите в локацию, куда вы хотите добавить npc, и используйте эту команду:
>>
>>```lua
>>.npc add 601026
>>```
>
>```bash
>azerothcore/acore.sh mi mod-profspecs
>azerothcore/acore.sh compiler build
>```
>
>*Чтобы добавить profspecs NPC:*
>>С учетной записью gm зайдите в локацию, куда вы хотите добавить npc, и используйте эту команду:
>>
>>```lua
>>.npc add 197761
>>```
>
>```bash
>azerothcore/acore.sh mi mod-transmog
>azerothcore/acore.sh compiler build
>```
>
>*Чтобы добавить transmog NPC:*
>>С учетной записью gm зайдите в локацию, куда вы хотите добавить npc, и используйте эту команду:
>>
>>```lua
>>.npc add 190010
>>```

### Установка дополнительных скриптов [:point_left:](#установка-дополнений-для-azerothcore-point_up_2)

### Внесение SQL правок в БД [:point_left:](#установка-дополнений-для-azerothcore-point_up_2)

https://github.com/azerothcore/portals-in-all-capitals
```bash
wget -P ~/azerothcore/data/sql/custom/db_world https://raw.githubusercontent.com/azerothcore/portals-in-all-capitals/main/portals-in-all-capitals.up.sql
```
https://github.com/AsgavinYT/hearthstone-cooldowns
```bash
wget -O ~/azerothcore/data/sql/custom/db_world/mod-hearthstone-5min.sql https://raw.githubusercontent.com/AsgavinYT/hearthstone-cooldowns/main/Hearthstone_5_Min.sql
```
>*Чтобы востановить значение по умольчанию (30 мин.):*
>```bash
>rm -f ~/azerothcore/data/sql/custom/db_world/mod-hearthstone-5min.sql
>wget -O ~/azerothcore/data/sql/custom/db_world/mod-hearthstone-30min.sql https://raw.githubusercontent.com/AsgavinYT/hearthstone-cooldowns/main/Hearthstone_30_Min.sql
>```
https://github.com/StraysFromPath/mod-rare-drops
```bash
wget -O ~/azerothcore/data/sql/custom/db_world/mod-rare-drops.sql https://raw.githubusercontent.com/StraysFromPath/mod-rare-drops/master/data/sql/db-world/updates/mod%20rare%20drops%20final.txt
```

## Первый запуск сервера [:point_up_2:](#установка--azerothcore-2024-rocket)

Создание файлов настроек для модулей
```bash
for i in $( ls ~/.local/etc/modules/*.dist ); do cp -n $i ${i%.*}; done
```

Первый запуск сервера для внисения обновлений и правок
```bash
worldserver
```

>[!TIP]
>*или используя `acore.sh`:*
>
>```bash
>~/azerothcore/acore.sh rw
>```

В консоле `worldserver` создаем нового пользователя с правами `GM` level 3
```lua
account create admin 'ВАШ-ДЛИННЫЙ-И-СЛОЖНЫЙ-ПАРОЛЬ'
account set gmlevel admin 3 -1
```

В консоле `worldserver` создаем нового пользователя для персонажа используемого аукционным ботом
```lua
account create ahbot 'ВАШ-ДЛИННЫЙ-И-СЛОЖНЫЙ-ПАРОЛЬ'
```

В консоле `worldserver` создаем нового пользователя для игровых персонажей
```lua
account create 'ИМЯ-АКАУНТА' 'ПАРОЛЬ'
```

Зауск сервера авторизации
```bash
authserver
```

>[!TIP]
>*или используя `acore.sh`:*
>
>```bash
>~/azerothcore/acore.sh ra
>```

## Настрока запуска сервера как службы [:point_up_2:](#установка--azerothcore-2024-rocket)

```bash
sudo nano /etc/systemd/system/auth.service
```

```ini
[Unit]
Description=AzerothCore Authserver
Requires=world.service
After=network.target world.service

[Service]
Type=simple
User=acore
WorkingDirectory=/home/acore/.local/bin
ExecStart=/home/acore/.local/bin/authserver
StartLimitIntervalSec=500
StartLimitBurst=5
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target
```

```bash
sudo nano /etc/systemd/system/world.service
```

```ini
[Unit]
Description=AzerothCore Worldserver
After=network.target mysql.service getty@tty3.service

[Service]
Type=simple
User=acore
StandardInput=tty
TTYPath=/dev/tty3
TTYReset=yes
TTYVHangup=yes
WorkingDirectory=/home/acore/.local/bin
ExecStart=/home/acore/.local/bin/worldserver
StartLimitIntervalSec=500
StartLimitBurst=5
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable auth world
sudo systemctl start world auth
```

### Поддержка сервера в актуальном состояние [:point_up_2:](#установка--azerothcore-2024-rocket)

Проверка обновлений ядра AzerothCore:
```bash
git -C $HOME/azerothcore pull origin master
```

Установка обновлений ядра AzerothCore:
```bash
cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
make -C $HOME/azerothcore/build/ -j $(nproc) install
```

Проверка обновлений модулей AzerothCore:
```bash
cd ~ && find ./azerothcore/modules -mindepth 1 -maxdepth 1 -type d -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;
```

Установка обновлений модулей AzerothCore:
```bash
cmake -B $HOME/azerothcore/build/ -S $HOME/azerothcore/
make -C $HOME/azerothcore/build/ -j $(nproc) install
```

