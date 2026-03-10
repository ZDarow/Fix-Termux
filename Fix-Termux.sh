#!/bin/bash
# Fix-Termux.sh — Автоматическая настройка Termux и Linux
# Автор: Ahmed Alaa
# Fixed & Refactored by Qwen Code
# Версия: 2.0

################################################################################
# КОНФИГУРАЦИЯ
################################################################################

VERSION="2.0"
LOG_FILE="$HOME/fix-termux.log"
REQUIRED_SPACE_MB=2048  # Минимум 2GB свободного места

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
        log_success "Установлен пакет: $pkg ($manager)"
        return 0
    else
        echo -e "${red}✗${reset}"
        log_error "Ошибка установки пакета: $pkg ($manager)"
        return 1
    fi
}

clone_repo() {
    local url="$1"
    local name="$2"
    
    echo -ne "${cyan}📥 Клонирование ${yellow}${name}${reset}... "
    
    if git clone "$url" >> "$LOG_FILE" 2>&1; then
        echo -e "${green}✓${reset}"
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
    
    echo -ne "${cyan}⚙️  ${description}${reset}... "
    
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        echo -e "${green}✓${reset}"
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
    
    # TODO: Реализовать установку Fedora
    echo -e "${yellow}⏳ В разработке...${reset}"
    log_info "Fedora installation not implemented yet"
}

################################################################################
# МЕНЮ
################################################################################

show_menu() {
    echo -e "${bold}${white}╭────────────────────────────────────────────────────────────────────────────╮${reset}"
    echo -e "${bold}${white}│${reset}  ${yellow}📋 МЕНЮ ВЫБОРА${reset}                                                      ${bold}${white}│${reset}"
    echo -e "${bold}${white}╰────────────────────────────────────────────────────────────────────────────╯${reset}"
    echo ""
    echo -e "  ${green}1${reset}) ${cyan}🐧${reset} Linux & Gnuroot          ${white}— Базовые инструменты для Linux${reset}"
    echo -e "  ${green}2${reset}) ${yellow}📱${reset} Termux                   ${white}— Полная настройка Termux${reset}"
    echo -e "  ${green}3${reset}) ${red}🔓${reset} Metasploit                ${white}— Metasploit Framework${reset}"
    echo -e "  ${green}4${reset}) ${purple}🔍${reset} Kali Info Gathering      ${white}— Инструменты разведки${reset}"
    echo -e "  ${green}5${reset}) ${blue}🌐${reset} Ngrok                    ${white}— Туннелирование${reset}"
    echo -e "  ${green}6${reset}) ${cyan}🏔️${reset} Termux-Alpine            ${white}— Alpine Linux в Termux${reset}"
    echo -e "  ${green}7${reset}) ${yellow}🎩${reset} Termux-Fedora           ${white}— Fedora в Termux${reset}"
    echo ""
    echo -e "  ${red}0${reset}) ${white}Выход${reset}"
    echo ""
}

################################################################################
# ОСНОВНАЯ ФУНКЦИЯ
################################################################################

main() {
    # Инициализация
    print_header
    print_banner
    
    # Проверки
    echo -e "${cyan}🔍 Проверка системы...${reset}"
    
    if ! check_connection; then
        echo -e "${red}❌ Ошибка: Требуется интернет-соединение${reset}"
        exit 1
    fi
    
    if ! check_storage; then
        exit 1
    fi
    
    log_info "=== Запуск Fix-Termux v${VERSION} ==="
    
    # Меню выбора
    show_menu
    
    echo -ne "${bold}${white}╭─${reset} ${yellow}Выберите опцию${reset}: "
    read use
    echo -e "${bold}${white}╰─${reset}"
    
    # Обработка выбора
    case $use in
        1)
            install_linux_gnuroot
            ;;
        2)
            install_termux
            ;;
        3)
            install_metasploit
            ;;
        4)
            install_kali_info_gathering
            ;;
        5)
            install_ngrok
            ;;
        6)
            install_termux_alpine
            ;;
        7)
            install_termux_fedora
            ;;
        0)
            echo -e "${green}👋 Выход из программы...${reset}"
            log_info "Пользователь вышел из программы"
            clear
            exit 0
            ;;
        *)
            echo -e "${red}❌ Неверный выбор!${reset}"
            log_error "Неверный выбор: $use"
            ;;
    esac
    
    # Возврат в меню
    echo ""
    echo -e "${yellow}⏎ Нажмите Enter для возврата в меню...${reset}"
    read
    main
}

################################################################################
# ЗАПУСК
################################################################################

# Создание директории для логов
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null

# Запуск основной функции
main
