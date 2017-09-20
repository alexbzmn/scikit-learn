#!/usr/bin/env bash
# This script is meant to be executed with 'docker run' using one of the manylinux images.
# The script employs running tests on 32bit linux image.
# The behavior of the script is controlled by environment variables defined
# in the .travis.yml in the top level folder of the project.

# License: 3-clause BSD

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86.sh \
        -O miniconda.sh

MINICONDA_PATH=/home/travis/miniconda
chmod +x miniconda.sh && ./miniconda.sh -b -p $MINICONDA_PATH

export PATH_OLD=$PATH
export PATH=$MINICONDA_PATH/bin:$PATH

conda update --yes conda

conda create -n testenv --yes python=$PYTHON_VERSION pip \
            numpy=$NUMPY_VERSION scipy=$SCIPY_VERSION \
            nomkl cython=$CYTHON_VERSION \
            ${PANDAS_VERSION+pandas=$PANDAS_VERSION}

source activate testenv

export PATH=$MINICONDA_PATH/envs/testenv/bin:$PATH_OLD

set -e
pip install numpy scipy cython nose pytest
cd /io
rm setup.cfg
pip install -e .
pytest -l sklearn
