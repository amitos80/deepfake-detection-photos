## 📁 Complete Repository Documentation

This file consolidates the documentation for all uploaded MATLAB files, covering four main areas: **Optimally Rotation-Equivariant Derivative Filter Design**, **Fractional Signal Transforms**, **Higher-Order Statistics for Blind Parameter Estimation**, and **Independent Component Analysis (ICA)**.

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

These scripts demonstrate extending core signal transforms (Derivatives and Fourier Transform) to non-integer orders, a concept in advanced signal processing.

| File Name | Function | Core Mathematical Concept |
| :--- | :--- | :--- |
| `fracderiv.m` | **Fractional Derivatives** | Differentiation via multiplication by $(j\omega)^n$ in the Fourier Domain. |
| `fracFourier.m` | **Fractional Fourier Transform (FrFT)** | Calculation by raising the Discrete Fourier Transform matrix ($\mathbf{B}$) to a fractional power ($\mathbf{B}^n$). |

---

### Part 3: Higher-Order Statistics for Blind Parameter Estimation

This section contains a script that uses statistical properties beyond the second-order (variance/spectrum) to blindly estimate a non-linear parameter applied to a signal.

| File Name | Function | Core Mathematical Concept |
| :--- | :--- | :--- |
| `blindgamma.m` | **Blind Inverse Gamma Correction** | Minimizes the **Bicoherence** (a higher-order statistic) of the corrected signal to estimate the inverse $\gamma$ value. |

---

### Part 4: Independent Component Analysis (ICA)

The `ica.m` script demonstrates a **non-iterative approach to Independent Component Analysis (ICA)** using higher-order moments. ICA is a computational method for separating a multivariate signal into additive subcomponents, assuming the subcomponents are statistically independent and non-Gaussian.

**Goal:** Separate a linearly mixed signal into its original independent source signals ($\mathbf{x} \rightarrow \mathbf{x}_{R4}$), based on the statistical goal of maximizing non-Gaussianity.

**Algorithm Flow (Non-Iterative Separation):**

The script follows a standard procedure for ICA but uses a non-iterative method to find the final rotation, relying on fourth-order moments (kurtosis).

1.  **Source Generation & Histograms:**
    * Generates 2-dimensional source data (`x`) with a non-Gaussian distribution defined by `dist` (using `exp(-|range|^p)`).
    * **Crucially, it uses `histoMatch`** (a function that needs to be in a separate file, as noted in the source) to impose the specific non-Gaussian histogram onto the raw Gaussian random data. This step ensures the source signals are non-Gaussian, a prerequisite for ICA.
2.  **Mixing:** The source signals are mixed using a random linear transformation matrix `M` to create the observed signal `x_M`.
3.  **Whitening/Sphering (PCA):**
    * The mixed signal `x_M` is **whitened** (transformed so that its covariance matrix is the identity matrix). This is done using an Eigendecomposition of the covariance matrix.
    * This step removes all second-order dependencies (correlations) and results in the Principal Component Analysis (PCA) basis, yielding `x_S`.
4.  **Rotation Estimation (Non-Gaussianity Maximization):**
    * **The key step:** Since the data is now whitened, only a rotation remains to achieve statistical independence.
    * The rotation angle (`th4`) is found by minimizing a cost function related to the **fourth-order moments (kurtosis)** of the components in polar coordinates (`cos2` and `sin2` terms). For $N=2$ sources, the non-iterative solution for the angle is derived from the fourth-order cumulants.
    * The rotation matrix `R4` is constructed from this estimated angle.
5.  **Separation:** The rotation `R4` is applied to the whitened signal `x_S` to obtain the separated independent components `x_R4`.

The script concludes by visually plotting the four stages of the process: Original, Mixed, Whitened, and Separated. The final check confirms that the product of the inverse transformation steps ($R4 \cdot S \cdot R2 \cdot M$) is approximately the Identity matrix, proving successful inversion of the mixing process.
