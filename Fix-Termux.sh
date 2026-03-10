#!/bin/bash
# Fix-Termux.sh — Автоматическая настройка Termux и Linux
# Автор: Ahmed Alaa
# Fixed & Refactored by Qwen Code
# Версия: 2.1

################################################################################
# ПОДКЛЮЧЕНИЕ КОНФИГУРАЦИИ
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/config.sh" ]; then
    source "$SCRIPT_DIR/config.sh"
fi

# Резервные значения если конфиг не загружен
VERSION="${VERSION:-2.1}"
LOG_FILE="${LOG_FILE:-$HOME/fix-termux.log}"
REQUIRED_SPACE_MB="${REQUIRED_SPACE_MB:-2048}"

################################################################################
# ЦВЕТА
################################################################################

red='\e[1;31m'
green='\e[1;32m'
blue='\e[1;34m'
purple='\e[1;35m'
cyan='\e[1;36m'
white='\e[1;37m'
yellow='\e[1;33m'
bold='\e[1;1m'
reset='\e[0m'

################################################################################
# ЛОГИРОВАНИЕ
################################################################################

log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

log_info() { log "INFO" "$1"; }
log_error() { log "ERROR" "$1"; }
log_success() { log "SUCCESS" "$1"; }

################################################################################
# ПРОВЕРКИ
################################################################################

