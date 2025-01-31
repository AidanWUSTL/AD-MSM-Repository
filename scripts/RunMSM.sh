#!/bin/bash
# hard-coded variables
SUBJECT_TXT=/scripts/$1 # List of subjects + sessions to iterate over - see README for guide on construction
# add workbench to path
PATH=/opt/workbench/bin_linux64:$PATH

# start building job file for parallelization
stub=`echo -n $1 | md5sum`
combos=( `cat /scripts/$1` )
jobs=/jobs/AD_cortical_expansion_${#combos[@]}_subs_MSM_${stub%???}.lst
rm $jobs
touch $jobs

# hard-coded hemispheres variable
hems=( L R )

# iterate over subjects + sessions
for line in `cat $SUBJECT_TXT`; do
	# get columns of input file
	sub=`echo $line | cut -d "," -f1`
	sess1=`echo $line | cut -d "," -f2`
	sess2=`echo $line | cut -d "," -f3`
    
    # iterate over hemispheres
	for hem in ${hems[@]}; do
		# "forwards" direction job to file
		echo "/scripts/call_msm_AD.sh ${sub} ${sess1} ${sess2} ${hem}" >> $jobs
		# "backwards" direction job to file
		echo "/scripts/call_msm_AD.sh ${sub} ${sess2} ${sess1} ${hem}" >> $jobs
	done
	
	# to avoid unneccesary writing of files, create some shared ones across these
	# jobs, before they are ran
	# construct ciftify folder locations for both sessions for the subject
	DATASET=/output/ciftify # Folder containing subject data
	RESOLUTION="32k" # resolution of mesh to use either '32k' or '164k'
	RESOLUTION_LOCATION="T1w/fsaverage_LR32k"
	# subject-session combo 1
	subsess1="${sub}${sess1}"
	# subject-session combo 2
	subsess2="${sub}${sess2}"
	# locations
	subsess1_loc=${DATASET}/${subsess1}/${RESOLUTION_LOCATION}
	subsess2_loc=${DATASET}/${subsess2}/${RESOLUTION_LOCATION}
	# generate the Left and Right Cortex Metric representations of the curvature data
	# for the first session
	wb_command -cifti-separate ${subsess1_loc}/../../MNINonLinear/fsaverage_LR32k/${subsess1}.curvature.${RESOLUTION}_fs_LR.dscalar.nii COLUMN -metric CORTEX_LEFT ${subsess1_loc}/../../MNINonLinear/fsaverage_LR32k/${subsess1}_Curvature.L.func.gii -metric CORTEX_RIGHT ${subsess1_loc}/../../MNINonLinear/fsaverage_LR32k/${subsess1}_Curvature.R.func.gii
	# and, for the second session
	wb_command -cifti-separate ${subsess2_loc}/../../MNINonLinear/fsaverage_LR32k/${subsess2}.curvature.${RESOLUTION}_fs_LR.dscalar.nii COLUMN -metric CORTEX_LEFT ${subsess2_loc}/../../MNINonLinear/fsaverage_LR32k/${subsess2}_Curvature.L.func.gii -metric CORTEX_RIGHT ${subsess2_loc}/../../MNINonLinear/fsaverage_LR32k/${subsess2}_Curvature.R.func.gii
	
	# great - now we've appended the job to the running "jobs" file and have all the necessary files
	
done

# after constructing the jobs - run them		
cat $jobs | parallel -j 60 --colsep ' ' --verbose bash {}

# eventually, we'll exit
exit 0

