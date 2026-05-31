# ThinkPad T14s Gen 4 AMD - Linux Setup (Fan & Sleep Fix)

[Русский](#настройка-thinkpad-t14s-gen-4-amd-на-linux) | [English](#thinkpad-t14s-gen-4-amd---linux-setup)

---

## Настройка ThinkPad T14s Gen 4 AMD на Linux

Автоматизированное решение для исправления проблем с охлаждением и режимом сна на ноутбуках Lenovo ThinkPad T14s Gen 4 с процессорами AMD Ryzen 7000 серии.

### 🛠 Решаемые проблемы:
1. **Троттлинг и перегрев:** Тонкая настройка `thinkfan`. Кулер остается выключенным до 55°C (полная тишина) и переходит в режим максимальных оборотов (`full-speed`) при 78°C, предотвращая падение производительности в играх и тяжелых задачах.
2. **Ошибки SSD (I/O Error):** Исправление "отваливания" дисков Kioxia/Samsung после выхода из сна (`s2idle`).
3. **Графические артефакты:** Устранение "точек" на экране после пробуждения и повышение стабильности GPU.

### 📦 Поддержка систем:
* **Arch Linux** (включая CachyOS, Manjaro, EndeavourOS)
* **Debian / Ubuntu** (и производные)

### 🚀 Быстрый старт:
```bash
git clone https://github.com/sharabdin1988/thinkpad-linux-sleep-fix.git
cd thinkpad-linux-sleep-fix
chmod +x setup.sh
sudo ./setup.sh
```

## Что делает скрипт?
- Устанавливает `thinkfan`.
- Разрешает управление куллером в `thinkpad_acpi`.
- Добавляет параметры ядра в загрузчик (GRUB):
  - `nvme.noacpi=1` и `nvme_core.default_ps_max_latency_us=0` для стабильности SSD.
  - `amdgpu.dcdebugmask=0x110` и `amdgpu.sg_display=0` для фикса артефактов и стабильности видеоядра.
  - `amd_iommu=off` и `iommu=soft` для устранения конфликтов ввода-вывода.
  - `acpi_osi="Windows 2020"` для правильной инициализации ACPI функций.
  - `pcie_aspm=off` для стабильности шины.
- Включает службу автоматического управления оборотами.

---

## ThinkPad T14s Gen 4 AMD - Linux Setup

Automated solution to fix cooling and sleep issues on Lenovo ThinkPad T14s Gen 4 laptops equipped with AMD Ryzen 7000 series processors.

### 🛠 Issues Addressed:
1. **Throttling & Overheating:** Precise `thinkfan` configuration. The fan remains off until 55°C (complete silence) and switches to `full-speed` at 78°C to prevent performance drops during gaming or heavy workloads.
2. **SSD I/O Errors:** Fixes the issue where Kioxia/Samsung drives become unresponsive after waking from sleep (`s2idle`).
3. **Graphic Artifacts:** Eliminates screen "dots" or corruption and improves GPU stability.

### 📦 Supported Systems:
* **Arch Linux** (including CachyOS, Manjaro, EndeavourOS)
* **Debian / Ubuntu** (and derivatives)

### 🚀 Quick Start:
```bash
git clone https://github.com/sharabdin1988/thinkpad-linux-sleep-fix.git
cd thinkpad-linux-sleep-fix
chmod +x setup.sh
sudo ./setup.sh
```

## What does the script do?
- Installs `thinkfan`.
- Enables fan control in `thinkpad_acpi`.
- Adds kernel parameters to the bootloader (GRUB):
  - `nvme.noacpi=1` and `nvme_core.default_ps_max_latency_us=0` for SSD stability.
  - `amdgpu.dcdebugmask=0x110` and `amdgpu.sg_display=0` to fix artifacts and ensure GPU stability.
  - `amd_iommu=off` and `iommu=soft` to eliminate I/O conflicts.
  - `acpi_osi="Windows 2020"` for proper ACPI initialization.
  - `pcie_aspm=off` to ensure PCIe bus stability.
- Enables the automatic fan speed control service.

---

### 💡 BIOS Recommendations / Рекомендации BIOS:
For best results, please set the following in your BIOS:
Для лучшей работы установите в BIOS:
`Config -> Power -> Sleep State -> Linux`

### 📄 License
MIT
