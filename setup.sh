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
TOTAL_STEPS=17
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
    
    # Ensure we don't exceed total steps
    if [ $CURRENT_STEP -gt $TOTAL_STEPS ]; then
        CURRENT_STEP=$TOTAL_STEPS
    fi
    
    PERCENTAGE=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    BAR_LENGTH=50
    FILLED_LENGTH=$((PERCENTAGE * BAR_LENGTH / 100))
    
    # Clear screen and show header
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
    
    # Show progress bar
    printf "${BLUE}[${NC}"
    for ((i=1; i<=FILLED_LENGTH; i++)); do printf "${GREEN}█${NC}"; done
    for ((i=FILLED_LENGTH+1; i<=BAR_LENGTH; i++)); do printf "${WHITE}░${NC}"; done
    printf "${BLUE}]${NC} ${WHITE}${PERCENTAGE}%%${NC} ${CYAN}(${CURRENT_STEP}/${TOTAL_STEPS})${NC}"
    echo ""
}

# Status functions  
info() {
    echo -e "  ${CYAN}[*]${NC} $1"
}

success() {
    echo -e "  ${GREEN}[✓]${NC} $1"
    sleep 0.5
}

warning() {
    echo -e "  ${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "  ${RED}[✗]${NC} $1"
    echo -e "  ${RED}[!]${NC} ${WHITE}If you need help, check the error above${NC}"
}

step() {
    show_progress
    echo ""
    echo -e "${PURPLE}[STEP $CURRENT_STEP/$TOTAL_STEPS]${NC} ${BOLD}$1${NC}"
    echo ""
}

# System update
step "Updating system packages"
info "Updating package lists and upgrading system..."
if sudo apt update >/dev/null 2>&1; then
    sudo apt upgrade -y >/dev/null 2>&1 || warning "Some packages couldn't be upgraded, continuing..."
    success "System updated successfully"
else
    warning "Package list update failed, but continuing with installation..."
fi

step "Installing base desktop environment"
info "Installing KDE desktop and essential tools..."
sudo apt install kali-desktop-kde kitty tmux flameshot lsd bat keepassxc fastfetch patchelf elfutils fzf oxide -y &>/dev/null
success "Base desktop environment installed"

sudo update-alternatives --config x-session-manager
sudo apt purge --autoremove --allow-remove-essential kali-desktop-xfce

step "Installing Brave Browser"
info "Downloading and installing Brave Browser..."
curl -fsS https://dl.brave.com/install.sh 2>/dev/null | sh &>/dev/null
success "Brave Browser installed"

step "Installing Discord"
info "Downloading Discord..."
curl -L "https://discord.com/api/download?platform=linux&format=deb" -o discord.deb &>/dev/null
info "Installing Discord..."
sudo apt install ./discord.deb -y &>/dev/null
rm discord.deb &>/dev/null
success "Discord installed"

step "Installing Telegram"
info "Downloading Telegram..."
curl -L https://telegram.org/dl/desktop/linux -o telegram.tar.xz &>/dev/null
info "Extracting Telegram to /opt..."
sudo tar -xf telegram.tar.xz -C /opt &>/dev/null
rm telegram.tar.xz &>/dev/null
success "Telegram installed"

step "Installing Obsidian"
info "Downloading Obsidian..."
curl -L https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.10/obsidian_1.8.10_amd64.deb -o obsidian.deb &>/dev/null
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
curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o vscode.deb &>/dev/null
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
curl -L https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.4.1_build/ghidra_11.4.1_PUBLIC_20250731.zip -o ghidra.zip &>/dev/null
info "Extracting Ghidra to /opt..."
sudo unzip ghidra.zip -d /opt &>/dev/null
rm ghidra.zip &>/dev/null
success "Ghidra installed"

step "Installing Pwninit"
info "Downloading and installing pwninit..."
curl -L https://github.com/io12/pwninit/releases/download/3.3.1/pwninit -o pwninit &>/dev/null
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
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &>/dev/null
info "Installing Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" &>/dev/null
success "Oh My Zsh and Powerlevel10k installed"

step "Installing Fira Code Nerd Font"
info "Downloading Fira Code Nerd Font..."
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip -o FiraCode.zip &>/dev/null
info "Installing font..."
unzip FiraCode.zip -d ~/.local/share/fonts &>/dev/null
rm FiraCode.zip &>/dev/null
fc-cache -fv &>/dev/null
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

git clone --depth=1 https://github.com/catppuccin/kde catppuccin-kde && cd catppuccin-kde
./install.sh

cd $HOME/.icons
curl -LOsS https://github.com/catppuccin/cursors/releases/download/v2.0.0/catppuccin-mocha-lavender-cursors.zip
unzip catppuccin-mocha-lavender-cursors.zip
cd -

sudo apt-get install gtk2-engines-murrine gtk2-engines-pixbuf
git clone --depth=1 https://github.com/vinceliuice/Layan-gtk-theme.git /tmp/layan-theme &>/dev/null
cd /tmp/layan-theme
./install.sh -c dark &>/dev/null
cd - &>/dev/null