check_root() {
    if [ "$(id -u)" -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

check_storage() {
    local available_kb=$(df -k "$HOME" | tail -1 | awk '{print $4}')
    local available_mb=$((available_kb / 1024))
    
    if [ $available_mb -lt $REQUIRED_SPACE_MB ]; then
        echo -e "${red}❌ Недостаточно места! Требуется минимум ${REQUIRED_SPACE_MB}MB${reset}"
        echo -e "${yellow}📊 Доступно: ${available_mb}MB${reset}"
        log_error "Недостаточно места: ${available_mb}MB (требуется ${REQUIRED_SPACE_MB}MB)"
        return 1
    fi
    
    log_info "Проверка места: ${available_mb}MB доступно"
    return 0
}

check_connection() {
    if ping -c 1 -W 5 google.com > /dev/null 2>&1; then
        log_info "Интернет-соединение: OK"
        return 0
    else
        echo -e "${red}❌ Нет интернет-соединения!${reset}"
        log_error "Нет интернет-соединения"
        return 1
    fi
}

check_termux_version() {
    echo -e "${cyan}📱 Проверка версии Termux...${reset}"

    if command -v pkg &> /dev/null; then
        local termux_version=$(pkg --version 2>&1 | head -1)
        echo -e "  ${green}✓${reset} Termux: ${bold}${termux_version}${reset}"
        log_info "Termux версия: $termux_version"
        return 0
    else
        echo -e "  ${yellow}⚠️${reset} Termux не найден (pkg не доступен)"
        log_warning "Termux не найден"
        return 1
    fi
}

check_android_version() {
    echo -e "${cyan}🤖 Проверка версии Android...${reset}"

    if [ -f /system/build.prop ]; then
        local android_version=$(grep "ro.build.version.release" /system/build.prop 2>/dev/null | cut -d'=' -f2)
        local android_sdk=$(grep "ro.build.version.sdk" /system/build.prop 2>/dev/null | cut -d'=' -f2)
        echo -e "  ${green}✓${reset} Android: ${bold}${android_version:-Unknown}${reset} (SDK ${android_sdk:-?})"
        log_info "Android версия: $android_version (SDK $android_sdk)"

        # Проверка минимальной версии
        if [ -n "$android_sdk" ] && [ "$android_sdk" -lt 21 ]; then
            echo -e "  ${red}❌ Android слишком старый! Требуется Android 5.0+ (SDK 21+)${reset}"
            log_error "Android слишком старый: SDK $android_sdk"
            return 1
        fi
        return 0
    elif [ -f /system/properties/build.prop ]; then
        local android_version=$(getprop ro.build.version.release 2>/dev/null)
        local android_sdk=$(getprop ro.build.version.sdk 2>/dev/null)
        echo -e "  ${green}✓${reset} Android: ${bold}${android_version:-Unknown}${reset} (SDK ${android_sdk:-?})"
        log_info "Android версия: $android_version (SDK $android_sdk)"
        return 0
    else
        # Попытка через getprop
        local android_version=$(getprop ro.build.version.release 2>/dev/null)
        local android_sdk=$(getprop ro.build.version.sdk 2>/dev/null)
        if [ -n "$android_version" ]; then
            echo -e "  ${green}✓${reset} Android: ${bold}${android_version}${reset} (SDK ${android_sdk:-?})"
            log_info "Android версия: $android_version (SDK $android_sdk)"
            return 0
        fi
        echo -e "  ${yellow}⚠️${reset} Не удалось определить версию Android"
        log_warning "Не удалось определить версию Android"
        return 1
    fi
}

check_root_status() {
    echo -e "${cyan}🔒 Проверка root-прав...${reset}"

    if [ "$(id -u)" -eq 0 ]; then
        echo -e "  ${green}✓${reset} Root: ${bold}доступен${reset}"
        log_info "Root права: доступны"
        return 0
    else
        echo -e "  ${yellow}⚠️${reset} Root: ${bold}не доступен${reset} (некоторые функции могут не работать)"
        log_info "Root права: не доступны"
        return 1
    fi
}

check_compatibility() {
    echo -e "${bold}${blue}🔍 Проверка совместимости...${reset}"
    echo ""

    local issues=0

    # Проверка Termux
    check_termux_version || issues=$((issues + 1))

    # Проверка Android
    check_android_version || issues=$((issues + 1))

    # Проверка root (не критично)
    check_root_status

    # Проверка места на диске
    check_storage || issues=$((issues + 1))

    # Проверка интернета
    check_connection || issues=$((issues + 1))

    echo ""
    if [ $issues -gt 0 ]; then
        echo -e "${yellow}⚠️  Найдено проблем: $issues${reset}"
        echo -e "${white}   Некоторые функции могут работать некорректно.${reset}"
        log_warning "Проверка совместимости: $issues проблем"
    else
        echo -e "${green}✅ Все проверки пройдены!${reset}"
        log_success "Проверка совместимости: OK"
    fi

    return 0
}

################################################################################
# УТИЛИТЫ
################################################################################

print_header() {
    clear
    echo -e "${green}╔════════════════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${green}║${reset}                    ${bold}Fix-Termux v${VERSION}${reset}                                ${green}║${reset}"
    echo -e "${green}║${reset}              ${cyan}Автоматическая настройка Termux и Linux${reset}                    ${green}║${reset}"
    echo -e "${green}╚════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo ""
}

print_banner() {
    echo -e "${green}╔════════════════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${green}║${reset}                                                                                ${green}║${reset}"
    echo -e "${green}║${reset}   ${yellow}██╗${reset}  ${yellow}██╗${reset} ██████╗ ███████╗██╗   ██╗${blue}██╗      █████╗ ████████╗██╗ ██████╗ ███╗   ██╗${reset}    ${green}║${reset}"
    echo -e "${green}║${reset}   ${yellow}██║${reset} ${yellow}██╔╝${reset} ██╔══██╗██╔════╝██║   ██║${blue}██║     ██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║${reset}    ${green}║${reset}"
    echo -e "${green}║${reset}   ${yellow}█████╔╝${reset}  ██████╔╝█████╗  ██║   ██║${blue}██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║${reset}    ${green}║${reset}"
    echo -e "${green}║${reset}   ${yellow}██╔═██╗${reset}  ██╔══██╗██╔══╝  ██║   ██║${blue}██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║${reset}    ${green}║${reset}"
    echo -e "${green}║${reset}   ${yellow}██║  ██╗${reset}██║  ██║███████╗╚██████╔╝${blue}███████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║${reset}    ${green}║${reset}"
    echo -e "${green}║${reset}   ${yellow}╚═╝  ╚═╝${reset}╚═╝  ╚═╝╚══════╝ ╚═════╝ ${blue}╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝${reset}    ${green}║${reset}"
    echo -e "${green}║${reset}                                                                                ${green}║${reset}"
    echo -e "${green}║${reset}                          ${purple}Haram-Masr Team${reset}                              ${green}║${reset}"
    echo -e "${green}╚════════════════════════════════════════════════════════════════════════════╝${reset}"
    echo ""
}

install_package() {
    local pkg="$1"
    local manager="$2"

    # Тестовый режим
    if [ "$DRY_RUN" = true ]; then
        echo -ne "${cyan}📦 [DRY-RUN] Установка ${yellow}${pkg}${reset}... "
        echo -e "${yellow}⊘${reset}"
        return 0
    fi

    echo -ne "${cyan}📦 Установка ${yellow}${pkg}${reset}... "

    if [ "$manager" = "pkg" ]; then
        pkg install "$pkg" -y >> "$LOG_FILE" 2>&1
    elif [ "$manager" = "apt" ]; then
        apt install "$pkg" -y >> "$LOG_FILE" 2>&1
    elif [ "$manager" = "pip" ]; then
        pip install "$pkg" >> "$LOG_FILE" 2>&1
    elif [ "$manager" = "gem" ]; then
        gem install "$pkg" >> "$LOG_FILE" 2>&1
    fi

    if [ $? -eq 0 ]; then
        echo -e "${green}✓${reset}"
        PACKAGES_INSTALLED=$((PACKAGES_INSTALLED + 1))
        log_success "Установлен пакет: $pkg ($manager)"
        return 0
    else
        echo -e "${red}✗${reset}"
        PACKAGES_FAILED=$((PACKAGES_FAILED + 1))
        log_error "Ошибка установки пакета: $pkg ($manager)"
        return 1
    fi
}

clone_repo() {
    local url="$1"
    local name="$2"

    # Тестовый режим
    if [ "$DRY_RUN" = true ]; then
        echo -ne "${cyan}📥 [DRY-RUN] Клонирование ${yellow}${name}${reset}... "
        echo -e "${yellow}⊘${reset}"
        return 0
    fi

    echo -ne "${cyan}📥 Клонирование ${yellow}${name}${reset}... "

    if git clone "$url" >> "$LOG_FILE" 2>&1; then
        echo -e "${green}✓${reset}"
        REPOS_CLONED=$((REPOS_CLONED + 1))
        log_success "Склонирован репозиторий: $name"
        return 0
    else
        echo -e "${red}✗${reset}"
        log_error "Ошибка клонирования репозитория: $name"
        return 1
    fi
}

run_command() {
    local cmd="$1"
    local description="$2"

    # Тестовый режим
    if [ "$DRY_RUN" = true ]; then
        echo -ne "${cyan}⚙️  [DRY-RUN] ${description}${reset}... "
        echo -e "${yellow}⊘${reset}"
        return 0
    fi

    echo -ne "${cyan}⚙️  ${description}${reset}... "

    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        echo -e "${green}✓${reset}"
        COMMANDS_EXECUTED=$((COMMANDS_EXECUTED + 1))
        log_success "Выполнено: $description"
        return 0
    else
        echo -e "${red}✗${reset}"
        log_error "Ошибка выполнения: $description"
        return 1
    fi
}

################################################################################
# ФУНКЦИИ УСТАНОВКИ (ОПЦИИ)
################################################################################

install_linux_gnuroot() {
    log_info "=== Начало установки: Linux & Gnuroot ==="
    
    echo -e "${bold}${blue}📋 Установка базовых пакетов для Linux/Gnuroot...${reset}"
    echo ""
    
    install_package "figlet" "apt"
    install_package "git" "apt"
    install_package "wget" "apt"
    install_package "toilet" "apt"
    install_package "lolcat" "apt"
    install_package "ruby" "apt"
    install_package "nano" "apt"
    install_package "termux-api" "apt"
    
    run_command "gem install figlet" "Установка figlet gem"
    install_package "youtube-dl" "pip"
    
    echo ""
    echo -e "${green}✅ Установка Linux & Gnuroot завершена!${reset}"
    log_success "=== Завершена установка: Linux & Gnuroot ==="
}

install_termux() {
    log_info "=== Начало установки: Termux ==="
    
    echo -e "${bold}${blue}📋 Полная настройка Termux...${reset}"
    echo ""
    
    # Обновление
    run_command "apt update && apt upgrade -y" "Обновление пакетов"
    
    # Базовые инструменты
    echo -e "${yellow}📦 Базовые инструменты:${reset}"
    install_package "git" "pkg"
    install_package "python" "pkg"
    install_package "python2" "pkg"
    install_package "wget" "pkg"
    install_package "nano" "pkg"
    install_package "curl" "pkg"
    
    # Развлекательные
    echo -e "${yellow}🎭 Развлекательные:${reset}"
    install_package "figlet" "pkg"
    install_package "toilet" "pkg"
    install_package "cmatrix" "pkg"
    install_package "cowsay" "pkg"
    
    # Языки программирования
    echo -e "${yellow}💻 Языки программирования:${reset}"
    install_package "ruby" "pkg"
    install_package "golang" "pkg"
    install_package "php" "pkg"
    install_package "clang" "pkg"
    
    # Инструменты для пентестинга
    echo -e "${yellow}🔐 Инструменты для пентестинга:${reset}"
    run_command "pkg install root-repo unstable-repo x11-repo -y" "Подключение репозиториев"
    install_package "tor" "pkg"
    
    # Системные утилиты
    echo -e "${yellow}🔧 Системные утилиты:${reset}"
    install_package "openssh" "pkg"
    install_package "unzip" "pkg"
    install_package "zip" "pkg"
    install_package "unrar" "pkg"
    install_package "tar" "pkg"
    install_package "ncurses-utils" "pkg"
    install_package "net-tools" "pkg"
    install_package "w3m" "pkg"
    install_package "proot" "pkg"
    install_package "locate" "pkg"
    install_package "mariadb" "pkg"
    install_package "man" "pkg"
    install_package "texinfo" "pkg"
    install_package "graphviz" "pkg"
    install_package "tty-clock" "pkg"
    
    # Python библиотеки
    echo -e "${yellow}🐍 Python библиотеки:${reset}"
    run_command "pip install --upgrade pip" "Обновление pip"
    install_package "youtube-dl" "pip"
    install_package "wordlist" "pip"
    install_package "requests" "pip"
    install_package "mechanize" "pip"
    install_package "argument" "pip"
    
    # Ruby gem
    echo -e "${yellow}💎 Ruby gem:${reset}"
    run_command "gem install figlet" "Установка figlet"
    run_command "gem install bundler" "Установка bundler"
    
    echo ""
    echo -e "${green}✅ Полная настройка Termux завершена!${reset}"
    log_success "=== Завершена установка: Termux ==="
}

install_metasploit() {
    log_info "=== Начало установки: Metasploit ==="
    
    echo -e "${bold}${blue}📋 Установка Metasploit Framework...${reset}"
    echo ""
    
    run_command "cd \$HOME" "Переход в домашнюю директорию"
    install_package "unstable-repo" "pkg"
    install_package "metasploit" "pkg"
    run_command "apt -f install -y" "Исправление зависимостей"
    
    echo ""
    echo -e "${green}✅ Metasploit установлен!${reset}"
    echo -e "${yellow}📝 Запуск: msfconsole${reset}"
    log_success "=== Завершена установка: Metasploit ==="
}

install_kali_info_gathering() {
    log_info "=== Начало установки: Kali Information Gathering ==="
    
    echo -e "${bold}${blue}📋 Установка инструментов разведки для Kali...${reset}"
    echo ""
    
    # Пакеты
    echo -e "${yellow}📦 Базовые инструменты:${reset}"
    apt install -y ace apt2 arp-scan bing-ip2hosts braa maltego >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y cdpsnarf cisco-torch dmitry >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y dnsenum dnsmap dnsrecon dnstracer dnswalk >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y dotdotpwn enum4linux enumiax >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y faraday fierce firewalk >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y goofile hping3 ident-user-enum inspy intrace ismtp lbd >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y masscan metagoofil nbtscan-unixwiz nikto >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y p0f parsero recon-ng >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y smbmap smtp-user-enum >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y sslsplit sublist3r theharvester tlssled twofi >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y unicornscan urlcrazy wireshark >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    
    # Git репозитории
    echo -e "${yellow}📥 Git репозитории:${reset}"
    clone_repo "https://github.com/pro-root/dnmap" "dnmap"
    clone_repo "https://github.com/FortyNorthSecurity/EyeWitness.git" "EyeWitness"
    clone_repo "https://github.com/savio-code/ghost-phisher.git" "ghost-phisher"
    clone_repo "https://github.com/golismero/golismero.git" "golismero"
    clone_repo "https://github.com/i3visio/osrframework.git" "osrframework"
    clone_repo "https://github.com/trustedsec/social-engineer-toolkit.git" "SET"
    clone_repo "https://github.com/secforce/sparta.git" "sparta"
    clone_repo "-b release_1_0 https://github.com/grwl/sslcaudit.git" "sslcaudit"
    
    echo ""
    echo -e "${green}✅ Инструменты разведки установлены!${reset}"
    log_success "=== Завершена установка: Kali Information Gathering ==="
}

install_ngrok() {
    log_info "=== Начало установки: Ngrok ==="
    
    echo -e "${bold}${blue}📋 Установка Ngrok...${reset}"
    echo ""
    
    # Загрузка ngrok
    echo -ne "${cyan}📥 Загрузка ngrok${reset}... "
    if command -v wget &> /dev/null; then
        wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz -O /tmp/ngrok.tgz >> "$LOG_FILE" 2>&1
        if [ $? -eq 0 ]; then
            echo -e "${green}✓${reset}"
            log_success "ngrok загружен"
            
            echo -ne "${cyan}📦 Распаковка${reset}... "
            tar -xzf /tmp/ngrok.tgz -C /tmp >> "$LOG_FILE" 2>&1
            if [ $? -eq 0 ]; then
                echo -e "${green}✓${reset}"
                
                echo -ne "${cyan}📦 Установка${reset}... "
                mv /tmp/ngrok /usr/local/bin/ >> "$LOG_FILE" 2>&1
                if [ $? -eq 0 ]; then
                    echo -e "${green}✓${reset}"
                    echo ""
                    echo -e "${green}✅ Ngrok установлен!${reset}"
                    echo -e "${yellow}📝 Зарегистрируйтесь на ngrok.io для получения токена${reset}"
                    log_success "=== Завершена установка: Ngrok ==="
                    return 0
                fi
            fi
        fi
    fi
    
    echo -e "${red}✗${reset}"
    log_error "Ошибка установки ngrok"
    echo -e "${red}❌ Ошибка установки ngrok${reset}"
}

install_termux_alpine() {
    log_info "=== Начало установки: Termux-Alpine ==="
    
    echo -e "${bold}${blue}📋 Установка Alpine Linux в Termux...${reset}"
    echo ""
    
    install_package "curl" "pkg"
    install_package "proot" "pkg"
    install_package "wget" "pkg"
    install_package "ruby" "pkg"
    
    echo -ne "${cyan}📥 Загрузка скрипта TermuxAlpine${reset}... "
    cd "$HOME"
    if curl -LO https://raw.githubusercontent.com/Hax4us/TermuxAlpine/master/TermuxAlpine.sh >> "$LOG_FILE" 2>&1; then
        echo -e "${green}✓${reset}"
        
        echo -ne "${cyan}⚙️  Настройка прав${reset}... "
        chmod 777 TermuxAlpine.sh
        echo -e "${green}✓${reset}"
        
        echo -ne "${cyan}🚀 Запуск установки${reset}... "
        ./TermuxAlpine.sh >> "$LOG_FILE" 2>&1
        if [ $? -eq 0 ]; then
            echo -e "${green}✓${reset}"
            echo ""
            echo -e "${green}✅ Alpine Linux установлен!${reset}"
            echo -e "${yellow}📝 Запуск: startalpine${reset}"
            log_success "=== Завершена установка: Termux-Alpine ==="
        else
            echo -e "${red}✗${reset}"
            log_error "Ошибка установки Alpine"
        fi
    else
        echo -e "${red}✗${reset}"
        log_error "Ошибка загрузки скрипта Alpine"
    fi
}

install_termux_fedora() {
    log_info "=== Начало установки: Termux-Fedora ==="

    echo -e "${bold}${blue}📋 Установка Fedora в Termux...${reset}"
    echo ""

    install_package "proot" "pkg"
    install_package "wget" "pkg"

    echo -ne "${cyan}📥 Загрузка скрипта${reset}... "
    cd "$HOME"
    if wget -O fedora.sh https://raw.githubusercontent.com/nmulasmajic/Proot-Distro/master/fedora.sh >> "$LOG_FILE" 2>&1; then
        echo -e "${green}✓${reset}"
        chmod +x fedora.sh
        echo -e "${green}✅ Fedora установлен!${reset}"
        echo -e "${yellow}📝 Запуск: ./fedora.sh${reset}"
        log_success "=== Завершена установка: Termux-Fedora ==="
    else
        echo -e "${red}✗${reset}"
        log_error "Ошибка загрузки скрипта Fedora"
        echo -e "${red}❌ Ошибка установки Fedora${reset}"
    fi
}

install_web_scraping() {
    log_info "=== Начало установки: Web Scraping Tools ==="

    echo -e "${bold}${blue}📋 Установка инструментов для Web Scraping...${reset}"
    echo ""

    # Python и pip
    echo -e "${yellow}🐍 Python и библиотеки:${reset}"
    install_package "python" "pkg"
    install_package "python3" "pkg"

    run_command "pip install --upgrade pip" "Обновление pip"
    install_package "requests" "pip"
    install_package "beautifulsoup4" "pip"
    install_package "lxml" "pip"
    install_package "selenium" "pip"
    install_package "scrapy" "pip"
    install_package "urllib3" "pip"
    install_package "httpx" "pip"
    install_package "aiohttp" "pip"
    install_package "fake-useragent" "pip"
    install_package "retrying" "pip"

    # Node.js
    echo -e "${yellow}📦 Node.js и пакеты:${reset}"
    install_package "nodejs" "pkg"
    install_package "npm" "pkg"

    run_command "npm install -g puppeteer" "Установка puppeteer"
    run_command "npm install -g cheerio" "Установка cheerio"

    echo ""
    echo -e "${green}✅ Web Scraping Tools установлены!${reset}"
    log_success "=== Завершена установка: Web Scraping Tools ==="
}

install_wifi_tools() {
    log_info "=== Начало установки: WiFi Tools ==="

    echo -e "${bold}${blue}📋 Установка WiFi инструментов...${reset}"
    echo ""

    # Проверка root
    if ! check_root; then
        echo -e "${red}⚠️  Требуется root-доступ для WiFi инструментов!${reset}"
        echo -e "${yellow}Продолжить без root? (некоторые функции не будут работать)${reset}"
        read -p "[y/N]: " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            log_info "Пользователь отменил установку WiFi Tools"
            return 1
        fi
    fi

    # Основные WiFi инструменты
    echo -e "${yellow}📡 WiFi инструменты:${reset}"
    apt install -y aircrack-ng reaver bully pixiewps >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y hashcat cowpatty wifite kismet >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    apt install -y wireshark tcpdump tshark >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"

    # Дополнительные инструменты
    echo -e "${yellow}🔧 Дополнительные инструменты:${reset}"
    apt install -y macchanger iw wireless-tools crda >> "$LOG_FILE" 2>&1 && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"

    echo ""
    echo -e "${green}✅ WiFi Tools установлены!${reset}"
    echo -e "${yellow}📝 Примечание: Для работы требуется root и беспроводной адаптер${reset}"
    log_success "=== Завершена установка: WiFi Tools ==="
}

################################################################################
# ПРОФИЛИ УСТАНОВКИ
################################################################################

install_profile() {
    local profile_name="$1"
    local -n profile_array=$2

    echo -e "${bold}${blue}📦 Установка профиля: ${cyan}${profile_name}${reset}"
    echo ""

    if [ ${#profile_array[@]} -eq 0 ]; then
        echo -e "${red}❌ Профиль пуст${reset}"
        return 1
    fi

    echo -e "${white}   Пакетов: ${#profile_array[@]}${reset}"
    echo -e "${white}   Режим: ${DRY_RUN}${reset}"
    echo ""

    # Создание backup
    if [ "$ENABLE_BACKUP" = true ] && [ "$DRY_RUN" = false ]; then
        create_backup
    fi

    # Сброс счётчиков
    PACKAGES_INSTALLED=0
    PACKAGES_FAILED=0

    # Установка пакетов
    local count=0
    for pkg in "${profile_array[@]}"; do
        count=$((count + 1))
        echo -ne "${cyan}[$count/${#profile_array[@]}]${reset} "
        install_package "$pkg" "pkg"
    done

    echo ""
    echo -e "${green}✅ Профиль '${profile_name}' установлен!${reset}"
    echo -e "${white}   Установлено: ${PACKAGES_INSTALLED}${reset}"
    echo -e "${red}   Ошибок: ${PACKAGES_FAILED}${reset}"
    log_success "Установлен профиль: $profile_name"
}

show_profiles_menu() {
    echo ""
    echo -e "${bold}${white}╭────────────────────────────────────────────────────────────────────────────╮${reset}"
    echo -e "${bold}${white}│${reset}  ${yellow}📦 ПРОФИЛИ УСТАНОВКИ${reset}                                                ${bold}${white}│${reset}"
    echo -e "${bold}${white}╰────────────────────────────────────────────────────────────────────────────╯${reset}"
    echo ""
    echo -e "  ${green}1${reset}) ${cyan}📌${reset} Minimal     ${white}— Базовые инструменты (~50MB)${reset}"
    echo -e "  ${green}2${reset}) ${yellow}📦${reset} Standard    ${white}— Популярные инструменты (~200MB)${reset}"
    echo -e "  ${green}3${reset}) ${blue}🚀${reset} Full        ${white}— Полная установка (~500MB)${reset}"
    echo -e "  ${green}4${reset}) ${red}🔓${reset} Pentest     ${white}— Инструменты для пентестинга (~800MB)${reset}"
    echo ""
    echo -e "  ${white}Выберите профиль:${reset}"
    echo -ne "  [1/2/3/4/B (назад)]: "
    read profile_choice

    case $profile_choice in
        1)
            install_profile "Minimal" PROFILE_MINIMAL
            ;;
        2)
            install_profile "Standard" PROFILE_STANDARD
            ;;
        3)
            install_profile "Full" PROFILE_FULL
            ;;
        4)
            install_profile "Pentest" PROFILE_PENTEST
            ;;
        [Bb])
            return
            ;;
        *)
            echo -e "${red}❌ Неверный выбор${reset}"
            ;;
    esac

    echo ""
    echo -ne "${yellow}⏎ Нажмите Enter для продолжения...${reset}"
    read
}

