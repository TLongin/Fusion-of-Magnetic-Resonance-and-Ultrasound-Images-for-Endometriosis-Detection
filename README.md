# Fusion of Magnetic Resonance and Ultrasound Images for Endometriosis Detection

This repository is an implementation of the Proximal Alternating Linearized Minimization algorithm for image fusion, as describe in the article [Fusion of Magnetic Resonance and Ultrasound Images for Endometriosis Detection](https://ieeexplore.ieee.org/document/9018380).

We begin with two images modalities : magnetic resonance imaging (MRI) and ultrasound imaging (US).
<p align="center">
  <img src="images/Data1/irm.png" alt="Magnetic Resonance Imaging" width="45%">
  <img src="images/Data1/us.png" alt="Ultrasound imaging" width="45%">
</p>

In clinical practice, these two imaging modalities are complementary for the assessment of endometriosis, for example (MRI for sensitivity, ultrasound for specificity and depth of infiltration). In this sense, we want to merge these two imaging modalities in order to combine their advantages and, at the same time, eliminate their disadvantages. In the case of MRI and ultrasound, we seek to reduce ultrasound noise (using MRI) by increasing MRI resolution (using ultrasound). These two medical imaging modalities are completely different, both in terms of the acquisition process and the methods used. This is the challenge we face. We assume that the two images we want to merge are geometrically aligned, i.e. superimposable and of the same size.

We use a denoising convolutional neural networks (DnCNN) to denoise the ultrasounds image with the checkpoint `sigma=25.mat` available in the file `models`. 

<p align="center">
  <img src="images/Data1/us.png" alt="Noised ultrasound imaging" width="45%">
  <img src="images/Data1/us_denoising.png" alt="Denoised ultrasound imaging" width="45%">
</p>

We can now merge the two images using the following algorithm.

```pseudo
Input : Denoised US image, MRI image, hyperparameters
Ouput : Fused Image
While the convergence criterion is satisfied :
    update US image by a gradient descent
    update MRI image by super-resolution
End
```

<p align="center">
  <img src="images/Data1/fusion.png" alt="Fused Image" width="45%">
</p>

Run the `Demo.m` file to obtain these results.

## Display problem

Clarification of certain aspects of Matlab : when saving results via Visual Studio Code, the saved images are inexplicably different from the figures displayed by Matlab. As I am not very familiar with the intricacies of Matlab, I wanted to point out this important aspect. This difference is effective with the denoised US image and the fused image.

- Denoised US image :
<p align="center">
  <img src="images/Data1/us_denoising.png" alt="us_denoising_image" width="45%">
  <img src="images/Data1/us_denoising_figure.png" alt="us_denoising_figure" width="45%">
</p>

- Fused image :
<p align="center">
  <img src="images/Data1/fusion.png" alt="fusion_image" width="45%">
  <img src="images/Data1/fusion_figure.png" alt="fusion_figure" width="45%">
</p>

Please let me know if you know what might be causing this noticeable difference.

## Tree view

```plaintext
Fusion-of-Magnetic-Resonance-and-Ultrasound-Images-for-Endometriosis-Detection/
├── images/
│   ├── Data1/
│   │   ├── fusion.png
│   │   ├── fusion_figure.png
│   │   ├── irm.mat
│   │   ├── irm.png
│   │   ├── mri_super_resolution.png
│   │   ├── mri_super_resolution_figure.png
│   │   ├── us.mat
│   │   ├── us.png
│   │   ├── us_denoising.png
│   │   └── us_denoising_figure.png
│   ├── Data2/
│   │   ├── IRM_GT.mat
│   │   ├── IRM_GT.png
│   │   ├── IRM_observed.mat
│   │   ├── IRM_observed.png
│   │   ├── US_GT.mat
│   │   ├── US_GT.png
│   │   ├── US_observed.mat
│   │   ├── US_observed.png
│   │   ├── fusion_GT.png
│   │   └── fusion_observed.png
│   └── Data3/
│   │   ├── IRM_GT.mat
│   │   ├── IRM_GT.png
│   │   ├── IRM_observed.mat
│   │   ├── IRM_observed.png
│   │   ├── US_GT.mat
│   │   ├── US_GT.png
│   │   ├── US_observed.mat
│   │   ├── US_observed.png
│   │   ├── fusion_GT.png
│   │   └── fusion_observed.png
├── models/
│   └── sigma=25.mat
├── utils/
│   ├── Descente_grad_xus_NL.m
│   ├── FSR_xirm_NL.m
│   ├── FusionPALM.m
│   ├── HXconv.m
│   ├── Link.m
│   ├── d1.m
│   ├── d2.m
│   ├── dtd.m
│   ├── f1_NL.m
│   └── grad_f1_NL.m
├── Demo.m
├── Demo_unidim.m
├── README.md
└── estimate_c.m           
```

## Citations
If you use the code or dataset, please cite the paper as below :
```bibtex
@article{9018380,
  author={El Mansouri, Oumaima and Vidal, Fabien and Basarab, Adrian and Payoux, Pierre and Kouamé, Denis and Tourneret, Jean-Yves},
  journal={IEEE Transactions on Image Processing}, 
  title={Fusion of Magnetic Resonance and Ultrasound Images for Endometriosis Detection}, 
  year={2020},
  volume={29},
  number={},
  pages={5324-5335},
  keywords={Spatial resolution;Magnetic resonance imaging;Image fusion;Diseases;Magnetic resonance;Image fusion;magnetic resonance imaging;ultrasound imaging;super-resolution;despeckling;proximal alternating linearized minimization},
  doi={10.1109/TIP.2020.2975977}}
```
