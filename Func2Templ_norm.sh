#!/bin/bash 
#preproc_test.sh
# Preprocessing fMRI files with FSL - Part II: normalization to template (MNI). First, the subject's functional image is coregistered to the structural image, next the structural image is brought to the standard MNI space. Parameter matrices of these two transformations are then concatenated and used to bring the functional images into the template space. 

#Number of runs in the experiment
nruns=4

#Subject ID, experiment date
SubjID="19900705BADC"

#Directory with the dicom files
DCMD="/home/elena/emoa/DATA/20130429_19900705BADC/dicom/"
# source directory, where nii files are stored
SRCD="/home/elena/emoa/DATA/20130429_19900705BADC/nii_files/"
#Target Directory where preprocessed files are to be stored
TGTD="/home/elena/emoa/DATA/20130429_19900705BADC/preprocessed_nii/"
#Directory with anatomy files
ANTD="/home/elena/emoa/DATA/anatomy/converted/Serena/"

#Anatomical image
ANAT="19900705BADC_be_restore.nii.gz"

#Path to template
TMLD="/usr/share/fsl/5.0/data/standard/MNI152_T1_2mm_brain.nii.gz"

#Path to Functional reference image (in this case, central image of the scanning session)
"/home/elena/emoa/DATA/20130410_19761110MRKS/preprocessed_nii/rf_nppmultiscan_run4_0001_stc_be_mcf.nii.gz"
ext=".nii.gz"

#Functional to Structural Native Space
suffix=_f2s #functional to structural
newname="${ANAT%%.*}"
flirt -ref $ANTD$ANAT -in $FREF_PR -out $TGTD$newname$suffix -omat F2S.mat -dof 6 #6 degrees of freedom


#Structural native to MNI template
suffix=_s2t #structural to template
newname="${ANAT%%.*}"
flirt -in $ANTD$ANAT  -ref $TMLD -out $TGTD$newname$suffix -omat SA2T.mat  

#concatenating the transformation matrices
convert_xfm -omat SF2T.mat -concat  SA2T.mat F2S.mat

#Functional to Template using parameters from the previous transformations
#Adjust for filename pattern if necessary
suffix=_nrm #functional normalized to template
FILE_PATTERN="19900705BADC_run?.nii.gz"
for file in `ls $TGTD/$FILE_PATTERN`
do
 newname="${file%%.*}"
 flirt -in $file -ref $TMLD  -out $newname$suffix -applyxfm -init SF2T.mat
rm $file
done