################################################################################
# ПОДТВЕРЖДЕНИЕ И СТАТИСТИКА
################################################################################

restore_from_backup() {
    local backup_dir="$1"

    echo -e "${bold}${blue}📦 Восстановление из backup...${reset}"
    echo ""

    if [ ! -d "$backup_dir" ]; then
        echo -e "${red}❌ Backup директория не найдена: $backup_dir${reset}"
        return 1
    fi

    # Проверка файлов backup
    if [ ! -f "$backup_dir/pkg-installed.txt" ]; then
        echo -e "${red}❌ Файл pkg-installed.txt не найден${reset}"
        return 1
    fi

    echo -e "${yellow}⚠️  Внимание: Это переустановит все пакеты из backup!${reset}"
    echo -e "${white}   Это может занять много времени.${reset}"
    echo ""
    echo -ne "${green}   Продолжить? [y/N]: ${reset}"
    read confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${cyan}❌ Отменено пользователем${reset}"
        return 0
    fi

    # Восстановление pkg пакетов
    echo ""
    echo -e "${yellow}📦 Восстановление pkg пакетов...${reset}"
    if [ -f "$backup_dir/pkg-installed.txt" ]; then
        local count=0
        while IFS= read -r line; do
            if [[ "$line" =~ ^pkg/ ]]; then
                local pkg_name=$(echo "$line" | cut -d'/' -f2 | cut -d' ' -f1)
                if [ -n "$pkg_name" ]; then
                    echo -ne "  Installing $pkg_name... "
                    if pkg install "$pkg_name" -y >> "$LOG_FILE" 2>&1; then
                        echo -e "${green}✓${reset}"
                        count=$((count + 1))
                    else
                        echo -e "${red}✗${reset}"
                    fi
                fi
            fi
        done < "$backup_dir/pkg-installed.txt"
        echo -e "${green}✅ Установлено пакетов: $count${reset}"
    fi

    # Восстановление pip пакетов
    echo ""
    echo -e "${yellow}🐍 Восстановление pip пакетов...${reset}"
    if [ -f "$backup_dir/pip-installed.txt" ]; then
        local count=0
        while IFS= read -r line; do
            local pkg_name=$(echo "$line" | awk '{print $1}')
            if [ -n "$pkg_name" ] && [[ ! "$pkg_name" =~ ^(Package|-----) ]]; then
                echo -ne "  Installing $pkg_name... "
                if pip install "$pkg_name" >> "$LOG_FILE" 2>&1; then
                    echo -e "${green}✓${reset}"
                    count=$((count + 1))
                else
                    echo -e "${red}✗${reset}"
                fi
            fi
        done < "$backup_dir/pip-installed.txt"
        echo -e "${green}✅ Установлено pip пакетов: $count${reset}"
    fi

    # Восстановление конфигов
    echo ""
    echo -e "${yellow}⚙️  Восстановление конфигов...${reset}"
    if [ -d "$backup_dir/.termux" ]; then
        cp -r "$backup_dir/.termux" "$HOME/" 2>/dev/null && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    else
        echo -e "${yellow}⊘ Конфиги не найдены${reset}"
    fi

    echo ""
    echo -e "${green}✅ Восстановление завершено!${reset}"
    echo -e "${white}   Рекомендуется перезапустить Termux.${reset}"
    log_success "Восстановление из backup: $backup_dir"
}

