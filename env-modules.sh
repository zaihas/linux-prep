#!/bin/bash

set -e
set -x



# define
# -----------------------------------------------------------

# target temp folder
PATH_TO_CC_TAR=$PWD/gcc-arm-temp
PATH_TO_CC_MOD_CFG=$PWD/mod_cfg
PATH_TO_CC_TGT=/opt
PATH_TO_PRI_MOD=/opt/module

# list of compiler
declare -a CC_VER=("gcc-arm-5.4")

# list of GCC compiler tarball
declare -a CC_TAR_FILE=("gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2")

# source of tarball - url
declare -a CC_URL=("https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q3-update/+download")

NUM_CC=${#CC_VER[@]}


# start installation
# -----------------------------------------------------------

# install environment-modules
sudo apt-get -y install environment-modules

# install fix for virtual-machine can't detect executable
sudo apt-get -y install lib32ncurses5

# clean up
if [ -d "$PATH_TO_CC_TAR" ]; then
    rm -rf $PATH_TO_CC_TAR
fi

# put the enviroment variable for .bashrc
if [ "$(cat $HOME/.bashrc | grep -F "source /etc/profile.d/modules.sh")" == "" ];then
    echo "" >> $HOME/.bashrc
    echo "# enable enviroment-modules" >> $HOME/.bashrc
    echo "source /etc/profile.d/modules.sh" >> $HOME/.bashrc
    echo "module use --append $PATH_TO_PRI_MOD" >> $HOME/.bashrc
fi

# download, and copy to specific location
mkdir -p $PATH_TO_CC_TAR
sudo mkdir -p $PATH_TO_PRI_MOD

for ((idx=0; idx<$NUM_CC; idx++)); do

    sudo mkdir -p $PATH_TO_CC_TGT/${CC_VER[$i]}

    # get fw and extract to target folder - /opt/<compiler_name>
    wget ${CC_URL[$i]}/${CC_TAR_FILE[$i]} -P $PATH_TO_CC_TAR
    sudo tar xvjf $PATH_TO_CC_TAR/${CC_TAR_FILE[$i]} -C $PATH_TO_CC_TGT/${CC_VER[$i]} --strip-components=1

    # copy config for that module
    sudo cp $PATH_TO_CC_MOD_CFG/${CC_VER[$i]} $PATH_TO_PRI_MOD
done

# re-initialize terminal with new setting
. $HOME/.bashrc

