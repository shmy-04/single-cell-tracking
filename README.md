# Single-Cell Tracking

This repository currently contains Python code for preliminary single-cell tracking of segmented time-lapse microscopy images. The complete image analysis workflow is described below.

## Overview

The image analysis workflow consists of the following steps:

### 1. Image Preprocessing

1. Remove background noise and enhance image contrast using a Fiji macro.
2. Correct image drift using:
   - StackReg
   - BigWarp (if necessary)
3. Crop images to the regions of interest for subsequent analysis.

### 2. Cell Segmentation

1. Train a custom StarDist model for the target cells (recommended).
2. Add the trained model to the `models` folder and adjust the segmentation thresholds in `thresholds.json` if necessary.
3. Run cell segmentation using the Python segmentation code.

### 3. Cell Tracking

1. Perform preliminary automated single-cell tracking using the Python tracking code.
2. Manually inspect and correct tracking trajectories using TrackMate in Fiji.

### 4. Data Analysis

Perform downstream analysis using the corrected tracking results.

## Important Notes

The preliminary tracking code is not intended to produce fully accurate tracking results on its own. Tracking errors may occur. Therefore, manual inspection and correction using TrackMate in Fiji are required before downstream analysis.