list_backups() {
    echo ""
    echo -e "${bold}${blue}📦 Доступные backup:${reset}"
    echo ""

    local backups=($(ls -dt $HOME/fix-termux-backup-* 2>/dev/null))

    if [ ${#backups[@]} -eq 0 ]; then
        echo -e "${yellow}⊘ Backup не найдены${reset}"
        return
    fi

    local i=1
    for backup in "${backups[@]}"; do
        local backup_name=$(basename "$backup")
        local backup_date=$(echo "$backup_name" | sed 's/fix-termux-backup-//')
        echo -e "  ${green}$i${reset}) ${cyan}$backup_name${reset} — $backup_date"

        # Показываем размер
        if [ -f "$backup/pkg-installed.txt" ]; then
            local pkg_count=$(wc -l < "$backup/pkg-installed.txt")
            echo -e "     📦 Пакетов: $pkg_count"
        fi

        i=$((i + 1))
    done

    echo ""
    echo -ne "${white}Выберите backup для восстановления (0 для отмены): ${reset}"
    read choice

    if [ "$choice" = "0" ]; then
        return
    fi

    local selected=$((choice - 1))
    if [ $selected -ge 0 ] && [ $selected -lt ${#backups[@]} ]; then
        restore_from_backup "${backups[$selected]}"
    else
        echo -e "${red}❌ Неверный выбор${reset}"
    fi
}

create_backup() {
    local backup_dir="$HOME/fix-termux-backup-$(date +%Y%m%d-%H%M%S)"

    echo -e "${cyan}📦 Создание backup...${reset}"

    if [ "$DRY_RUN" = true ]; then
        echo -e "${yellow}⊘ [DRY-RUN] Backup не создаётся${reset}"
        return 0
    fi

    mkdir -p "$backup_dir" >> "$LOG_FILE" 2>&1

    # Backup списков пакетов
    echo -ne "  📋 pkg list... "
    pkg list --installed 2>/dev/null > "$backup_dir/pkg-installed.txt" && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"

    echo -ne "  📋 apt list... "
    apt list --installed 2>/dev/null > "$backup_dir/apt-installed.txt" && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"

    echo -ne "  📋 pip list... "
    pip list 2>/dev/null > "$backup_dir/pip-installed.txt" && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"

    # Backup конфигов
    echo -ne "  ⚙️  Конфиги... "
    if [ -d "$HOME/.termux" ]; then
        cp -r "$HOME/.termux" "$backup_dir/" 2>/dev/null && echo -e "${green}✓${reset}" || echo -e "${red}✗${reset}"
    else
        echo -e "${yellow}⊘${reset}"
    fi

    echo ""
    echo -e "${green}✅ Backup создан: ${bold}${backup_dir}${reset}"
    log_success "Backup создан: $backup_dir"

    # Сохраняем путь к backup
    LAST_BACKUP="$backup_dir"
}

install_packages_parallel() {
    local -a packages=("$@")
    local max_parallel=3
    local count=0
    local pids=()

    echo -e "${cyan}🚀 Параллельная установка пакетов (${#packages[@]} шт, макс. параллельно: $max_parallel)...${reset}"
    echo ""

    for pkg in "${packages[@]}"; do
        # Ждём, если достигнут лимит параллельных процессов
        while [ ${#pids[@]} -ge $max_parallel ]; do
            for pid in "${pids[@]}"; do
                if ! kill -0 "$pid" 2>/dev/null; then
                    wait "$pid"
                    pids=("${pids[@]/$pid}")
                fi
            done
            sleep 0.5
        done

        # Запускаем установку в фоне
        (
            if [ "$DRY_RUN" = true ]; then
                echo -ne "[DRY-RUN] $pkg... ⊘\n"
            else
                echo -ne "📦 $pkg... "
                if pkg install "$pkg" -y >> "$LOG_FILE" 2>&1; then
                    echo -e "✓\n"
                else
                    echo -e "✗\n"
                fi
            fi
        ) &

        pids+=($!)
        count=$((count + 1))

        # Показываем прогресс
        if [ $((count % 10)) -eq 0 ]; then
            echo -e "${white}   Установлено: $count/${#packages[@]}${reset}"
        fi
    done

    # Ждём завершения всех процессов
    for pid in "${pids[@]}"; do
        wait "$pid"
    done

    echo ""
    echo -e "${green}✅ Параллельная установка завершена!${reset}"
}

confirm_and_install() {
    local option="$1"
    local option_name=""

    # Получаем название опции
    case $option in
        1) option_name="Linux & Gnuroot" ;;
        2) option_name="Termux (полная настройка)" ;;
        3) option_name="Metasploit" ;;
        4) option_name="Kali Info Gathering" ;;
        5) option_name="Ngrok" ;;
        6) option_name="Termux-Alpine" ;;
        7) option_name="Termux-Fedora" ;;
        8) option_name="Web Scraping Tools" ;;
        9) option_name="WiFi Tools" ;;
    esac

    # Если включён режим авто-подтверждения, пропускаем
    if [ "$AUTO_CONFIRM" = true ]; then
        run_installation "$option"
        return
    fi

    # Запрос подтверждения
    echo ""
    echo -e "${yellow}⚠️  Вы уверены, что хотите установить: ${bold}${cyan}${option_name}${reset}${yellow}?${reset}"
    echo -e "${white}   Будет установлено множество пакетов. Это может занять время.${reset}"
    echo ""
    echo -ne "${green}   [y/N]: ${reset}"
    read confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        run_installation "$option"
    else
        echo -e "${cyan}❌ Отменено пользователем${reset}"
        log_info "Пользователь отменил установку: $option_name"
    fi
}

