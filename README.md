# Fix-Termux v2.0

Автоматический скрипт для настройки Termux, Kali Linux и других Linux-окружений.

**YouTube:** [بالمصريMR.Robot](https://youtube.com/@بالمصريMR.Robot)  
**Автор:** Ahmed Alaa  
**Релиз:** v2.0 (Refactored by Qwen Code)

---

## 🚀 Быстрый Старт

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

## 📋 Доступные Опции

| № | Опция | Описание | Статус |
|---|-------|----------|--------|
| 1 | 🐧 Linux & Gnuroot | Базовые инструменты для Linux | ✅ |
| 2 | 📱 Termux | Полная настройка Termux | ✅ |
| 3 | 🔓 Metasploit | Metasploit Framework | ✅ |
| 4 | 🔍 Kali Info Gathering | Инструменты разведки для Kali | ✅ |
| 5 | 🌐 Ngrok | Туннелирование | ✅ NEW |
| 6 | 🏔️ Termux-Alpine | Alpine Linux в Termux | ✅ |
| 7 | 🎩 Termux-Fedora | Fedora в Termux | ⏳ В разработке |
| 0 | Выход | Завершение работы | ✅ |

---

## ✨ Особенности v2.0

### 🔧 Технические улучшения
- **Модульная архитектура** — код разбит на функции
- **Логирование** — все действия записываются в `~/fix-termux.log`
- **Проверка системы** — интернет, место на диске
- **Обработка ошибок** — корректная обработка сбоев
- **Цветной интерфейс** — улучшенное меню с иконками

### 📦 Пакеты

#### Termux (Опция 2)
- **Базовые:** git, python, wget, nano, curl
- **Развлекательные:** figlet, toilet, cmatrix, cowsay
- **Языки:** ruby, golang, php, clang
- **Пентестинг:** tor, root-repo, unstable-repo
- **Утилиты:** openssh, unzip, mariadb, graphviz
- **Python:** youtube-dl, requests, mechanize

#### Kali Info Gathering (Опция 4)
- **Сканеры:** nmap, masscan, dnsenum, dnsrecon
- **Разведка:** theharvester, recon-ng, sublist3r
- **Анализ:** wireshark, hping3, nikto
- **Git репозитории:** EyeWitness, SET, sparta

---

## ⚠️ Требования

- **ОС:** Termux / Kali Linux / Linux / Gnuroot
- **Место:** минимум 2 ГБ свободно
- **Интернет:** обязательное подключение
- **Root:** рекомендуется для полного функционала

---

## 📁 Структура Проекта

```
Fix-Termux/
├── Fix-Termux.sh      # Главный скрипт (v2.0)
├── README.md          # Документация
├── CHANGELOG.md       # История изменений
├── QWEN.md            # Полная документация
└── .git/              # Git репозиторий
```

---

## 🔧 Настройка

### Логирование
Все логи сохраняются в файле `~/fix-termux.log`:
```bash
# Просмотр логов
cat ~/fix-termux.log

# Логи в реальном времени
tail -f ~/fix-termux.log
```

### Проверка системы
Скрипт автоматически проверяет:
- ✅ Интернет-соединение
- ✅ Свободное место на диске (минимум 2GB)
- ✅ Доступность репозиториев

---

## 📊 История Версий

| Версия | Дата | Изменения |
|--------|------|-----------|
| 2.0 | 2026-03-11 | Рефакторинг, логирование, новые опции |
| 1.1 | 2026-03-11 | Исправление 9 критических ошибок |
| 1.0 | 2024 | Первый релиз |

Подробности в [CHANGELOG.md](CHANGELOG.md)

---

## 🤝 Contributing

1. Fork репозиторий
2. Создайте ветку (`git checkout -b feature/AmazingFeature`)
3. Commit изменений (`git commit -m 'Add AmazingFeature'`)
4. Push (`git push origin feature/AmazingFeature`)
5. Откройте Pull Request

---

## 📝 Лицензия

Открытый исходный код (лицензия не указана)

---

## 🔗 Ресурсы

- **Оригинал:** https://github.com/pro-root/Fix-Termux
- **Fork:** https://github.com/ZDarow/Fix-Termux
- **TermuxAlpine:** https://github.com/Hax4us/TermuxAlpine
- **YouTube:** بالمصريMR.Robot

---

## ⚡ Быстрые Команды

```bash
# Обновление репозитория
git pull origin master

# Проверка синтаксиса
bash -n Fix-Termux.sh

# Запуск с правами root
sudo bash Fix-Termux.sh

# Просмотр логов
tail -f ~/fix-termux.log
```

---

**Статус:** ✅ Проверено и исправлено (v2.0)  
**Последнее обновление:** 2026-03-11
