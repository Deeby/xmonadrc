# 添加vscode
if [ ! -e /etc/apt/trusted.gpg.d/microsoft.gpg ];then
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
fi

# 添加chrome
if [ ! -e /etc/apt/sources.list.d/google-chrome.list ];then
sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -
fi

# theme
sudo add-apt-repository ppa:daniruiz/flat-remix

apt update

apt install  astyle tty-clock ipython gnome-screensaver screen tree polipo libboost1.62-all-dev libclang-common-6.0-dev libclang-dev libclang1-5.0 libclang-5.0-dev ycmd xbuilder fcitx-table fcitx-bin powertop haskell-stack haskell-platform lua5.1 ruby lua5.1-policy-dev perl libperl-dev python3 python3.6-dev libruby2.5 ruby-dev llvm clang ack libclang-6.0-dev gimp htop xclip arandr hsetroot xcompmgr shutter indicator-cpufreq autocutsel numlockx happy alex icdiff xmonad google-chrome-stable code xmonad cabal-install feh taffybar xcompmgr numlockx libgtk-3-dev indicator-cpufreq suckless-tools sakura gobject-introspection libgirepository1.0-dev libdbusmenu-gtk3-dev libgirepository1.0-dev libwebkit2gtk-4.0-dev libgtksourceview-3.0-dev python-smbus python3-pip -y lxappearance flat-remix-gnome flat-remix-theme

# 我想要一劳永逸地解决启动资源管理器就启动gnome整个桌面系统的问题
# 所以使用nemo
sudo apt install dconf-tools nemo -y
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.nemo.desktop show-desktop-icons false
gsettings set org.gnome.desktop.background show-desktop-icons true
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search


# 设置sakura为默认模拟器
sudo update-alternatives --set x-terminal-emulator /usr/bin/sakura
# 恢复使用nautilus(原生资源管理器)使用一下命令
# xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
