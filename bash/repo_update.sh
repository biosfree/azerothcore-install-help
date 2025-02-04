#!/bin/bash

# Настройки основных путей
CORE_DIR="$HOME/azerothcore"            # путь репозитория Azerothcore
INSTALL_DIR="$CORE_DIR/env/dist"        # путь установки сервера Azerothcore

# Настройки стандартных путей
MODULES_DIR="$CORE_DIR/modules"         # путь директории с модулям Azerothcore
BUILD_DIR="$CORE_DIR/build"             # путь сборки Azerothcore
LOG_DIR="$INSTALL_DIR/logs"             # путь логов этого скрипта

# Стандартные настройки сборки CMake
C_COMPILER="/usr/bin/clang"             # используемый компилятор С
CXX_COMPILER="/usr/bin/clang++"         # используемый компилятор С++
WITH_WARNINGS=1                         # показать все ошибки
TOOLS_BUILD="all"                       # компилировать дополнительные утилиты
SCRIPTS="static"                        # статичные скрипты
CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DCMAKE_C_COMPILER=$C_COMPILER -DCMAKE_CXX_COMPILER=$CXX_COMPILER -DWITH_WARNINGS=$WITH_WARNINGS -DTOOLS_BUILD=$TOOLS_BUILD -DSCRIPTS=$SCRIPTS"

# Настройки остановки сервера запущенного через сервисы или вручную
ALLOW_STOP_SERVER="true"                # Разрешить остановку сервера перед обновлением
SERVICES=("authserver" "worldserver")   # Компоненты сервера (сервисы/процессы)
PROCESS_GRACE_TIMEOUT=10                # Время ожидания корректного завершения (секунды)

# Настройки зависимостей необходимых для компиляции сервера
DEPENDENCIES_ALLOW_CHECK=true           # Разрешает проводить проверку зависимостей
DEPENDENCIES_SHOW_ALL=false             # Показывать все зависимости (false - только отсутствующие зависимости)
DEPENDENCIES_LIST=(                     # Список зависимостей
    git
    cmake
    make
    clang
    libssl-dev
    libbz2-dev
    libreadline-dev
    libncurses-dev
    libboost-all-dev
    mysql-server
    libmysqlclient-dev
)

# Цвета для вывода
CLR=(
    "\033[0m"    # 0 - сброс
    "\033[1;31m" # 1 - красный
    "\033[1;32m" # 2 - зеленый
    "\033[1;33m" # 3 - желтый
    "\033[1;34m" # 4 - синий
    "\033[1;35m" # 5 - пурпурный
    "\033[1;36m" # 6 - голубой
    "\033[0K"    # 7 - сброс конца строки
)

# Инициализация логов
mkdir -p "$LOG_DIR"
CMAKE_LOG="$LOG_DIR/cmake.log"
BUILD_OUTPUT_LOG="$LOG_DIR/build_output.log"
BUILD_ERRORS_LOG="$LOG_DIR/build_errors.log"

# Функция для получения версии через dpkg
get_version() {
    local dep=$1
    local version=""

    # Извлекаем версию и фильтруем до первого дефиса/не цифрового символа
    version=$(dpkg -s "$dep" 2>/dev/null | grep -i '^Version:' | awk '{print $2}' | sed -E 's/^[0-9]+://; s/[^0-9.].*$//')

    if [[ -n "$version" ]]; then
        echo "$version"
    else
        echo ""
    fi
}

# Функция для проверки зависимостей
check_dependencies() {
    if [[ "$DEPENDENCIES_ALLOW_CHECK" != "true" ]]; then
        print_msg 3 "Проверка зависимостей отключена."
        return
    fi

    print_msg 6 "Проверка зависимостей..."

    local all_ok=true
    for dep in "${DEPENDENCIES_LIST[@]}"; do
        # Проверяем наличие пакета
        if ! dpkg -s "$dep" &>/dev/null; then
            print_msg 1 "Ошибка: $dep не установлен."
            all_ok=false
        else
            # Получаем и форматируем версию
            local version=$(get_version "$dep")
            
            # Выводим информацию только если разрешено
            if [[ "$DEPENDENCIES_SHOW_ALL" == "true" ]]; then
                if [[ -n "$version" ]]; then
                    print_msg 2 "$dep: установлен (версия $version)"
                else
                    print_msg 2 "$dep: установлен"
                fi
            fi
        fi
    done

    if ! $all_ok; then
        print_msg 1 "Некоторые зависимости отсутствуют. Установите их и повторите попытку."
        exit 1
    fi

    [[ "$DEPENDENCIES_SHOW_ALL" == "true" ]] && print_msg 2 "Все зависимости проверены успешно."
}

