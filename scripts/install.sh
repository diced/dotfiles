function print {
  echo -e "\n\n$1\n\n";
}

print 'installing paru';

# create Downloads
mkdir -p ~/Downloads;

# install paru
git clone https://aur.archlinux.org/paru.git ~/Downloads
cd ~/Downloads && makepkg -si;


print 'install xorg & xorg related programs';
paru -S xorg xorg-xinit xdotool xsel

print 'install wm & wm related programs';
paru -S bspwm sxhkd rofi polybar siji-git lxappearance matcha-gtk-theme capitaine-cursors 

# paru -S xorg xorg-xinit alacritty antibody audacity base bspwm sxhkd picom capitaine-cursors dhcpcd dust-bin dvm-git feh firefox-developer-edition flameshot gnome-keyring gotop grub htop intel-ucode jdk-openjdk jq lutris lxappearance matcha-gtk-theme ttf-symbola nano nautilus neofetch nerd-fonts-jetbrains-mono networkmanager nodejs npm yarn nvidia-dkms nvidia-prime nvtop obs-studio pavucontrol picom pipewire pipewire-alsa pipewire-media-session pipewire-pulse polybar postgresql postman-bin rofi rsync rustup siji-git spotify starship steam tealdeer ttf-jetbrains-mono ttf-ms-fonts ttf-windows ttf-twemoji zip unzip rar vlc wgcf wget wireguard-tools xcolor xdotool xsel youtube-dl zoom zsh
