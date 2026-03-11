#!/bin/bash
################################################################################
# Fix-Termux Launcher — Меню запуска инструментов
# Версия: 1.0
# Автор: Qwen Code
################################################################################

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'

# Версия
VERSION="1.0"

################################################################################
# ЗАГОЛОВОК
################################################################################
show_header() {
    clear
    echo -e "${bold}${white}╭────────────────────────────────────────────────────────────────────────────╮${reset}"
    echo -e "${bold}${white}│${reset}  ${cyan}🚀 Fix-Termux Launcher${reset}                                              ${bold}${white}│${reset}"
    echo -e "${bold}${white}│${reset}  ${white}Меню запуска инструментов${reset}                                          ${bold}${white}│${reset}"
    echo -e "${bold}${white}╰────────────────────────────────────────────────────────────────────────────╯${reset}"
    echo ""
}

################################################################################
# ПРОВЕРКА УСТАНОВКИ ИНСТРУМЕНТА
################################################################################
check_installed() {
    local cmd="$1"
    if command -v "$cmd" &> /dev/null; then
        echo "✅"
        return 0
    else
        echo "❌"
        return 1
    fi
}

################################################################################
# ЗАПУСК ИНСТРУМЕНТА
################################################################################
run_tool() {
    local cmd="$1"
    local args="${@:2}"
    
    echo ""
    echo -e "${cyan}🚀 Запуск: ${white}${cmd} ${args}${reset}"
    echo -e "${yellow}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    
    # Запуск команды
    eval "$cmd $args"
    
    echo ""
    echo -e "${yellow}─────────────────────────────────────────────────────────────────────────${reset}"
    echo -ne "${white}⏎ Нажмите Enter для продолжения...${reset}"
    read
}

################################################################################
# МЕНЮ: ГЛАВНОЕ
################################################################################
show_main_menu() {
    show_header
    
    echo -e "  ${GREEN}1${reset}) ${cyan}📱${reset} Термукс и Разработка"
    echo -e "  ${GREEN}2${reset}) ${red}🔓${reset} Pentesting Инструменты"
    echo -e "  ${GREEN}3${reset}) ${blue}📡${reset} Сетевые Инструменты"
    echo -e "  ${GREEN}4${reset}) ${cyan}🔬${reset} Forensics (Криминалистика)"
    echo -e "  ${GREEN}5${reset}) ${red}🚩${reset} CTF Инструменты"
    echo -e "  ${GREEN}6${reset}) ${blue}📶${reset} Bluetooth / BLE"
    echo -e "  ${GREEN}7${reset}) ${green}🕸️${reset} Web Scraping"
    echo -e "  ${GREEN}8${reset}) ${yellow}🛠️${reset} Системные Утилиты"
    echo ""
    echo -e "  ${white}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    echo -e "  ${GREEN}0${reset}) ${white}Выход${reset}"
    echo ""
    echo -ne "  ${YELLOW}Выберите раздел${reset}: "
    read choice
    
    case $choice in
        1) show_dev_menu ;;
        2) show_pentest_menu ;;
        3) show_network_menu ;;
        4) show_forensics_menu ;;
        5) show_ctf_menu ;;
        6) show_bluetooth_menu ;;
        7) show_web_menu ;;
        8) show_system_menu ;;
        0)
            echo -e "${GREEN}👋 Выход...${reset}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Неверный выбор${reset}"
            sleep 1
            ;;
    esac
}

