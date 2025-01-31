#!/bin/bash
# script to call msm
# add workbench to path
PATH=/opt/workbench/bin_linux64:$PATH
# add msm to path
PATH=/opt/msm:/opt:$PATH
# add freesurfer to path
PATH=/opt/freesurfer/bin:$PATH
# source FSL config for environment variables
. /opt/fsl/etc/fslconf/fsl.sh
# hard-coded variables - change as necessary for file structure
DATASET=/output/ciftify # Folder containing subject data
MSM_OUT=/output/msm # output for msm
mkdir -p $MSM_OUT
RESOLUTION="32k" # resolution of mesh to use either '32k' or '164k'
RESOLUTION_LOCATION="T1w/fsaverage_LR32k"

# MSM-related variables
LEVELS=6 # Levels for MSM
config=/scripts/configFINAL_anat6 # configuration file

# get input
# subject-session combo 1
subsess1=${1}${2}
# subject-session combo 2
subsess2=${1}${3}
# get hemisphere
hem=$4

# construct ciftify folder locations for both sessions for the subject
subsess1_loc=${DATASET}/${subsess1}/${RESOLUTION_LOCATION}
subsess2_loc=${DATASET}/${subsess2}/${RESOLUTION_LOCATION}

# define meshes for both sessions
ASsess1=${subsess1_loc}/${subsess1}.${hem}.midthickness.${RESOLUTION}_fs_LR.surf.gii
SSsess1=${subsess1_loc}/${subsess1}.${hem}.sphere.${RESOLUTION}_fs_LR.surf.gii
ASsess2=${subsess2_loc}/${subsess2}.${hem}.midthickness.${RESOLUTION}_fs_LR.surf.gii
SSsess2=${subsess2_loc}/${subsess2}.${hem}.sphere.${RESOLUTION}_fs_LR.surf.gii
# define curvature for both sessions
Csess1=${subsess1_loc}/../../MNINonLinear/fsaverage_LR32k/${subsess1}_Curvature.${hem}.func.gii
Csess2=${subsess2_loc}/../../MNINonLinear/fsaverage_LR32k/${subsess2}_Curvature.${hem}.func.gii

# define output folder structure
out_folder=${MSM_OUT}/${1}${2}${3}
mkdir -p $out_folder
out_name=${out_folder}/${1}${2}${3}_${hem}.

# with all that set - make the formal call to msm with options
msm --levels=${LEVELS} --conf=${config} --inmesh=${SSsess1} --refmesh=${SSsess2} --indata=${Csess1} --refdata=${Csess2} --inanat=${ASsess1} --refanat=${ASsess2} --out=${out_name} --verbose

# exit with success if we made it this far
exit 0
