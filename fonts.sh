#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use 'sudo' or log in as root."
    exit 1
fi

# Update the system
echo "Updating system packages..."
pacman -Syu --noconfirm

# Install Noto Fonts (Covers most languages)
echo "Installing Noto Fonts (Universal multilingual support)..."
pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

# Install additional CJK fonts (Chinese, Japanese, Korean)
echo "Installing Adobe Source Han fonts (CJK support)..."
pacman -S --noconfirm adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts

# Install Bengali & Indic fonts
echo "Installing Bengali and Indic fonts..."
pacman -S --noconfirm ttf-freebanglafont ttf-indic-otf

# Install Emoji & Symbol fonts
echo "Installing Emoji and Symbol fonts..."
pacman -S --noconfirm ttf-twemoji ttf-symbola

# Install fallback fonts (DejaVu, Liberation)
echo "Installing fallback fonts..."
pacman -S --noconfirm ttf-dejavu ttf-liberation

# Regenerate font cache
echo "Regenerating font cache..."
fc-cache -fv

# Create a basic fontconfig file for better font rendering
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

echo "Font installation and configuration complete!"
echo "You may need to restart applications or your system for changes to take full effect."