#!/bin/bash

LOG_FILE="post-install.log"
FONTS_DIR="$HOME/.local/share/fonts/nerdfonts"

PACKAGES="libreoffice libreoffice-gnome vim gnome-boxes htop neofetch curl wget git tilix flatpak lollypop dirmngr devscripts devscripts-devuan ts-node nodejs tlp shellcheck rsyslog pipenv optipng npm build-essential ccls bleachbit apparmor-notify apparmor-profiles-extra apparmor-profiles apparmor-utils ansible gitg podman podman-compose podman-docker podman-toolbox crun python3-pip python3-dev python3-distutils python3-venv default-jdk gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly ffmpeg timeshift ufw gufw gnome-software-plugin-flatpak flatpak-xdg-utils earlyoom gnome-builder gtk2-engines-murrine gtk2-engines-pixbuf sassc inkscape gparted gnome-disk-utlity vim cmake lshw unrar-free unzip"

FLATPAKS="com.github.IsmaelMartinez.teams_for_linux com.microsoft.Edge io.podman_desktop.PodmanDesktop io.github.flattool.Warehouse io.dbeaver.DBeaverCommunity com.hunterwittenborn.Celeste com.github.jeromerobert.pdfarranger flatpak install flathub com.rtosta.zapzap com.logseq.Logseq com.spotify.Client io.posidon.Paper org.keepassxc.KeePassXC"

NAMESERVERS="1.1.1.1"

FLATHUB_REPO="https://flathub.org/repo/flathub.flatpakrepo"

function handle_error() {
    local exit_code="$1"
    local error_message="$2"
    echo "Error: $error_message (Exit code: $exit_code)" | tee -a $LOG_FILE
    exit "$exit_code"
}

log_action() {
    local action="$1"
    local start_time
    start_time=$(date +%s)

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Inicio de $action" | tee -a "$LOG_FILE"

    $action || handle_error $? "Error trying to run $action"

    local end_time
    end_time=$(date +%s)
    local elapsed_time=$((end_time - start_time))

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Fin de $action. Tiempo transcurrido: $elapsed_time segundos" | tee -a "$LOG_FILE"
}

function update_system() {
    log_action "Updating the currently installed packages" "sudo apt update"
    log_action "Upgrading the system Packages" "sudo apt upgrade -yy"
}

function add_backports() {
    log_action "Adding backports repository support..." "echo 'deb http://deb.devuan.org/merged daedalus-backports main' | sudo tee -a /etc/apt/sources.list.d/backports.list" 
    update_system
    log_action "Syncing backports..." "sudo apt update -t daedalus-backports && sudo apt upgrade -t daedalus-backports -y"
}

function install_packages() {
    log_action "Installing DevOps workstation applications" "sudo apt install $PACKAGES -yy"
}

function flatpakization() {
    log_action "Configuring Flatpak remote" "flatpak remote-add --if-not-exists flathub $FLATHUB_REPO"
    log_action "Installing DevOps Workstation flatpaks" "flatpak install flathub $FLATPAKS"
}

function nameservers() {
    log_action "Setting up nameservers" "sudo echo 'nameserver $NAMESERVERS' | sudo tee /etc/resolv.conf > /dev/null"
}

function fonts() {
    log_action "Downloading JetBrainsMono Nerd Font for programming" "wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
    log_action "Extracting fonts..." "unzip JetBrainsMono.zip"
    mkdir -p "$FONTS_DIR"
    mv *.ttf "$FONTS_DIR"
    rm JetBrainsMono.zip
    log_action "Updating font cache" "fc-cache -fv"
}

function workstation_setup() {
    log_action "Setting tilix as the default terminal emulator" "sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix"
    log_action "Setting up tilix as the default terminal emulator in gsettings" "gsettings set org.gnome.desktop.default-applications.terminal exec '/usr/bin/x-terminal-emulator'"
}

function main() {
    echo "Debian/Devuan post install script starting, please do not use your computer in the meantime..."

    nameservers;
    update_system;
    add_backports;
    install_packages;
    flatpakization;
    fonts;
    
    echo "Script finished, your computer will restart in:"
    for i in {5..1}; do
        echo "$i"
        sleep 1
    done
    sudo reboot
}

main;
