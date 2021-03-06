FMRI_preprocessing
==================

This repository contains scripts for preprocessing FMRI data.

preproc_anat.sh - this is a script for preprocessing anatomical images with FSL. Includes steps: conversion of dicom files to nii format, skull stripping and inhomogeneity correction.

FSL_and_niftim.sh - this is the first script in the series for preprocessing functional data. The steps in the script include: conversion from dicom to nifti format, slice timing correction, brain extraction and movement correction with FSL + temporal filtering and detrending is then passed over to a python script. Temporal filtering (low pass) and detrending is done with the Niftimasker tool. 

Func2Templ_norm.sh - the second script in the functional preprocessing series deals with normalization to template (MNI). First, the subject's functional image is coregistered to the structural image, next the structural image is brought to the standard MNI space. Parameter matrices of these two transformations are then concatenated and used to bring the functional images into the template space. 

scale_and_smooth.sh - the third and the last script of the series. It includes: scaling = subtracting the mean image from each volume; next the volumes are concatenated in time into runs and smoothed spatially.
