FMRI_preprocessing
==================

This repository contains scripts for preprocessing FMRI data.

preproc_anat.sh - this is a script for preprocessing anatomical images with FSL. Includes steps: conversion of dicom files to nii format, skull stripping and inhomogeneity correction.

FSL_and_niftim.sh - this is the first script in the series for preprocessing functional data. The steps in the script include: conversion from dicom to nifti format, slice timing correction, brain extraction and movement correction with FSL + temporal filtering and detrending is then passed over to a python script. Temporal filtering (low pass) and detrending is done with the Niftimasker tool. 
