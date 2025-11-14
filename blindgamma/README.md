## 📁 Complete Repository Documentation

This file consolidates the documentation for all uploaded MATLAB files, covering three main areas: **Optimally Rotation-Equivariant Derivative Filter Design**, **Fractional Signal Transforms**, and **Higher-Order Statistics for Blind Parameter Estimation**.

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

This section contains a script that uses statistical properties beyond the second-order (variance/spectrum) to **blindly estimate** a non-linear parameter applied to a signal.

#### 👁️ `blindgamma.m`: Blind Inverse Gamma Correction

This script implements an algorithm to blindly estimate the $\gamma$ value used to corrupt a signal, based on the statistical property that linear signals (like the original source signal) have a near-zero bicoherence.

**Goal:** Given a signal $g(u) = u^\gamma$, estimate $\gamma$ without prior knowledge of the source or the applied value.

**Underlying Principle:**

1.  **Source Signal:** The original signal is modeled as a linear (Gaussian) process.
2.  **Higher-Order Statistics (HOS):** For a Gaussian signal, all HOS, including the **Bispectrum** and its normalized version, **Bicoherence**, are theoretically zero.
3.  **Gamma Correction:** Applying a non-linear Gamma function $u^\gamma$ to the signal makes it non-Gaussian, resulting in a non-zero Bicoherence.
4.  **Blind Estimation:** The correct inverse Gamma correction ($u^{1/\gamma_{\text{true}}}$) is the function that best **re-linearizes** the signal back to its original Gaussian state, thus **minimizing the Bicoherence** of the resulting corrected signal.

**Algorithm Flow:**

The script tests a range of candidate inverse $\gamma$ values ($\mathbf{g} \in \text{range}$). For each candidate, it:

1.  Applies the inverse correction $f^{1/g}$ to a window of the corrupted signal.
2.  Computes the **Bispectrum Magnitude** (`B = mean(abs(bispec(...)))`) of the corrected signal.
3.  Selects the $\gamma$ value that yields the minimum Bicoherence, as this is the value closest to linearizing the signal.

The final estimate is the average of the $\gamma$ estimates calculated across multiple overlapping windows of the signal.

**Key Components:**

* **`bispec(y)`:** A helper function within the file that explicitly calculates the **Bispectrum** of the input signal `y` using methods like windowing and the Fast Fourier Transform (FFT).
