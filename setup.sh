#!/bin/bash

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Progress tracking
TOTAL_STEPS=25
CURRENT_STEP=0

# Banner
clear
echo -e "${PURPLE}${BOLD}"
cat << "EOF"
    ____        __  _____ __                 ____       __            
   / __ \____  / /_/ __(_) /__  _____      / __ \_____/ /_____ _____ 
  / / / / __ \/ __/ /_/ / / _ \/ ___/     / / / / ___/ __/ __ `/ __ \
 / /_/ / /_/ / /_/ __/ / /  __(__  )     / /_/ (__  ) /_/ /_/ / / / /
/_____/\____/\__/_/ /_/_/\___/____/     /_____/____/\__/\__,_/_/ /_/ 
                                                                     
EOF
echo -e "${NC}"
echo -e "${CYAN}${BOLD}           Automated Desktop Environment Setup${NC}"
echo -e "${WHITE}                    By: Your Setup Script${NC}"
echo ""
echo -e "${YELLOW}[!]${NC} This script will install and configure your complete desktop environment"
echo -e "${YELLOW}[!]${NC} Estimated time: 15-30 minutes depending on your internet connection"
echo -e "${CYAN}[*]${NC} Detected user: ${WHITE}$(whoami)${NC}"
echo -e "${CYAN}[*]${NC} Home directory: ${WHITE}$HOME${NC}"
echo ""
read -p "Press Enter to continue..."
echo ""

# Progress bar function
show_progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    PERCENTAGE=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    BAR_LENGTH=50
    FILLED_LENGTH=$((PERCENTAGE * BAR_LENGTH / 100))
    
    printf "\r${BLUE}[${NC}"
    for ((i=1; i<=FILLED_LENGTH; i++)); do printf "${GREEN}█${NC}"; done
    for ((i=FILLED_LENGTH+1; i<=BAR_LENGTH; i++)); do printf "${WHITE}░${NC}"; done
    printf "${BLUE}]${NC} ${WHITE}${PERCENTAGE}%%${NC} ${CYAN}(${CURRENT_STEP}/${TOTAL_STEPS})${NC}"
}

# Status functions
info() {
    echo -e "\n${CYAN}[*]${NC} $1"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
}

step() {
    show_progress
    echo -e "\n${PURPLE}[STEP $CURRENT_STEP/$TOTAL_STEPS]${NC} ${BOLD}$1${NC}"
}

# System update
step "Updating system packages"
info "Updating package lists and upgrading system..."
sudo apt update &>/dev/null && sudo apt upgrade -y &>/dev/null
success "System updated successfully"

step "Installing base desktop environment"
info "Installing KDE desktop and essential tools..."
sudo apt install kali-desktop-kde kitty tmux flameshot lsd batcat keepassxc fastfetch -y &>/dev/null
success "Base desktop environment installed"

success "Base desktop environment installed"

step "Installing Brave Browser"
info "Downloading and installing Brave Browser..."
curl -fsS https://dl.brave.com/install.sh 2>/dev/null | sh &>/dev/null
success "Brave Browser installed"

step "Installing Discord"
info "Downloading Discord..."
curl https://discord.com/api/download?platform=linux&format=deb -o discord.deb &>/dev/null
info "Installing Discord..."
sudo apt install ./discord.deb -y &>/dev/null
rm discord.deb &>/dev/null
success "Discord installed"

step "Installing Telegram"
info "Downloading Telegram..."
curl https://telegram.org/dl/desktop/linux -o telegram.tar.xz &>/dev/null
info "Extracting Telegram to /opt..."
tar -xf telegram.tar.xz -C /opt &>/dev/null
rm telegram.tar.xz &>/dev/null
success "Telegram installed"

step "Installing Obsidian"
info "Downloading Obsidian..."
curl https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.10/obsidian_1.8.10_amd64.deb -o obsidian.deb &>/dev/null
info "Installing Obsidian..."
sudo apt install ./obsidian.deb -y &>/dev/null
rm obsidian.deb &>/dev/null
success "Obsidian installed"

step "Installing Spotify"
info "Adding Spotify repository..."
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg 2>/dev/null | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg &>/dev/null
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list &>/dev/null
info "Installing Spotify client..."
sudo apt-get update &>/dev/null && sudo apt-get install spotify-client -y &>/dev/null
success "Spotify installed"

step "Installing Visual Studio Code"
info "Downloading VS Code..."
curl https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64 -o vscode.deb &>/dev/null
info "Installing VS Code..."
sudo apt install ./vscode.deb -y &>/dev/null
rm vscode.deb &>/dev/null
success "VS Code installed"

step "Installing VS Code extensions"
info "Installing essential VS Code extensions..."
extensions=(
    "catppuccin.catppuccin-vsc"
    "catppuccin.catppuccin-vsc-icons"
    "devsense.composer-php-vscode"
    "devsense.intelli-php-vscode"
    "devsense.phptools-vscode"
    "devsense.profiler-php-vscode"
    "esbenp.prettier-vscode"
    "ms-python.debugpy"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.vscode-python-envs"
    "ms-vscode.cpptools"
    "ritwickdey.liveserver"
)

for ext in "${extensions[@]}"; do
    code --install-extension "$ext" &>/dev/null
done
success "VS Code extensions installed"

step "Installing Ghidra"
info "Downloading Ghidra..."
curl https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.4.1_build/ghidra_11.4.1_PUBLIC_20250731.zip -o ghidra.zip &>/dev/null
info "Extracting Ghidra to /opt..."
unzip ghidra.zip -d /opt &>/dev/null
rm ghidra.zip &>/dev/null
success "Ghidra installed"

step "Installing Pwninit"
info "Downloading and installing pwninit..."
curl https://github.com/io12/pwninit/releases/download/3.3.1/pwninit -o pwninit &>/dev/null
sudo mv pwninit /usr/local/bin/ &>/dev/null
sudo chmod +x /usr/local/bin/pwninit &>/dev/null
success "Pwninit installed"

step "Installing Pwndbg"
info "Cloning pwndbg repository..."
sudo git clone https://github.com/pwndbg/pwndbg /opt/pwndbg &>/dev/null
info "Setting up pwndbg (this may take a while)..."
cd /opt/pwndbg
sudo ./setup.sh &>/dev/null
cd - &>/dev/null
success "Pwndbg installed and configured"

step "Installing Oh My Zsh"
info "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &>/dev/null
info "Installing Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" &>/dev/null
success "Oh My Zsh and Powerlevel10k installed"

step "Installing Fira Code Nerd Font"
info "Downloading Fira Code Nerd Font..."
curl https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip -o FiraCode.zip &>/dev/null
info "Installing font..."
unzip FiraCode.zip -d ~/.local/share/fonts &>/dev/null
rm FiraCode.zip &>/dev/null
fc-cache -fv &>/dev/null
success "Fira Code Nerd Font installed"

success "Fira Code Nerd Font installed"

step "Copying dotfiles configuration"
info "Copying configuration files to home directory..."

# Get current user information
CURRENT_USER=$(whoami)
CURRENT_HOME=$(eval echo ~$CURRENT_USER)

info "Configuring files for user: $CURRENT_USER"
info "Home directory: $CURRENT_HOME"

# Create wallpaper directory
mkdir -p "$CURRENT_HOME/.wallpapers" &>/dev/null

info "Copying wallpaper.jpg to ~/.wallpapers..."
cp "dotfiles/wallpaper.jpg" "$CURRENT_HOME/.wallpapers/" &>/dev/null
success "Wallpaper copied to ~/.wallpapers"

for item in dotfiles/*; do
    item_name=$(basename "$item")
    if [ "$item_name" != "setup.sh" ] && [ "$item_name" != "README.md" ] && [ "$item_name" != "wallpapers" ] && [ "$item_name" != "wallpaper.jpg" ]; then
        if [ -d "$item" ]; then
            info "Copying directory $item_name → ~/.$item_name"
            cp -r "$item" "$HOME/.$item_name" &>/dev/null
            
            # Replace user placeholders in all files within the directory
            if [ -d "$HOME/.$item_name" ]; then
                find "$HOME/.$item_name" -type f -exec sed -i "s|{{USER_HOME}}|$CURRENT_HOME|g" {} \; 2>/dev/null
            fi
        elif [ -f "$item" ]; then
            info "Copying file $item_name → ~/.$item_name"
            cp "$item" "$HOME/.$item_name" &>/dev/null
            
            # Replace user placeholders in the file
            if [ -f "$HOME/.$item_name" ]; then
                sed -i "s|{{USER_HOME}}|$CURRENT_HOME|g" "$HOME/.$item_name" 2>/dev/null
            fi
        fi
    fi
done
success "Dotfiles configuration copied and user paths updated"

step "Installing Zsh plugins"
info "Installing syntax highlighting plugin..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &>/dev/null
info "Installing autosuggestions plugin..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &>/dev/null
success "Zsh plugins installed"

step "Installing theming dependencies"
info "Installing packages required for theming..."
sudo apt install -y \
    gtk2-engines-murrine \
    gtk2-engines-pixbuf \
    sassc \
    optipng \
    inkscape \
    libcanberra-gtk-module \
    libglib2.0-dev \
    libxml2-utils &>/dev/null

info "Creating theme directories..."
mkdir -p ~/.local/share/themes &>/dev/null
mkdir -p ~/.local/share/icons &>/dev/null
mkdir -p ~/.local/share/fonts &>/dev/null
success "Theming dependencies installed"

step "Installing Catppuccin GTK theme"
info "Downloading Catppuccin GTK theme..."
git clone https://github.com/catppuccin/gtk.git /tmp/catppuccin-gtk &>/dev/null
info "Installing Catppuccin Mocha Dark theme..."
cd /tmp/catppuccin-gtk
python3 install.py -d ~/.local/share/themes -a mocha -s dark &>/dev/null
cd - &>/dev/null
success "Catppuccin GTK theme installed"

step "Installing Layan theme"
info "Downloading Layan theme..."
git clone https://github.com/vinceliuice/Layan-gtk-theme.git /tmp/layan-theme &>/dev/null
info "Installing Layan theme..."
cd /tmp/layan-theme
./install.sh -d ~/.local/share/themes &>/dev/null
cd - &>/dev/null
success "Layan theme installed"

step "Installing Tela icon theme"
info "Downloading Tela icon theme..."
git clone https://github.com/vinceliuice/Tela-icon-theme.git /tmp/tela-icons &>/dev/null
info "Installing Tela purple variant..."
cd /tmp/tela-icons
./install.sh -d ~/.local/share/icons purple &>/dev/null
cd - &>/dev/null
success "Tela icon theme installed"

step "Installing Flat-Remix icons"
info "Downloading Flat-Remix icons..."
git clone https://github.com/daniruiz/flat-remix.git /tmp/flat-remix &>/dev/null
info "Installing Flat-Remix Blue Dark..."
cd /tmp/flat-remix
mkdir -p ~/.local/share/icons &>/dev/null
cp -r Flat-Remix-Blue-Dark ~/.local/share/icons/ &>/dev/null
cd - &>/dev/null
success "Flat-Remix icons installed"

step "Installing Catppuccin cursor theme"
info "Downloading Catppuccin cursors..."
git clone https://github.com/catppuccin/cursors.git /tmp/catppuccin-cursors &>/dev/null
info "Installing Catppuccin Mocha Lavender cursors..."
cd /tmp/catppuccin-cursors
mkdir -p ~/.local/share/icons &>/dev/null
cp -r cursors/catppuccin-mocha-lavender ~/.local/share/icons/ &>/dev/null
cd - &>/dev/null
success "Catppuccin cursor theme installed"

step "Applying theme configurations"
info "Configuring GTK theme..."
kwriteconfig5 --file ~/.config/kdeglobals --group General --key Name "Catppuccin-Mocha-Dark" &>/dev/null
kwriteconfig5 --file ~/.config/kdeglobals --group General --key ColorScheme "CatppuccinMochaLavender" &>/dev/null

info "Configuring icon theme..."
kwriteconfig5 --file ~/.config/kdeglobals --group Icons --key Theme "Tela-purple-dark" &>/dev/null

info "Configuring cursor theme..."
kwriteconfig5 --file ~/.config/kdeglobals --group General --key cursorTheme "catppuccin-mocha-lavender-cursors" &>/dev/null

info "Configuring window decorations..."
kwriteconfig5 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key theme "Catppuccin-Mocha" &>/dev/null

info "Configuring Plasma theme..."
kwriteconfig5 --file ~/.config/plasmarc --group Theme --key name "catppuccin-mocha" &>/dev/null

info "Configuring fonts..."
kwriteconfig5 --file ~/.config/kdeglobals --group General --key font "FiraCode Nerd Font,10,-1,5,50,0,0,0,0,0" &>/dev/null
kwriteconfig5 --file ~/.config/kdeglobals --group General --key menuFont "FiraCode Nerd Font,10,-1,5,50,0,0,0,0,0" &>/dev/null
kwriteconfig5 --file ~/.config/kdeglobals --group General --key toolBarFont "FiraCode Nerd Font,10,-1,5,50,0,0,0,0,0" &>/dev/null

info "Configuring desktop settings..."
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key SingleClick false &>/dev/null
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key ShowDeleteCommand false &>/dev/null

info "Updating icon cache..."
gtk-update-icon-cache ~/.local/share/icons/Tela-purple-dark 2>/dev/null || true
gtk-update-icon-cache ~/.local/share/icons/Flat-Remix-Blue-Dark 2>/dev/null || true
success "Theme configurations applied"

step "Finalizing setup"
info "Restarting plasma shell..."
killall plasmashell 2>/dev/null || true
kstart5 plasmashell &>/dev/null &

info "Cleaning up temporary files..."
rm -rf /tmp/catppuccin-gtk /tmp/layan-theme /tmp/tela-icons /tmp/flat-remix /tmp/catppuccin-cursors &>/dev/null
success "Setup completed successfully!"

# Final message
echo ""
echo -e "${GREEN}${BOLD}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}                            🎉 SETUP COMPLETED! 🎉${NC}"
echo -e "${GREEN}${BOLD}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}[✓]${NC} Desktop environment: ${WHITE}KDE Plasma with Catppuccin theme${NC}"
echo -e "${CYAN}[✓]${NC} Applications installed: ${WHITE}All essential apps ready${NC}"
echo -e "${CYAN}[✓]${NC} Development tools: ${WHITE}VS Code, Ghidra, Pwndbg configured${NC}"
echo -e "${CYAN}[✓]${NC} Terminal setup: ${WHITE}Oh My Zsh with Powerlevel10k${NC}"
echo -e "${CYAN}[✓]${NC} Dotfiles: ${WHITE}All configurations applied${NC}"

# Check if wallpapers were copied
if [ -f "$HOME/.wallpapers/wallpaper.jpg" ]; then
    echo -e "${CYAN}[✓]${NC} Wallpaper: ${WHITE}Copied to ~/.wallpapers/${NC}"
else
    echo -e "${YELLOW}[!]${NC} Wallpaper: ${WHITE}Add wallpaper.jpg to dotfiles/ for automatic setup${NC}"
fi

echo ""
echo -e "${YELLOW}[!]${NC} ${BOLD}Next steps:${NC}"
echo -e "    • Log out and log back in to apply all theme changes"
echo -e "    • Configure Powerlevel10k by running: ${CYAN}p10k configure${NC}"
echo -e "    • Customize your dotfiles in ~/.config as needed"
if [ ! -f "$HOME/.wallpapers/wallpaper.jpg" ]; then
    echo -e "    • Add your wallpaper.jpg to dotfiles/ and re-run the script to set it up"
fi
echo ""
echo -e "${PURPLE}${BOLD}Enjoy your new desktop environment! 🚀${NC}"
