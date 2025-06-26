#!/bin/bash
# ----------------------------------------------------------
# © Copyright 2021 European Space Agency, 2021
# This file is subject to the terms and conditions defined
# in file 'LICENSE.txt', which is part of this
# [source code/executable] package. No part of the package,
# including this file, may be copied, modified, propagated,
# or distributed except according to the terms contained in
# the file 'LICENSE.txt'.
# -----------------------------------------------------------
JUPYTER_DEBUG=""
if [ "$LOG_LEVEL" == 'debug' ]; then
  JUPYTER_DEBUG="--debug"
fi
export JUPYTER_CONFIG_DIR=$HOME/.jupyterlab-$DATALAB_ID
# export MAIN_PORT=10000
echo "Jupyterlab server context"
echo "MAIN_ID=$MAIN_ID"
echo "MAIN_PORT=$MAIN_PORT"
echo "JUPYTER_CONFIG_DIR=$JUPYTER_CONFIG_DIR"
echo "Init Jupyterlab server environment"
jupyter lab --ip=0.0.0.0 $JUPYTER_DEBUG --port=$MAIN_PORT \
  --ServerApp.disable_check_xsrf=True \
  --NotebookApp.base_url="/datalabs/$MAIN_ID" \
  --NotebookApp.token='' --NotebookApp.password='' 