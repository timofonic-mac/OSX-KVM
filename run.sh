#!/bin/bash -
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd "$SCRIPTPATH"

. ./install_basic.sh
. ./install_cuda.sh
. ./install_cudnn.sh
. ./install_anaconda3.sh
export CUDA_HOME=/usr/local/cuda
export PATH="$HOME/anaconda3/bin:$PATH"
export PATH="/usr/local/bin:/opt/local/sbin:$PATH"
. ./install_fastai.sh
. ./configure_jupyter.sh
