# FFT, MUSIC, ESPRIT and SERBES for Stator Inter-Turn Fault Detection

This repository contains the MATLAB implementation used in the study:

**“Comparative Performance Evaluation of FFT, MUSIC, ESPRIT, and SERBES for Stator Inter-Turn Fault Detection in Induction Machines.”**

## Description

The code generates synthetic stator current signals for an induction machine under different inter-turn fault conditions and evaluates four frequency estimation methods:

* Fast Fourier Transform (FFT)
* Multiple Signal Classification (MUSIC)
* Estimation of Signal Parameters via Rotational Invariance Techniques (ESPRIT)
* q-Shift Estimation (QSE), implemented using the SERBES method

The simulations were performed for different fault amplitudes, harmonic orders, and signal-to-noise ratio (SNR) levels.

## Requirements

* MATLAB R2020a or later
* Signal Processing Toolbox, if required by the implementation

## Main parameters

The main simulation parameters are defined in the corresponding MATLAB files. The study considers different:

* fault severity levels;
* harmonic orders;
* SNR values;
* Monte Carlo trials.

## How to run

1. Download or clone this repository.
2. Open MATLAB.
3. Add the repository folder and its subfolders to the MATLAB path.
4. Open `main.m`.
5. Run the script.

The code generates the simulated signals, applies the four frequency estimation methods, and calculates the corresponding performance metrics.

## Performance metrics

The following metrics are calculated:

* RMSE — Root Mean Square Error
* MAE — Mean Absolute Error
* NMSE — Normalized Mean Square Error
* Detection Rate
* Execution Time
* Memory Usage

## Reproducibility

The code and simulation parameters are provided to facilitate the reproduction of the results reported in the manuscript.
