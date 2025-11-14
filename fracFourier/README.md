## 📁 Complete Repository Documentation

This file consolidates the documentation for all uploaded MATLAB files, covering two main areas: **Optimally Rotation-Equivariant Derivative Filter Design** and **Fractional Signal Transforms** (Derivatives and Fourier Transform).

---

### Part 1: Optimally Rotation-Equivariant Derivative Filter Design

This set of MATLAB code is designed to create a family of derivative filters (kernels) that exhibit **rotation-equivariance**. This property ensures that applying the filters and then rotating the image is mathematically equivalent to rotating the image and then applying the filters. The system uses a combination of generalized eigenvector solutions and non-linear optimization to minimize rotation invariance error.

#### ⚙️ Core Files and Functionality

| File Name | Primary Function | Thought Process/Reasoning |
| :--- | :--- | :--- |
| `design_deriv.m` | **Main Design Script** | **Goal:** Designs a set of $N$ filters for a derivative of order $N$. It formulates the design as a minimization problem under linear constraints, using an SVD-based generalized eigenvector solution for initialization and non-linear optimization for final refinement. |
| `rot_invariance_err.m` | **Rotation Invariance Error** | **Goal:** Quantifies the error in the filter's rotation-equivariance. **Reasoning:** Measures the difference between the **Rotated 2-D Fourier Transform** (of the filter product) and the **Steered 2-D Fourier Transform** (linear combination of filter outputs), which must be zero for perfect equivariance. |
| `deriv2_err.m` | **2nd-Order Derivative Error** | **Goal:** Compute the error for $N=2$ during non-linear optimization. **Reasoning:** Checks consistency between filter responses in the frequency domain, ensuring the prefilter ($P$), first derivative ($D_1$), and second derivative ($D_2$) follow the mathematical relationships expected for derivatives (e.g., related by factors of $\omega$ and $\omega^2$). |
| `deriv3_err.m` | **3rd-Order Derivative Error** | **Goal:** Compute the error for $N=3$ during non-linear optimization. **Reasoning:** Performs a complex error calculation based on multiple consistency checks between filter responses up to the third order. |
| `fulltohalf.m` | **FULL-TO-HALF CONVERSION** | **Goal:** Converts full 1-D filter coefficients into a compact 'half' vector representation for optimization. **Reasoning:** Optimization is performed on the smaller vector, taking advantage of the filters' inherent **symmetry** (even order) or **anti-symmetry** (odd order) to reduce computation. |
| `halftofull.m` | **HALF-TO-FULL CONVERSION** | **Goal:** Reconstructs the full 1-D filter coefficients from the compact 'half' vector. **Reasoning:** Applies the correct symmetry rules (reflection for even order, reflection and sign flip for odd order) to build the complete, physical filter kernel. |
| `intersect.m` | **Geometric Subspace Intersection** | **Goal:** Finds an orthonormal basis for the intersection of two subspaces. Used within `design_deriv.m` to find vectors that satisfy both null-space and linear constraints simultaneously. |
| `rotate.m` | **2-D Map Rotation** | **Goal:** Rotates a 2-D input (e.g., a filter's 2-D Fourier Transform). **Reasoning:** Necessary for the `rot_invariance_err` calculation to test for rotational properties. |
| `showfilt.m` | **Visualization of Filters** | **Goal:** Plots the designed filter coefficients in the **spatial domain** using a stem plot. |
| `showfreq.m` | **Visualization of Frequency Response** | **Goal:** Plots the magnitude of the filter's Fourier Transform in the **frequency domain**, comparing the actual response ($|D|$) to the ideal derivative response ($|\omega^k \cdot P|$). |
| `solution10.mat` | **Pre-Computed Solution** | **Goal:** Loads a pre-computed initial solution (`u10_half`) for the filter coefficients, used to initialize the non-linear optimization for fast convergence. |

---

### Part 2: Fractional Signal Transforms

These scripts demonstrate extending signal transforms (Derivatives and Fourier Transform) to non-integer orders, a topic in advanced signal processing.

#### 📈 `fracderiv.m`: Fractional Derivatives

This script computes and visualizes the **fractional derivatives** (order $n$ from 0 to 4) of a 1-D Gaussian signal using the frequency-domain definition of differentiation. Differentiation in the spatial domain is equivalent to multiplication by a power of $j\omega$ in the frequency domain. The core operation is $F_n = (\mathbf{j} \cdot \mathbf{\omega})^n \cdot \mathbf{F}$, where $F$ is the signal's Fourier Transform.

#### 🌀 `fracFourier.m`: Fractional Fourier Transform (FrFT)

This script computes and visualizes the **Fractional Fourier Transform (FrFT)** of a 1-D Gaussian signal for orders $n$ from 0 to 2. The FrFT rotates the signal's representation continuously in the time-frequency plane.

| Code Section | Reasoning/Concept |
| :--- | :--- |
| **BUILD FOURIER BASIS** | The script explicitly constructs the **Discrete Fourier Transform (DFT) Matrix ($B$)** whose columns are the discrete Fourier basis functions. |
| `Bn = B^n;` | **FrFT Concept:** The Fractional Fourier Transform of order $n$ (often denoted as $\mathcal{F}^n$) is calculated by raising the DFT matrix $B$ to the fractional power $n$ using matrix exponentiation. |
| `fn = abs( Bn * f );` | **Visualization of Rotation:** This step applies the FrFT matrix $B^n$ to the signal $f$. As $n$ increases from $0$ (the original signal in the time domain) to $1$ (the standard Fourier Transform in the frequency domain) and up to $2$, the plot visually tracks the continuous rotation of the signal's representation. |
