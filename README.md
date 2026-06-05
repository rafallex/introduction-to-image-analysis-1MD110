# Introduction to Image Analysis (1MD110)

Coursework from **1MD110 Introduction to Image Analysis** (period 1, year 1) of the M.Sc. in Image Analysis and Machine Learning at Uppsala University.

The course covered classical image analysis: point operations and histograms, thresholding and segmentation, spatial filtering, multispectral imagery, and image registration. Everything here is MATLAB, using the Image Processing and Computer Vision toolboxes. The lab 1 problem statement is included as `Intro2IA_Lab1_Instructions.pdf`.

## Assignments

These are the loose scripts at the repo root. Most of them run on the toy images in `images/`.

**`assignment1.m`** — histogram flattening done by hand. It walks every grey level, and where a level holds more pixels than the target uniform count it pushes the surplus up to the next level, redistributing intensities toward a flatter histogram instead of calling a built-in.

**`assignment3.m`** — color segmentation. Splits an RGB image into its channels and into HSV, runs Otsu thresholding (`graythresh` / `imbinarize`) on each channel, and shows the six binary masks side by side. It then hands the image to the interactive segmentation tools below.

**`colorseg_RB.m` / `colorseg_SV.m`** — interactive 2D-histogram segmentation. You draw a polygon over the joint Red-Blue (or Saturation-Value) histogram and the pixels falling inside that region get highlighted live as an overlay. Useful for picking out a colour cluster by eye.

**`assignment4.m`** — multispectral Landsat data (`landsat_data.mat`). Builds a false-colour composite from bands 4/1/3 and shows all bands as a montage.

**`assignment5.m`** — grayscale conversion, centre-crop to a square, resize to 128×128, then a hand-written mean (box) filter with a sliding window. Subtracting the blurred image from the original gives a simple high-pass / sharpening result.

**`assignmentv2.m` and `IterativeTresh.m`** — iterative global thresholding. Starts from a guess, splits pixels into two groups by the current threshold, and sets the new threshold to the mean of the two group means until it converges. This is k-means with two clusters; `IterativeTresh.m` is the clean standalone version.

The `.fig` files (`best_segmentation_*`) are saved figures of the best colour-segmentation results for the toys and cup images.

## Lab 4 — Registration and motion tracking

`lab4-image-registration/` aligns a moving image to a fixed one with a rigid transform, and scores each method by the mean landmark distance before and after registration (landmarks are in the `*.csv` files alongside the images in `data/`). Three approaches:

- **`intensity_based_registration_mono.m`** — monomodal, regular-step gradient descent with a mean-squares metric over a 5-level pyramid.
- **`intensity_based_registration_multi.m`** — multimodal, (1+1) evolutionary optimizer with Mattes mutual information, for images of differing modality where intensities don't match directly.
- **`feature_based_registration.m`** — detects SIFT keypoints in both images, matches descriptors, and estimates the transform from the matched pairs.

`plot_image_and_points.m` is the shared helper for overlaying landmark points (including ones that fall outside the image).

`lab4-motion-tracking/` holds `VideoUtilities.m`, the frame-by-frame skeleton for reading a video, annotating tracked positions, and writing the result back out, plus the source sequence and a binary mask to work from.

## Running it

Open the repo in MATLAB with the Image Processing and Computer Vision toolboxes installed. The root scripts are mostly self-contained — `cd` into the repo so the relative `images/` and `landsat_data.mat` paths resolve. The lab 4 registration functions take the data folder and the fixed/moving image and landmark filenames as arguments, e.g.

```matlab
T = intensity_based_registration_mono('lab4-image-registration/data', ...
        'z1f.png', 'z1m.png', 'z1f.csv', 'z1m.csv');
```
