#!/bin/bash

install_vim()
{
    #Build and install Vim with python2.7 enabled
  
    present_working_dir=`pwd`

    #Installing dependencies
    sudo apt -y update
    sudo apt -y install libncurses5-dev libgnome2-dev python-dev git
    #Removing vim
    sudo apt -y remove vim vim-runtime gvim

    #Building vim
    cd /tmp
    sudo rm -rf vim
    git clone https://github.com/vim/vim.git
    if [ "$1" == "-lr" ]; then
        git checkout `git describe --tags`
    fi
    cd vim
    ./configure --with-features=huge \
        --enable-multibyte \
        --enable-pythoninterp=yes \
        --with-python-config-dir=/usr/lib/python2.7/config \
        --enable-gui=gtk4 \
        --enable-cscope \
        --prefix=/usr/local
    #make VIMRUNTIMEDIR=/usr/local/share/vim/vim80
    make
    #Installing VIM
    sudo make install
    cd $present_working_dir
}


setup_vim()
{

    #Setting up plugins for vim

    rm -rf ~/.vim/

    #Setting up vundle(pluging manager)
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    cp vimrc ~/.vim/
    #Installing plugins
    vim +PluginInstall +qall
}

main()
{

    set -x
    set -e
    install_vim "$@"
    setup_vim
    set +x
    set +e
}

main "$@"
