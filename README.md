# Single-Cell Tracking

This repository provides an image analysis workflow for single-cell tracking and lineage reconstruction from time-lapse microscopy images. The workflow combines Fiji, Python, TrackMate, and R.

## Overview

The image analysis workflow consists of the following steps:

### 1. Image Preprocessing

1. Remove background noise and enhance image contrast using a Fiji macro `image_preprocessing.ijm`.
2. Correct image drift using:
   - [StackReg](https://bigwww.epfl.ch/thevenaz/stackreg/) ([Thevenaz et al., 1998](https://doi.org/10.1109/83.650848))
   - [BigWarp](https://imagej.net/plugins/bigwarp) ([Bogovic et al., 2016](https://doi.org/10.1109/isbi.2016.7493463)), if needed.
3. Crop images to the regions of interest for subsequent analysis.
4. Split the processed image stack into individual TIFF images using the Fiji macro `split_image_stack.ijm`.

### 2. Cell Segmentation

1. Train a custom StarDist model ([Schmidt et al., 2018](https://link.springer.com/chapter/10.1007/978-3-030-00934-2_30)) for the target cells based on the example code provided by the [StarDist project](https://github.com/stardist/stardist).
2. Add the trained model to the `3_segmentation/models` folder and adjust the segmentation thresholds in `thresholds.json` if necessary. In our analysis, the probability threshold (prob) was typically reduced by approximately 0.3 from the optimized value to improve cell detection.
3. Run cell segmentation using the Python segmentation code `segmentation_stardist-opp.ipynb`.
4. Run the Fiji macro `watershed_cell_separation.ijm` to separate touching cells using [Adjustable Watershed](https://imagej.net/plugins/adjustable-watershed/adjustable-watershed). The tolerance parameter is set to 3.0 by default in this macro.

### 3. Cell Tracking

1. Perform preliminary automated single-cell tracking using the Python tracking code `preliminary_cell_tracking.ipynb`.
2. Convert the grayscale images in the `prediction` folder into an image stack, then convert the stack to 8-bit using Fiji.
3. Construct cell lineages using TrackMate 7 ([Ershov et al., 2022](https://www.nature.com/articles/s41592-022-01507-1)) in Fiji with the following settings:
    - **Detector:** Label Image Detector
    - **Initial thresholding:** Select all cells
    - **Spot coloring:** Area (Auto)
    - **Tracker:** LAP Tracker
      - Frame-to-frame linking: Max distance = 50 pixels; Mean intensity Ch1 weight = 12.5
      - Gap closing: Enabled; Max distance = 50 pixels; Max frame gap = 5; Mean intensity Ch1 weight = 12.5
      - Segment splitting: Enabled; Max distance = 40 pixels; Mean intensity Ch1 weight = 12.5
    - **Track filtering:** Track start (retain only tracks originating from the initial frame)
    
    **Note:** The tracking parameters listed above were optimized for our image dataset and may require adjustment for other datasets. In particular, assigning a high weight to Mean intensity Ch1 is important for accurate cell tracking in this workflow. This is because our Python tracking code assigns different grayscale intensity values to cells based on their track IDs.
    
4. Manually inspect and correct tracking trajectories, including cell division events and reconnection of temporarily lost cells.
5. When performing TrackMate analysis in multiple rounds, exclude previously analyzed cells from subsequent rounds by subtracting a binary mask of the first frame of the previously analyzed label image (`LblImg`) from the first frame of the image stack using a Fiji macro `exclude_analyzed_cells.ijm`.
6. Export spots, edges and allspots data from TrackMate as CSV files into the `csv_results` folder.

### 4. Genealogy Data Construction

1. Construct genealogy data by connecting individual cell trajectories and organizing parent–daughter relationships using the R code `TrackMate Cell Genealogy Reconstruction.Rmd`.
2. Perform downstream analysis using the reconstructed cell lineages.

## Important Notes

The preliminary tracking code is not intended to produce fully accurate tracking results on its own. Tracking errors may occur. Therefore, manual inspection and correction using TrackMate in Fiji are required before downstream analysis.

## How to Cite

If you use the code or image analysis workflow provided in this repository, please cite this GitHub repository:

Ikeda S. 2026. *single-cell-tracking*. GitHub. (https://github.com/shmy-04/single-cell-tracking)

## Related Publication

The image analysis workflow provided in this repository was developed and used in the following study:

- [Ikeda et al. 2026. *mBio*](https://journals.asm.org/doi/10.1128/mbio.02345-26)
