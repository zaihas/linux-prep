#!/bin/bash

set -e
set -x

CURR_DIR=$PWD
FONT_DIR=$CURR_DIR/font-temp

if [ ! -d "$FONT_DIR" ]; then
    mkdir $FONT_DIR
fi
cd $FONT_DIR

# get windows cab
wget http://download.microsoft.com/download/E/6/7/E675FFFC-2A6D-4AB0-B3EB-27C9F8C8F696/PowerPointViewer.exe

# extract cab
cabextract -L -F ppviewer.cab PowerPointViewer.exe
cabextract ppviewer.cab

# run font manager
sudo font-manager

# remove folder
if [ -d "$FONT_DIR" ]; then
    rm -rf $FONT_DIR
fi