# Функция для логирования с временными метками
log_with_timestamp() {
    local log_file="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] ${message}" >> "$log_file"
}

# Функция для форматирования времени
format_duration() {
    local duration=$1
    local hours=$(( duration / 3600 ))
    local remaining=$(( duration % 3600 ))
    local minutes=$(( remaining / 60 ))
    local seconds=$(( remaining % 60 ))

    local time_str=""

    # Добавляем часы, если они есть
    if [ $hours -gt 0 ]; then
        time_str+="${hours} ч."
    fi

    # Добавляем минуты, если они есть
    if [ $minutes -gt 0 ]; then
        # Добавляем пробел, если уже есть часы
        [ -n "$time_str" ] && time_str+=" "
        time_str+="${minutes} мин."
    fi

    # Добавляем секунды, если они есть или если время меньше минуты
    if { [ $seconds -gt 0 ] || [ $duration -eq 0 ] || [ -z "$time_str" ]; }; then
        # Добавляем пробел, если уже есть другие компоненты
        [ -n "$time_str" ] && time_str+=" "
        time_str+="${seconds} сек."
    fi

    echo "$time_str"
}

# Функция для вывода сообщений
print_msg() {
    local color="$1"
    local message="$2"
    [ -n "$message" ] && echo -e "${CLR[color]}>>> $message${CLR[0]}"
}

# Проверка ошибок
check_error() {
    if [ $? -ne 0 ]; then
        print_msg 1 "Ошибка при выполнении: $1"
        [ -f "$BUILD_ERRORS_LOG" ] && tail -n 5 "$BUILD_ERRORS_LOG"
        exit 1
    fi
}

# Функция проверки существования сервиса
service_exists() {
    local service="$1"
    systemctl list-unit-files --full --type=service | grep -q "^${service}\.service"
}

# Функция проверки активности сервиса
service_is_active() {
    local service="$1"
    systemctl is-active --quiet "$service" 2>/dev/null
}

# Функция остановки сервиса
stop_service() {
    local service="$1"
    if service_is_active "$service"; then
        print_msg 5 "Остановка сервиса ${service}..."
        sudo systemctl stop "$service" 2>/dev/null
        check_error "Остановка сервиса ${service}"
    fi
}

# Функция остановки процесса
stop_process() {
    local process_name="$1"
    local pids=$(pgrep -f "$process_name")
    
    if [ -n "$pids" ]; then
        print_msg 5 "Остановка процесса ${process_name}..."
        kill -TERM $pids 2>/dev/null
        
        local counter=0
        while kill -0 $pids 2>/dev/null && [ $counter -lt $PROCESS_GRACE_TIMEOUT ]; do
            sleep 1
            ((counter++))
        done
        
        if kill -0 $pids 2>/dev/null; then
            print_msg 3 "Принудительная остановка процесса ${process_name}..."
            kill -KILL $pids 2>/dev/null
        fi
    fi
}

# Управление остановкой сервера
manage_server_stop() {
    if [ "$ALLOW_STOP_SERVER" != "true" ]; then
        print_msg 3 "Остановка сервера отключена в настройках."
        return
    fi

    for component in "${SERVICES[@]}"; do
        # Сначала проверяем, запущен ли компонент как сервис
        if service_exists "$component"; then
            stop_service "$component"
        else
            # Если сервис не найден, проверяем, запущен ли процесс вручную
            if pgrep -f "$component" >/dev/null; then
                stop_process "$component"
            fi
        fi
    done
}

# Универсальный индикатор выполнения (процент или анимация)
show_progress() {
    local pid=$1
    local msg="$2"
    local log_file="$3"
    local delay=0.5
    local spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    
    while kill -0 $pid 2>/dev/null; do
        # Получаем последний процент из лога
        local last_line=$(tail -n 1 "$log_file" 2>/dev/null)
        local percent=$(echo "$last_line" | grep -oE '[0-9]{1,3}%')
        
        # Обновляем прогресс, если найден процент
        if [ -n "$percent" ]; then
            echo -ne "\r${CLR[5]}>>> $msg: ${CLR[3]}$percent${CLR[0]} "
        # Иначе показываем анимацию
        else
            for c in "${spin[@]}"; do
                kill -0 $pid 2>/dev/null || break
                echo -ne "\r${CLR[5]}>>> $msg $c ${CLR[0]}"
                sleep 0.1
            done
        fi
    done
    echo -ne "\r${CLR[7]}"
}

