#!/bin/bash 
#preproc_anat.sh
#Preprocessing the anatomical image

#Directory with anatomy files
ANTD="/home/elena/emoa/DATA/anatomy/Giacomo/"
subjID="19881016MCBL"
#1. Conversion to nii
#Convert the images from dicom to nifty using dcm2nii specifying in the options .nii as output (-n). 

cd $ANTD
echo "Converting dicom files to nifti"

dcm2nii -e n -n y $subjID*

#2. Brain extraction
#Strips off the skull
echo "Extracting the brain"
suff=_be
ext=".nii.gz"
for file in $ANTD*

do
 newname="${file%%.*}"
 bet $file $newname$suff$ext
  
done

cd $ANTD
#3. Inhomogeneity correction
#Options - outputting the inhomogeneity corrected file
echo "Performing inhomogeneity correction"

find . -name "*_be*" -exec fast -B {} \;






