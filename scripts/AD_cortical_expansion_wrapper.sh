#!/bin/bash
# wrapper for docker to perform various aspects of the AD-cortical expansion pipeline
# initally developed by Dr. Kara Garcia and Emily Ianappolos.

# hard-coded log location
LOG_OUTPUT_DIR=/logs

# get params
subs_and_sess=$1 # subjects and sessions
stage=$2 # stage of processing - i.e. "CIFTIFY" or "MSM"

if [ "$stage" == "CIFTIFY" ]; then
	# set-up logging
	CURRENT_DATETIME=$(date +'%Y-%m-%d_%H-%M-%S') # Date and time will be appended to the log file so multiple can be run keeping data seperate
	LOG_OUTPUT=${LOG_OUTPUT_DIR}/RunCiftify_${CURRENT_DATETIME}.log # name and location of log file
	mkdir -p ${LOG_OUTPUT_DIR}
	touch $LOG_OUTPUT
	# run + log
	/scripts/RunCiftify.sh $subs_and_sess >> $LOG_OUTPUT
elif [ "$stage" == "MSM" ]; then
	# set-up logging
	CURRENT_DATETIME=$(date +'%Y-%m-%d_%H-%M-%S') # Date and time will be appended to the log file so multiple can be run keeping data seperate
	LOG_OUTPUT=${LOG_OUTPUT_DIR}/RunMSM_${CURRENT_DATETIME}.log # name and location of log file
	mkdir -p ${LOG_OUTPUT_DIR}
	touch $LOG_OUTPUT
	# run + log
	/scripts/RunMSM.sh $subs_and_sess >> $LOG_OUTPUT
elif [ "$stage" == "POSTMSM" ]; then
	# set-up logging
	CURRENT_DATETIME=$(date +'%Y-%m-%d_%H-%M-%S') # Date and time will be appended to the log file so multiple can be run keeping data seperate
	LOG_OUTPUT=${LOG_OUTPUT_DIR}/RunPostMSM_${CURRENT_DATETIME}.log # name and location of log file
	mkdir -p ${LOG_OUTPUT_DIR}
	touch $LOG_OUTPUT
	/scripts/RunPostMSM.sh $subs_and_sess >> $LOG_OUTPUT
fi

# exit with success if we made it this far
exit 0

