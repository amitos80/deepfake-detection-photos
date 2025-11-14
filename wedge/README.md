## 📁 Complete Repository Documentation

This file consolidates the documentation for all uploaded MATLAB files, covering five main areas: **Optimally Rotation-Equivariant Derivative Filter Design**, **Fractional Signal Transforms**, **Higher-Order Statistics**, **Independent Component Analysis (ICA)**, and **Steerable Wedge Filters**.

---

### Part 1: Optimally Rotation-Equivariant Derivative Filter Design

This set of MATLAB code is designed to create a family of derivative filters (kernels) that exhibit **rotation-equivariance**—a property ensuring that rotation and differentiation commute. The design uses a combination of generalized eigenvector solutions and non-linear optimization to minimize the rotation invariance error.

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

The `wedge.m` script implements the design and application of **Steerable Wedge Filters** for local orientation analysis in images. These filters are defined by a polar-separable functional form and are designed to be easily "steerable" (i.e., rotated) to any desired angle.

**Goal:** Design a set of basis filters whose linear combination can create a filter at any arbitrary orientation. This is key for efficient and precise orientation estimation in image processing.

#### 📐 Design and Application Flow

1.  **Angular Basis Design:**
    * The script first designs the 1D angular part of the filters.
    * It minimizes an eigenvalue-based cost function involving sine and cosine basis functions ($\mathbf{S}$ and $\mathbf{C}$) and a weighting function ($\mathbf{W}$) in the angular domain. This step determines the optimal coefficients (`vc`, `vs`) for the angular functions, ensuring they form a complete and steerable basis.

2.  **Filter Construction:**
    * The 2D filter kernels (`evenfilts` and `oddfilts`) are constructed on a rectangular grid (`d x d`).
    * The filters are defined in polar coordinates by multiplying a radial function (`rad`) with the angular functions (sums of `cos(n*th)` for even, `sin(n*th)` for odd, weighted by `vc` and `vs` respectively).
    * **NOTE:** The code includes a warning about DC value aliasing due to sampling the polar form onto a rectangular grid, suggesting the use of large filters and subsampling to mitigate this.

3.  **Steering (Interpolation Matrix):**
    * The interpolation matrix (`B`) is created. This matrix allows the filter responses at any number of base angles (`numfilts`) to be linearly combined to predict the responses at all other angles (based on the angular Fourier expansion).

4.  **Convolution and Steering Application:**
    * The designed basis filters are convolved with the input image (`I`) to get initial responses.
    * The `invB` (pseudo-inverse of the interpolation matrix) is used to solve for the Fourier coefficients that best describe the image's orientation content from the filter responses.

**Key Components:**

* **`N`:** The number of frequency components used in the angular Fourier expansion (`N=5` in the default script). This determines the richness of the orientation representation.
* **Steerability:** The property that any filter orientation can be generated as a linear combination of the pre-designed basis filters. The matrix `B` (and its inverse `invB`) is the mechanism for this steering.
* **Filter Type:** The filters are **polar-separable**, meaning they can be factored into a product of a radial function and an angular function.
