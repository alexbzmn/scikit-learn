#!/usr/bin/env bash
# This test script is mean to be executed with 'docker run' using one of the manylinux images

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86.sh \
        -O miniconda.sh

MINICONDA_PATH=/home/travis/miniconda
chmod +x miniconda.sh && ./miniconda.sh -b -p $MINICONDA_PATH
export PATH=$MINICONDA_PATH/bin:$PATH
conda update --yes conda

conda create -n testenv --yes python=$PYTHON_VERSION pip \
            numpy=$NUMPY_VERSION scipy=$SCIPY_VERSION \
            nomkl cython=$CYTHON_VERSION \
            ${PANDAS_VERSION+pandas=$PANDAS_VERSION}

source activate testenv

export PATH=$MINICONDA_PATH/envs/testenv/bin:$PATH

rm setup.cfg

set -e
export PATH=/opt/python/cp36-cp36m/bin:$PATH
pip install nose pytest
cd /io
pip install -e .
pytest -l sklearn