# Проверка обновлений
check_updates() {
    local repo_dir=$1
    local repo_name=$2
    
    git -C "$repo_dir" fetch origin --quiet
    check_error "git fetch в $repo_name"
    
    local count=$(git -C "$repo_dir" rev-list @..@{u} --count)
    if [ "$count" -gt 0 ]; then
        print_msg 3 "Обнаружены обновления в $repo_name: $count"
        return 0
    else
        return 1
    fi
}

# Основной процесс
check_dependencies
core_updated=false
modules_updated=false

# Проверка обновлений ядра
print_msg 6 "Проверка обновлений AzerothCore..."
if check_updates "$CORE_DIR" "AzerothCore"; then
    core_updated=true
    manage_server_stop  # Остановка сервера
    print_msg 4 "Применяем обновления ядра..."
    git -C "$CORE_DIR" pull origin master >/dev/null 2>&1
    check_error "git pull для AzerothCore"
fi

# Проверка обновлений модулей
start_time=$(date +%s)
print_msg 6 "Проверка обновлений модулей..."
for module in "$MODULES_DIR"/*; do
    if [ -d "$module/.git" ]; then
        module_name=$(basename "$module")
        if check_updates "$module" "$module_name"; then
            modules_updated=true
            print_msg 4 "Применяем обновления модуля $module_name..."
            git -C "$module" pull origin master >/dev/null 2>&1
            check_error "git pull для $module_name"
        fi
    fi
done
print_msg 4 "Этап завершен за $(format_duration "$(( $(date +%s) - start_time ))")"

# Запуск сборки при наличии обновлений
if $core_updated || $modules_updated; then
    print_msg 5 "Подготовка к сборке..."
    # Очистка старых логов
    > "$CMAKE_LOG"
    > "$BUILD_OUTPUT_LOG"
    > "$BUILD_ERRORS_LOG"

    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR" || exit 1

    # Запуск CMake с логированием
    start_time=$(date +%s)
    print_msg 6 "Конфигурация сборки..."
    cmake "$CORE_DIR" $CMAKE_FLAGS > >(while IFS= read -r line; do log_with_timestamp "$CMAKE_LOG" "$line"; done) 2>&1 &
    cmake_pid=$!
    show_progress $cmake_pid "Конфигурация сборки" "$CMAKE_LOG"
    wait $cmake_pid
    check_error "CMake"
    print_msg 4 "Этап завершен за $(format_duration "$(( $(date +%s) - start_time ))")"

    # Анализ логов CMake
    grep --color=auto -iE 'error|warning' "$CMAKE_LOG" | \
        grep -vE \
        -e 'All warnings enabled' \
        -e 'Show all warnings' \
        -e '^--' \
        -e '^[*]' \
        -e 'ok!$' \
        -e 'default' \
        | head -n 5

    # Компиляция
    start_time=$(date +%s)
    print_msg 6 "Компиляция исходного кода..."
    make -j$(($(nproc)-1)) > >(while IFS= read -r line; do log_with_timestamp "$BUILD_OUTPUT_LOG" "$line"; done) 2> >(while IFS= read -r line; do log_with_timestamp "$BUILD_ERRORS_LOG" "$line"; done) &
    make_pid=$!
    show_progress $make_pid "Компиляция исходного кода" "$BUILD_OUTPUT_LOG"
    wait $make_pid
    check_error "Сборка"
    print_msg 4 "Этап завершен за $(format_duration "$(( $(date +%s) - start_time ))")"

    # Установка
    start_time=$(date +%s)
    print_msg 6 "Установка собранных файлов..."
    make install > >(while IFS= read -r line; do log_with_timestamp "$BUILD_OUTPUT_LOG" "$line"; done) 2> >(while IFS= read -r line; do log_with_timestamp "$BUILD_ERRORS_LOG" "$line"; done) &
    install_pid=$!
    show_progress $install_pid "Установка собранных файлов" "$BUILD_OUTPUT_LOG"
    wait $install_pid
    check_error "Установка"
    print_msg 4 "Этап завершен за $(format_duration "$(( $(date +%s) - start_time ))")"

    # Проверка результатов
    print_msg 6 "Проверка результатов сборки:"
    if [ -f "$INSTALL_DIR/bin/authserver" ] && [ -f "$INSTALL_DIR/bin/worldserver" ]; then
        print_msg 2 "Успешно установлены:"
        ls -lh "$INSTALL_DIR/bin/" | grep -E 'authserver|worldserver'
    else
        print_msg 1 "Критическая ошибка: бинарники не найдены!"
        exit 1
    fi

    print_msg 2 "Сборка успешно завершена!"
    print_msg 6 "Логи процесса доступны в: $LOG_DIR"
else
    print_msg 2 "Обновления не обнаружены. Сборка не требуется."
fi
