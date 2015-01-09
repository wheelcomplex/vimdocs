#!/bin/bash
#
# base on https://github.com/yourihua/Documents/blob/master/Vim/Mac%E4%B8%8B%E4%BD%BF%E7%94%A8Vim%E6%90%AD%E5%BB%BAGo%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83.mdown
#

cat /etc/issue.net
isubuntu=`cat /etc/issue.net| grep -ci Ubuntu`
if $isubuntu -eq 0 ]
	then
	echo "error: this script support ubuntu only."
	exit 1
fi
if [ `id -u` -eq 0 ]
	then
	echo "error: this script should no run by root."
	exit 1
fi

if [ ! -x /usr/bin/vim ]
	then
	echo "error: /usr/bin/vim no executable."
	exit 1
fi

vimverok=`/usr/bin/vim --version | grep -c 'VIM - Vi IMproved 7.'`
if $vimverok -eq 0 ]
	then
	echo "error: this script support VIM - Vi IMproved 7.x only."
	echo "TIPS: sudo apt-get update && sudo apt-get install vim"
	exit 1
fi

cmdok=`which git| wc -l`
if $cmdok -eq 0 ]
	then
	echo "error: git has not installed"
	echo "TIPS: sudo apt-get update && sudo apt-get install git"
	exit 1
fi

cmdok=`which hg| wc -l`
if $cmdok -eq 0 ]
	then
	echo "error: hg/mercurial has not installed"
	echo "TIPS: sudo apt-get update && sudo apt-get install mercurial"
	exit 1
fi

cmdok=`env | grep -c 'GOARCH='`
if $cmdok -eq 0 ]
	then
	echo "error: GOARCH environment has not setup"
	echo "TIPS: http://wiki.ubuntu.org.cn/Golang"
	echo "TIPS: http://golang.org/doc/install"
	exit 1
fi

cmdok=`env | grep -c 'GOROOT='`
if $cmdok -eq 0 ]
	then
	echo "error: GOROOT environment has not setup"
	echo "TIPS: http://wiki.ubuntu.org.cn/Golang"
	echo "TIPS: http://golang.org/doc/install"
	exit 1
fi

cmdok=`env | grep -c 'GOPATH='`
if $cmdok -eq 0 ]
	then
	echo "error: GOPATH environment has not setup"
	echo "TIPS: http://wiki.ubuntu.org.cn/Golang"
	echo "TIPS: http://golang.org/doc/install"
	exit 1
fi

cd ~ 
backdir="vim-back-wheelcomplex/`date +%Y-%m-%d-%H-%M-%S`/" &&mkdir -p ~/"$backdir"
if [ $? -ne 0 ]
	then
	echo "error: create backup directory failed: $backdir"
	exit 1
fi
needback=`ls -a ~/.vim* 2>/dev/null|wc -l`
if [ $needback -ne 0 ]
	then
	mv ~/.vim* ~/"$backdir"
fi
gcmd="git clone https://github.com/wheelcomplex/vimdocs.git ~/tmp/vimdocs/"
mkdir -p ~/tmp/ && $gcmd
if [ $? -ne 0 ]
	then
	echo "error: git clone failed: $gcmd"
	exit 1
fi

gcmd="git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
$gcmd
if [ $? -ne 0 ]
	then
	echo "error: git clone failed: $gcmd"
	exit 1
fi

gcmd="cp ~/tmp/vimdocs/vimrc.txt ~/.vimrc"
$gcmd
if [ $? -ne 0 ]
	then
	echo "error: create .vimrc failed: $gcmd"
	exit 1
fi

gcmd="vim +PluginInstall +qall"
if [ $? -ne 0 ]
	then
	echo "error: PluginInstall failed: $gcmd"
	exit 1
fi
# start Vim，and run command :PluginInstall
# :qall exit vim and compile YouCompleteMe

cd ~/.vim/bundle/YouCompleteMe && git submodule update --init --recursive && ./install.sh
if [ $? -ne 0 ]
	then
	echo "error: YouCompleteMe compile failed: $gcmd"
	echo "TIPS: https://github.com/Valloric/YouCompleteMe"
	exit 1
fi
#