################################################################################
# МЕНЮ: ТЕРМУКС И РАЗРАБОТКА
################################################################################
show_dev_menu() {
    show_header
    
    echo -e "  ${CYAN}📱 ТЕРМУКС И РАЗРАБОТКА${reset}"
    echo ""
    echo -e "  $(check_installed python3) ${GREEN}1${reset}) Python 3"
    echo -e "  $(check_installed node) ${GREEN}2${reset}) Node.js"
    echo -e "  $(check_installed git) ${GREEN}3${reset}) Git"
    echo -e "  $(check_installed vim) ${GREEN}4${reset}) Vim"
    echo -e "  $(check_installed nano) ${GREEN}5${reset}) Nano"
    echo -e "  $(check_installed clang) ${GREEN}6${reset}) Clang (C/C++)"
    echo -e "  $(check_installed ruby) ${GREEN}7${reset}) Ruby"
    echo -e "  $(check_installed golang) ${GREEN}8${reset}) Go"
    echo -e "  $(check_installed php) ${GREEN}9${reset}) PHP"
    echo -e "  $(check_installed mariadbd) ${GREEN}10${reset}) MariaDB"
    echo -e "  $(check_installed psql) ${GREEN}11${reset}) PostgreSQL"
    echo ""
    echo -e "  ${WHITE}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    echo -e "  ${GREEN}B${reset}) Назад | ${GREEN}0${reset}) Выход"
    echo ""
    echo -ne "  ${YELLOW}Выберите инструмент${reset}: "
    read choice
    
    case $choice in
        1) run_tool "python3" ;;
        2) run_tool "node" ;;
        3) 
            echo ""
            echo -e "  ${CYAN}GIT МЕНЮ${reset}"
            echo -e "  1) git status"
            echo -e "  2) git add ."
            echo -e "  3) git commit"
            echo -e "  4) git push"
            echo -e "  5) git clone"
            echo -e "  6) git log"
            echo -ne "  Выбор: "
            read git_choice
            case $git_choice in
                1) run_tool "git status" ;;
                2) run_tool "git add ." ;;
                3) run_tool "git commit" ;;
                4) run_tool "git push" ;;
                5) echo -ne "URL: "; read url; run_tool "git clone $url" ;;
                6) run_tool "git log" ;;
            esac
            ;;
        4) run_tool "vim" ;;
        5) run_tool "nano" ;;
        6) run_tool "clang" ;;
        7) run_tool "ruby" ;;
        8) run_tool "go" ;;
        9) 
            echo -ne "PHP файл: "
            read file
            run_tool "php" "$file"
            ;;
        10) run_tool "mariadbd" ;;
        11) run_tool "psql" ;;
        [Bb]) show_main_menu ;;
        0) exit 0 ;;
        *) echo -e "${RED}❌ Неверный выбор${reset}"; sleep 1 ;;
    esac
    
    show_dev_menu
}

################################################################################
# МЕНЮ: PENTESTING ИНСТРУМЕНТЫ
################################################################################
show_pentest_menu() {
    show_header
    
    echo -e "  ${RED}🔓 PENTESTING ИНСТРУМЕНТЫ${reset}"
    echo ""
    echo -e "  $(check_installed nmap) ${GREEN}1${reset}) Nmap (сканирование сети)"
    echo -e "  $(check_installed sqlmap) ${GREEN}2${reset}) SQLMap (SQL инъекции)"
    echo -e "  $(check_installed hydra) ${GREEN}3${reset}) Hydra (брутфорс)"
    echo -e "  $(check_installed john) ${GREEN}4${reset}) John the Ripper (взлом хешей)"
    echo -e "  $(check_installed msfconsole) ${GREEN}5${reset}) Metasploit"
    echo -e "  $(check_installed nikto) ${GREEN}6${reset}) Nikto (web scanner)"
    echo -e "  $(check_installed wpscan) ${GREEN}7${reset}) WPScan (WordPress scanner)"
    echo ""
    echo -e "  ${WHITE}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    echo -e "  ${GREEN}B${reset}) Назад | ${GREEN}0${reset}) Выход"
    echo ""
    echo -ne "  ${YELLOW}Выберите инструмент${reset}: "
    read choice
    
    case $choice in
        1)
            echo -ne "Цель (IP/домен): "
            read target
            run_tool "nmap" "-sC -sV $target"
            ;;
        2)
            echo -ne "URL: "
            read url
            run_tool "sqlmap" "-u \"$url\" --batch"
            ;;
        3)
            echo -ne "Цель: "
            read target
            echo -ne "Логин: "
            read login
            echo -ne "Словарь: "
            read dict
            run_tool "hydra" "-l $login -P $dict ssh://$target"
            ;;
        4)
            echo -ne "Файл с хешем: "
            read hashfile
            run_tool "john" "--wordlist=/data/data/com.termux/files/home/rockyou.txt $hashfile"
            ;;
        5) run_tool "msfconsole" ;;
        6)
            echo -ne "URL: "
            read url
            run_tool "nikto" "-h $url"
            ;;
        7)
            echo -ne "WordPress URL: "
            read url
            run_tool "wpscan" "--url $url --enumerate"
            ;;
        [Bb]) show_main_menu ;;
        0) exit 0 ;;
        *) echo -e "${RED}❌ Неверный выбор${reset}"; sleep 1 ;;
    esac
    
    show_pentest_menu
}

