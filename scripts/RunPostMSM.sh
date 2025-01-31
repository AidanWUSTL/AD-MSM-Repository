#!/bin/bash
# run the "post msm" steps for the series of subjects+sessions
# add workbench to path
PATH=/opt/workbench/bin_linux64:$PATH
# hard-coded variables
SUBJECT_TXT=/scripts/$1 # List of subjects + sessions to iterate over - see README for guide on construction

# spheres of specified mesh for resampling
MAXCP=/scripts/ico5sphere.LR.reg.surf.gii # path to ico5sphere
MAXANAT=/scripts/ico6sphere.LR.reg.surf.gii # path to ico6sphere

DATASET=/output/ciftify # Folder containing subject data
MSM_OUT=/output/msm # output for msm
RESOLUTION="32k" # resolution of mesh to use either '32k' or '164k'
RESOLUTION_LOCATION="T1w/fsaverage_LR32k"

# hard-coded hemispheres variable
hems=( L R )

# iterate over subjects + sessions
for line in `cat $SUBJECT_TXT`; do
	# get columns of input file
	sub=`echo $line | cut -d "," -f1`
	sess1=`echo $line | cut -d "," -f2`
	sess2=`echo $line | cut -d "," -f3`
	
	# subject-session combo 1
	subsess1="${sub}${sess1}"
	# subject-session combo 2
	subsess2="${sub}${sess2}"
	# locations
	subsess1_loc=${DATASET}/${subsess1}/${RESOLUTION_LOCATION}
	subsess2_loc=${DATASET}/${subsess2}/${RESOLUTION_LOCATION}
	
	# iterate
	for hem in ${hems[@]}; do
		# handle hemisphere variable
		if [ ${hem} = L ]; then
			STRUCTURE="CORTEX_LEFT"
		else
			STRUCTURE="CORTEX_RIGHT"
		fi
		# define midthickness/sphere meshes for both sessions
		ASsess1=${subsess1_loc}/${subsess1}.${hem}.midthickness.${RESOLUTION}_fs_LR.surf.gii
		SSsess1=${subsess1_loc}/${subsess1}.${hem}.sphere.${RESOLUTION}_fs_LR.surf.gii
		ASsess2=${subsess2_loc}/${subsess2}.${hem}.midthickness.${RESOLUTION}_fs_LR.surf.gii
		SSsess2=${subsess2_loc}/${subsess2}.${hem}.sphere.${RESOLUTION}_fs_LR.surf.gii
		
		# "forwards" calls variables
		# define output folder structure
		forwards_out_folder=${MSM_OUT}/${sub}${sess1}${sess2}
		forwards_out_name=${forwards_out_folder}/${sub}${sess1}${sess2}_${hem}.
		# surface distortion
		wb_command -surface-resample ${ASsess1} ${SSsess1} ${MAXANAT} "BARYCENTRIC" ${forwards_out_name}ASsess1.ANATgrid.surf.gii
		wb_command -set-structure ${forwards_out_name}ASsess1.ANATgrid.surf.gii ${STRUCTURE}
		wb_command -surface-resample ${ASsess1} ${SSsess1} ${MAXCP} "BARYCENTRIC" ${forwards_out_name}ASsess1.CPgrid.surf.gii
		wb_command -set-structure ${forwards_out_name}ASsess1.CPgrid.surf.gii ${STRUCTURE}
		# output calculations
		wb_command -surface-resample ${ASsess2} ${SSsess2} ${forwards_out_name}sphere.reg.surf.gii "BARYCENTRIC" ${forwards_out_name}anat.true.reg.surf.gii
		wb_command -surface-distortion ${ASsess1} ${forwards_out_name}anat.true.reg.surf.gii ${forwards_out_name}surfdist.func.gii
		# MAXANAT
		wb_command -surface-sphere-project-unproject ${MAXANAT} ${SSsess1} ${forwards_out_name}sphere.reg.surf.gii ${forwards_out_name}sphere.ANATgrid.reg.surf.gii
		wb_command -surface-resample ${ASsess2} ${SSsess2} ${forwards_out_name}sphere.ANATgrid.reg.surf.gii "BARYCENTRIC" ${forwards_out_name}anat.ANATgrid.reg.surf.gii
		wb_command -surface-distortion ${forwards_out_name}ASsess1.ANATgrid.surf.gii ${forwards_out_name}anat.ANATgrid.reg.surf.gii ${forwards_out_name}surfdist.ANATgrid.func.gii
		# MAXCP
		wb_command -surface-sphere-project-unproject ${MAXCP} ${SSsess1} ${forwards_out_name}sphere.reg.surf.gii ${forwards_out_name}sphere.CPgrid.reg.surf.gii
		wb_command -surface-resample ${ASsess2} ${SSsess2} ${forwards_out_name}sphere.CPgrid.reg.surf.gii "BARYCENTRIC" ${forwards_out_name}anat.CPgrid.reg.surf.gii
		wb_command -surface-distortion ${forwards_out_name}ASsess1.CPgrid.surf.gii ${forwards_out_name}anat.CPgrid.reg.surf.gii ${forwards_out_name}surfdist.CPgrid.func.gii
		
		# "backwards" calls variables - repeat the above steps with differing "order"
		# define output folder structure
		reverse_out_folder=${MSM_OUT}/${sub}${sess2}${sess1}
		reverse_out_name=${reverse_out_folder}/${sub}${sess2}${sess1}_${hem}.
		# surface distortion
		wb_command -surface-resample ${ASsess2} ${SSsess2} ${MAXANAT} "BARYCENTRIC" ${reverse_out_name}ASsess2.ANATgrid.surf.gii
		wb_command -set-structure ${reverse_out_name}ASsess2.ANATgrid.surf.gii ${STRUCTURE}
		wb_command -surface-resample ${ASsess2} ${SSsess2} ${MAXCP} "BARYCENTRIC" ${reverse_out_name}ASsess2.CPgrid.surf.gii
		wb_command -set-structure ${reverse_out_name}ASsess2.CPgrid.surf.gii ${STRUCTURE}
		# output calculations
		wb_command -surface-resample ${ASsess1} ${SSsess1} ${reverse_out_name}sphere.reg.surf.gii "BARYCENTRIC" ${reverse_out_name}anat.true.reg.surf.gii
		wb_command -surface-distortion ${ASsess2} ${reverse_out_name}anat.true.reg.surf.gii ${reverse_out_name}surfdist.func.gii
		# MAXANAT
		wb_command -surface-sphere-project-unproject ${MAXANAT} ${SSsess2} ${reverse_out_name}sphere.reg.surf.gii ${reverse_out_name}sphere.ANATgrid.reg.surf.gii
		wb_command -surface-resample ${ASsess1} ${SSsess1} ${reverse_out_name}sphere.ANATgrid.reg.surf.gii "BARYCENTRIC" ${reverse_out_name}anat.ANATgrid.reg.surf.gii
		wb_command -surface-distortion ${reverse_out_name}ASsess2.ANATgrid.surf.gii ${reverse_out_name}anat.ANATgrid.reg.surf.gii ${reverse_out_name}surfdist.ANATgrid.func.gii
		# MAXCP
		wb_command -surface-sphere-project-unproject ${MAXCP} ${SSsess2} ${reverse_out_name}sphere.reg.surf.gii ${reverse_out_name}sphere.CPgrid.reg.surf.gii
		wb_command -surface-resample ${ASsess1} ${SSsess1} ${reverse_out_name}sphere.CPgrid.reg.surf.gii "BARYCENTRIC" ${reverse_out_name}anat.CPgrid.reg.surf.gii
		wb_command -surface-distortion ${reverse_out_name}ASsess2.CPgrid.surf.gii ${reverse_out_name}anat.CPgrid.reg.surf.gii ${reverse_out_name}surfdist.CPgrid.func.gii
		
		# after the "forwards" and "backwards" direction calls - also compute the "inverted" surfdist files
		# that is - we do the "forwards" and "backwards" directions, but when we average together, we need
		# to account for that sign change.
		# build the variables
		CPgrid_sess2_surf=${reverse_out_name}ASsess2.CPgrid.surf.gii # this is the session 2 input to the "backwards" MSM - CPgrid resolution
		CPgrid_sess1_surf=${reverse_out_name}anat.CPgrid.reg.surf.gii # this is the session 1 output from the "backwards" MSM - CPgrid resolution
		ANATgrid_sess2_surf=${reverse_out_name}ASsess2.ANATgrid.surf.gii # this is the session 2 input to the "backwards" MSM - ANATgrid resolution
		ANATgrid_sess1_surf=${reverse_out_name}anat.ANATgrid.reg.surf.gii # this is the session 1 output from the "backwards" MSM - ANATgrid resolution
		# now, we make the calls - essentially, we are inverting the last "-surface-distortion" calls from the "backwards" direction commands above
		# MAXANAT
		wb_command -surface-distortion ${ANATgrid_sess1_surf} ${ANATgrid_sess2_surf} ${reverse_out_name}surfdist.ANATgrid.inverse.func.gii
		# MAXCP
		wb_command -surface-distortion ${CPgrid_sess1_surf} ${CPgrid_sess2_surf} ${reverse_out_name}surfdist.CPgrid.inverse.func.gii
		
		# finally, after all of this for both session combos for this hemisphere, generate the average of the "forwards" surfdist and
		# the "backwards" *inverted* surfdists
		# MAXANAT
		wb_command -metric-math "(A+B)/2" ${MSM_OUT}/${sub}${sess1}${sess2}_${hem}.surfdist.ANATgrid.forwards_and_reverse.func.gii -var A ${forwards_out_name}surfdist.ANATgrid.func.gii -var B ${reverse_out_name}surfdist.ANATgrid.inverse.func.gii
		# MAXCP
		wb_command -metric-math "(A+B)/2" ${MSM_OUT}/${sub}${sess1}${sess2}_${hem}.surfdist.CPgrid.forwards_and_reverse.func.gii -var A ${forwards_out_name}surfdist.CPgrid.func.gii -var B ${reverse_out_name}surfdist.CPgrid.inverse.func.gii
		
	done # end hemisphere loop
	
done

# exit with success if we made it this far
exit 0

