
######################################
# AD-Cortical Expansion Docker Setup #
######################################

	0. Make a copy of this whole directory
There are many ways to do this. I recommend the following:
First, enter the folder:
`cd /data/smyser/smyser3/wunder/lisaG/AD_docker_construction/for_distribution`
Then, copy to your desired working location:
`cp -r * <path to your desired working location>`

	1. Build the docker
After being granted sudo docker access for a specified machine, you need to build the docker image.
To do so, enter the "dockerfile" directory and run the following:
`sudo docker build ./Dockerfile -t cortical_expansion_ad --no-cache ./empty/`

This will take some time to build. Upon completion, you should see a series of logs stating so, and
additionally should be able to view the docker image when listing the available images:
`sudo docker images`

	2. Compile subject lists
For this construction, I've decided to let the user compile the subject lists.
In order to avoid any issues with naming conventions, I've essentially made that
completely handled by the input list. For example, my list is formatted:
Subject_0649,_Image_63508,_Image_120553
Subject_0507,_Image_75459,_Image_132918
Subject_1331,_Image_82509,_Image_174851
Subject_1066,_Image_129313,_Image_90916
Subject_0835,_Image_120256,_Image_35653

My subject folders are:
Subject_0649_Image_63508
Subject_0649_Image_120553
etc.

You will have to adjust your list accordingly.

	3. Run the docker
To kick this off, you need to run the wrapper csh script: run_AD_cortical_expansion_docker.csh, with a variety of parameters.
Namely, the name of your subjects list, the desired processing stage, the input location, and the output location.
Some of these can be modified depending on the file structure and steps you are working with. Input and output can be the same folders, if desired
`run_AD_cortical_expansion_docker.csh test_subjects_and_sessions_1_27_2025.lst MSM inpu_folder output_folder`

	4. Review the output
Enter the specified output folder/logs, and review, perform QC, and further analyses as necessary.