################################################################################
# МЕНЮ: СЕТЕВЫЕ ИНСТРУМЕНТЫ
################################################################################
show_network_menu() {
    show_header
    
    echo -e "  ${BLUE}📡 СЕТЕВЫЕ ИНСТРУМЕНТЫ${reset}"
    echo ""
    echo -e "  $(check_installed tshark) ${GREEN}1${reset}) Wireshark (TShark)"
    echo -e "  $(check_installed tcpdump) ${GREEN}2${reset}) TCPDump"
    echo -e "  $(check_installed tor) ${GREEN}3${reset}) Tor"
    echo -e "  $(check_installed netcat) ${GREEN}4${reset}) Netcat"
    echo -e "  $(check_installed ncat) ${GREEN}5${reset}) Ncat"
    echo -e "  $(check_installed curl) ${GREEN}6${reset}) Curl"
    echo -e "  $(check_installed wget) ${GREEN}7${reset}) Wget"
    echo ""
    echo -e "  ${WHITE}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    echo -e "  ${GREEN}B${reset}) Назад | ${GREEN}0${reset}) Выход"
    echo ""
    echo -ne "  ${YELLOW}Выберите инструмент${reset}: "
    read choice
    
    case $choice in
        1)
            echo -ne "Интерфейс (wlan0): "
            read iface
            run_tool "tshark" "-i ${iface:-wlan0}"
            ;;
        2)
            echo -ne "Интерфейс (wlan0): "
            read iface
            run_tool "tcpdump" "-i ${iface:-wlan0}"
            ;;
        3) run_tool "tor" ;;
        4)
            echo -ne "Хост: "
            read host
            echo -ne "Порт: "
            read port
            run_tool "nc" "-v $host $port"
            ;;
        5)
            echo -ne "Хост: "
            read host
            echo -ne "Порт: "
            read port
            run_tool "ncat" "$host" "$port"
            ;;
        6)
            echo -ne "URL: "
            read url
            run_tool "curl" "-I $url"
            ;;
        7)
            echo -ne "URL: "
            read url
            run_tool "wget" "$url"
            ;;
        [Bb]) show_main_menu ;;
        0) exit 0 ;;
        *) echo -e "${RED}❌ Неверный выбор${reset}"; sleep 1 ;;
    esac
    
    show_network_menu
}

################################################################################
# МЕНЮ: FORENSICS
################################################################################
show_forensics_menu() {
    show_header
    
    echo -e "  ${CYAN}🔬 FORENSICS (КРИМИНАЛИСТИКА)${reset}"
    echo ""
    echo -e "  $(check_installed exiftool) ${GREEN}1${reset}) ExifTool (метаданные)"
    echo -e "  $(check_installed binwalk) ${GREEN}2${reset}) Binwalk (анализ прошивок)"
    echo -e "  $(check_installed foremost) ${GREEN}3${reset}) Foremost (восстановление)"
    echo -e "  $(check_installed sleuthkit) ${GREEN}4${reset}) SleuthKit"
    echo ""
    echo -e "  ${WHITE}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    echo -e "  ${GREEN}B${reset}) Назад | ${GREEN}0${reset}) Выход"
    echo ""
    echo -ne "  ${YELLOW}Выберите инструмент${reset}: "
    read choice
    
    case $choice in
        1)
            echo -ne "Файл: "
            read file
            run_tool "exiftool" "$file"
            ;;
        2)
            echo -ne "Файл прошивки: "
            read file
            run_tool "binwalk" "-e $file"
            ;;
        3)
            echo -ne "Образ диска: "
            read image
            run_tool "foremost" "-i $image -o recovered/"
            ;;
        4) run_tool "fls" ;;
        [Bb]) show_main_menu ;;
        0) exit 0 ;;
        *) echo -e "${RED}❌ Неверный выбор${reset}"; sleep 1 ;;
    esac
    
    show_forensics_menu
}

