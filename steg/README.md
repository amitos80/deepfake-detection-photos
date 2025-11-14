## 📁 Complete Repository Documentation

This file consolidates the documentation for all uploaded MATLAB files, covering six main areas: **Derivative Filter Design**, **Fractional Transforms**, **Higher-Order Statistics**, **Independent Component Analysis (ICA)**, **Steerable Wedge Filters**, and **Steganalysis**.

---

### Part 1: Optimally Rotation-Equivariant Derivative Filter Design

This set of MATLAB code is designed to create a family of derivative filters (kernels) that exhibit **rotation-equivariance**—a property ensuring that rotation and differentiation commute.

#### ⚙️ Core Files and Functionality

| File Name | Primary Function | Domain / Concept |
| :--- | :--- | :--- |
| `design_deriv.m` | **Main Filter Design Script** | Non-linear optimization, SVD initialization |
| `rot_invariance_err.m` | **Rotation Invariance Error** | 2-D Fourier Transform, Equivariance Check |
| `deriv2_err.m` | **2nd-Order Derivative Error** | Frequency Domain Consistency ($N=2$) |
| `deriv3_err.m` | **3rd-Order Derivative Error** | Frequency Domain Consistency ($N=3$) |
| `fulltohalf.m` | **FULL-TO-HALF CONVERSION** | Filter Symmetry/Anti-Symmetry Modeling |
| `halftofull.m` | **HALF-TO-FULL CONVERSION** | Filter Symmetry/Anti-Symmetry Modeling |
| `intersect.m` | **Geometric Subspace Intersection** | SVD, Linear Algebra (Null Space) |
| `rotate.m` | **2-D Map Rotation** | Image Interpolation (`interp2`) |
| `showfilt.m` | **Visualization of Filters** | Spatial Domain Plotting (Stem Plot) |
| `showfreq.m` | **Visualization of Frequency Response** | Frequency Domain Plotting (Actual vs. Ideal) |
| `solution10.mat` | **Pre-Computed Solution** | Optimization Initialization Data |

---

### Part 2: Fractional Signal Transforms

These scripts demonstrate extending core signal transforms (Derivatives and Fourier Transform) to non-integer orders.

| File Name | Function | Core Mathematical Concept |
| :--- | :--- | :--- |
| `fracderiv.m` | **Fractional Derivatives** | Differentiation via multiplication by $(j\omega)^n$ in the Fourier Domain. |
| `fracFourier.m` | **Fractional Fourier Transform (FrFT)** | Calculation by raising the Discrete Fourier Transform matrix ($\mathbf{B}$) to a fractional power ($\mathbf{B}^n$). |

---

### Part 3: Higher-Order Statistics

| File Name | Function | Core Mathematical Concept |
| :--- | :--- | :--- |
| `blindgamma.m` | **Blind Inverse Gamma Correction** | Minimizes the **Bicoherence** (a higher-order statistic) of the corrected signal to estimate the inverse $\gamma$ value. |

---

### Part 4: Independent Component Analysis (ICA)

| File Name | Function | Core Mathematical Concept |
| :--- | :--- | :--- |
| `ica.m` | **Non-Iterative ICA** | Separates sources by whitening (PCA) and then rotating to maximize **fourth-order moments (kurtosis)**, exploiting non-Gaussianity. |

---

### Part 5: Steerable Wedge Filters

| File Name | Function | Core Mathematical Concept |
| :--- | :--- | :--- |
| `wedge.m` | **Steerable Wedge Filter Design** | Designs a polar-separable basis set whose linear combination (steering) can generate a filter at any arbitrary orientation. |

---

### Part 6: Steganalysis

The `steg.m` script implements a statistical approach for **steganalysis**—the detection of hidden steganographic messages in digital images. This method relies on analyzing the statistical properties of wavelet coefficients, which are highly sensitive to the small, subtle changes introduced by steganographic embedding.

| File Name | Function | Core Mathematical Concept |
| :--- | :--- | :--- |
| `steg.m` | **Steganography Detector (Training & Testing)** | **Fisher's Linear Discriminant (FLD)** is trained on feature vectors derived from the moments (mean, variance, skewness, kurtosis) of **Wavelet Coefficient Sub-bands** to maximize the separation between "steg" and "no-steg" images. |

**Algorithm Summary:**

1.  **Feature Extraction (PART I):** An image is decomposed into a multi-scale, multi-orientation representation using a **Wavelet Pyramid**. Statistical moments of the coefficients within each sub-band (Vertical, Horizontal, Diagonal) and at each scale are computed, forming a high-dimensional feature vector (FV).
2.  **Classifier Training (PART II):**
    * The FVs from images with and without hidden messages are used as training data.
    * **Fisher's Linear Discriminant (FLD)** is calculated to find the optimal projection axis (the vector **e**) that maximizes the ratio of the between-class scatter to the within-class scatter.
    * A classification threshold is determined along this axis, typically set to achieve a low false-positive rate.
3.  **Classifier Testing (PART III):** New FVs are projected onto the learned axis **e** and classified against the threshold to determine if a hidden message is present, thereby estimating the detection accuracy.
