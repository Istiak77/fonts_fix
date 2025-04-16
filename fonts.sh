#!/bin/bash

# I thinK this part is not necessary..

# Check if running as root
# if [ "$(id -u)" -ne 0 ]; then
#     echo "This script must be run as root. Use 'sudo' or log in as root."
#     exit 1
# fi

aur=$(command -v yay || command -v paru)

# Update the system
printf "Updating system packages...\n"
sudo pacman -Syu --noconfirm

# noto fonst
noto=(
    noto-fonts 
    noto-fonts-cjk 
    noto-fonts-emoji 
    noto-fonts-extra
)

# asobe source han fonts
adobe=(
    adobe-source-han-sans-otc-fonts 
    adobe-source-han-serif-otc-fonts
)

# bengali fonts
bengali=(
    ttf-freebanglafont
    ttf-indic-otf
)

# emoji and symbol
emoji=(
    ttf-twemoji
    ttf-symbola
)

# fallback fonts
fallback=(
    ttf-dejavu
    ttf-liberation
)

# installation function
install_fonts() {
    local fonts=$1

    $aur -S --noconfirm $fonts
}

# loop for installing fonts
printf "Installing Noto Fonts (Universal multilingual support)...\n"
for font in "${noto[@]}"; do
    install_fonts "$font"
done

printf "Installing Adobe Source Han fonts (CJK support)...\n"
for font in "${adobe[@]}"; do
    install_fonts "$font"
done

printf "Installing Bengali and Indic fonts...\n"
for font in "${bengali[@]}"; do
    install_fonts "$font"
done

printf "Installing Emoji and Symbol fonts...\n"
for font in "${emoji[@]}"; do
    install_fonts "$font"
done


printf "Installing fallback fonts...\n"
for font in "${fallback[@]}"; do
    install_fonts "$font"
done

sleep 1 && clear

# Regenerate font cache
printf "Regenerating font cache...\n"
sudo fc-cache -fv

# Create a basic fontconfig file for better font rendering
printf "Configuring font preferences..\n"

FONT_CONFIG_FILE="/etc/fonts/local.conf"
sudo tee "$FONT_CONFIG_FILE" > /dev/null << 'EOF'
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

echo && sleep 1
printf "Font installation and configuration complete!\n"
printf "You may need to restart applications or your system for changes to take full effect.\n"