################################################################################
# МЕНЮ: CTF ИНСТРУМЕНТЫ
################################################################################
show_ctf_menu() {
    show_header
    
    echo -e "  ${RED}🚩 CTF ИНСТРУМЕНТЫ${reset}"
    echo ""
    echo -e "  $(check_installed gdb) ${GREEN}1${reset}) GDB (отладчик)"
    echo -e "  $(check_installed ROPgadget) ${GREEN}2${reset}) ROPgadget"
    echo -e "  $(check_installed hashcat) ${GREEN}3${reset}) Hashcat"
    echo -e "  $(check_installed gobuster) ${GREEN}4${reset}) Gobuster"
    echo -e "  $(check_installed dirb) ${GREEN}5${reset}) Dirb"
    echo -e "  $(check_installed pwntools) ${GREEN}6${reset}) Pwntools (Python)"
    echo ""
    echo -e "  ${WHITE}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    echo -e "  ${GREEN}B${reset}) Назад | ${GREEN}0${reset}) Выход"
    echo ""
    echo -ne "  ${YELLOW}Выберите инструмент${reset}: "
    read choice
    
    case $choice in
        1)
            echo -ne "Бинарный файл: "
            read binary
            run_tool "gdb" "$binary"
            ;;
        2)
            echo -ne "Бинарный файл: "
            read binary
            run_tool "ROPgadget" "--binary $binary"
            ;;
        3)
            echo -ne "Файл с хешем: "
            read hashfile
            run_tool "hashcat" "-m 0 -a 0 $hashfile /data/data/com.termux/files/home/rockyou.txt"
            ;;
        4)
            echo -ne "URL: "
            read url
            echo -ne "Словарь (wordlist.txt): "
            read wordlist
            run_tool "gobuster" "dir -u $url -w ${wordlist:-wordlist.txt}"
            ;;
        5)
            echo -ne "URL: "
            read url
            run_tool "dirb" "$url"
            ;;
        6)
            echo -e "${CYAN}Pwntools Python REPL${reset}"
            python3 -c "from pwn import *; print('Pwntools ready!')"
            ;;
        [Bb]) show_main_menu ;;
        0) exit 0 ;;
        *) echo -e "${RED}❌ Неверный выбор${reset}"; sleep 1 ;;
    esac
    
    show_ctf_menu
}

################################################################################
# МЕНЮ: BLUETOOTH / BLE
################################################################################
show_bluetooth_menu() {
    show_header
    
    echo -e "  ${BLUE}📶 BLUETOOTH / BLE${reset}"
    echo ""
    echo -e "  $(check_installed python3) ${GREEN}1${reset}) BLE Сканирование (Bleak)"
    echo -e "  $(check_installed python3) ${GREEN}2${reset}) BLE Подключение"
    echo -e "  $(check_installed python3) ${GREEN}3${reset}) PyGATT Пример"
    echo -e "  $(check_installed qt6-qtconnectivity) ${GREEN}4${reset}) Qt Bluetooth"
    echo ""
    echo -e "  ${WHITE}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    echo -e "  ${GREEN}B${reset}) Назад | ${GREEN}0${reset}) Выход"
    echo ""
    echo -ne "  ${YELLOW}Выберите инструмент${reset}: "
    read choice
    
    case $choice in
        1)
            echo -e "${CYAN}Сканирование BLE устройств...${reset}"
            python3 -c "
import asyncio
from bleak import BleakScanner

async def scan():
    print('🔍 Сканирование...')
    devices = await BleakScanner.discover(timeout=5.0)
    for d in devices:
        print(f'  {d.name}: {d.address}')
    print(f'Найдено: {len(devices)} устройств')

asyncio.run(scan())
"
            ;;
        2)
            echo -ne "BLE адрес устройства: "
            read address
            python3 -c "
import asyncio
from bleak import BleakClient

async def connect():
    address = '$address'
    print(f'Подключение к {address}...')
    async with BleakClient(address) as client:
        print(f'✅ Подключено: {client.is_connected}')
        services = await client.get_services()
        print(f'Сервисов: {len(services)}')
        for service in services:
            print(f'  {service}')

asyncio.run(connect())
"
            ;;
        3)
            echo -e "${CYAN}PyGATT пример${reset}"
            python3 -c "
try:
    import pygatt
    print('PyGATT готов к работе!')
    print('Пример использования:')
    print('  adapter = pygatt.GATTToolBackend()')
    print('  adapter.start()')
    print('  device = adapter.connect(\"XX:XX:XX:XX:XX:XX\")')
except ImportError:
    print('❌ PyGATT не установлен')
    print('Установка: pip install pygatt')