run_installation() {
    local option="$1"

    # Создание backup перед установкой
    if [ "$ENABLE_BACKUP" = true ] && [ "$DRY_RUN" = false ]; then
        create_backup
    fi

    # Сброс счётчиков перед установкой
    if [ "$DRY_RUN" = false ]; then
        PACKAGES_INSTALLED=0
        PACKAGES_FAILED=0
        REPOS_CLONED=0
        COMMANDS_EXECUTED=0
    fi

    case $option in
        1) install_linux_gnuroot ;;
        2) install_termux ;;
        3) install_metasploit ;;
        4) install_kali_info_gathering ;;
        5) install_ngrok ;;
        6) install_termux_alpine ;;
        7) install_termux_fedora ;;
        8) install_web_scraping ;;
        9) install_wifi_tools ;;
    esac

    # Показ статистики после установки
    if [ "$DRY_RUN" = false ]; then
        echo ""
        echo -e "${green}✅ Установка завершена!${reset}"
        echo -e "${white}   Пакетов установлено: ${PACKAGES_INSTALLED}${reset}"
        echo -e "${red}   Ошибок: ${PACKAGES_FAILED}${reset}"
    fi
}

show_settings() {
    echo ""
    echo -e "${bold}${white}╭────────────────────────────────────────────────────────────────────────────╮${reset}"
    echo -e "${bold}${white}│${reset}  ${yellow}⚙️  НАСТРОЙКИ${reset}                                                        ${bold}${white}│${reset}"
    echo -e "${bold}${white}╰────────────────────────────────────────────────────────────────────────────╯${reset}"
    echo ""
    echo -e "  ${cyan}1${reset}) Тестовый режим (Dry Run):     ${yellow}${DRY_RUN}${reset}"
    echo -e "  ${cyan}2${reset}) Авто-подтверждение:           ${yellow}${AUTO_CONFIRM}${reset}"
    echo -e "  ${cyan}3${reset}) Backup перед установкой:      ${yellow}${ENABLE_BACKUP}${reset}"
    echo -e "  ${cyan}4${reset}) 🔄 Восстановление из backup   ${white}— Откат изменений${reset}"
    echo ""
    echo -e "  ${white}Выберите настройку для переключения:${reset}"
    echo -ne "  [1/2/3/4/B (назад)]: "
    read setting

    case $setting in
        1)
            if [ "$DRY_RUN" = true ]; then
                DRY_RUN=false
                echo -e "${green}✅ Тестовый режим выключен${reset}"
            else
                DRY_RUN=true
                echo -e "${yellow}✅ Тестовый режим включён${reset}"
                echo -e "${cyan}   Пакеты не будут устанавливаться, только симуляция${reset}"
            fi
            ;;
        2)
            if [ "$AUTO_CONFIRM" = true ]; then
                AUTO_CONFIRM=false
                echo -e "${green}✅ Авто-подтверждение выключено${reset}"
            else
                AUTO_CONFIRM=true
                echo -e "${yellow}✅ Авто-подтверждение включено${reset}"
                echo -e "${red}   Внимание: Установка начнётся сразу после выбора опции!${reset}"
            fi
            ;;
        3)
            if [ "$ENABLE_BACKUP" = true ]; then
                ENABLE_BACKUP=false
                echo -e "${green}✅ Backup выключен${reset}"
            else
                ENABLE_BACKUP=true
                echo -e "${yellow}✅ Backup включен${reset}"
                echo -e "${cyan}   Backup будет создаваться перед установкой${reset}"
            fi
            ;;
        4)
            list_backups
            ;;
        [Bb])
            return
            ;;
    esac

    sleep 2
}

