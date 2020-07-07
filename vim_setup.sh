#!/bin/bash

ENABLE_PYTHON3=1
LATEST_RELEASE=0

install_vim_py2()
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
    if [ $LATEST_RELEASE == 1 ]; then
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

usage()
{
    echo -e "Syntax: ./vim_setup.sh [-py2] [-lr]\n"
    echo -e "Description:"
    echo -e     "\tInstall vim and setup the vim enviroment for python2/3\n"
    echo -e "Options:"
    echo -e     "\t -py2,--enable-python2: 	enable python2.7"
    echo -e     "\t -lr,--latest-release:  	Install latest release vim"
}


parse_cmd_line_args()
{
    while [ "$1" != "" ]; do
        case $1 in
            -py2 | --enable-python2 )
                shift
                ENABLE_PYTHON3=0
                ;;
            -lr | --latest-release )
                shift
                LATEST_RELEASE=1
                ;;
            -h | --help )
                usage
                exit
                ;;
            * )
                usage
                exit 1
        esac
        shift
    done
}

main()
{
    parse_cmd_line_args "$@"
    set -x
    set -e
    if [ $ENABLE_PYTHON3 == 0 ]; then
        install_vim_py2
    else
        sudo apt install vim-nox
    fi
    setup_vim
    set +x
    set +e
}

main "$@"
