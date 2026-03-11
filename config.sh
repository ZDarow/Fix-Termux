#!/bin/bash
# Конфигурация пакетов для Fix-Termux
# Версия: 3.0

################################################################################
# ПРОФИЛИ УСТАНОВКИ
################################################################################

# Minimal — только базовые инструменты (~50MB)
PROFILE_MINIMAL=(
    "git" "wget" "curl" "nano" "vim"
    "python" "python3" "pip"
)

# Standard — базовые + популярные инструменты (~200MB)
PROFILE_STANDARD=(
    "${PROFILE_MINIMAL[@]}"
    "git" "wget" "curl" "nano" "vim"
    "python" "python3" "pip"
    "ruby" "golang" "nodejs" "npm"
    "figlet" "toilet" "cmatrix"
    "openssh" "unzip" "zip" "tar" "gzip"
    "termux-api" "proot"
)

# Full — полная установка (~500MB)
PROFILE_FULL=(
    "${PROFILE_STANDARD[@]}"
    "clang" "php" "mariadb" "postgresql"
    "metasploit" "nmap" "sqlmap"
    "tor" "hydra" "john"
    "wireshark" "tcpdump"
    "mc" "htop" "tree" "jq"
    "man" "texinfo" "graphviz"
)

# Pentest — инструменты для пентестинга (~800MB)
PROFILE_PENTEST=(
    "${PROFILE_FULL[@]}"
    "aircrack-ng" "reaver" "bully"
    "hashcat" "wifite" "kismet"
    "nikto" "masscan" "recon-ng"
    "theharvester" "sublist3r"
    "burpsuite" "owasp-zap"
    "ghidra" "radare2" "binwalk"
)

################################################################################
# ПАКЕТЫ ДЛЯ TERMUX
################################################################################

TERMUX_BASIC=(
    "git" "python" "python2" "wget" "nano" "curl"
)

TERMUX_ENTERTAINMENT=(
    "figlet" "toilet" "cmatrix" "cowsay"
)

TERMUX_LANGUAGES=(
    "ruby" "golang" "php" "clang"
)

TERMUX_PENTEST=(
    "tor" "hydra" "john" "nmap" "sqlmap"
)

TERMUX_UTILITIES=(
    "openssh" "unzip" "zip" "unrar" "tar"
    "ncurses-utils" "net-tools" "w3m" "proot" "locate"
    "mariadb" "man" "texinfo" "graphviz" "tty-clock"
)

TERMUX_PYTHON_PACKAGES=(
    "youtube-dl" "wordlist" "requests" "mechanize" "argument"
)

################################################################################
# ПАКЕТЫ ДЛЯ KALI INFO GATHERING
################################################################################

KALI_INFO_GATHERING=(
    "ace" "apt2" "arp-scan" "bing-ip2hosts" "braa"
    "maltego" "cdpsnarf" "cisco-torch" "dmitry"
    "dnsenum" "dnsmap" "dnsrecon" "dnstracer" "dnswalk"
    "dotdotpwn" "enum4linux" "enumiax" "faraday" "fierce" "firewalk"
    "goofile" "hping3" "ident-user-enum" "inspy" "intrace" "ismtp" "lbd"
    "masscan" "metagoofil" "nbtscan-unixwiz" "nikto"
    "p0f" "parsero" "recon-ng" "smbmap" "smtp-user-enum"
    "sslsplit" "sublist3r" "theharvester" "tlssled" "twofi"
    "unicornscan" "urlcrazy" "wireshark"
)

KALI_GIT_REPOS=(
    "https://github.com/pro-root/dnmap:dnmap"
    "https://github.com/FortyNorthSecurity/EyeWitness.git:EyeWitness"
    "https://github.com/savio-code/ghost-phisher.git:ghost-phisher"
    "https://github.com/golismero/golismero.git:golismero"
    "https://github.com/i3visio/osrframework.git:osrframework"
    "https://github.com/trustedsec/social-engineer-toolkit.git:SET"
    "https://github.com/secforce/sparta.git:sparta"
    "https://github.com/grwl/sslcaudit.git:sslcaudit"
)

################################################################################
# WEB SCRAPING TOOLS (Опция 8)
################################################################################

WEB_SCRAPING_PACKAGES=(
    "python" "python3" "pip" "pip3"
)

WEB_SCRAPING_PYTHON=(
    "requests" "beautifulsoup4" "lxml" "selenium"
    "scrapy" "urllib3" "httpx" "aiohttp"
    "playwright" "fake-useragent" "retrying"
)

WEB_SCRAPING_TOOLS=(
    "nodejs" "npm"
)

WEB_SCRAPING_NODEJS=(
    "puppeteer" "cheerio" "axios" "request"
)

################################################################################
# WIFI TOOLS (Опция 9)
################################################################################

WIFI_TOOLS=(
    "aircrack-ng" "reaver" "bully" "pixiewps"
    "hashcat" "cowpatty" "wifite" "kismet"
    "wireshark" "tcpdump" "tshark"
)

WIFI_TOOLS_EXTRA=(
    "macchanger" "iw" "wireless-tools" "crda"
)

################################################################################
# НАСТРОЙКИ
################################################################################

# Минимальное место на диске (MB)
REQUIRED_SPACE_MB=2048

# Таймаут для проверки соединения (сек)
CONNECTION_TIMEOUT=5

# Лог файл
LOG_FILE="$HOME/fix-termux.log"

# Версия
VERSION="3.0"

################################################################################
# НОВЫЕ ИНСТРУМЕНТЫ (Опции 10-14)
################################################################################

# Опция 10: Reverse Engineering
REVERSE_ENGINEERING=(
    "radare2" "ghidra" "binwalk" "r2frida"
    "ltrace" "strace" "gdb" "objdump"
    "apktool" "dex2jar" "jd-gui"
)

# Опция 11: Social Engineering
SOCIAL_ENGINEERING=(
    "setoolkit" "gophish" "king-phisher"
    "set" "social-engineer-toolkit"
    "maltego" "theharvester"
    "creepy" "recon-ng"
)

# Опция 12: Forensics
FORENSICS=(
    "autopsy" "sleuthkit" "volatility"
    "bulk-extractor" "foremost" "scalpel"
    "exiftool" "binwalk" "forensics"
    "wireshark" "tcpdump" "tshark"
)

# Опция 13: CTF Tools
CTF_TOOLS=(
    "pwntools" "gef" "ropper" "ROPgadget"
    "one_gadget" "seccomp-tools"
    "john" "hashcat" "hydra"
    "sqlmap" "burpsuite" "owasp-zap"
    "nikto" "gobuster" "dirb"
    "wireshark" "ncat" "netcat"
)

# Опция 14: Development Tools
DEVELOPMENT=(
    "git" "subversion" "mercurial"
    "vim" "neovim" "emacs" "nano"
    "nodejs" "npm" "yarn"
    "python" "python2" "python3" "pip"
    "ruby" "gem" "bundler"
    "golang" "rust" "cargo"
    "clang" "gcc" "make" "cmake"
    "docker" "kubectl" "helm"
    "code-server" "termux-api"
)

# Опция 15: Bluetooth Tools (обновлённый - реальные пакеты Termux)
BLUETOOTH_TOOLS=(
    "qt6-qtconnectivity"
    "bluez"
    "bluez-repo"
)

# Опция 16: Bluetooth LE (Low Energy) Tools - Python библиотеки
BLUETOOTH_LE_TOOLS=(
    "bleak"
    "bluepy"
    "pygatt"
    "gattlib"
    "bleson"
    "bt-prox"
)
