sudo -v &&
    { systemd-inhibit --what=idle:sleep sleep 7200 & } &&
    tuned-adm profile throughput-performance &&
    TMP_DIR="$(mktemp -d)" &&
    wget -O "$TMP_DIR/dotfiles.zip" https://github.com/daniele821/dotfiles/archive/refs/heads/fedora-kde.zip &&
    unzip -d "$TMP_DIR" "$TMP_DIR/dotfiles.zip" &&
    NO_CHECKS="" "${TMP_DIR}/dotfiles-fedora-kde/autosaver" run &&
    echo fedora-kde >~/.personal/repos/daniele821/dotfiles/.branch &&
    rm -rf ~/.config/nvim && ln -s ~/.personal/repos/daniele821/nvim-config/ ~/.config/nvim && nvim --headless +qa &&
    for i in {30..1}; do
        echo -en "\r\e[Krebooting in $i seconds... ctrl+c to skip"
        sleep 1
    done &&
    tuned-adm profile powersave &&
    reboot || echo -e "\e[1;31mfailed to download and run init scripts\e[m"
