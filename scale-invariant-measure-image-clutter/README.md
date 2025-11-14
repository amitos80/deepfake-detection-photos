# A Scale Invariant Measure of Image Clutter

This repository contains a MATLAB function, `SIclutter.m`, for calculating the Scale Invariant Measure of Image Clutter ($C$) as defined by Bravo and Farid (2008). This measure is based on finding a power law relationship between the number of segmented regions ($N$) in an image and the scale of segmentation ($K$).

## Description

The function calculates the clutter measure $C$ by measuring the number of regions ($N$) in an image at six different segmentation scales ($K$), and fitting the relationship to a power law of the form $N \propto C \cdot K^{\text{Exponent}}$. The final measure $C$ is the average constant of proportionality derived from the six scale measurements.

## Dependencies

This script is **NOT a standalone MATLAB function**. It requires an external executable for image segmentation to be present in the same directory.

* **Segmentation Routine:** The script relies on the compiled `segment` executable from the routines developed by **P. Felzenszwalb and D. Huttenlocher**.
    * **Requirement:** The executable named **`segment`** must be placed in the same directory as the `SIclutter.m` MATLAB script.

## Usage

The function is called from the MATLAB command window:

```matlab
[N, K, C] = SIclutter( INFILE, EXPONENT );


# A Scale Invariant Measure of Image Clutter

This repository contains a MATLAB function, `SIclutter.m`, for calculating the Scale Invariant Measure of Image Clutter ($C$) as defined by Bravo and Farid (2008). This measure is based on finding a power law relationship between the number of segmented regions ($N$) in an image and the scale of segmentation ($K$).

## Description

The function calculates the clutter measure $C$ by measuring the number of regions ($N$) in an image at six different segmentation scales ($K$), and fitting the relationship to a power law of the form $N \propto C \cdot K^{\text{Exponent}}$. The final measure $C$ is the average constant of proportionality derived from the six scale measurements.

## Dependencies

This script is **NOT a standalone MATLAB function**. It requires an external executable for image segmentation to be present in the same directory.

* **Segmentation Routine:** The script relies on the compiled `segment` executable from the routines developed by **P. Felzenszwalb and D. Huttenlocher**.
    * **Requirement:** The executable named **`segment`** must be placed in the same directory as the `SIclutter.m` MATLAB script.

## Usage

The function is called from the MATLAB command window:

```matlab
[N, K, C] = SIclutter( INFILE, EXPONENT );


Variable,Description
N,A vector containing the number of segments found at each segmentation scale.
K,"The vector of segmentation scales used: [250, 500, 750, 1000, 1500, 2000]."
C,The final Scale Invariant Measure of Image Clutter.


[N, K, C] = SIclutter( 'test.jpg', -1.3925 );

The information about digital forensics and image manipulation is provided, followed by the complete README file for your uploaded code, presented in a single markup block as requested.

1. Digital Forensics in Images: Detection of Deepfakes and CGI

Digital forensics in visual media focuses on uncovering traces left by image acquisition devices or manipulation software. Detecting fakes relies on the fact that every step in the imaging pipeline—from the camera sensor to the final software edit—leaves a unique statistical or physical artifact.

Deepfake Detection

Deepfakes are highly realistic synthetic media generated using deep learning models, primarily Generative Adversarial Networks (GANs). The main detection strategies exploit flaws in how AI recreates complex human physiology and the physical environment:

    Physiological Inconsistencies: AI often struggles with complex or small human features. Forensic analysis looks for discrepancies in:

        Eye Blinking: Deepfakes may exhibit unnatural, absent, or inconsistent blinking patterns because AI training data often lacks images of eyes closed.

        Anatomy: Imperfections in rendering hands, ears, teeth, or hair can expose a deepfake.

        Biological Signals: Analyzing subtle skin color changes (via remote Photoplethysmography or rPPG) can detect inconsistencies in the synthesized person's simulated heart rate, a feature AI often fails to perfectly replicate.

    Environmental Inconsistencies:

        Lighting and Shadows: When a forged face is spliced onto a new scene, the light intensity, direction, or corresponding shadows on the face may not align with the rest of the image.

    Statistical Artifacts: Advanced detection uses Convolutional Neural Networks (CNNs) or Vision Transformers to analyze invisible statistical fingerprints left behind by the specific generative model (GAN or Diffusion Model) used to create the fake.

