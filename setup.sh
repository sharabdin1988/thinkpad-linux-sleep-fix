#!/bin/bash

# ==============================================================================
# ThinkPad T14s Gen 4 AMD - Linux Setup (Fan & Sleep Fix)
# Поддержка: Arch Linux (CachyOS), Debian, Ubuntu
# ==============================================================================

set -e

echo "🚀 Начинаю настройку ThinkPad T14s Gen 4 AMD..."

# 1. Определение дистрибутива
if [ -f /etc/arch-release ]; then
    OS="Arch"
    PKG_MGR="pacman -S --noconfirm"
elif [ -f /etc/debian_version ]; then
    OS="Debian"
    PKG_MGR="apt-get install -y"
    sudo apt-get update
else
    echo "❌ Ошибка: Дистрибутив не поддерживается (только Arch/Debian/Ubuntu)."
    exit 1
fi

echo "📦 Обнаружена система: $OS"

# 2. Установка ThinkFan
echo "🌀 Настройка управления вентилятором..."
sudo $PKG_MGR thinkfan

# Включение управления в драйвере
if ! grep -q "fan_control=1" /etc/modprobe.d/thinkpad_acpi.conf 2>/dev/null; then
    echo "options thinkpad_acpi fan_control=1" | sudo tee /etc/modprobe.d/thinkpad_acpi.conf
fi

# Копирование конфига
if [ -f "thinkfan.conf" ]; then
    sudo cp thinkfan.conf /etc/thinkfan.conf
    echo "✅ Конфигурация вентилятора скопирована."
fi

# 3. Применение параметров ядра для исправления сна
echo "💤 Настройка параметров ядра (Fix Sleep & SSD)..."
PARAMS="amd_iommu=off iommu=soft amdgpu.dcdebugmask=0x110 amdgpu.sg_display=0 nvme.noacpi=1 acpi_osi=\"Windows 2020\" pcie_aspm=off nvme_core.default_ps_max_latency_us=0"

# Определение загрузчика и применение
if [ -f /etc/default/grub ]; then
    echo "🔍 Обнаружен GRUB. Обновляю параметры..."
    sudo sed -i "s/^GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"$PARAMS /" /etc/default/grub
    sudo update-grub || sudo grub-mkconfig -o /boot/grub/grub.cfg
elif [ -f /etc/default/limine ]; then
    echo "🔍 Обнаружен Limine. Обновляю параметры..."
    # Для Limine просто выводим напоминание или пытаемся добавить
    echo "Пожалуйста, добавьте следующие параметры в ваш конфиг Limine вручную:"
    echo "$PARAMS"
elif command -v bootctl &> /dev/null; then
    echo "🔍 Обнаружен systemd-boot. Проверьте ваши .conf файлы в /boot/loader/entries/"
    echo "Добавьте: $PARAMS"
fi

# 4. Активация сервисов
echo "🚀 Активация служб..."
sudo systemctl enable --now thinkfan || echo "⚠️ Не удалось запустить thinkfan. Проверьте модули ядра."

echo "--------------------------------------------------------------------------"
echo "✅ Настройка завершена!"
echo "⚠️  ВАЖНО: Для вступления в силу параметров сна ПЕРЕЗАГРУЗИТЕ компьютер."
echo "💡 Также рекомендуется в BIOS выставить: Config -> Power -> Sleep State -> Linux."
echo "--------------------------------------------------------------------------"