for item in dotfiles/*; do
    item_name=$(basename "$item")
    if [ "$item_name" != "setup.sh" ] && [ "$item_name" != "README.md" ] && [ "$item_name" != "wallpapers" ] && [ "$item_name" != "wallpaper.jpg" ] && [ "$item_name" != "config" ]; then
        if [ -f "$item" ]; then
            info "Copying file $item_name → ~/.$item_name"
            cp "$item" "$HOME/.$item_name" &>/dev/null
            
            # Replace user placeholders in the file
            if [ -f "$HOME/.$item_name" ]; then
                sed -i "s|{{USER_HOME}}|$CURRENT_HOME|g" "$HOME/.$item_name" 2>/dev/null
            fi
        fi
    fi
done

# Copy config directory contents to ~/.config/ without prefix
if [ -d "dotfiles/config" ]; then
    info "Copying config directory contents to ~/.config/"
    mkdir -p "$HOME/.config" &>/dev/null
    
    for config_item in dotfiles/config/*; do
        config_name=$(basename "$config_item")
        if [ -d "$config_item" ]; then
            # Create the destination directory
            mkdir -p "$HOME/.config/$config_name" &>/dev/null
            
            # Copy only files from within the subdirectory, not the directory itself
            for subfile in "$config_item"/*; do
                if [ -f "$subfile" ]; then
                    subfile_name=$(basename "$subfile")
                    info "Copying config file $config_name/$subfile_name → ~/.config/$config_name/$subfile_name"
                    cp "$subfile" "$HOME/.config/$config_name/" &>/dev/null
                    
                    # Replace user placeholders in the config file
                    if [ -f "$HOME/.config/$config_name/$subfile_name" ]; then
                        sed -i "s|{{USER_HOME}}|$CURRENT_HOME|g" "$HOME/.config/$config_name/$subfile_name" 2>/dev/null
                    fi
                elif [ -d "$subfile" ]; then
                    # Handle nested directories recursively
                    subdir_name=$(basename "$subfile")
                    mkdir -p "$HOME/.config/$config_name/$subdir_name" &>/dev/null
                    
                    for nested_file in "$subfile"/*; do
                        if [ -f "$nested_file" ]; then
                            nested_file_name=$(basename "$nested_file")
                            info "Copying nested config file $config_name/$subdir_name/$nested_file_name → ~/.config/$config_name/$subdir_name/$nested_file_name"
                            cp "$nested_file" "$HOME/.config/$config_name/$subdir_name/" &>/dev/null
                            
                            # Replace user placeholders in the nested config file
                            if [ -f "$HOME/.config/$config_name/$subdir_name/$nested_file_name" ]; then
                                sed -i "s|{{USER_HOME}}|$CURRENT_HOME|g" "$HOME/.config/$config_name/$subdir_name/$nested_file_name" 2>/dev/null
                            fi
                        fi
                    done
                fi
            done
        elif [ -f "$config_item" ]; then
            info "Copying config file $config_name → ~/.config/$config_name"
            cp "$config_item" "$HOME/.config/" &>/dev/null
            
            # Replace user placeholders in the config file
            if [ -f "$HOME/.config/$config_name" ]; then
                sed -i "s|{{USER_HOME}}|$CURRENT_HOME|g" "$HOME/.config/$config_name" 2>/dev/null
            fi
        fi
    done
fi

# Copy vscode directory to ~/.config/Code/User/ if it exists
if [ -d "dotfiles/vscode" ]; then
    info "Copying vscode settings to ~/.config/Code/User/"
    mkdir -p "$HOME/.config/Code/User" &>/dev/null
    
    for vscode_item in dotfiles/vscode/*; do
        vscode_name=$(basename "$vscode_item")
        if [ -f "$vscode_item" ]; then
            info "Copying vscode file $vscode_name → ~/.config/Code/User/$vscode_name"
            cp "$vscode_item" "$HOME/.config/Code/User/" &>/dev/null
            
            # Replace user placeholders in the vscode file
            if [ -f "$HOME/.config/Code/User/$vscode_name" ]; then
                sed -i "s|{{USER_HOME}}|$CURRENT_HOME|g" "$HOME/.config/Code/User/$vscode_name" 2>/dev/null
            fi
        fi
    done
fi

success "Dotfiles configuration copied and user paths updated"

step "Installing Zsh plugins"
info "Installing syntax highlighting plugin..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &>/dev/null
info "Installing autosuggestions plugin..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &>/dev/null
success "Zsh plugins installed"

step "Applying theme configurations"
info "Note: Most theme settings are already in dotfiles and will be applied automatically"
info "Configuring additional KDE settings..."

info "Configuring fonts..."
kwriteconfig5 --file ~/.config/kdeglobals --group General --key font "FiraCode Nerd Font,10,-1,5,50,0,0,0,0,0" &>/dev/null
kwriteconfig5 --file ~/.config/kdeglobals --group General --key menuFont "FiraCode Nerd Font,10,-1,5,50,0,0,0,0,0" &>/dev/null
kwriteconfig5 --file ~/.config/kdeglobals --group General --key toolBarFont "FiraCode Nerd Font,10,-1,5,50,0,0,0,0,0" &>/dev/null

info "Configuring desktop settings..."
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key SingleClick false &>/dev/null
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key ShowDeleteCommand false &>/dev/null

info "Updating icon cache..."
gtk-update-icon-cache ~/.local/share/icons/Tela-purple-dark 2>/dev/null || true
success "Theme configurations applied"

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
echo -e "    • Customize your dotfiles in ~/.config as needed"
echo ""
echo -e "${PURPLE}${BOLD}Enjoy your new desktop environment! 🚀${NC}"