show_statistics() {
    echo ""
    echo -e "${bold}${white}╭────────────────────────────────────────────────────────────────────────────╮${reset}"
    echo -e "${bold}${white}│${reset}  ${yellow}📊 СТАТИСТИКА${reset}                                                        ${bold}${white}│${reset}"
    echo -e "${bold}${white}╰────────────────────────────────────────────────────────────────────────────╯${reset}"
    echo ""
    echo -e "  ${green}✓${reset} Установлено пакетов:    ${bold}${PACKAGES_INSTALLED}${reset}"
    echo -e "  ${red}✗${reset} Ошибок установки:       ${bold}${PACKAGES_FAILED}${reset}"
    echo -e "  ${cyan}📥${reset} Склонировано репозиториев: ${bold}${REPOS_CLONED}${reset}"
    echo -e "  ${yellow}⚙️${reset} Выполнено команд:       ${bold}${COMMANDS_EXECUTED}${reset}"
    echo ""

    if [ $PACKAGES_FAILED -gt 0 ]; then
        local success_rate=$(( (PACKAGES_INSTALLED * 100) / (PACKAGES_INSTALLED + PACKAGES_FAILED) ))
        echo -e "  ${white}Успешность установки:     ${bold}${success_rate}%${reset}"
    fi

    echo ""
    echo -ne "${yellow}⏎ Нажмите Enter для возврата...${reset}"
    read
}

