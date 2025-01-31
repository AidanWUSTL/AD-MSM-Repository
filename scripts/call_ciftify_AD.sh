#!/bin/bash
# script to call ciftify_recon_all
# add workbench to path
PATH=/opt/workbench/bin_linux64:$PATH
# add msm to path
PATH=/opt/msm:/opt:$PATH
# add freesurfer to path
PATH=/opt/freesurfer/bin:$PATH
# source FSL config for environment variables
. /opt/fsl/etc/fslconf/fsl.sh

# get input
sub=$1
sess=$2

# hard-coded variables - change as necessary for file structure
DATASET=/input # Folder containing subject data
CIFTIFY_OUTPUT_DIR=/output/ciftify

# source and add to path necessary FreeSurfer elements for CIFTIFY process
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export PATH=/opt:$PATH

# output directory (made it parent script)
SUBJECT_CIFTIFY_OUTPUT_DIR=${CIFTIFY_OUTPUT_DIR}/${sub}${sess}

# formal ciftify call
ciftify_recon_all --no-symlinks --resampleT1w32k --fs-license /license.txt --fs-subjects-dir ${DATASET} --ciftify-work-dir ${SUBJECT_CIFTIFY_OUTPUT_DIR} ${sub}${sess}

# exit with success if we made it this far
exit 0
