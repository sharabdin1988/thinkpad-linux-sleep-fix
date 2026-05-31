#!/bin/bash
# УЛЬТРА-СОН для Niri/Wayland (CPU + GPU + Screen + BT + Audio)
LID_STATE=$(grep -o "open\|closed" /proc/acpi/button/lid/LID*/state)

# Путь к сокету Niri (нужен для команд управления экраном)
export NIRI_SOCKET=$(ls /run/user/1000/niri-* | head -n 1)

if [ "$LID_STATE" == "closed" ]; then
    # --- ЗАСЫПАЕМ ---
    
    # 1. CPU на минимум (408 MHz)
    for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
        echo 407895 > "$file"
    done
    
    # 2. Выключаем подсветку экрана напрямую (через ядро)
    # Ищем актуальный контроллер подсветки
    BACKLIGHT=$(ls /sys/class/backlight/ | head -n 1)
    echo 0 > "/sys/class/backlight/$BACKLIGHT/brightness" 2>/dev/null
    
    # 3. Выключаем Bluetooth
    rfkill block bluetooth
    
    # 4. Выключаем звук
    amixer set Master mute 2>/dev/null
    
    # 5. GPU в режим low
    echo "low" > /sys/class/drm/card1/device/power_dpm_force_performance_level 2>/dev/null

else
    # --- ПРОСЫПАЕМСЯ ---
    
    # 1. CPU в рабочий режим (1.2 GHz)
    for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
        echo 1200000 > "$file"
    done
    
    # 2. Возвращаем подсветку (ставим 50% для примера)
    BACKLIGHT=$(ls /sys/class/backlight/ | head -n 1)
    MAX_BRIGHT=$(cat "/sys/class/backlight/$BACKLIGHT/max_brightness")
    echo $((MAX_BRIGHT / 2)) > "/sys/class/backlight/$BACKLIGHT/brightness" 2>/dev/null
    
    # 3. Включаем связь
    rfkill unblock bluetooth
    rfkill unblock wifi
    
    # 4. Возвращаем звук
    amixer set Master unmute 2>/dev/null
    
    # 5. GPU в auto
    echo "auto" > /sys/class/drm/card1/device/power_dpm_force_performance_level 2>/dev/null
fi