print_final_statistics() {
    if [ $PACKAGES_INSTALLED -gt 0 ] || [ $REPOS_CLONED -gt 0 ]; then
        echo ""
        echo -e "${bold}${white}╔════════════════════════════════════════════════════════════════════════════╗${reset}"
        echo -e "${bold}${white}║${reset}  ${yellow}📊 ИТОГОВАЯ СТАТИСТИКА${reset}                                               ${bold}${white}║${reset}"
        echo -e "${bold}${white}╚════════════════════════════════════════════════════════════════════════════╝${reset}"
        echo ""
        echo -e "  ${green}✓${reset} Установлено пакетов:    ${PACKAGES_INSTALLED}"
        echo -e "  ${red}✗${reset} Ошибок:                 ${PACKAGES_FAILED}"
        echo -e "  ${cyan}📥${reset} Репозиториев:           ${REPOS_CLONED}"
        echo -e "  ${yellow}⚙️${reset} Команд:                 ${COMMANDS_EXECUTED}"
        echo ""
    fi
}

################################################################################
# ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
################################################################################

# Счётчики статистики
PACKAGES_INSTALLED=0
PACKAGES_FAILED=0
REPOS_CLONED=0
COMMANDS_EXECUTED=0

# Режимы
DRY_RUN=false
AUTO_CONFIRM=false
ENABLE_BACKUP=true