"
            ;;
        4)
            echo -e "${YELLOW}Qt Bluetooth требует GUI${reset}"
            ;;
        [Bb]) show_main_menu ;;
        0) exit 0 ;;
        *) echo -e "${RED}❌ Неверный выбор${reset}"; sleep 1 ;;
    esac
    
    show_bluetooth_menu
}

################################################################################
# МЕНЮ: WEB SCRAPING
################################################################################
show_web_menu() {
    show_header
    
    echo -e "  ${GREEN}🕸️ WEB SCRAPING${reset}"
    echo ""
    echo -e "  $(check_installed python3) ${GREEN}1${reset}) Python Requests"
    echo -e "  $(check_installed python3) ${GREEN}2${reset}) Python BeautifulSoup"
    echo -e "  $(check_installed scrapy) ${GREEN}3${reset}) Scrapy"
    echo -e "  $(check_installed curl) ${GREEN}4${reset}) Curl"
    echo ""
    echo -e "  ${WHITE}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    echo -e "  ${GREEN}B${reset}) Назад | ${GREEN}0${reset}) Выход"
    echo ""
    echo -ne "  ${YELLOW}Выберите инструмент${reset}: "
    read choice
    
    case $choice in
        1)
            echo -ne "URL: "
            read url
            python3 -c "
import requests
url = '$url'
print(f'GET {url}...')
r = requests.get(url)
print(f'Status: {r.status_code}')
print(f'Content length: {len(r.text)} bytes')
"
            ;;
        2)
            echo -ne "URL: "
            read url
            python3 -c "
import requests
from bs4 import BeautifulSoup

url = '$url'
r = requests.get(url)
soup = BeautifulSoup(r.text, 'html.parser')
print('Заголовки:')
for h in soup.find_all(['h1', 'h2', 'h3']):
    print(f'  {h.text.strip()}')
"
            ;;
        3) run_tool "scrapy" "shell" ;;
        4)
            echo -ne "URL: "
            read url
            run_tool "curl" "-s $url | head -50"
            ;;
        [Bb]) show_main_menu ;;
        0) exit 0 ;;
        *) echo -e "${RED}❌ Неверный выбор${reset}"; sleep 1 ;;
    esac
    
    show_web_menu
}

################################################################################
# МЕНЮ: СИСТЕМНЫЕ УТИЛИТЫ
################################################################################
show_system_menu() {
    show_header
    
    echo -e "  ${YELLOW}🛠️ СИСТЕМНЫЕ УТИЛИТЫ${reset}"
    echo ""
    echo -e "  $(check_installed htop) ${GREEN}1${reset}) Htop (мониторинг)"
    echo -e "  $(check_installed tree) ${GREEN}2${reset}) Tree (структура)"
    echo -e "  $(check_installed mc) ${GREEN}3${reset}) Midnight Commander"
    echo -e "  $(check_installed figlet) ${GREEN}4${reset}) Figlet"
    echo -e "  $(check_installed cmatrix) ${GREEN}5${reset}) CMatrix"
    echo -e "  $(check_installed jq) ${GREEN}6${reset}) JSON Processor"
    echo ""
    echo -e "  ${WHITE}─────────────────────────────────────────────────────────────────────────${reset}"
    echo ""
    echo -e "  ${GREEN}B${reset}) Назад | ${GREEN}0${reset}) Выход"
    echo ""
    echo -ne "  ${YELLOW}Выберите инструмент${reset}: "
    read choice
    
    case $choice in
        1) run_tool "htop" ;;
        2) run_tool "tree" "-L 2" ;;
        3) run_tool "mc" ;;
        4)
            echo -ne "Текст: "
            read text
            run_tool "figlet" "$text"
            ;;
        5) run_tool "cmatrix" ;;
        6)
            echo -ne "JSON файл: "
            read file
            run_tool "jq" "." "$file"
            ;;
        [Bb]) show_main_menu ;;
        0) exit 0 ;;
        *) echo -e "${RED}❌ Неверный выбор${reset}"; sleep 1 ;;
    esac
    
    show_system_menu
}

################################################################################
# ГЛАВНЫЙ ЦИКЛ
################################################################################
echo -e "${CYAN}🚀 Запуск Fix-Termux Launcher...${reset}"
sleep 1

# Главный цикл
while true; do
    show_main_menu
done
