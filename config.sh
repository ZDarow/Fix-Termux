#!/bin/bash
# Конфигурация пакетов для Fix-Termux
# Версия: 2.3

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
VERSION="2.1"