# Backup
LAST_BACKUP=""

################################################################################
# ОСНОВНАЯ ФУНКЦИЯ
################################################################################

main() {
    # Инициализация
    print_header
    print_banner

    # Полная проверка совместимости
    check_compatibility

    log_info "=== Запуск Fix-Termux v${VERSION} ==="

    # Главное меню
    show_main_menu
}

################################################################################
# ГЛАВНОЕ МЕНЮ
################################################################################

show_main_menu() {
    echo ""
    echo -e "${bold}${white}╭────────────────────────────────────────────────────────────────────────────╮${reset}"
    echo -e "${bold}${white}│${reset}  ${yellow}📋 ГЛАВНОЕ МЕНЮ${reset}                                                    ${bold}${white}│${reset}"
    echo -e "${bold}${white}╰────────────────────────────────────────────────────────────────────────────╯${reset}"
    echo ""
    echo -e "  ${green}1${reset}) ${cyan}🐧${reset} Linux & Gnuroot          ${white}— Базовые инструменты для Linux${reset}"
    echo -e "  ${green}2${reset}) ${yellow}📱${reset} Termux                   ${white}— Полная настройка Termux${reset}"
    echo -e "  ${green}3${reset}) ${red}🔓${reset} Metasploit                ${white}— Metasploit Framework${reset}"
    echo -e "  ${green}4${reset}) ${purple}🔍${reset} Kali Info Gathering      ${white}— Инструменты разведки${reset}"
    echo -e "  ${green}5${reset}) ${blue}🌐${reset} Ngrok                    ${white}— Туннелирование${reset}"
    echo -e "  ${green}6${reset}) ${cyan}🏔️${reset} Termux-Alpine            ${white}— Alpine Linux в Termux${reset}"
    echo -e "  ${green}7${reset}) ${yellow}🎩${reset} Termux-Fedora           ${white}— Fedora в Termux${reset}"
    echo -e "  ${green}8${reset}) ${green}🕸️${reset} Web Scraping Tools       ${white}— Парсинг веб-сайтов${reset}"
    echo -e "  ${green}9${reset}) ${red}📡${reset} WiFi Tools               ${white}— Аудит беспроводных сетей${reset}"
    echo ""
    echo -e "  ${bold}${white}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    echo -e "  ${blue}📦${reset} ${cyan}P${reset}) Профили установки           ${white}— Minimal, Standard, Full, Pentest${reset}"
    echo ""
    echo -e "  ${bold}${white}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    echo -e "  ${yellow}⚙️${reset} ${cyan}S${reset}) Настройки                  ${white}— Режимы и параметры${reset}"
    echo -e "  ${yellow}📊${reset} ${cyan}T${reset}) Статистика                 ${white}— Показать статистику${reset}"
    echo ""
    echo -e "  ${red}0${reset}) ${white}Выход${reset}"
    echo ""
    echo -ne "${bold}${white}╭─${reset} ${yellow}Выберите опцию${reset}: "
    read use
    echo -e "${bold}${white}╰─${reset}"

    # Обработка выбора
    case $use in
        1|2|3|4|5|6|7|8|9)
            confirm_and_install "$use"
            ;;
        [Pp])
            show_profiles_menu
            ;;
        [Ss])
            show_settings
            ;;
        [Tt])
            show_statistics
            ;;
        0)
            echo -e "${green}👋 Выход из программы...${reset}"
            log_info "Пользователь вышел из программы"
            print_final_statistics
            clear
            exit 0
            ;;
        *)
            echo -e "${red}❌ Неверный выбор!${reset}"
            log_error "Неверный выбор: $use"
            sleep 1
            ;;
    esac

    # Возврат в меню
    echo ""
    echo -e "${yellow}⏎ Нажмите Enter для возврата в меню...${reset}"
    read
    show_main_menu
}

################################################################################
# ЗАПУСК
################################################################################

# Создание директории для логов
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null

# Запуск основной функции
main
