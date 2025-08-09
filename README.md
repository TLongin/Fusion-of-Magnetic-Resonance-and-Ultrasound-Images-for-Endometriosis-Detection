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
