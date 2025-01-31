#!/usr/bin/csh
#  A script to kick-off the AD cortical expansion docker
# This docker has a variety of options in order to follow through with the
# "full" process

# check and display usage
if ( ${#argv} != 4 ) then
    echo "USAGE: run_AD_cortical_expansion_docker.sh <DESIRED LIST OF SUBJECTS + SESSIONS> <PROCESSING STAGE> <input folder> <output folder>"
    echo "Ex: run_AD_cortical_expansion_docker.sh selected_subjects_and_sessions.lst MSM input output"
	exit -1
endif

set subs_and_sess = $1
set stage = $2
set input = $3
set output = $4

# make log folder
mkdir -p ./logs ./jobs

sudo docker run --rm --user `id -u`:`id -g` -v "$input":/input -v "$output":/output -v `pwd`/scripts:/scripts -v `pwd`/logs:/logs -v `pwd`/jobs:/jobs -v `pwd`/license.txt:/opt/freesurfer/license.txt cortical_expansion_ad_test_build:latest $subs_and_sess $stage

exit 0
