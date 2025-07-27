sudo -v &&
    echo -e "\e[1;33mWARNING: make sure to connect usb drive with passwords...\e[0m" &&
    sleep 10 &&
    { systemd-inhibit --what=idle:sleep sleep 7200 & } &&
    tuned-adm profile throughput-performance &&
    TMP_DIR="$(mktemp -d)" &&
    wget -O "$TMP_DIR/dotfiles.zip" https://github.com/daniele821/dotfiles/archive/refs/heads/fedora-kde.zip &&
    unzip -d "$TMP_DIR" "$TMP_DIR/dotfiles.zip" &&
    BRANCH="" "${TMP_DIR}/dotfiles-fedora-kde/autosaver" run &&
    for i in {30..1}; do
        echo "rebooting in $i seconds... ctrl+c to skip" && sleep 1
    done &&
    tuned-adm profile powersave &&
    reboot || echo -e "\e[1;31mfailed to download and run init scripts\e[m"