CGI and General Forgery Detection

General image manipulation, including splicing (copy-paste) or Computer-Generated Imagery (CGI) insertion, is detected by examining low-level artifacts:

    Noise Analysis (PRNU): Every digital camera sensor has a unique microscopic pattern noise called Photo-Response Non-Uniformity (PRNU). This is a unique "fingerprint." If a region of an image has a PRNU pattern that is different from the rest of the photo, it is likely a spliced or inserted fake.

    Error Level Analysis (ELA): ELA highlights areas of an image that have a different level of JPEG compression history. Spliced-in content, not compressed as often as the original image, will often stand out with a much lower "error level."

    Color Filter Array (CFA) Artifacts: Digital cameras use a CFA (e.g., Bayer filter) to capture color and then use a process called demosaicing to interpolate the full-color image. This process leaves a unique, periodic statistical pattern. Any manipulation disrupts this pattern, which can be detected.

    Metadata (EXIF) Forensics: Although metadata can be easily faked or stripped, the Exchangeable Image File Format (EXIF) can contain the camera model, date, time, and even the history of software used to process the file, providing initial clues.

2. SIclutter.m README File

Markdown

# A Scale Invariant Measure of Image Clutter

This repository contains a MATLAB function, `SIclutter.m`, for calculating the Scale Invariant Measure of Image Clutter ($C$) as defined by Bravo and Farid (2008). This measure is based on finding a power law relationship between the number of segmented regions ($N$) in an image and the scale of segmentation ($K$).

## Description

The function calculates the clutter measure $C$ by measuring the number of regions ($N$) in an image at six different segmentation scales ($K$), and fitting the relationship to a power law of the form $N \propto C \cdot K^{\text{Exponent}}$. The final measure $C$ is the average constant of proportionality derived from the six scale measurements.

## Dependencies

This script is **NOT a standalone MATLAB function**. It requires an external executable for image segmentation to be present in the same directory.

* **Segmentation Routine:** The script relies on the compiled `segment` executable from the routines developed by **P. Felzenszwalb and D. Huttenlocher**.
    * **Requirement:** The executable named **`segment`** must be placed in the same directory as the `SIclutter.m` MATLAB script.

## Usage

The function is called from the MATLAB command window:

```matlab
[N, K, C] = SIclutter( INFILE, EXPONENT );

Parameters

Parameter	Description
INFILE	The filename (as a string) of the input image (e.g., 'image.jpg').
EXPONENT	The fixed exponent (α) that describes the power law relationship. This value is typically determined empirically for a specific class of images.

Output Variables

Variable	Description
N	A vector containing the number of segments found at each segmentation scale.
K	The vector of segmentation scales used: [250, 500, 750, 1000, 1500, 2000].
C	The final Scale Invariant Measure of Image Clutter.

Example

Matlab

[N, K, C] = SIclutter( 'test.jpg', -1.3925 );

Implementation Details

    Filtering: The input image is first loaded and a 3x3 median filter is applied to each color channel to reduce noise.

    Format Conversion: The filtered image is saved as a temporary .ppm file, which is the required input format for the external segment program.

    Segmentation: The external segment executable is run six times with the fixed scale parameters K=[250,500,750,1000,1500,2000].

    Calculation: The number of regions (N) for each scale is extracted from the segmentation output. The clutter measure (C) is calculated as the mean constant of proportionality:
    C=mean(KExponentN​)

    Cleanup: Temporary files (tmp_segin.ppm, tmp_segout.txt, etc.) are removed after calculation.

Authors and Citation

Authors: Hany Farid and Mary J. Bravo Date of Script: February 10, 2011

If you use this code in your research, please cite the original paper:


@ARTICLE{bravo-farid08,
  AUTHOR = "M.J. Bravo and H. Farid",
  TITLE = "A Scale Invariant Measure of Image Clutter",
  JOURNAL = "Journal of Vision",
  NUMBER = "8",
  VOLUME = "1",
  PAGES = "1-9",
  YEAR = "2008",
  URL = "www.cs.dartmouth.edu/farid/publications/jov07.html"
}
