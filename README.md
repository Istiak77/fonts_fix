# Multilingual Font Installer for Arch Linux

## 📝 Project Description
A complete solution to fix broken font rendering for Bengali, Chinese, Japanese, Korean and other languages on Arch Linux.

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Shell Script](https://img.shields.io/badge/Shell_Script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

## 📁 Files

### `install-multilingual-fonts.sh`
```bash
#!/bin/bash

# Check root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use 'sudo' or log in as root."
    exit 1
fi

# Update system
echo "Updating system packages..."
pacman -Syu --noconfirm

# Install Noto Fonts
echo "Installing Noto Fonts..."
pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

# Install CJK fonts
echo "Installing CJK fonts..."
pacman -S --noconfirm adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts

# Install Bengali & Indic fonts
echo "Installing Bengali fonts..."
pacman -S --noconfirm ttf-freebanglafont ttf-indic-otf

# Install Emoji & Symbols
echo "Installing emoji fonts..."
pacman -S --noconfirm ttf-twemoji ttf-symbola

# Install fallback fonts
echo "Installing fallback fonts..."
pacman -S --noconfirm ttf-dejavu ttf-liberation

# Regenerate font cache
echo "Regenerating font cache..."
fc-cache -fv

# Configure font preferences
echo "Configuring font preferences..."
FONT_CONFIG_FILE="/etc/fonts/local.conf"
cat > "$FONT_CONFIG_FILE" << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
    <alias>
        <family>sans-serif</family>
        <prefer>
            <family>Noto Sans</family>
            <family>Noto Sans CJK JP</family>
            <family>Noto Sans Bengali</family>
            <family>DejaVu Sans</family>
        </prefer>
    </alias>
    <alias>
        <family>serif</family>
        <prefer>
            <family>Noto Serif</family>
            <family>Noto Serif CJK JP</family>
            <family>Noto Serif Bengali</family>
            <family>DejaVu Serif</family>
        </prefer>
    </alias>
    <alias>
        <family>monospace</family>
        <prefer>
            <family>Noto Sans Mono</family>
            <family>Noto Sans Mono CJK JP</family>
            <family>DejaVu Sans Mono</family>
        </prefer>
    </alias>
</fontconfig>
EOF

echo "Installation complete! Restart your applications."
