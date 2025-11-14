# Digital Forensics in Images: Detection of Deepfakes and CGI 🕵️

![Deepfake Detection Cover](./.github/cover.png)

**Digital forensics** in visual media is the science of uncovering traces left by image acquisition devices or manipulation software. Detecting fakes relies on the fact that every step in the imaging pipeline—from the camera sensor to the final software edit—leaves a unique statistical or physical artifact.

## Deepfake Detection

**Deepfakes** are highly realistic synthetic media generated using **deep learning models**, primarily **Generative Adversarial Networks (GANs)**. The main detection strategies exploit flaws in how AI recreates complex human physiology and the physical environment:

### A. Physiological Inconsistencies
AI often struggles with complex or small human features. Forensic analysis looks for discrepancies in:
* **Eye Blinking:** Deepfakes may exhibit unnatural, absent, or inconsistent blinking patterns because AI training data often lacks images of eyes closed.
* **Anatomy:** Imperfections in rendering **hands, ears, teeth, or hair** can expose a deepfake.
* **Biological Signals:** Analyzing subtle skin color changes (via remote **Photoplethysmography** or **rPPG**) can detect inconsistencies in the synthesized person's simulated heart rate, a feature AI often fails to perfectly replicate.

### B. Environmental Inconsistencies
* **Lighting and Shadows:** When a forged face is spliced onto a new scene, the light intensity, direction, or corresponding shadows on the face may not align with the rest of the image.

### C. Statistical Artifacts
* Advanced detection uses **Convolutional Neural Networks (CNNs)** or **Vision Transformers** to analyze invisible statistical **fingerprints** left behind by the specific generative model (GAN or Diffusion Model) used to create the fake.

***

## CGI and General Forgery Detection

General image manipulation, including splicing (copy-paste) or **Computer-Generated Imagery (CGI)** insertion, is detected by examining low-level artifacts:

* **Noise Analysis (PRNU):** Every digital camera sensor has a unique microscopic pattern noise called **Photo-Response Non-Uniformity (PRNU)**. This is a unique "fingerprint." If a region of an image has a PRNU pattern that is different from the rest of the photo, it is likely a spliced or inserted fake.
* **Error Level Analysis (ELA):** ELA highlights areas of an image that have a different level of JPEG compression history. Spliced-in content, not compressed as often as the original image, will often stand out with a much lower "error level."
* **Color Filter Array (CFA) Artifacts:** Digital cameras use a **CFA** (e.g., Bayer filter) to capture color and then use a process called **demosaicing** to interpolate the full-color image. This process leaves a unique, periodic statistical pattern. Any manipulation disrupts this pattern, which can be detected.
* **Metadata (EXIF) Forensics:** Although metadata can be easily faked or stripped, the **Exchangeable Image File Format (EXIF)** can contain the camera model, date, time, and even the history of software used to process the file, providing initial clues.
