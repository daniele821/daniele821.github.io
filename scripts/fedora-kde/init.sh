sudo -v && echo -e "\e[1;33mWARNING: make sure to connect usb drive with passwords...\e[0m" &&
    sleep 10 && { systemd-inhibit --what=idle:sleep sleep 3600 & } &&
    tuned-adm profile throughput-performance &&
    TMP_DIR="$(mktemp -d)" && ZIP_FILE="${TMP_DIR}/dotfiles.zip" &&
    wget -O "$ZIP_FILE" https://github.com/daniele821/dotfiles/archive/refs/heads/fedora-kde.zip &&
    unzip -d "$TMP_DIR" "$ZIP_FILE" && BRANCH="" "${TMP_DIR}/dotfiles-fedora-kde/autosaver" restoreall &&
    bash -lic "BRANCH= '${TMP_DIR}/dotfiles-fedora-kde/autosaver' run" &&
    BRANCH="" "${TMP_DIR}/dotfiles-fedora-kde/autosaver" git &&
    SET_BRANCH="" /personal/repos/daniele821/dotfiles/autosaver &>/dev/null && rm -rf ~/.config/nvim &&
    ln -s /personal/repos/daniele821/nvim-config ~/.config/nvim && nvim --headless +qa &&
    for i in {30..1}; do echo "rebooting in $i seconds... ctrl+c to skip"; sleep 1; done &&
    tuned-adm profile powersave &&
    reboot || echo -e "\e[1;31mfailed to download and run init scripts\e[m"
