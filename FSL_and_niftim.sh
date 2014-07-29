#!/bin/bash 
#preproc_test.sh
# Preprocessing fMRI files with FSL - Part I: conversion from dicom to nifti, slice timing correction, brain extraction and movement correction with FSL + temporal filtering and detrending is then passed over to a python script. Temporal filtering (low pass) and detrending is done with the Niftimasker tool. 

#Number of runs in the experiment
nruns=4

#Subject ID, experiment date
SubjID="19900422ADDL"

#Directory with the dicom files
#Directory with the dicom files
DCMD="/home/elena/ATTEND/DATA/PercIm/ADDL/"
# source directory, where nii files are stored
SRCD="/home/elena/ATTEND/DATA/PercIm/ADDL/"
#Target Directory where preprocessed files are to be stored
TGTD="/home/elena/ATTEND/DATA/PercIm/ADDL/preprocessed/"


ext=".nii.gz"


#1. Convert the images from dicom to nifty using dcm2nii specifying the options: no 4d, no collapsing input folders, no events in filename, gunzip no, identity in the filename, nii output, output directory, no protocol in the filename. 

for run in `seq $nruns`
do
printf -v SUBDIR "Run%02d" "$run"

for file in $DCMD$SUBDIR*
do
#mkdir $SRCD$run
#dcm2nii -4 n -c n -e n -g n -i y -n y -m n -o $SRCD$run -p n $file
dcm2nii -4 n -c n -e n -g n -i y -n y -m n -o $SRCD$SUBDIR -p n $file
done
done

#2. Slice timing correction
#Options: TR, acquisition direction, specifying interleaved acquisition

suff="_stc"
for run in `seq $nruns`
do
printf -v SUBDIR "Run%02d/" "$run"
for file in $SRCD$SUBDIR*
do
newname="${file%%.*}_run${run}"
echo $newname
slicetimer -i $file -o $newname$suff$ext -r 2 -d 2 --odd
rm $file
done
done

#3. Brain extraction

suff="_be"
FILE_PATTERN="*_stc*"
for run in `seq $nruns`
do
printf -v SUBDIR "Run%02d" "$run"
for file in `ls $SRCD$SUBDIR/$FILE_PATTERN`
do
newname="${file%%.*}"
if [[ ! "$newname" =~ "$suff" ]]; then
 bet $file $newname$suff$ext
rm $file
fi
done
done

#4. Motion correction
#Options can be activated for saving parameters
FILE_PATTERN="*_be*"
for run in `seq $nruns`
do
printf -v SUBDIR "Run%02d" "$run"
for file in `ls $SRCD$SUBDIR/$FILE_PATTERN`
do
  mcflirt -in $file #-mats -plots
rm $file
done
done

#5. Temporal filtering and detrending at this point are handed over to the NiftiMasker tool from the Nilearn library
#python detrend_and_tmpf.py



