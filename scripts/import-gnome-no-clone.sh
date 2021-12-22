# use this script if you don't want to import my entire dotfiles
# the script will download the files it needs like gnome.ini
# then it will ask if you want to overwrite certain settings
# if you do, it will ask you to review the settings before importing
# then it will import the settings
# then it will ask if you want to enable various gnome extensions
# it will download them if they don't already exist
# after all this it will restart the gnome-shell and enable all the extensions.
# the other script will not import pop-shell or the unite extension as they are custom and already included in the git repo.


extension_dir="$HOME/.local/share/gnome-shell/extensions"
# extension_dir="$HOME/gnomeer"

if [ ! -f "$HOME/.config/gnome/gnome.ini" ]; then
  echo "importing gnome.ini from github"
  mkdir -p $HOME/.config/gnome
  curl -s https://raw.githubusercontent.com/diced/dotfiles/trunk/.config/gnome/gnome.ini > $HOME/.config/gnome/gnome.ini
fi

echo "please review the config file as it may overwrite keybinds or settings you may have";
sleep 1;
less $HOME/.config/gnome/gnome.ini;


read -p "Do you want to import gnome.ini? [y/N] " -n 1 -r
echo
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "> dconf load /org/gnome/ < $HOME/.config/gnome/gnome.ini"
  dconf load /org/gnome/ < $HOME/.config/gnome/gnome.ini
  echo
else
  echo "aborting";
  exit 0;
fi

read -p "Would you like to enable/install the 'Argos' extension? [y/N] " -n 1 -r
echo
echo

# gnome 40 supported unofficial argos fork but still works! https://github.com/mwilck/argos
if [[ $REPLY =~ ^[Yy]$ ]]
then
  if [ ! -d "$extension_dir/argos@pew.worldwidemann.com" ];
  then
    mkdir -p $extension_dir

    echo "> git clone https://github.com/mwilck/argos"
    git clone https://github.com/mwilck/argos /tmp/argos

    echo "Installing Argos"
    mv /tmp/argos/argos@pew.worldwidemann.com $extension_dir/

    rm -rf /tmp/argos

    echo "Argos is installed, the extension will be enabled at the end of the script";
  else
    echo "Argos is already installed, the extension will be enabled at the end of the script";
  fi
else
  echo "aborting";
fi

# install auto move windows extension https://extensions.gnome.org/extension-data/auto-move-windowsgnome-shell-extensions.gcampax.github.com.v48.shell-extension.zip
read -p "Would you like to enable/install the 'Auto Move Windows' extension? [y/N] " -n 1 -r
echo
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
  if [ ! -d "$extension_dir/auto-move-windows@gnome-shell-extensions.gcampax.github.com" ];
  then
    mkdir -p $extension_dir

    echo "> wget https://extensions.gnome.org/extension-data/auto-move-windowsgnome-shell-extensions.gcampax.github.com.v48.shell-extension.zip"
    wget https://extensions.gnome.org/extension-data/auto-move-windowsgnome-shell-extensions.gcampax.github.com.v48.shell-extension.zip -O /tmp/auto-move-windows.zip

    echo "> unzip -d /tmp/auto-move-windows@gnome-shell-extensions.gcampax.github.com"
    unzip -d /tmp/auto-move-windows@gnome-shell-extensions.gcampax.github.com /tmp/auto-move-windows.zip

    echo "Installing Auto Move Windows"
    mv /tmp/auto-move-windows@gnome-shell-extensions.gcampax.github.com $extension_dir/

    rm -rf /tmp/auto-move-windows@gnome-shell-extensions.gcampax.github.com

    echo "Auto Move Windows is installed, the extension will be enabled at the end of the script";
  else
    echo "Auto Move Windows is already installed, the extension will be enabled at the end of the script";
  fi
else
  echo "aborting";
fi

