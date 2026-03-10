# Fix-Termux — Скрипт Настройки Termux

## 📋 Обзор

**Fix-Termux** — это Bash-скрипт для автоматической настройки и установки популярных пакетов в среде Termux (Android) и других Linux-окружениях (Kali Linux, Gnuroot). Скрипт предоставляет интерактивное меню для выбора типа установки.

**Автор:** Ahmed Alaa  
**YouTube:** بالمصريMR.Robot  
**Лицензия:** Не указана (открытый исходный код)

---

## 🗂️ Структура Проекта

```
Fix-Termux/
├── Fix-Termux.sh      # Главный скрипт настройки (✅ Исправлен)
├── README.md          # Краткая инструкция по установке
└── QWEN.md            # Документация проекта
```

---

## 🛠️ Функционал

Скрипт предоставляет 7 опций:

| № | Опция | Описание |
|---|-------|----------|
| 1 | **Linux & Gnuroot** | Установка базовых инструментов для Linux/Gnuroot |
| 2 | **Termux** | Полная настройка Termux (Python, Git, Metasploit, инструменты для пентестинга) |
| 3 | **Metasploit** | Установка Metasploit Framework |
| 4 | **Kali Information Gathering** | Установка всех инструментов для разведки в Kali Linux |
| 5 | **Ngrok** | Заглушка (soon) |
| 6 | **Termux-Alpine** | Установка Alpine Linux в Termux |
| 7 | **Termux-Fedora** | Заглушка (soon) |
| 0 | **Exit** | Выход из скрипта |

---

## 📦 Установка и Запуск

### Требования
- Termux или Linux-окружение (Kali, Gnuroot)
- Root-доступ (рекомендуется для полного функционала)
- Интернет-соединение

### Команды установки

```bash
# 1. Клонирование репозитория
git clone https://github.com/pro-root/Fix-Termux.git

# 2. Переход в директорию
cd Fix-Termux

# 3. Предоставление прав на выполнение
chmod +x Fix-Termux.sh

# 4. Запуск скрипта
bash Fix-Termux.sh
```

---

## 🔧 Устанавливаемые Пакеты

### Для Termux (Опция 2)

**Базовые инструменты:**
- `git`, `python`, `python2`, `wget`, `nano`
- `figlet`, `toilet`, `cmatrix`, `cowsay` (развлекательные)
- `ruby`, `php`, `golang`, `clang` (языки программирования)

**Инструменты для пентестинга:**
- `metasploit`, `tor`
- `hydra`, `john`

**Системные утилиты:**
- `openssh`, `unzip`, `zip`, `unrar`, `tar`
- `ncurses-utils`, `net-tools`, `w3m`
- `mariadb`, `graphviz`, `man`, `texinfo`

**Python-библиотеки:**
- `youtube-dl`, `requests`, `mechanize`
- `wordlist`, `argument`

**Дополнительно:**
- `termux-api` — доступ к API Termux
- `locate` — поиск файлов
- `tty-clock` — часы в терминале

### Для Linux & Gnuroot (Опция 1)

- Базовые утилиты: `figlet`, `git`, `wget`, `toilet`, `nano`
- `ruby`, `lolcat`
- `termux-api`, `youtube-dl`

### Для Metasploit (Опция 3)

- Подключение `unstable-repo`
- Установка `metasploit`

### Для Kali Information Gathering (Опция 4)

**Инструменты разведки:**
- `ace`, `apt2`, `arp-scan`, `bing-ip2hosts`, `braa`
- `dmitry`, `dnsenum`, `dnsmap`, `dnsrecon`, `dnstracer`, `dnswalk`
- `enum4linux`, `enumiax`, `fierce`, `firewalk`
- `nikto`, `masscan`, `metagoofil`, `nbtscan-unixwiz`
- `recon-ng`, `theharvester`, `sublist3r`, `tlssled`, `twofi`
- `wireshark`, `maltego`, `goofile`, `hping3`

**Репозитории (Git):**
- `dnmap` — https://github.com/pro-root/dnmap
- `EyeWitness` — https://github.com/FortyNorthSecurity/EyeWitness
- `ghost-phisher` — https://github.com/savio-code/ghost-phisher
- `golismero` — https://github.com/golismero/golismero
- `osrframework` — https://github.com/i3visio/osrframework
- `social-engineer-toolkit` — https://github.com/trustedsec/social-engineer-toolkit
- `sparta` — https://github.com/secforce/sparta
- `sslcaudit` — https://github.com/grwl/sslcaudit

