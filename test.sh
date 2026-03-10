#!/bin/bash
# Тестовый скрипт для Fix-Termux v2.3
# Проверка основных функций

echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║                    Fix-Termux v2.3 — Тестирование                          ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Тест 1: Проверка конфига
echo "📋 Тест 1: Проверка config.sh"
if [ "$VERSION" = "2.3" ]; then
    echo "  ✅ VERSION = 2.3"
else
    echo "  ❌ VERSION = $VERSION (ожидалось 2.3)"
fi

if [ ${#TERMUX_BASIC[@]} -gt 0 ]; then
    echo "  ✅ TERMUX_BASIC: ${#TERMUX_BASIC[@]} пакетов"
else
    echo "  ❌ TERMUX_BASIC пуст"
fi

if [ ${#KALI_INFO_GATHERING[@]} -gt 0 ]; then
    echo "  ✅ KALI_INFO_GATHERING: ${#KALI_INFO_GATHERING[@]} пакетов"
else
    echo "  ❌ KALI_INFO_GATHERING пуст"
fi

if [ ${#WEB_SCRAPING_PACKAGES[@]} -gt 0 ]; then
    echo "  ✅ WEB_SCRAPING_PACKAGES: ${#WEB_SCRAPING_PACKAGES[@]} пакетов"
else
    echo "  ❌ WEB_SCRAPING_PACKAGES пуст"
fi

if [ ${#WIFI_TOOLS[@]} -gt 0 ]; then
    echo "  ✅ WIFI_TOOLS: ${#WIFI_TOOLS[@]} пакетов"
else
    echo "  ❌ WIFI_TOOLS пуст"
fi

echo ""

# Тест 2: Проверка синтаксиса Fix-Termux.sh
echo "📋 Тест 2: Проверка синтаксиса Fix-Termux.sh"
if bash -n "$SCRIPT_DIR/Fix-Termux.sh" 2>/dev/null; then
    echo "  ✅ Синтаксис OK"
else
    echo "  ❌ Ошибка синтаксиса"
    bash -n "$SCRIPT_DIR/Fix-Termux.sh"
fi

echo ""

# Тест 3: Проверка наличия функций
echo "📋 Тест 3: Проверка наличия функций"
functions=(
    "install_package"
    "clone_repo"
    "run_command"
    "create_backup"
    "install_packages_parallel"
    "confirm_and_install"
    "run_installation"
    "show_settings"
    "show_statistics"
    "show_main_menu"
    "install_linux_gnuroot"
    "install_termux"
    "install_metasploit"
    "install_kali_info_gathering"
    "install_ngrok"
    "install_termux_alpine"
    "install_termux_fedora"
    "install_web_scraping"
    "install_wifi_tools"
)

for func in "${functions[@]}"; do
    if grep -q "^${func}()" "$SCRIPT_DIR/Fix-Termux.sh"; then
        echo "  ✅ $func()"
    else
        echo "  ❌ $func() не найдена"
    fi
done

echo ""

# Тест 4: Проверка глобальных переменных
echo "📋 Тест 4: Проверка глобальных переменных"
variables=(
    "PACKAGES_INSTALLED"
    "PACKAGES_FAILED"
    "REPOS_CLONED"
    "COMMANDS_EXECUTED"
    "DRY_RUN"
    "AUTO_CONFIRM"
    "ENABLE_BACKUP"
    "LAST_BACKUP"
)

for var in "${variables[@]}"; do
    if grep -q "${var}" "$SCRIPT_DIR/Fix-Termux.sh"; then
        echo "  ✅ $var"
    else
        echo "  ❌ $var не найдена"
    fi
done

echo ""

# Тест 5: Проверка файлов проекта
echo "📋 Тест 5: Проверка файлов проекта"
files=(
    "Fix-Termux.sh"
    "config.sh"
    "README.md"
    "CHANGELOG.md"
    "QWEN.md"
    "LICENSE"
    ".gitignore"
)

for file in "${files[@]}"; do
    if [ -f "$SCRIPT_DIR/$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file не найден"
    fi
done

echo ""
echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║                         Тестирование завершено                             ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
