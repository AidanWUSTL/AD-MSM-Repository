#!/bin/bash
# hard-coded variables
CIFTIFY_OUTPUT_DIR=/output/ciftify # output location for script results
SUBJECT_TXT=/scripts/$1 # List of subjects + sessions to iterate over - see README for guide on construction

# start building job file for parallelization
stub=`echo -n $1 | md5sum`
combos=( `cat /scripts/$1` )
jobs=/jobs/AD_cortical_expansion_${#combos[@]}_subs_CIFTIFY_${stub%???}.lst
rm $jobs
touch $jobs

# iterate over subjects + sessions
for line in `cat $SUBJECT_TXT`; do
	# get columns of input file
	sub=`echo $line | cut -d "," -f1`
	sess1=`echo $line | cut -d "," -f2`
	sess2=`echo $line | cut -d "," -f3`
    
    # session 1 job
	# add to job file
	echo "/scripts/call_ciftify_AD.sh $sub $sess1" >> $jobs
	
	# session 2 job
	# add to job file
	echo "/scripts/call_ciftify_AD.sh $sub $sess2" >> $jobs
	
	# great - now we've added all the necessary jobs for this subject to the running jobs file
	
done

# after constructing the jobs - run them		
cat $jobs | parallel -j 60 --colsep ' ' --verbose bash {}

# eventually, we'll exit
exit 0

