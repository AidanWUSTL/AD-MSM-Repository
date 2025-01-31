## Build docker image for running "AD"-Cortical Expansion Code
# Edited by Aidan Latham
# main elements:
# 0. base image/setup
# 1. necessary system libraries/dependencies
# 2. FSL
# 3. FreeSurfer
# 4. MSM
# 5. Workbench
# 6. Create entrypoint
# 7. User setup

#######################
# 0. base image/setup #
#######################
# base OS image
FROM ubuntu:20.04
# install without interactivity
ARG DEBIAN_FRONTEND=noninteractive
# update apt
RUN apt-get update

##############################################
# 1. necessary system libraries/dependencies #
##############################################
# apt-get libraries
RUN apt-get install -yq --no-install-recommends build-essential &&\
apt-get install -yq --no-install-recommends apt-utils &&\
apt-get install -yq --no-install-recommends csh &&\
apt-get install -yq --no-install-recommends bash &&\
apt-get install -yq --no-install-recommends ca-certificates &&\
apt-get install -yq --no-install-recommends gcc &&\
apt-get install -yq --no-install-recommends g++ &&\
apt-get install -yq --no-install-recommends cmake &&\
apt-get install -yq --no-install-recommends curl &&\
apt-get install -yq --no-install-recommends zlib1g-dev &&\
apt-get install -yq --no-install-recommends libboost-dev &&\
apt-get install -yq --no-install-recommends libssl-dev &&\
apt-get install -yq --no-install-recommends libgl1-mesa-dev &&\
apt-get install -yq --no-install-recommends libglu1-mesa-dev &&\
apt-get install -yq --no-install-recommends libxt-dev &&\
apt-get install -yq --no-install-recommends python-dev &&\ 
apt-get install -yq --no-install-recommends python3-dev &&\
apt-get install -yq --no-install-recommends libtbb-dev &&\
apt-get install -yq --no-install-recommends libflann-dev &&\
apt-get install -yq --no-install-recommends libeigen3-dev &&\
apt-get install -yq --no-install-recommends python-contextlib2 &&\
apt-get install -yq --no-install-recommends python3-contextlib2 &&\
apt-get install -yq --no-install-recommends python3-imageio &&\
apt-get install -yq --no-install-recommends python3-numpy &&\
apt-get install -yq --no-install-recommends python3-scipy &&\
apt-get install -yq --no-install-recommends python3-pandas &&\
apt-get install -yq --no-install-recommends python3-numexpr &&\
apt-get install -yq --no-install-recommends git &&\
apt-get install -yq --no-install-recommends tcsh &&\
apt-get install -yq --no-install-recommends python3-pip &&\
apt-get install -yq --no-install-recommends unzip &&\
apt-get install -yq --no-install-recommends parallel &&\
apt-get install -yq --no-install-recommends wget &&\
apt-get install -yq libopenblas-dev &&\
apt-get install -yq --no-install-recommends bc &&\
apt-get install coreutils
# pip-based instllations
RUN yes | pip3 install pandas
RUN yes | pip3 install scipy
RUN yes | pip3 install matplotlib
RUN yes | pip3 install nilearn
RUN yes | pip3 install formulaic
RUN yes | pip3 install h5py
RUN yes | pip3 install scikit-learn
RUN yes | pip3 install PyYAML
RUN yes | pip3 install Pillow
RUN yes | pip3 install docopt
RUN yes | pip3 install ciftify
RUN yes | pip3 install --upgrade --force-reinstall numexpr
RUN yes | pip3 install --force-reinstall "nibabel==3.2.0"
RUN yes | pip3 install --force-reinstall "numpy==1.23.5"

##########
# 2. FSL #
##########
# install FSL
RUN echo "Downloading FSL ..." && curl -sSL --retry 5 https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.4-centos6_64.tar.gz | tar zx -C /opt
RUN chmod -R 777 /opt/fsl   
# add to path/environment variables
ENV FSLDIR="/opt/fsl"
ENV FSL_DIR="/opt/fsl"
ENV PATH="/opt/fsl/bin:$PATH"

#################
# 3. FreeSurfer #
#################
# install freesurfer
RUN echo "Downloading FreeSurfer ..." && curl -sSL --retry 5 https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz | tar xz -C /opt 
RUN chmod -R 777 /opt/freesurfer
ENV FREESURFER_HOME="/opt/freesurfer"

##########
# 4. MSM #
##########
RUN echo "Downloading MSM ..." && wget https://github.com/ecr05/MSM_HOCR/releases/download/v3.0FSL/msm_ubuntu_v3 -P /opt
RUN mv /opt/msm_ubuntu_v3 /opt/msm
RUN chmod 777 /opt/msm

################
# 4. Workbench #
################
# get workbench 
RUN echo "Downloading Workbench ..." && wget https://www.humanconnectome.org/storage/app/media/workbench/workbench-linux64-v1.5.0.zip -P /opt
RUN unzip /opt/workbench-linux64-v1.5.0.zip -d /opt
RUN chmod -R 777 /opt/workbench

########################
# 6. Create entrypoint #
########################
RUN touch /opt/entrypoint.sh
RUN echo "#!/bin/bash" >> /opt/entrypoint.sh
RUN echo "echo \$@" >> /opt/entrypoint.sh
RUN echo "/scripts/AD_cortical_expansion_wrapper.sh \$@" >> /opt/entrypoint.sh
RUN chmod 777 /opt/entrypoint.sh

#################
# 7. User setup #
#################
# create user with correponding ID
# To get the NIL USERID and USERNAME, use the following commands:
# NIL USERID : id -u
# NIL USERNAME : whoami
# UNCOMMENT below lines and fill-in to add a user
#RUN useradd -u <NIL USERID> -m -K UMASK=0000 <NIL USERNAME>
#USER <NIL USERNAME>
# Example:
RUN useradd -u 2249 -m -K UMASK=0000 lathama
USER lathama

ENTRYPOINT ["/opt/entrypoint.sh"]

