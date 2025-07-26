#!/bin/bash

# Скрипт полного сброса Cursor до заводских настроек
# Автор: Assistant
# Версия: 1.0

echo "🔄 Начинаем полный сброс Cursor до заводских настроек..."
echo ""

# Функция для безопасного удаления
safe_remove() {
    if [ -e "$1" ]; then
        echo "✅ Удаляем: $1"
        rm -rf "$1"
    else
        echo "⚪ Не найдено: $1"
    fi
}

# Остановка всех процессов Cursor
echo "🛑 Остановка процессов Cursor..."
pkill -f cursor 2>/dev/null || echo "Процессы Cursor не найдены"
sleep 2

# Удаление пользовательских данных
echo ""
echo "📁 Удаление пользовательских данных..."
safe_remove "$HOME/.cursor"
safe_remove "$HOME/.config/Cursor"
safe_remove "$HOME/.local/share/Cursor"
safe_remove "$HOME/.cache/Cursor"
safe_remove "$HOME/.cache/cursor-updater"

# Удаление записей в меню приложений
echo ""
echo "📋 Удаление записей в меню..."
safe_remove "$HOME/.local/share/applications/cursor.desktop"
safe_remove "$HOME/.local/share/applications/cursor-*.desktop"
safe_remove "$HOME/Desktop/cursor.desktop"
safe_remove "$HOME/Desktop/cursor-*.desktop"

# Удаление временных файлов
echo ""
echo "🗑️ Удаление временных файлов..."
rm -rf /tmp/.mount_cursor* 2>/dev/null || echo "Временные файлы не найдены"

# Поиск и удаление AppImage файлов
echo ""
echo "📦 Поиск AppImage файлов..."
APPIMAGE_FILES=$(find "$HOME" -name "*cursor*.AppImage" 2>/dev/null)
if [ ! -z "$APPIMAGE_FILES" ]; then
    echo "Найдены AppImage файлы:"
    echo "$APPIMAGE_FILES"
    echo "Удаляем их..."
    find "$HOME" -name "*cursor*.AppImage" -delete 2>/dev/null
else
    echo "AppImage файлы не найдены"
fi

# Удаление из PATH (если есть символические ссылки)
echo ""
echo "🔗 Проверка символических ссылок..."
safe_remove "$HOME/.local/bin/cursor"

# Очистка системных записей (если есть права)
echo ""
echo "🔐 Попытка удаления системных записей (может потребовать sudo)..."
if sudo -n true 2>/dev/null; then
    sudo rm -f /usr/share/applications/cursor*.desktop 2>/dev/null
    sudo rm -f /usr/local/share/applications/cursor*.desktop 2>/dev/null
    sudo rm -rf /opt/cursor* 2>/dev/null
    sudo rm -f /usr/local/bin/cursor 2>/dev/null
    echo "✅ Системные записи очищены"
else
    echo "⚠️ Нет прав sudo - системные записи не удалены"
    echo "Для полной очистки выполните:"
    echo "sudo rm -f /usr/share/applications/cursor*.desktop"
    echo "sudo rm -f /usr/local/share/applications/cursor*.desktop"
    echo "sudo rm -rf /opt/cursor*"
    echo "sudo rm -f /usr/local/bin/cursor"
fi

# Обновление базы данных приложений
echo ""
echo "🔄 Обновление базы данных приложений..."
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
    echo "✅ База данных приложений обновлена"
else
    echo "⚠️ update-desktop-database не найден - пропускаем"
fi

# Очистка истории оболочки от команд cursor
echo ""
echo "📝 Очистка истории команд..."
if [ -f "$HOME/.bashrc" ]; then
    sed -i '/cursor/d' "$HOME/.bash_history" 2>/dev/null
fi
if [ -f "$HOME/.zshrc" ]; then
    sed -i '/cursor/d' "$HOME/.zsh_history" 2>/dev/null
fi

echo ""
echo "✅ Полный сброс Cursor завершён!"
echo ""
echo "📋 Что было сделано:"
echo "   • Остановлены все процессы Cursor"
echo "   • Удалены все пользовательские данные и настройки"
echo "   • Удалены записи в меню приложений"
echo "   • Удалены временные файлы"
echo "   • Удалены AppImage файлы"
echo "   • Очищены символические ссылки"
echo "   • Обновлена база данных приложений"
echo ""
echo "🔄 Для переустановки Cursor:"
echo "   1. Скачайте новый AppImage с https://cursor.sh/"
echo "   2. Или используйте нативные пакеты (.deb/.rpm)"
echo "   3. Запустите установку заново"
echo ""
echo "🎉 Готово! Cursor полностью удалён из системы."