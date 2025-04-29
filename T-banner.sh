#!/bin/bash
#Developer: Aman Khan
#Github   : https://github.com/ak-alien

GREEN="\033[1;32m"
RESET="\033[0m"

install() {
    clear
    display_banner
    echo -e "${GREEN}Updating and installing packages...${RESET}"
    pkg update -y && pkg upgrade -y
    pkg install figlet ruby curl -y

    echo -e "${GREEN}Installing lolcat...${RESET}"
    gem install lolcat

    rm -rf ~/.figlet
    mkdir -p ~/.figlet

    echo -e "${GREEN}Downloading ANSI Shadow font...${RESET}"
    curl -L -o ~/.figlet/ansi_shadow.flf https://raw.githubusercontent.com/ak-alien/T-banner/refs/heads/main/Font/ANSI%20Shadow.flf

    if [ ! -f ~/.figlet/ansi_shadow.flf ]; then
      echo -e "${GREEN}Error: Font not found!${RESET}"
      exit 1
    fi
    menu
}

set_banner() {
    clear
    display_banner
    echo -e "$GREEN"
    read -p "  Enter your Banner Name: " BANNER_NAME
    echo -e "$RESET"

    BANNER_RAW=$(figlet -d ~/.figlet -f ansi_shadow "$BANNER_NAME")

    MAX_WIDTH=0
    while IFS= read -r line; do
        line_length=${#line}
        if [ "$line_length" -gt "$MAX_WIDTH" ]; then
            MAX_WIDTH=$line_length
        fi
    done <<< "$BANNER_RAW"

    MIN_WIDTH=60

    outer_width=$((MAX_WIDTH + 4))  # 2 spaces padding + 2 borders

    if [ "$outer_width" -lt "$MIN_WIDTH" ]; then
    outer_width=$MIN_WIDTH
    fi

    side_space=1

    CENTER_STYLE="≫ ──── ≪•◦ ❈ ◦•≫ ──── ≪"

    top=" ╔$(printf '═%.0s' $(seq 1 $((outer_width-2))))╗"

    CENTER_LENGTH=${#CENTER_STYLE}
    REMAINING=$(( outer_width - 2 - CENTER_LENGTH ))
    LEFT_FILL=$(( REMAINING / 2 ))
    RIGHT_FILL=$(( REMAINING - LEFT_FILL ))
    bottom=" ╚$(printf '═%.0s' $(seq 1 $LEFT_FILL))${CENTER_STYLE}$(printf '═%.0s' $(seq 1 $RIGHT_FILL))╝"

    {
      echo
      echo "$top"
      printf " ║%*s%*s║\n" $((outer_width-2)) " " ""

      while IFS= read -r line; do
        LINE_LENGTH=${#line}
        LEFT_PADDING=$(( (outer_width - 2 - LINE_LENGTH) / 2 ))
        RIGHT_PADDING=$(( outer_width - 2 - LINE_LENGTH - LEFT_PADDING ))
        printf " ║%*s%s%*s║\n" "$LEFT_PADDING" "" "$line" "$RIGHT_PADDING" ""
      done <<< "$BANNER_RAW"

      echo "$bottom"

      echo
      echo
      echo

    } > /data/data/com.termux/files/usr/etc/motd.bak

    # Remove motd file if exist
    MOTD_FILE="/data/data/com.termux/files/usr/etc/motd"
    if [ -f "$MOTD_FILE" ]; then
        rm -f "$MOTD_FILE"
    fi

    # Modify bash.bashrc
    BASHRC_PATH="/data/data/com.termux/files/usr/etc/bash.bashrc"

    # Remove old entries if exist
    sed -i '/cat \/data\/data\/com.termux\/files\/usr\/etc\/motd.bak/d' "$BASHRC_PATH"
    sed -i '/PS1=/d' "$BASHRC_PATH"

    # Add new entries
    echo "cat /data/data/com.termux/files/usr/etc/motd.bak | lolcat" >> "$BASHRC_PATH"
    echo "export PS1='\e[1;31m ┌─╼[\e[1;32m${BANNER_NAME}@Terminal\e[1;31m]-[\e[1;32m\w\e[1;31m]\e[0m\n\e[1;31m └╼\e[1;97m❯\e[1;34m❯\e[1;36m❯\e[0m '" >> "$BASHRC_PATH"

    clear
    source "$BASHRC_PATH"

    echo -e "${GREEN}Setup finished. Restart Termux to view it.${RESET}"
}

add_motd() {
  cat > "$PREFIX/etc/motd" << 'EOF'
Welcome to Termux!

Docs:       https://termux.dev/docs
Donate:     https://termux.dev/donate
Community:  https://termux.dev/community

Working with packages:

 - Search:  pkg search <query>
 - Install: pkg install <package>
 - Upgrade: pkg upgrade

Subscribing to additional repositories:

 - Root:    pkg install root-repo
 - X11:     pkg install x11-repo

For fixing any repository issues,
try 'termux-change-repo' command.

Report issues at https://termux.dev/issues

EOF
}

remove_banner() {
    clear
    display_banner
    # Remove motd file if exist
    MOTD_FILE="/data/data/com.termux/files/usr/etc/motd.bak"
    if [ -f "$MOTD_FILE" ]; then
        rm -f "$MOTD_FILE"
    fi
    echo -e "${GREEN}  Removed banner file...${RESET}"
    sleep 2

    # Modify bash.bashrc
    BASHRC_PATH="/data/data/com.termux/files/usr/etc/bash.bashrc"

    # Remove old entries if exist
    sed -i '/cat \/data\/data\/com.termux\/files\/usr\/etc\/motd.bak/d' "$BASHRC_PATH"
    echo -e "${GREEN}  Removed banner entrie...${RESET}"
    sed -i '/PS1=/d' "$BASHRC_PATH"
    echo -e "${GREEN}  Removed prompt entrie...${RESET}"

    # Add new entries
    add_motd
    echo -e "${GREEN}  Termux default MOTD restored.${RESET}"
    echo "export PS1='\[\e[0;32m\]\w\[\e[0m\] \[\e[0;97m\]\$\[\e[0m\] '" >> "$BASHRC_PATH"
    echo -e "${GREEN}  Termux default PS1 prompt restored.${RESET}"
    echo
    echo -e "${GREEN}Banner removed. Restart Termux to view it.${RESET}"
}

display_banner() {
    echo -e " ╔══════════════════════════════════════════════════════════╗"
    echo -e " ║                                                          ║"
    echo -e " ║  ████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗   ║"
    echo -e " ║  ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║╚██╗██╔╝   ║"
    echo -e " ║     ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║ ╚███╔╝    ║"
    echo -e " ║     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ██╔██╗    ║"
    echo -e " ║     ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗   ║"
    echo -e " ║     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ║"
    echo -e " ║                                                          ║"
    echo -e " ╚═════════════════≫ ──── ≪•◦ ❈ ◦•≫ ──── ≪══════════════════╝"
    echo
    echo
    echo -e " ============================================================"
    echo -e "    Developed by: Aman Khan"
    echo -e "    Github: https://github.com/ak-alien"
    echo -e "    Telegram: https://t.me/ak_xlien"
    echo -e " ============================================================"
    echo
    echo
    echo
}

menu() {
    clear
    display_banner
    echo "  [1] Install packages & resources"
    echo "  [2] Setup Banner"
    echo "  [3] Remove Banner"
    echo "  [0] Exit"
    echo ""
    read -p "  [+] Please enter your choice (1-3): " choice

    case $choice in
        1)
            install
            ;;
        2)
            set_banner
            ;;
        3)
            remove_banner
            ;;
        0)
            echo -e "${CYAN}Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${CYAN}Invalid option. Please try again.${RESET}"
            sleep 2
            menu
            ;;
    esac
}

menu