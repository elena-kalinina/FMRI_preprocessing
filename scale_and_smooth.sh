#!/bin/bash 
#preproc_test.sh
# Preprocessing fMRI files with FSL - Part III: scaling = subtracting the mean image from each volume; next the volumes are concatenated in time into runs and smoothed spatially.

#Number of runs in the experiment
nruns=6
#Kernel value for smoothing
kernel=8
#Subject ID, experiment date
SubjID="19761110MRKS"

#Directory with the dicom files
DCMD="/home/elena/emoa/DATA/20130410_19761110MRKS/dicom/"
# source directory, where nii files are stored
SRCD="/home/elena/emoa/DATA/20130410_19761110MRKS/nii_files/"
#Target Directory where preprocessed files are to be stored
TGTD="/home/elena/emoa/DATA/20130410_19761110MRKS/preprocessed_nii/"
#Directory with anatomy files
ANTD="/home/elena/emoa/DATA/anatomy/converted/Angelika/"

#Anatomical image
ANAT="19761110MRKS_be_restore.nii.gz"

#Path to template
TMLD="/usr/share/fsl/5.0/data/standard/MNI152_T1_2mm_brain.nii.gz"

#Path to Functional reference image (in this case, central image of the scanning session)

FREF_PR="/home/elena/emoa/DATA/20130410_19761110MRKS/preprocessed_nii/rf_nppmultiscan_run4_0001_stc_be_mcf.nii.gz"
ext=".nii.gz"
#cd $TGTD

#1. Subtracting the mean, intensity normalization
FILE_PATTERN="*_stc_be_mcf*"
for run in `seq $nruns`
do
printf -v SUBDIR "Run%02d/" "$run"
for file in `ls $SRCD$SUBDIR$FILE_PATTERN`
do
fslmerge -t ${SubjID}_run$run $file

fslmaths ${SubjID}_run$run* -Tmean mean_run$run
done
done

suff2=_sc #scaled

for run in `seq $nruns`
do
printf -v SUBDIR "Run%02d/" "$run"

for file in `ls $SRCD$SUBDIR$FILE_PATTERN`
do
newname="${file%%.*}"
if [[ ! "$newname" =~ "$suff2" ]]; then
fslmaths $file -sub mean_run$run* $newname$suff2 #Subtract mean 
#rm $file
fi
done
done

#2. Merging files into runs
#Options - concatenate in time

FILE_PATTERN="_stc_be_mcf_sc"
do
printf -v SUBDIR "Run%02d/" "$run"

for file in `ls $SRCD$SUBDIR$FILE_PATTERN`
do
fslmerge -t ${SubjID}_run$run$FILE_PATTERN *run$run?????$FILE_PATTERN*
mv ${SubjID}_run$run$FILE_PATTERN* $TGTD
done

#3. Spatial smoothing

suff=_sps
for file in `ls $TGTD$SubjID`
do
newname="${file%%.*}"
fslmaths $file -s $kernel $newname$suff$kernel
rm $file
done