### Для Termux-Alpine (Опция 6)

- Установка `curl`, `proot`, `wget`, `ruby`
- Загрузка и запуск скрипта `TermuxAlpine.sh`
- Команда запуска: `startalpine`

---

## 🎯 Использование

После запуска скрипта выберите нужный вариант:

```bash
./Fix-Termux.sh
```

**Пример выбора:**
```
What useing?
1- Linux & Gnuroot
2- Termux
3- Metaspoloit
4- all information gatherin on kali
5- ngrok
6- Termux-Alpine
7- Termux-Fedora
0- Exit

> 2  # Выбор полной настройки Termux
```

---

## ⚠️ Примечания

1. **Root-права:** Некоторые пакеты требуют root-доступа (`pkg install root-repo`)
2. **Время установки:** Полная установка Termux может занять 10-30 минут
3. **Место на диске:** Убедитесь, что есть минимум 2-3 ГБ свободного места
4. **Заглушки:** Опции 5 (ngrok) и 7 (Termux-Fedora) ещё не реализованы

---

## 🔗 Ресурсы

- **GitHub:** https://github.com/pro-root/Fix-Termux
- **TermuxAlpine:** https://github.com/Hax4us/TermuxAlpine

---

## 📝 Конвенции

### Стиль кода
- Bash-скрипты с цветным выводом (ANSI escape codes)
- Интерактивное меню через `read`
- Проверка условий через `if [ $use = X ]`

### Безопасность
- Скрипт выполняет команды от имени пользователя
- Требуется доверие к источнику перед запуском
- Рекомендуется запускать в тестовой среде сначала

---

## 🔧 История Версий

### v2.0 (2026-03-11) — Рефакторинг и Новые Возможности

**✨ Новые функции:**
- ✅ Модульная архитектура — код разбит на функции
- ✅ Логирование — все действия в `~/fix-termux.log`
- ✅ Проверка системы — интернет, место на диске
- ✅ Обработка ошибок — корректная обработка сбоев
- ✅ Цветное меню — с иконками и описаниями
- ✅ Возврат в меню — после завершения установки
- ✅ Реализована опция 5 (Ngrok)

**📦 Функции установки:**
- `install_linux_gnuroot()` — Linux & Gnuroot
- `install_termux()` — полная настройка Termux
- `install_metasploit()` — Metasploit Framework
- `install_kali_info_gathering()` — Kali разведка
- `install_ngrok()` — туннелирование
- `install_termux_alpine()` — Alpine Linux
- `install_termux_fedora()` — Fedora (TODO)

**🔧 Утилиты:**
- `log()` — логирование с уровнями
- `check_root()` — проверка root-прав
- `check_storage()` — проверка места на диске
- `check_connection()` — проверка интернета
- `install_package()` — установка пакетов
- `clone_repo()` — клонирование репозиториев
- `run_command()` — выполнение команд

**📚 Документация:**
- ✅ Обновлён README.md
- ✅ Создан CHANGELOG.md
- ✅ Обновлён QWEN.md

---

### v1.1 (2026-03-11) — Исправления Qwen Code

**Исправленные ошибки:**

| Файл | Строка | Ошибка | Исправление |
|------|--------|--------|-------------|
| Fix-Termux.sh | 24 | `$gteen` → `$green` | Опечатка в переменной цвета |
| Fix-Termux.sh | 59-85 | `apt install` → `pkg install` | Termux использует `pkg` |
| Fix-Termux.sh | 77-78 | `pip2` → `pip` | Python 2 устарел |
| Fix-Termux.sh | 118 | `git clone git clone` → `git clone` | Дублирование команды |
| Fix-Termux.sh | 122 | `inatall` → `install` | Опечатка |
| Fix-Termux.sh | 130 | `$ HOME` → `$HOME` | Пробел в переменной |
| Fix-Termux.sh | 84-85 | `gem install bundle` | Удалено (несуществует) |

**Улучшения:**
- ✅ Добавлены флаги `-y` для автоматической установки
- ✅ Добавлена проверка ошибок для `git clone`
- ✅ Унифицированы команды (`pkg` для Termux, `apt` для Kali)
- ✅ Удалены несуществующие пакеты
- ✅ Проверено: `bash -n` — синтаксических ошибок нет

---

**Последнее обновление:** 2026-03-11  
**Среда:** Termux / Linux / Kali / Gnuroot  
**Язык скрипта:** Bash  
**Версия:** 2.0  
**Статус:** ✅ Рефакторинг завершён
