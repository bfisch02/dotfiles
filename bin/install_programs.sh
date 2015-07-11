#!/bin/bash
# Install script for setting up all of my programs on Linux

printHelp()
{
    echo "Ben's Software Manager"
    echo "   Options:"
    echo "   -h  Print Help"
    echo "   -u  Upgrade"
    echo "   -i  Install new programs"
    echo "   -m  Install minimum program set"
}

getUpdates()
{
    sudo apt-get -y update
}

getUpgrades()
{
    sudo apt-get -y upgrade
}

installAll()
{
    installMin

    # Development
    installLanguages

    sudo apt-get -y install ack-grep
                            byacc flex \
                            clang \
                            curl \
                            exuberant-ctags \
                            gdb \
                            icedtea-netx \
                            icedtea-plugin \
                            npm
                            python-software-properties pkg-config \
                            shellcheck \
                            subversion \

    sudo npm -g install instant-markdown-d
    sudo npm -g install glob

    installArcanist

    # Browsers
    sudo apt-get -y install chromium-browser \
                            google-chrome \
                            flashplugin-installer

    # Networking
    sudo apt-get -y install nmap \
                            install vinagre \
                            install wireshark \
                            install filezilla \
                            install curl

    # Media
    sudo apt-get -y install libavcodec-extra \
                            vlc \
                            totem \
                            xbmc \
                            libav-tools \
                            mupdf \
                            gimp \
                            imagemagick

    # Other
    sudo apt-get -y install deluge \
                            htop
}

installMin()
{
    sudo apt-get -y install keepass2
}

installArcanist()
{
    if ! [[ -f ~/arcanist/arcanist/README ]]; then
        sudo apt-get -y install php5-cli php5-curl php5-json
        mkdir ~/arcanist
        cd ~/arcanist
        git clone https://github.com/facebook/libphutil.git
        git clone https://github.com/facebook/arcanist.git
    fi
}

installRuby()
{
    curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    curl -sSL https://get.rvm.io | bash -s stable --ruby
}

installGems()
{
    gem install bundler
    bundle install
}

installLanguages()
{
    sudo apt-get -y install ghc \
                            cabal-install \
                            ghc-mod
    cabal update
    cabal install parsec
    cabal install happy
    cabal install hoogle

    sudo apt-get -y install mit-scheme
    sudo apt-get -y install octave

    sudo apt-get -y install python \
                            python-dev \
                            python-pip
    sudo pip install "ipython[all]"

    #installRuby
    checkYCM
}

# First install and setup LLVM!
installClang()
{
    sudo ln -s /usr/local/bin/clang++ clang++
    sudo ln -s /usr/local/bin/clang clang
}

checkYCM()
{
    return
    #[ -f ~/.vim/bundle/YouCompleteMe/
    #~/bin/ycm_home_install.sh
}

## ============================================================================
##                                  OptArgs
## ============================================================================
if [ -z "$1" ]; then printHelp; fi

while getopts "huimr" opt; do
    case $opt in
        h)
            printHelp
            ;;
        u)
            echo "Upgrading"
            getUpdates
            getUpgrades
            ;;
        i)
            echo "Installing programs" >&2
            getUpdates
            installAll
            ;;
        m)
            echo "Installing minimum program set" >&2
            getUpdates
            installMin
            ;;
        r)
            echo "Installing Ruby" >&2
            installRuby
            installGems
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done