# install Dash to Panel extension https://github.com/home-sweet-gnome/dash-to-panel
read -p "Would you like to enable/install the 'Dash to Panel' extension? [y/N] " -n 1 -r
echo
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
  if [ ! -d "$extension_dir/dash-to-panel@jderose9.github.com" ];
  then
    mkdir -p $extension_dir

    echo "> git clone https://github.com/home-sweet-gnome/dash-to-panel"
    git clone https://github.com/home-sweet-gnome/dash-to-panel /tmp/dash-to-panel@jderose9.github.com

    echo "Installing Dash to Panel"
    mv /tmp/dash-to-panel@jderose9.github.com $extension_dir/

    rm -rf /tmp/dash-to-panel@jderose9.github.com

    echo "Dash to Panel is installed, the extension will be enabled at the end of the script";
  else
    echo "Dash to Panel is already installed, the extension will be enabled at the end of the script";
  fi
else
  echo "aborting";
fi

# install Panel Date Format extension https://github.com/KEIII/gnome-shell-panel-date-format
read -p "Would you like to enable/install the 'Panel Date Format' extension? [y/N] " -n 1 -r
echo
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
  if [ ! -d "$extension_dir/panel-date-format@keiii.github.com" ];
  then
    mkdir -p $extension_dir

    echo "> git clone https://github.com/KEIII/gnome-shell-panel-date-format"
    git clone https://github.com/KEIII/gnome-shell-panel-date-format /tmp/panel-date-format@keiii.github.com

    echo "Installing Panel Date Format"
    mv /tmp/panel-date-format@keiii.github.com $extension_dir/

    rm -rf /tmp/panel-date-format@keiii.github.com

    echo "Panel Date Format is installed, the extension will be enabled at the end of the script";
  else
    echo "Panel Date Format is already installed, the extension will be enabled at the end of the script";
  fi
else
  echo "aborting";
fi

# install pop shell https://i.diced.cf/u/uQJcrD.gz (custom version)
read -p "Would you like to enable/install the 'Pop Shell' extension? [y/N] " -n 1 -r
echo
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
  if [ ! -d "$extension_dir/pop-shell@system76.com" ];
  then
    mkdir -p $extension_dir

    echo "> wget https://i.diced.cf/u/uQJcrD.gz"
    wget https://i.diced.cf/u/uQJcrD.gz -O /tmp/pop-shell.gz

    echo "> unzip -d /tmp/pop-shell.gz"
    tar xvf /tmp/pop-shell.gz -C $extension_dir
    echo "Installing Pop Shell"

    rm -rf /tmp/pop-shell.gz

    echo "Pop Shell is installed, the extension will be enabled at the end of the script";
  else
    echo "Pop Shell is already installed, the extension will be enabled at the end of the script";
  fi
else
  echo "aborting";
fi

# install pop shell https://i.diced.cf/u/rkqEyU.gz (custom version)
read -p "Would you like to enable/install the 'Unite' extension? [y/N] " -n 1 -r
echo
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
  if [ ! -d "$extension_dir/unite@hardpixel.eu" ];
  then
    mkdir -p $extension_dir

    echo "> wget https://i.diced.cf/u/rkqEyU.gz"
    wget https://i.diced.cf/u/rkqEyU.gz -O /tmp/unite.gz

    echo "> unzip -d /tmp/unite.gz"
    tar xvf /tmp/unite.gz -C $extension_dir
    echo "Installing Pop Shell"

    rm -rf /tmp/unite.gz

    echo "Unite is installed, the extension will be enabled at the end of the script";
  else
    echo "Unite is already installed, the extension will be enabled at the end of the script";
  fi
else
  echo "aborting";
fi


read -p "Do you want to restart gnome shell to apply changes? Your desktop may become unusable for a few moments [y/N] " -n 1 -r
echo
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "> killall -SIGQUIT gnome-shell"
  killall -SIGQUIT gnome-shell
else
  echo "aborting";
  exit 0;
fi

echo "Waiting for gnome-shell...";
sleep 3;

echo "Enabling extensions"
extensions=(argos@pew.worldwidemann.com dash-to-panel@jderose9.github.com pop-shell@system76.com auto-move-windows@gnome-shell-extensions.gcampax.github.com panel-date-format@keiii.github.com unite@hardpixel.eu native-window-placement@gnome-shell-extensions.gcampax.github.com)

# enable each extension
for extension in "${extensions[@]}"
do
  echo "> gnome-extensions enable $extension"
  gnome-extensions enable $extension
done
